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

 Date: 03/03/2026 15:08:43
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for medical_doctor
-- ----------------------------
DROP TABLE IF EXISTS `medical_doctor`;
CREATE TABLE `medical_doctor`  (
  `doctor_id` bigint NOT NULL AUTO_INCREMENT COMMENT '医生ID',
  `user_id` bigint NULL DEFAULT NULL COMMENT '关联系统用户ID（RuoYi sys_user）',
  `doctor_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '医生姓名',
  `doctor_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '医生工号',
  `dept_id` bigint NOT NULL COMMENT '所属科室ID',
  `title` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '职称：主任医师/副主任医师/主治医师/医师',
  `specialty` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '擅长领域',
  `intro` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '医生简介',
  `avatar` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '头像URL',
  `fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '挂号费',
  `max_patients` int NULL DEFAULT 20 COMMENT '半日最大接诊数',
  `work_status` tinyint NULL DEFAULT 0 COMMENT '工作状态：0在职 1休假 2离职',
  `status` tinyint NULL DEFAULT 0 COMMENT '预约状态：0可约 1暂停',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`doctor_id`) USING BTREE,
  UNIQUE INDEX `uk_doctor_code`(`doctor_code` ASC) USING BTREE,
  INDEX `idx_dept_id`(`dept_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '医生信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of medical_doctor
-- ----------------------------
INSERT INTO `medical_doctor` VALUES (1, 1001, '张伟', 'DOC001', 6, '主任医师', '冠心病介入治疗、高血压管理', '从事心血管临床工作20年，擅长复杂冠脉病变处理', NULL, 50.00, 30, 0, 0, '', '2026-03-02 11:09:16', '', NULL, NULL);
INSERT INTO `medical_doctor` VALUES (2, 1002, '李娜', 'DOC002', 6, '副主任医师', '心律失常、心力衰竭', '精通起搏器植入术，对难治性心衰有独到见解', NULL, 30.00, 25, 0, 0, '', '2026-03-02 11:09:16', '', NULL, NULL);
INSERT INTO `medical_doctor` VALUES (3, 1003, '王强', 'DOC003', 2, '主治医师', '腹腔镜微创手术、胃肠肿瘤', '累计完成腹腔镜手术超过2000例', NULL, 20.00, 20, 0, 0, '', '2026-03-02 11:09:16', '', NULL, NULL);
INSERT INTO `medical_doctor` VALUES (4, 1004, '赵敏', 'DOC004', 3, '主任医师', '小儿呼吸系统疾病、新生儿护理', '儿科专家，深受小朋友喜爱，耐心细致', NULL, 40.00, 35, 0, 0, '', '2026-03-02 11:09:16', '', NULL, NULL);
INSERT INTO `medical_doctor` VALUES (5, 1005, '孙丽', 'DOC005', 4, '副主任医师', '青少年近视防控、屈光手术', '拥有万例近视激光手术成功经验', NULL, 35.00, 20, 0, 0, '', '2026-03-02 11:09:16', '', NULL, NULL);
INSERT INTO `medical_doctor` VALUES (6, 1006, '周杰', 'DOC006', 5, '主治医师', '隐形矫正、种植牙', '美学修复专家，注重功能与美观并重', NULL, 25.00, 15, 0, 0, '', '2026-03-02 11:09:16', '', NULL, NULL);
INSERT INTO `medical_doctor` VALUES (7, 1007, '吴刚', 'DOC007', 7, '住院医师', '慢性咳嗽、哮喘管理', '专注于呼吸慢病的全程管理', NULL, 15.00, 30, 0, 0, '', '2026-03-02 11:09:16', '', NULL, NULL);
INSERT INTO `medical_doctor` VALUES (8, 1008, '刘洋', 'DOC008', 1, '主治医师', '消化系统疾病、幽门螺杆菌管理', '擅长常见内科疾病的规范化诊疗', NULL, 20.00, 25, 0, 0, '', '2026-03-02 11:09:16', '', NULL, NULL);
INSERT INTO `medical_doctor` VALUES (9, 1009, '高峰', 'DOC009', 1, '医师', '呼吸道感染、慢病随访', '注重循证医学与全程管理', NULL, 15.00, 30, 0, 0, '', '2026-03-02 11:09:16', '', NULL, NULL);
INSERT INTO `medical_doctor` VALUES (10, 1010, '郑凯', 'DOC010', 2, '主治医师', '腹腔镜微创、疝气修补', '手术经验丰富，恢复方案个体化', NULL, 25.00, 20, 0, 0, '', '2026-03-02 11:09:16', '', NULL, NULL);
INSERT INTO `medical_doctor` VALUES (11, 1011, '林珊', 'DOC011', 3, '副主任医师', '儿童呼吸系统疾病、过敏性疾病', '专注儿童慢病管理与健康指导', NULL, 35.00, 25, 0, 0, '', '2026-03-02 11:09:16', '', NULL, NULL);
INSERT INTO `medical_doctor` VALUES (12, 1012, '韩梅', 'DOC012', 4, '主治医师', '干眼、角膜炎、屈光检查', '强调规范检查与长期随访', NULL, 25.00, 20, 0, 0, '', '2026-03-02 11:09:16', '', NULL, NULL);
INSERT INTO `medical_doctor` VALUES (13, 1013, '赵磊', 'DOC013', 5, '医师', '龋齿治疗、牙周基础治疗', '注重舒适化治疗体验', NULL, 20.00, 18, 0, 0, '', '2026-03-02 11:09:16', '', NULL, NULL);
INSERT INTO `medical_doctor` VALUES (14, 1014, '彭杰', 'DOC014', 7, '主治医师', '慢阻肺、肺结节随访', '擅长慢病长期管理与风险评估', NULL, 20.00, 25, 0, 0, '', '2026-03-02 11:09:16', '', NULL, NULL);
INSERT INTO `medical_doctor` VALUES (15, 1015, '宋敏', 'DOC015', 8, '主治医师', '湿疹、荨麻疹、皮肤过敏', '擅长过敏原筛查与综合治疗', NULL, 20.00, 25, 0, 0, '', '2026-03-02 11:09:16', '', NULL, NULL);
INSERT INTO `medical_doctor` VALUES (16, 1016, '许倩', 'DOC016', 8, '副主任医师', '痤疮、玫瑰痤疮、皮肤美容', '注重皮肤屏障修复与生活方式指导', NULL, 30.00, 20, 0, 0, '', '2026-03-02 11:09:16', '', NULL, NULL);
INSERT INTO `medical_doctor` VALUES (17, 1017, '秦浩', 'DOC017', 9, '主治医师', '鼻炎、鼻窦炎、鼾症评估', '强调规范检查与阶梯治疗', NULL, 25.00, 22, 0, 0, '', '2026-03-02 11:09:16', '', NULL, NULL);
INSERT INTO `medical_doctor` VALUES (18, 1018, '何婷', 'DOC018', 9, '医师', '咽喉炎、耳鸣眩晕初筛', '门诊接诊细致，重视随访', NULL, 20.00, 24, 0, 0, '', '2026-03-02 11:09:16', '', NULL, NULL);

SET FOREIGN_KEY_CHECKS = 1;
