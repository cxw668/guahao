/*
 Navicat Premium Dump SQL
 
 医生端 RBAC 补充数据：
 - 新增 doctor 角色
 - 绑定 doctor 用户（sys_user.user_id = 3）
 - 赋予医生端菜单（3000-3004）
 
 说明：
 - 本文件只做数据插入，不建表
 - 依赖表：sys_role、sys_user_role、sys_role_menu、sys_menu、sys_user
 */
 
SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;
 
-- 新增“医生”角色（role_id=3）
INSERT INTO `sys_role` (`role_id`, `role_name`, `role_key`, `role_sort`, `data_scope`, `menu_check_strictly`, `dept_check_strictly`, `status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`)
VALUES (3, '医生', 'doctor', 3, '2', 1, 1, '0', '0', 'admin', NOW(), '', NULL, '医生端角色')
ON DUPLICATE KEY UPDATE
  `role_name` = VALUES(`role_name`),
  `role_key` = VALUES(`role_key`),
  `role_sort` = VALUES(`role_sort`),
  `status` = VALUES(`status`),
  `del_flag` = VALUES(`del_flag`);
 
-- 绑定用户与角色：doctor 用户（user_id=3）=> doctor 角色（role_id=3）
INSERT IGNORE INTO `sys_user_role` (`user_id`, `role_id`) VALUES (3, 3);
 
-- 赋予 doctor 角色医生端菜单（目录+子菜单）
INSERT IGNORE INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES
(3, 3000),
(3, 3001),
(3, 3002),
(3, 3003),
(3, 3004);
 
SET FOREIGN_KEY_CHECKS = 1;
