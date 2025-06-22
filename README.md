# Feature_flag_management_system
Feature Flag Management System that manages feature toggling for applications. It allows enabling/disabling features per environment, user, or group, supports flag dependencies, audit logging, and expiration.

Database Schema Overview:

1. feature_flags
   - Stores all feature flags with metadata like name, description, status, and expiry.
2. users
   - Stores user information.
3. user_groups
   - Stores logical groupings of users.
4. user_group_membership
   - Many-to-many mapping between users and groups.
5. environments
   - Defines deployment environments (e.g., development, staging, production).
6. flag_assignments
   - Maps feature flags to users/groups in specific environments.
   - Can expire flags based on time.
   - Supports both user-level and group-level targeting.
7. flag_dependencies
   - Represents parent-child flag relationships (flag A depends on flag B).
8. audit_logs
   - Logs changes to flags (create, update) with timestamps and actor information.
  
Stored Procedures and Triggers:

1. Procedure: enable_flag(flag_id, actor_name)
   - Enables a flag and inserts a corresponding audit log entry.

2. Trigger: trg_update_flag
   - After any update to `feature_flags`, an audit log is automatically inserted.

Sample Queries:

-- View active flags for a user in production
select distinct ff.flag_name
from feature_flags ff
join flag_assignments fa on ff.flag_id = fa.flag_id
join environments e on fa.env_id = e.env_id
left join user_group_membership ugm on fa.group_id = ugm.group_id
where (
    (fa.user_id = 101 or ugm.user_id = 101)
)
and e.env_name = 'production'
and ff.is_enabled = true
and (ff.expires_at is null or ff.expires_at > now())
and (fa.expires_at is null or fa.expires_at > now());

-- Show dependencies for a given feature
select pf.flag_name as parent_flag, cf.flag_name as dependent_flag
from flag_dependencies fd
join feature_flags pf on pf.flag_id = fd.parent_flag_id
join feature_flags cf on cf.flag_id = fd.child_flag_id
where cf.flag_name = 'dependent_feature'
and pf.is_enabled = false;




