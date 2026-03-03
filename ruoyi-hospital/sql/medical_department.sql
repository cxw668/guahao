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

 Date: 03/03/2026 15:10:20
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for medical_department
-- ----------------------------
DROP TABLE IF EXISTS `medical_department`;
CREATE TABLE `medical_department`  (
  `dept_id` bigint NOT NULL AUTO_INCREMENT COMMENT '科室ID',
  `dept_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '科室名称',
  `dept_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '科室编码',
  `parent_id` bigint NULL DEFAULT 0 COMMENT '父科室ID（0为顶级）',
  `dept_type` tinyint NULL DEFAULT 1 COMMENT '科室类型：1门诊 2急诊 3住院 4医技',
  `location` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '科室位置（如：门诊楼3层）',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '科室电话',
  `intro` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '科室简介',
  `sort_order` int NULL DEFAULT 0 COMMENT '排序',
  `status` tinyint NULL DEFAULT 0 COMMENT '状态：0正常 1停用',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dept_id`) USING BTREE,
  UNIQUE INDEX `uk_dept_code`(`dept_code` ASC) USING BTREE,
  INDEX `idx_parent_id`(`parent_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '科室信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of medical_department
-- ----------------------------
INSERT INTO `medical_department` VALUES (1, '内科', 'NK001', 0, 4, '门诊楼2层', '010-88881001', '主要诊治呼吸、消化、心血管等内部系统疾病', 1, 0, '', '2026-03-02 11:09:16', 'admin', '2026-03-03 14:33:31', NULL);
INSERT INTO `medical_department` VALUES (2, '外科', 'WK001', 0, 1, '门诊楼3层', '010-88881002', '涵盖普外、骨科、神经外科等手术治疗', 2, 0, '', '2026-03-02 11:09:16', '', NULL, NULL);
INSERT INTO `medical_department` VALUES (3, '儿科', 'EK001', 0, 1, '门诊楼1层', '010-88881003', '专为0-14岁儿童提供医疗服务', 3, 0, '', '2026-03-02 11:09:16', '', NULL, NULL);
INSERT INTO `medical_department` VALUES (4, '眼科', 'YK001', 0, 1, '门诊楼4层', '010-88881004', '近视矫正、白内障、青光眼等眼部疾病', 4, 0, '', '2026-03-02 11:09:16', '', NULL, NULL);
INSERT INTO `medical_department` VALUES (5, '口腔科', 'KQ001', 0, 1, '门诊楼4层', '010-88881005', '牙齿种植、正畸、牙周治疗', 5, 0, '', '2026-03-02 11:09:16', '', NULL, NULL);
INSERT INTO `medical_department` VALUES (6, '心血管内科', 'XXGNK', 1, 1, '门诊楼2层A区', '010-88881006', '高血压、冠心病、心律失常专病门诊', 10, 0, '', '2026-03-02 11:09:16', '', NULL, NULL);
INSERT INTO `medical_department` VALUES (7, '呼吸内科', 'HXNK', 1, 1, '门诊楼2层B区', '010-88881007', '哮喘、慢阻肺、肺炎等呼吸道疾病', 11, 0, '', '2026-03-02 11:09:16', '', NULL, NULL);
INSERT INTO `medical_department` VALUES (8, '皮肤科', 'PFK001', 0, 1, '门诊楼1层', '010-88881008', '常见皮肤病、过敏性皮炎、痤疮等诊疗', 6, 0, '', '2026-03-02 11:09:16', '', NULL, NULL);
INSERT INTO `medical_department` VALUES (9, '耳鼻喉科', 'EBHK01', 0, 1, '门诊楼2层', '010-88881009', '鼻炎、咽喉炎、耳鸣耳聋等诊疗', 7, 0, '', '2026-03-02 11:09:16', '', NULL, NULL);

SET FOREIGN_KEY_CHECKS = 1;
