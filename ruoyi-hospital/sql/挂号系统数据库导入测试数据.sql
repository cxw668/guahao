-- ==========================================
-- 1. 插入科室数据 (medical_department)
-- ==========================================
INSERT INTO medical_department (dept_name, dept_code, parent_id, dept_type, location, phone, intro, sort_order, status, create_time) VALUES
('内科', 'NK001', 0, 1, '门诊楼2层', '010-88881001', '主要诊治呼吸、消化、心血管等内部系统疾病', 1, 0, NOW()),
('外科', 'WK001', 0, 1, '门诊楼3层', '010-88881002', '涵盖普外、骨科、神经外科等手术治疗', 2, 0, NOW()),
('儿科', 'EK001', 0, 1, '门诊楼1层', '010-88881003', '专为0-14岁儿童提供医疗服务', 3, 0, NOW()),
('眼科', 'YK001', 0, 1, '门诊楼4层', '010-88881004', '近视矫正、白内障、青光眼等眼部疾病', 4, 0, NOW()),
('口腔科', 'KQ001', 0, 1, '门诊楼4层', '010-88881005', '牙齿种植、正畸、牙周治疗', 5, 0, NOW()),
('心血管内科', 'XXGNK', 1, 1, '门诊楼2层A区', '010-88881006', '高血压、冠心病、心律失常专病门诊', 10, 0, NOW()),
('呼吸内科', 'HXNK', 1, 1, '门诊楼2层B区', '010-88881007', '哮喘、慢阻肺、肺炎等呼吸道疾病', 11, 0, NOW());

-- ==========================================
-- 2. 插入医生数据 (medical_doctor)
-- ==========================================
-- 假设 user_id 暂时填 0 或 1001-1005，实际使用时需关联 sys_user 表
INSERT INTO medical_doctor (user_id, doctor_name, doctor_code, dept_id, title, specialty, intro, fee, max_patients, work_status, status, create_time) VALUES
(1001, '张伟', 'DOC001', 6, '主任医师', '冠心病介入治疗、高血压管理', '从事心血管临床工作20年，擅长复杂冠脉病变处理', 50.00, 30, 0, 0, NOW()),
(1002, '李娜', 'DOC002', 6, '副主任医师', '心律失常、心力衰竭', '精通起搏器植入术，对难治性心衰有独到见解', 30.00, 25, 0, 0, NOW()),
(1003, '王强', 'DOC003', 2, '主治医师', '腹腔镜微创手术、胃肠肿瘤', '累计完成腹腔镜手术超过2000例', 20.00, 20, 0, 0, NOW()),
(1004, '赵敏', 'DOC004', 3, '主任医师', '小儿呼吸系统疾病、新生儿护理', '儿科专家，深受小朋友喜爱，耐心细致', 40.00, 35, 0, 0, NOW()),
(1005, '孙丽', 'DOC005', 4, '副主任医师', '青少年近视防控、屈光手术', '拥有万例近视激光手术成功经验', 35.00, 20, 0, 0, NOW()),
(1006, '周杰', 'DOC006', 5, '主治医师', '隐形矫正、种植牙', '美学修复专家，注重功能与美观并重', 25.00, 15, 0, 0, NOW()),
(1007, '吴刚', 'DOC007', 7, '住院医师', '慢性咳嗽、哮喘管理', '专注于呼吸慢病的全程管理', 15.00, 30, 0, 0, NOW());

-- ==========================================
-- 3. 插入排班数据 (medical_schedule)
-- ==========================================
-- 生成未来3天的排班 (假设今天是 2023-10-27，实际执行时会基于当前日期)
-- 上午(1), 下午(2), 晚间(3)
INSERT INTO medical_schedule (doctor_id, work_date, period, start_time, end_time, total_slots, booked_slots, slot_minutes, status, create_time) VALUES
-- 张伟 (心血管)
(1, DATE_ADD(CURDATE(), INTERVAL 1 DAY), 1, '08:00:00', '12:00:00', 20, 15, 15, 0, NOW()),
(1, DATE_ADD(CURDATE(), INTERVAL 1 DAY), 2, '14:00:00', '17:00:00', 15, 15, 15, 2, NOW()), -- 已满
(1, DATE_ADD(CURDATE(), INTERVAL 2 DAY), 1, '08:00:00', '12:00:00', 20, 5, 15, 0, NOW()),

-- 李娜 (心血管)
(2, DATE_ADD(CURDATE(), INTERVAL 1 DAY), 2, '14:00:00', '17:30:00', 18, 10, 15, 0, NOW()),
(2, DATE_ADD(CURDATE(), INTERVAL 3 DAY), 1, '08:00:00', '12:00:00', 20, 0, 15, 0, NOW()),

-- 王强 (外科)
(3, DATE_ADD(CURDATE(), INTERVAL 1 DAY), 1, '08:30:00', '12:00:00', 15, 8, 20, 0, NOW()),
(3, DATE_ADD(CURDATE(), INTERVAL 2 DAY), 2, '14:00:00', '17:00:00', 15, 2, 20, 0, NOW()),

-- 赵敏 (儿科)
(4, DATE_ADD(CURDATE(), INTERVAL 1 DAY), 1, '08:00:00', '12:00:00', 30, 28, 10, 0, NOW()),
(4, DATE_ADD(CURDATE(), INTERVAL 1 DAY), 2, '14:00:00', '18:00:00', 30, 12, 10, 0, NOW()),

-- 孙丽 (眼科)
(5, DATE_ADD(CURDATE(), INTERVAL 2 DAY), 1, '09:00:00', '12:00:00', 15, 5, 20, 0, NOW()),
(5, DATE_ADD(CURDATE(), INTERVAL 3 DAY), 2, '14:00:00', '17:00:00', 15, 0, 20, 0, NOW());

-- ==========================================
-- 4. 插入就诊人数据 (medical_patient_visitor)
-- ==========================================
-- 假设 patient_id 1001 是主账户，为其添加本人和家属
INSERT INTO medical_patient_visitor (patient_id, name, id_card, phone, relation, gender, birth_date, medical_card_no, allergy_history, past_history, is_default, status, create_time) VALUES
(1001, '张三', '110101199001011234', '13800138001', '本人', 0, '1990-01-01', 'BJ12345678', '无', '高血压', 1, 0, NOW()),
(1001, '李四', '110101199202022345', '13800138002', '配偶', 1, '1992-02-02', 'BJ87654321', '青霉素过敏', '无', 0, 0, NOW()),
(1001, '张小宝', '110101201505053456', '13800138001', '子女', 0, '2015-05-05', 'BJ11223344', '无', '幼年哮喘', 0, 0, NOW()),
(1002, '王五', '110101198503034567', '13900139001', '本人', 0, '1985-03-03', 'SH99887766', '磺胺类过敏', '糖尿病', 1, 0, NOW());

-- ==========================================
-- 5. 插入预约记录 (medical_appointment)
-- ==========================================
-- 需要关联上面生成的 schedule_id，这里假设 schedule_id 从 1 开始连续
-- 注意：实际执行时，请根据数据库中实际生成的 schedule_id 调整，或者使用子查询动态获取

-- 预约1: 张三挂张伟明天的号 (状态：待支付)
INSERT INTO medical_appointment (appointment_no, patient_id, visitor_id, doctor_id, schedule_id, appointment_date, period, time_slot, status, fee, pay_status, create_time) 
VALUES ('APT20231028001', 1001, 1, 1, 1, DATE_ADD(CURDATE(), INTERVAL 1 DAY), 1, '08:00-08:15', 0, 50.00, 0, NOW());

-- 预约2: 李四挂张伟明天的号 (状态：已完成 - 假设是过去的数据或逻辑上已完成)
-- 为了演示，我们创建一个已支付的记录，状态改为待就诊 (1)
INSERT INTO medical_appointment (appointment_no, patient_id, visitor_id, doctor_id, schedule_id, appointment_date, period, time_slot, status, fee, pay_status, pay_time, pay_way, create_time) 
VALUES ('APT20231028002', 1001, 2, 1, 1, DATE_ADD(CURDATE(), INTERVAL 1 DAY), 1, '08:15-08:30', 1, 50.00, 1, NOW(), 'wechat', NOW());

-- 预约3: 张小宝挂赵敏明天的号 (状态：待就诊)
INSERT INTO medical_appointment (appointment_no, patient_id, visitor_id, doctor_id, schedule_id, appointment_date, period, time_slot, status, fee, pay_status, pay_time, pay_way, create_time) 
VALUES ('APT20231028003', 1001, 3, 4, 8, DATE_ADD(CURDATE(), INTERVAL 1 DAY), 1, '09:00-09:10', 1, 40.00, 1, NOW(), 'alipay', NOW());

-- 预约4: 王五挂王强的号 (状态：已取消)
INSERT INTO medical_appointment (appointment_no, patient_id, visitor_id, doctor_id, schedule_id, appointment_date, period, time_slot, status, fee, pay_status, cancel_time, cancel_reason, create_time) 
VALUES ('APT20231028004', 1002, 4, 3, 6, DATE_ADD(CURDATE(), INTERVAL 1 DAY), 1, '09:00-09:20', 4, 20.00, 2, NOW(), '行程冲突', NOW());

-- 预约5: 张三挂李娜的号 (状态：待支付)
INSERT INTO medical_appointment (appointment_no, patient_id, visitor_id, doctor_id, schedule_id, appointment_date, period, time_slot, status, fee, pay_status, create_time) 
VALUES ('APT20231028005', 1001, 1, 2, 4, DATE_ADD(CURDATE(), INTERVAL 1 DAY), 2, '14:00-14:15', 0, 30.00, 0, NOW());

-- 提示：由于 schedule_id 是自增的，上述 SQL 中的 schedule_id (1, 4, 6, 8) 是基于插入顺序的假设。
-- 如果执行后 ID 不匹配，可以通过以下逻辑修正（可选）：
-- 先查询实际的 schedule_id: SELECT schedule_id, doctor_id, work_date FROM medical_schedule;
-- 然后更新 appointment 表中的 schedule_id 以匹配正确的排班。