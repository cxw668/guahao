create table sys_job
(
    job_id          bigint auto_increment comment '任务ID',
    job_name        varchar(64)  default ''        not null comment '任务名称',
    job_group       varchar(64)  default 'DEFAULT' not null comment '任务组名',
    invoke_target   varchar(500)                   not null comment '调用目标字符串',
    cron_expression varchar(255) default ''        null comment 'cron执行表达式',
    misfire_policy  varchar(20)  default '3'       null comment '计划执行错误策略（1立即执行 2执行一次 3放弃执行）',
    concurrent      char         default '1'       null comment '是否并发执行（0允许 1禁止）',
    status          char         default '0'       null comment '状态（0正常 1暂停）',
    create_by       varchar(64)  default ''        null comment '创建者',
    create_time     datetime                       null comment '创建时间',
    update_by       varchar(64)  default ''        null comment '更新者',
    update_time     datetime                       null comment '更新时间',
    remark          varchar(500) default ''        null comment '备注信息',
    primary key (job_id, job_name, job_group)
)
    comment '定时任务调度表';

INSERT INTO ruoyi_hospital.sys_job (job_id, job_name, job_group, invoke_target, cron_expression, misfire_policy, concurrent, status, create_by, create_time, update_by, update_time, remark) VALUES (100, '每周自动创建医生排班计划', 'SYSTEM', 'ryTask.generateNextWeekSchedule()', '0 0 2 ? * 1 *', '1', '1', '1', 'admin', '2026-03-04 11:43:46', '', null, '');
INSERT INTO ruoyi_hospital.sys_job (job_id, job_name, job_group, invoke_target, cron_expression, misfire_policy, concurrent, status, create_by, create_time, update_by, update_time, remark) VALUES (101, '自动排班测试', 'SYSTEM', 'ryTask.generateNextWeekSchedule()', '0 25 14 8 3 ? 2026', '1', '1', '1', 'admin', '2026-03-04 11:46:07', 'admin', '2026-03-08 14:23:49', '');
INSERT INTO ruoyi_hospital.sys_job (job_id, job_name, job_group, invoke_target, cron_expression, misfire_policy, concurrent, status, create_by, create_time, update_by, update_time, remark) VALUES (102, '后台自动更新预约状态', 'SYSTEM', 'ryTask.checkAppointmentStatus()', '0 0 0 * * ?', '1', '1', '1', 'admin', '2026-03-04 14:59:24', '', null, '');
