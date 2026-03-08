create table sys_user_role
(
    user_id bigint not null comment '用户ID',
    role_id bigint not null comment '角色ID',
    primary key (user_id, role_id)
)
    comment '用户和角色关联表';

INSERT INTO ruoyi_hospital.sys_user_role (user_id, role_id) VALUES (1, 1);
INSERT INTO ruoyi_hospital.sys_user_role (user_id, role_id) VALUES (2, 2);
INSERT INTO ruoyi_hospital.sys_user_role (user_id, role_id) VALUES (3, 3);
INSERT INTO ruoyi_hospital.sys_user_role (user_id, role_id) VALUES (100, 2);
INSERT INTO ruoyi_hospital.sys_user_role (user_id, role_id) VALUES (101, 2);
INSERT INTO ruoyi_hospital.sys_user_role (user_id, role_id) VALUES (102, 2);
INSERT INTO ruoyi_hospital.sys_user_role (user_id, role_id) VALUES (103, 2);
