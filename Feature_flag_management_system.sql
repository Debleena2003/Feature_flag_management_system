/*create table user_group_membership(user_id int, group_id int, primary key(user_id,group_id),
foreign key(user_id) references users(user_id),
foreign key (group_id) references user_groups(group_id)); */
#select * from user_group_membership;
/*create table flag_assignments(assignment_id int auto_increment primary key, flag_id int, env_id int, user_id int default null,
 group_id int default null, is_enabled boolean default true, assigned_at datetime default current_timestamp,
 expires_at datetime default null,
 foreign key(flag_id)references feature_flags(flag_id),
foreign key(env_id)references environments(env_id),
foreign key(user_id)references users(user_id),
foreign key(group_id)references user_groups(group_id)); */

/*create table flag_dependencies(parent_flag_id int , child_flag_id int, primary key (parent_flag_id, child_falg_id),
foreign key (parent_flag_id) references feature_flags(flag_id),
foreign key(child_flag_id)references feature_flags(flag_id)); */

/*create table audit_logs(log_id int auto_increment primary key,
action_type enum('create', 'update', 'delete') not null,
flag_id int, actor varchar(100) not null,
change_time datetime default current_timestamp, description text,
foreign key (flag_id) references feature_flags(flag_id)); */

#SQL queries and operations
#update feature_flags set is_enabled=true, updated_at=NOW() where flag_name='new_dashboard';
/*insert into feature_flags (flag_name, description, is_enabled)
values ('new_dashboard', 'Enable new dashboard UI', TRUE);*/

#insert into audit_logs(action_type, flag_id,actor, description) values('update', 1, 'admin_user', 'Enabled new_dashboard flag');
#SELECT * FROM feature_flags WHERE flag_id = 1;

#Assign flag to user or group for a specific environment
#insert into users(user_id, username) values (101, 'test_user');
#insert into flag_assignments(flag_id,env_id, group_id, is_enabled) values (1,2,5,true);
#insert into user_groups (group_id, group_name) values (5, 'qa_team');

/*select distinct ff.flag_name
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
and (fa.expires_at is null or fa.expires_at > now());*/

/*create table flag_dependencies (
    parent_flag_id int,
    child_flag_id int,
    primary key (parent_flag_id, child_flag_id),
    foreign key (parent_flag_id) references feature_flags(flag_id),
    foreign key (child_flag_id) references feature_flags(flag_id));*/
    
 #insert into feature_flags (flag_name, description, is_enabled) values ('dependent_feature', 'This feature depends on another', false);



/*select pf.flag_name as parent_flag, cf.flag_name as dependent_flag
from flag_dependencies fd
join feature_flags pf on pf.flag_id = fd.parent_flag_id
join feature_flags cf on cf.flag_id = fd.child_flag_id
where cf.flag_name = 'dependent_feature'
and pf.is_enabled = false;*/

# creating triggers,views, procedures
/*delimiter //

-- trigger
create trigger trg_update_flag
after update on feature_flags
for each row
begin
  insert into audit_logs (action_type, flag_id, actor, description)
  values ('update', new.flag_id, 'system_trigger', concat('Flag ', new.flag_name, ' updated'));
end;//
delimiter ;

-- procedure
delimiter //
create procedure enable_flag(in f_id int, in actor_name varchar(100))
begin
  update feature_flags set is_enabled = true where flag_id = f_id;
  insert into audit_logs (action_type, flag_id, actor, description)
  values ('update', f_id, actor_name, 'Flag enabled');
end;//
delimiter ;*/


#use feature_flag_db;
#call enable_flag(1,'admin');
select * from audit_logs;

























