-- ----------------------------
-- 自动化服务菜单 (admin 专属)
-- ----------------------------
-- 一级菜单：自动化服务
-- ----------------------------
-- 自动化服务菜单 (admin 专属)
-- ----------------------------

-- 二级菜单：定时任务
INSERT INTO `sys_menu` VALUES
    (1000, '定时任务', 2000, 1, 'job', 'monitor/job/index', NULL, '', 0, 0, 'C', '0', '0', 'monitor:job:list', 'job', 'admin', sysdate(), '', NULL, '定时任务菜单');

-- 按钮权限：任务查询
INSERT INTO `sys_menu` VALUES
    (1001, '任务查询', 1000, 1, '', '', NULL, '', 0, 0, 'F', '0', '0', 'monitor:job:query', '#', 'admin', sysdate(), '', NULL, '');

-- 按钮权限：任务新增
INSERT INTO `sys_menu` VALUES
    (1002, '任务新增', 1000, 2, '', '', NULL, '', 0, 0, 'F', '0', '0', 'monitor:job:add', '#', 'admin', sysdate(), '', NULL, '');

-- 按钮权限：任务修改
INSERT INTO `sys_menu` VALUES
    (1003, '任务修改', 1000, 3, '', '', NULL, '', 0, 0, 'F', '0', '0', 'monitor:job:edit', '#', 'admin', sysdate(), '', NULL, '');

-- 按钮权限：任务删除
INSERT INTO `sys_menu` VALUES
    (1004, '任务删除', 1000, 4, '', '', NULL, '', 0, 0, 'F', '0', '0', 'monitor:job:remove', '#', 'admin', sysdate(), '', NULL, '');

-- 按钮权限：任务导出
INSERT INTO `sys_menu` VALUES
    (1005, '任务导出', 1000, 5, '', '', NULL, '', 0, 0, 'F', '0', '0', 'monitor:job:export', '#', 'admin', sysdate(), '', NULL, '');

-- 按钮权限：任务详情
INSERT INTO `sys_menu` VALUES
    (1006, '任务详情', 1000, 6, '', '', NULL, '', 0, 0, 'F', '0', '0', 'monitor:job:detail', '#', 'admin', sysdate(), '', NULL, '');

-- 按钮权限：任务日志
INSERT INTO `sys_menu` VALUES
    (1007, '任务日志', 1000, 7, '', '', NULL, '', 0, 0, 'F', '0', '0', 'monitor:job:log', '#', 'admin', sysdate(), '', NULL, '');

-- ----------------------------
-- 角色菜单关联（仅 admin 角色可访问）
-- ----------------------------
-- 注意：以下 SQL 确保只有超级管理员 (role_id=1) 可以访问该菜单
-- 如果已存在关联记录，请先执行 DELETE 操作

-- 删除其他角色对该菜单的权限（如果有）
DELETE FROM `sys_role_menu` WHERE `menu_id` IN (110, 2000, 2001, 2002, 2003, 2004, 2005, 2006, 2007) AND `role_id` != 1;

-- 为 admin 角色添加菜单权限（如果尚未添加）
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES 
(1, 110),   -- admin - 自动化服务目录
(1, 1000),  -- admin - 定时任务菜单
(1, 1001),  -- admin - 任务查询
(1, 1002),  -- admin - 任务新增
(1, 1003),  -- admin - 任务修改
(1, 1004),  -- admin - 任务删除
(1, 1005),  -- admin - 任务导出
(1, 1006),  -- admin - 任务详情
(1, 1007);  -- admin - 任务日志
