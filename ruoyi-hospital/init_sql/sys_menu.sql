create table sys_menu
(
    menu_id     bigint auto_increment comment '菜单ID'
        primary key,
    menu_name   varchar(50)              not null comment '菜单名称',
    parent_id   bigint       default 0   null comment '父菜单ID',
    order_num   int          default 0   null comment '显示顺序',
    path        varchar(200) default ''  null comment '路由地址',
    component   varchar(255)             null comment '组件路径',
    query       varchar(255)             null comment '路由参数',
    route_name  varchar(50)  default ''  null comment '路由名称',
    is_frame    int          default 1   null comment '是否为外链（0是 1否）',
    is_cache    int          default 0   null comment '是否缓存（0缓存 1不缓存）',
    menu_type   char         default ''  null comment '菜单类型（M目录 C菜单 F按钮）',
    visible     char         default '0' null comment '菜单状态（0显示 1隐藏）',
    status      char         default '0' null comment '菜单状态（0正常 1停用）',
    perms       varchar(100)             null comment '权限标识',
    icon        varchar(100) default '#' null comment '菜单图标',
    create_by   varchar(64)  default ''  null comment '创建者',
    create_time datetime                 null comment '创建时间',
    update_by   varchar(64)  default ''  null comment '更新者',
    update_time datetime                 null comment '更新时间',
    remark      varchar(500) default ''  null comment '备注'
)
    comment '菜单权限表' row_format = DYNAMIC;

INSERT INTO ruoyi_hospital.sys_menu (menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (1000, '定时任务', 2000, 1, 'job', 'monitor/job/index', null, '', 0, 0, 'C', '0', '0', 'monitor:job:list', 'job', 'admin', '2026-03-07 17:40:48', '', null, '定时任务菜单');
INSERT INTO ruoyi_hospital.sys_menu (menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (1001, '任务查询', 1000, 1, '', '', null, '', 0, 0, 'F', '0', '0', 'monitor:job:query', '#', 'admin', '2026-03-07 17:40:48', '', null, '');
INSERT INTO ruoyi_hospital.sys_menu (menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (1002, '任务新增', 1000, 2, '', '', null, '', 0, 0, 'F', '0', '0', 'monitor:job:add', '#', 'admin', '2026-03-07 17:40:48', '', null, '');
INSERT INTO ruoyi_hospital.sys_menu (menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (1003, '任务修改', 1000, 3, '', '', null, '', 0, 0, 'F', '0', '0', 'monitor:job:edit', '#', 'admin', '2026-03-07 17:40:48', '', null, '');
INSERT INTO ruoyi_hospital.sys_menu (menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (1004, '任务删除', 1000, 4, '', '', null, '', 0, 0, 'F', '0', '0', 'monitor:job:remove', '#', 'admin', '2026-03-07 17:40:48', '', null, '');
INSERT INTO ruoyi_hospital.sys_menu (menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (1005, '任务导出', 1000, 5, '', '', null, '', 0, 0, 'F', '0', '0', 'monitor:job:export', '#', 'admin', '2026-03-07 17:40:48', '', null, '');
INSERT INTO ruoyi_hospital.sys_menu (menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (1006, '任务详情', 1000, 6, '', '', null, '', 0, 0, 'F', '0', '0', 'monitor:job:detail', '#', 'admin', '2026-03-07 17:40:48', '', null, '');
INSERT INTO ruoyi_hospital.sys_menu (menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (1007, '任务日志', 1000, 7, '', '', null, '', 0, 0, 'F', '0', '0', 'monitor:job:log', '#', 'admin', '2026-03-07 17:40:48', '', null, '');
INSERT INTO ruoyi_hospital.sys_menu (menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (2000, '医疗管理', 0, 0, 'medical', 'Layout', null, '', 0, 0, 'M', '1', '0', null, 'system', 'admin', '2026-02-28 14:49:08', 'admin', '2026-02-28 14:49:08', '医疗业务管理根菜单');
INSERT INTO ruoyi_hospital.sys_menu (menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (2001, '科室管理', 2000, 6, 'department', 'medical/department/index', null, '', 0, 0, 'C', '0', '0', 'medical:department:list', 'tree', 'admin', '2026-02-28 14:49:08', 'admin', '2026-02-28 14:49:08', '医院科室管理');
INSERT INTO ruoyi_hospital.sys_menu (menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (2002, '医生管理', 2000, 5, 'doctor', 'medical/doctor/index', null, '', 0, 0, 'C', '0', '0', 'medical:doctor:list', 'user', 'admin', '2026-02-28 14:49:08', 'admin', '2026-02-28 14:49:08', '医生信息管理');
INSERT INTO ruoyi_hospital.sys_menu (menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (2003, '号源管理', 2000, 4, 'schedule', 'medical/schedule/index', null, '', 0, 0, 'C', '0', '0', 'medical:schedule:list', 'date', 'admin', '2026-02-28 14:49:08', 'admin', '2026-02-28 14:49:08', '医生排班与号源');
INSERT INTO ruoyi_hospital.sys_menu (menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (2004, '预约管理', 2000, 3, 'appointment', 'medical/appointment/index', null, '', 0, 0, 'C', '0', '0', 'medical:appointment:list', 'message', 'admin', '2026-02-28 14:49:08', 'admin', '2026-02-28 14:49:08', '患者预约订单');
INSERT INTO ruoyi_hospital.sys_menu (menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (2006, '数据大屏', 2000, 2, 'dashboard', 'medical/dashboard/index', null, '', 1, 1, 'C', '0', '0', 'medical:dashboard:list', 'monitor', 'admin', null, 'admin', '2026-03-02 13:50:50', '数据大屏');
INSERT INTO ruoyi_hospital.sys_menu (menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3000, '医生端', 0, 0, 'medical-doctor', 'Layout', null, '', 0, 0, 'M', '0', '0', '', 'system', 'doctor', null, 'doctor', null, '医生端');
INSERT INTO ruoyi_hospital.sys_menu (menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3001, '工作台', 3000, 1, 'workbench', 'medical-doctor/workbench/index', null, '', 0, 0, 'C', '0', '0', '', 'monitor', 'doctor', null, 'doctor', null, '医生端-工作台（今日概览）');
INSERT INTO ruoyi_hospital.sys_menu (menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3002, '候诊队列', 3000, 2, 'queue', 'medical-doctor/queue/index', null, '', 0, 0, 'C', '0', '0', '', 'message', 'doctor', null, 'doctor', null, '医生端-候诊队列（实时/轮询降级）');
INSERT INTO ruoyi_hospital.sys_menu (menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3003, '接诊/病历', 3000, 3, 'consult', 'medical-doctor/consult/index', null, '', 0, 0, 'C', '0', '0', '', 'edit', 'doctor', null, 'doctor', null, '医生端-接诊与病历草稿');
INSERT INTO ruoyi_hospital.sys_menu (menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES (3004, '我的排班', 3000, 4, 'schedule', 'medical-doctor/schedule/index', null, '', 0, 0, 'C', '0', '0', '', 'date', 'doctor', null, 'doctor', null, '医生端-排班管理');
