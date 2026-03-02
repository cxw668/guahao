/*
 Navicat Premium Dump SQL

 Source Server         : 挂号系统
 Source Server Type    : MySQL
 Source Server Version : 80041 (8.0.41)
 Source Host           : localhost:3306
 Source Schema         : ruoyi_hospital

 Target Server Type    : MySQL
 Target Server Version : 80041 (8.0.41)
 File Encoding         : 65001

 Date: 02/03/2026 16:12:32
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu`  (
  `menu_id` bigint NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
  `menu_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '菜单名称',
  `parent_id` bigint NULL DEFAULT 0 COMMENT '父菜单ID',
  `order_num` int NULL DEFAULT 0 COMMENT '显示顺序',
  `path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '路由地址',
  `component` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '组件路径',
  `query` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '路由参数',
  `route_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '路由名称',
  `is_frame` int NULL DEFAULT 1 COMMENT '是否为外链（0是 1否）',
  `is_cache` int NULL DEFAULT 0 COMMENT '是否缓存（0缓存 1不缓存）',
  `menu_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '菜单类型（M目录 C菜单 F按钮）',
  `visible` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '菜单状态（0显示 1隐藏）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '菜单状态（0正常 1停用）',
  `perms` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '权限标识',
  `icon` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '#' COMMENT '菜单图标',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`menu_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3001 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '菜单权限表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_menu
-- ----------------------------
INSERT INTO `sys_menu` VALUES (2000, '医疗管理', 0, 6, 'medical', 'Layout', NULL, '', 0, 0, 'M', '1', '0', NULL, 'system', 'admin', '2026-02-28 14:49:08', 'admin', '2026-02-28 14:49:08', '医疗业务管理根菜单');
INSERT INTO `sys_menu` VALUES (2001, '科室管理', 2000, 2, 'department', 'medical/department/index', NULL, '', 0, 0, 'C', '0', '0', 'medical:department:list', 'tree', 'admin', '2026-02-28 14:49:08', 'admin', '2026-02-28 14:49:08', '医院科室管理');
INSERT INTO `sys_menu` VALUES (2002, '医生管理', 2000, 3, 'doctor', 'medical/doctor/index', NULL, '', 0, 0, 'C', '0', '0', 'medical:doctor:list', 'user', 'admin', '2026-02-28 14:49:08', 'admin', '2026-02-28 14:49:08', '医生信息管理');
INSERT INTO `sys_menu` VALUES (2003, '号源管理', 2000, 4, 'schedule', 'medical/schedule/index', NULL, '', 0, 0, 'C', '0', '0', 'medical:schedule:list', 'date', 'admin', '2026-02-28 14:49:08', 'admin', '2026-02-28 14:49:08', '医生排班与号源');
INSERT INTO `sys_menu` VALUES (2004, '预约管理', 2000, 5, 'appointment', 'medical/appointment/index', NULL, '', 0, 0, 'C', '0', '0', 'medical:appointment:list', 'message', 'admin', '2026-02-28 14:49:08', 'admin', '2026-02-28 14:49:08', '患者预约订单');
INSERT INTO `sys_menu` VALUES (2006, '数据大屏', 2000, 1, 'dashboard', 'medical/dashboard/index', NULL, '', 1, 1, 'C', '0', '0', 'medical:dashboard:list', 'monitor', 'admin', NULL, 'admin', '2026-03-02 13:50:50', '数据大屏');
INSERT INTO `sys_menu` VALUES (3000, '医生端', 0, 0, 'doctor', 'Layout', NULL, '', 1, 0, '', '0', '0', '', 'system', 'doctor', NULL, 'doctor', NULL, '医生端');

INSERT INTO `sys_menu` VALUES
(3000, '医生端', 0, 0, 'medical-doctor', 'Layout', NULL, '', 0, 0, 'M', '0', '0', '', 'system', 'doctor', NULL, 'doctor', NULL, '医生端');

INSERT INTO `sys_menu` VALUES
(3001, '工作台', 3000, 1, 'workbench', 'medical-doctor/workbench/index', NULL, '', 0, 0, 'C', '0', '0', '', 'monitor', 'doctor', NULL, 'doctor', NULL, '医生端-工作台（今日概览）'),
(3002, '候诊队列', 3000, 2, 'queue', 'medical-doctor/queue/index', NULL, '', 0, 0, 'C', '0', '0', '', 'message', 'doctor', NULL, 'doctor', NULL, '医生端-候诊队列（实时/轮询降级）'),
(3003, '接诊/病历', 3000, 3, 'consult', 'medical-doctor/consult/index', NULL, '', 0, 0, 'C', '0', '0', '', 'edit', 'doctor', NULL, 'doctor', NULL, '医生端-接诊与病历草稿'),
(3004, '我的排班', 3000, 4, 'schedule', 'medical-doctor/schedule/index', NULL, '', 0, 0, 'C', '0', '0', '', 'date', 'doctor', NULL, 'doctor', NULL, '医生端-排班管理');
SET FOREIGN_KEY_CHECKS = 1;
