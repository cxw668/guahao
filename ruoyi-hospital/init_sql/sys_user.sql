create table sys_user
(
    user_id         bigint auto_increment comment '用户ID'
        primary key,
    dept_id         bigint                    null comment '部门ID',
    user_name       varchar(30)               not null comment '用户账号',
    nick_name       varchar(30)               not null comment '用户昵称',
    user_type       varchar(2)   default '00' null comment '用户类型（00系统用户）',
    email           varchar(50)  default ''   null comment '用户邮箱',
    phonenumber     varchar(11)  default ''   null comment '手机号码',
    sex             char         default '0'  null comment '用户性别（0男 1女 2未知）',
    avatar          varchar(100) default ''   null comment '头像地址',
    password        varchar(100) default ''   null comment '密码',
    status          char         default '0'  null comment '账号状态（0正常 1停用）',
    del_flag        char         default '0'  null comment '删除标志（0代表存在 2代表删除）',
    login_ip        varchar(128) default ''   null comment '最后登录IP',
    login_date      datetime                  null comment '最后登录时间',
    pwd_update_date datetime                  null comment '密码最后更新时间',
    create_by       varchar(64)  default ''   null comment '创建者',
    create_time     datetime                  null comment '创建时间',
    update_by       varchar(64)  default ''   null comment '更新者',
    update_time     datetime                  null comment '更新时间',
    remark          varchar(500)              null comment '备注'
)
    comment '用户信息表';

INSERT INTO ruoyi_hospital.sys_user (user_id, dept_id, user_name, nick_name, user_type, email, phonenumber, sex, avatar, password, status, del_flag, login_ip, login_date, pwd_update_date, create_by, create_time, update_by, update_time, remark) VALUES (1, 103, 'admin', 'IT科主任', '00', 'ry@163.com', '15888888888', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', '2026-03-08 14:05:23', '2026-02-28 14:26:58', 'admin', '2026-02-28 14:26:58', '', null, '管理员');
INSERT INTO ruoyi_hospital.sys_user (user_id, dept_id, user_name, nick_name, user_type, email, phonenumber, sex, avatar, password, status, del_flag, login_ip, login_date, pwd_update_date, create_by, create_time, update_by, update_time, remark) VALUES (2, 105, 'common', '普通用户', '00', '2070873372@qq.com', '15666666668', '0', '', '$2a$10$0nNS4b8QBKR.xfnPKx9c8.l2JftYu3fmtXM7klpzY6gdKVsLvZ52i', '0', '0', '127.0.0.1', '2026-03-06 13:35:12', '2026-03-06 11:05:43', 'admin', '2026-02-28 14:26:58', '', '2026-03-06 11:58:23', '用户端账号');
INSERT INTO ruoyi_hospital.sys_user (user_id, dept_id, user_name, nick_name, user_type, email, phonenumber, sex, avatar, password, status, del_flag, login_ip, login_date, pwd_update_date, create_by, create_time, update_by, update_time, remark) VALUES (3, 105, 'doctor', '陈医生', '00', 'doctor@demo.com', '12888888888', '0', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', '2026-03-08 13:57:22', '2026-02-28 14:26:58', 'admin', '2026-02-28 14:26:58', '', null, '医生端账号');
INSERT INTO ruoyi_hospital.sys_user (user_id, dept_id, user_name, nick_name, user_type, email, phonenumber, sex, avatar, password, status, del_flag, login_ip, login_date, pwd_update_date, create_by, create_time, update_by, update_time, remark) VALUES (102, null, 'test01', 'test01', '00', '', '', '0', '', '$2a$10$ZKkSKaDtXEjVWDG/Zr9x0Ony81oM1ACoH3/t0Oj3H8w8Xb8p74gH6', '0', '0', '', null, '2026-03-06 13:26:14', '', '2026-03-06 13:26:14', '', null, null);
INSERT INTO ruoyi_hospital.sys_user (user_id, dept_id, user_name, nick_name, user_type, email, phonenumber, sex, avatar, password, status, del_flag, login_ip, login_date, pwd_update_date, create_by, create_time, update_by, update_time, remark) VALUES (103, null, 'test02', 'test02', '00', '2070873373@qq.com', '', '0', '', '$2a$10$e7XNLcz5olCW.rWeJ5m2N.LL0/h/JqWyOCZTOxP3Jjaf8zWPSHMHe', '0', '0', '127.0.0.1', '2026-03-06 13:34:52', '2026-03-06 13:34:38', '', '2026-03-06 13:34:38', '', null, null);
