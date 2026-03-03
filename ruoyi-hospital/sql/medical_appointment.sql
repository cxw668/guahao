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

 Date: 03/03/2026 14:42:53
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for medical_appointment
-- ----------------------------
DROP TABLE IF EXISTS `medical_appointment`;
CREATE TABLE `medical_appointment`  (
  `appointment_id` bigint NOT NULL AUTO_INCREMENT COMMENT '预约ID',
  `appointment_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '预约单号（业务唯一）',
  `patient_id` bigint NOT NULL COMMENT '患者ID（关联sys_user）',
  `visitor_id` bigint NULL DEFAULT NULL COMMENT '就诊人ID（0表示本人）',
  `doctor_id` bigint NOT NULL COMMENT '医生ID',
  `schedule_id` bigint NOT NULL COMMENT '排班ID',
  `appointment_date` date NOT NULL COMMENT '预约就诊日期',
  `period` tinyint NOT NULL COMMENT '时段',
  `time_slot` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '具体时间段（如08:00-08:30）',
  `status` tinyint NULL DEFAULT 0 COMMENT '状态：0待支付 1待就诊 2就诊中 3已完成 4已取消 5失约',
  `fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '挂号费',
  `pay_status` tinyint NULL DEFAULT 0 COMMENT '支付状态：0未支付 1已支付 2已退款',
  `pay_time` datetime NULL DEFAULT NULL COMMENT '支付时间',
  `pay_way` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '支付方式：wechat/alipay',
  `checkin_time` datetime NULL DEFAULT NULL COMMENT '签到时间',
  `finish_time` datetime NULL DEFAULT NULL COMMENT '就诊完成时间',
  `cancel_time` datetime NULL DEFAULT NULL COMMENT '取消时间',
  `cancel_reason` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '取消原因',
  `medical_record_id` bigint NULL DEFAULT NULL COMMENT '关联病历ID',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`appointment_id`) USING BTREE,
  UNIQUE INDEX `uk_appointment_no`(`appointment_no` ASC) USING BTREE,
  INDEX `idx_patient_id`(`patient_id` ASC) USING BTREE,
  INDEX `idx_doctor_date`(`doctor_id` ASC, `appointment_date` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '预约订单表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of medical_appointment
-- ----------------------------
INSERT INTO `medical_appointment` VALUES (1, 'APT20231028001', 1001, 1, 1, 1, '2026-03-03', 1, '08:00-08:15', 0, 50.00, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', '2026-03-02 11:09:16', '', NULL, NULL);
INSERT INTO `medical_appointment` VALUES (2, 'APT20231028002', 1001, 2, 1, 1, '2026-03-03', 1, '08:15-08:30', 1, 50.00, 1, '2026-03-02 11:09:16', 'wechat', NULL, NULL, NULL, NULL, NULL, '', '2026-03-02 11:09:16', '', NULL, NULL);
INSERT INTO `medical_appointment` VALUES (3, 'APT20231028003', 1001, 3, 4, 8, '2026-03-03', 1, '09:00-09:10', 1, 40.00, 1, '2026-03-02 11:09:16', 'alipay', NULL, NULL, NULL, NULL, NULL, '', '2026-03-02 11:09:16', '', NULL, NULL);
INSERT INTO `medical_appointment` VALUES (4, 'APT20231028004', 1002, 4, 3, 6, '2026-03-03', 1, '09:00-09:20', 4, 20.00, 2, NULL, NULL, NULL, NULL, '2026-03-02 11:09:16', '行程冲突', NULL, '', '2026-03-02 11:09:16', '', NULL, NULL);
INSERT INTO `medical_appointment` VALUES (5, 'APT20231028005', 1001, 1, 2, 4, '2026-03-03', 2, '14:00-14:15', 1, 30.00, 1, '2026-03-02 13:21:58', 'wechat', NULL, NULL, NULL, NULL, NULL, '', '2026-03-02 11:09:16', 'admin', '2026-03-02 13:21:58', NULL);

SET FOREIGN_KEY_CHECKS = 1;
