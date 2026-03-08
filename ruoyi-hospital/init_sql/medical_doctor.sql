create table medical_doctor
(
    doctor_id    bigint auto_increment comment '医生ID'
        primary key,
    user_id      bigint                      null comment '关联系统用户ID（RuoYi sys_user）',
    doctor_name  varchar(50)                 not null comment '医生姓名',
    doctor_code  varchar(20)                 not null comment '医生工号',
    dept_id      bigint                      not null comment '所属科室ID',
    title        varchar(20)                 null comment '职称：主任医师/副主任医师/主治医师/医师',
    specialty    varchar(500)                null comment '擅长领域',
    intro        text                        null comment '医生简介',
    avatar       varchar(200)                null comment '头像URL',
    fee          decimal(10, 2) default 0.00 null comment '挂号费',
    max_patients int            default 20   null comment '半日最大接诊数',
    work_status  tinyint        default 0    null comment '工作状态：0在职 1休假 2离职',
    status       tinyint        default 0    null comment '预约状态：0可约 1暂停',
    create_by    varchar(64)    default ''   null comment '创建者',
    create_time  datetime                    null comment '创建时间',
    update_by    varchar(64)    default ''   null comment '更新者',
    update_time  datetime                    null comment '更新时间',
    remark       varchar(500)                null comment '备注',
    constraint uk_doctor_code
        unique (doctor_code)
)
    comment '医生信息表' charset = utf8mb4;

create index idx_dept_id
    on medical_doctor (dept_id);

INSERT INTO ruoyi_hospital.medical_doctor (doctor_id, user_id, doctor_name, doctor_code, dept_id, title, specialty, intro, avatar, fee, max_patients, work_status, status, create_by, create_time, update_by, update_time, remark) VALUES (1, 1001, '张伟', 'DOC001', 6, '主任医师', '冠心病介入治疗、高血压管理', '从事心血管临床工作20年，擅长复杂冠脉病变处理', null, 50.00, 30, 0, 1, '', '2026-03-02 11:09:16', 'admin', '2026-03-04 10:44:16', null);
INSERT INTO ruoyi_hospital.medical_doctor (doctor_id, user_id, doctor_name, doctor_code, dept_id, title, specialty, intro, avatar, fee, max_patients, work_status, status, create_by, create_time, update_by, update_time, remark) VALUES (2, 1002, '李娜', 'DOC002', 6, '副主任医师', '心律失常、心力衰竭', '精通起搏器植入术，对难治性心衰有独到见解', null, 30.00, 25, 0, 0, '', '2026-03-02 11:09:16', '', null, null);
INSERT INTO ruoyi_hospital.medical_doctor (doctor_id, user_id, doctor_name, doctor_code, dept_id, title, specialty, intro, avatar, fee, max_patients, work_status, status, create_by, create_time, update_by, update_time, remark) VALUES (3, 1003, '王强', 'DOC003', 2, '主治医师', '腹腔镜微创手术、胃肠肿瘤', '累计完成腹腔镜手术超过2000例', null, 20.00, 20, 0, 0, '', '2026-03-02 11:09:16', '', null, null);
INSERT INTO ruoyi_hospital.medical_doctor (doctor_id, user_id, doctor_name, doctor_code, dept_id, title, specialty, intro, avatar, fee, max_patients, work_status, status, create_by, create_time, update_by, update_time, remark) VALUES (4, 1004, '赵敏', 'DOC004', 3, '主任医师', '小儿呼吸系统疾病、新生儿护理', '儿科专家，深受小朋友喜爱，耐心细致', null, 40.00, 35, 0, 0, '', '2026-03-02 11:09:16', '', null, null);
INSERT INTO ruoyi_hospital.medical_doctor (doctor_id, user_id, doctor_name, doctor_code, dept_id, title, specialty, intro, avatar, fee, max_patients, work_status, status, create_by, create_time, update_by, update_time, remark) VALUES (5, 1005, '孙丽', 'DOC005', 4, '副主任医师', '青少年近视防控、屈光手术', '拥有万例近视激光手术成功经验', null, 35.00, 20, 0, 0, '', '2026-03-02 11:09:16', '', null, null);
INSERT INTO ruoyi_hospital.medical_doctor (doctor_id, user_id, doctor_name, doctor_code, dept_id, title, specialty, intro, avatar, fee, max_patients, work_status, status, create_by, create_time, update_by, update_time, remark) VALUES (6, 1006, '周杰', 'DOC006', 5, '主治医师', '隐形矫正、种植牙', '美学修复专家，注重功能与美观并重', null, 25.00, 15, 0, 0, '', '2026-03-02 11:09:16', '', null, null);
INSERT INTO ruoyi_hospital.medical_doctor (doctor_id, user_id, doctor_name, doctor_code, dept_id, title, specialty, intro, avatar, fee, max_patients, work_status, status, create_by, create_time, update_by, update_time, remark) VALUES (7, 1007, '吴刚', 'DOC007', 7, '住院医师', '慢性咳嗽、哮喘管理', '专注于呼吸慢病的全程管理', null, 15.00, 30, 0, 0, '', '2026-03-02 11:09:16', '', null, null);
INSERT INTO ruoyi_hospital.medical_doctor (doctor_id, user_id, doctor_name, doctor_code, dept_id, title, specialty, intro, avatar, fee, max_patients, work_status, status, create_by, create_time, update_by, update_time, remark) VALUES (8, 1008, '刘洋', 'DOC008', 1, '主治医师', '消化系统疾病、幽门螺杆菌管理', '擅长常见内科疾病的规范化诊疗', null, 20.00, 25, 0, 0, '', '2026-03-02 11:09:16', '', null, null);
INSERT INTO ruoyi_hospital.medical_doctor (doctor_id, user_id, doctor_name, doctor_code, dept_id, title, specialty, intro, avatar, fee, max_patients, work_status, status, create_by, create_time, update_by, update_time, remark) VALUES (9, 1009, '高峰', 'DOC009', 1, '医师', '呼吸道感染、慢病随访', '注重循证医学与全程管理', null, 15.00, 30, 0, 0, '', '2026-03-02 11:09:16', '', null, null);
INSERT INTO ruoyi_hospital.medical_doctor (doctor_id, user_id, doctor_name, doctor_code, dept_id, title, specialty, intro, avatar, fee, max_patients, work_status, status, create_by, create_time, update_by, update_time, remark) VALUES (10, 1010, '郑凯', 'DOC010', 2, '主治医师', '腹腔镜微创、疝气修补', '手术经验丰富，恢复方案个体化', null, 25.00, 20, 0, 0, '', '2026-03-02 11:09:16', '', null, null);
INSERT INTO ruoyi_hospital.medical_doctor (doctor_id, user_id, doctor_name, doctor_code, dept_id, title, specialty, intro, avatar, fee, max_patients, work_status, status, create_by, create_time, update_by, update_time, remark) VALUES (11, 1011, '林珊', 'DOC011', 3, '副主任医师', '儿童呼吸系统疾病、过敏性疾病', '专注儿童慢病管理与健康指导', null, 35.00, 25, 0, 0, '', '2026-03-02 11:09:16', '', null, null);
INSERT INTO ruoyi_hospital.medical_doctor (doctor_id, user_id, doctor_name, doctor_code, dept_id, title, specialty, intro, avatar, fee, max_patients, work_status, status, create_by, create_time, update_by, update_time, remark) VALUES (12, 1012, '韩梅', 'DOC012', 4, '主治医师', '干眼、角膜炎、屈光检查', '强调规范检查与长期随访', null, 25.00, 20, 0, 0, '', '2026-03-02 11:09:16', '', null, null);
INSERT INTO ruoyi_hospital.medical_doctor (doctor_id, user_id, doctor_name, doctor_code, dept_id, title, specialty, intro, avatar, fee, max_patients, work_status, status, create_by, create_time, update_by, update_time, remark) VALUES (13, 1013, '赵磊', 'DOC013', 5, '医师', '龋齿治疗、牙周基础治疗', '注重舒适化治疗体验', null, 20.00, 18, 0, 0, '', '2026-03-02 11:09:16', '', null, null);
INSERT INTO ruoyi_hospital.medical_doctor (doctor_id, user_id, doctor_name, doctor_code, dept_id, title, specialty, intro, avatar, fee, max_patients, work_status, status, create_by, create_time, update_by, update_time, remark) VALUES (14, 1014, '彭杰', 'DOC014', 7, '主治医师', '慢阻肺、肺结节随访', '擅长慢病长期管理与风险评估', null, 20.00, 25, 0, 0, '', '2026-03-02 11:09:16', '', null, null);
INSERT INTO ruoyi_hospital.medical_doctor (doctor_id, user_id, doctor_name, doctor_code, dept_id, title, specialty, intro, avatar, fee, max_patients, work_status, status, create_by, create_time, update_by, update_time, remark) VALUES (15, 1015, '宋敏', 'DOC015', 8, '主治医师', '湿疹、荨麻疹、皮肤过敏', '擅长过敏原筛查与综合治疗', null, 20.00, 25, 0, 0, '', '2026-03-02 11:09:16', '', null, null);
INSERT INTO ruoyi_hospital.medical_doctor (doctor_id, user_id, doctor_name, doctor_code, dept_id, title, specialty, intro, avatar, fee, max_patients, work_status, status, create_by, create_time, update_by, update_time, remark) VALUES (16, 1016, '许倩', 'DOC016', 8, '副主任医师', '痤疮、玫瑰痤疮、皮肤美容', '注重皮肤屏障修复与生活方式指导', null, 30.00, 20, 0, 0, '', '2026-03-02 11:09:16', '', null, null);
INSERT INTO ruoyi_hospital.medical_doctor (doctor_id, user_id, doctor_name, doctor_code, dept_id, title, specialty, intro, avatar, fee, max_patients, work_status, status, create_by, create_time, update_by, update_time, remark) VALUES (17, 1017, '秦浩', 'DOC017', 9, '主治医师', '鼻炎、鼻窦炎、鼾症评估', '强调规范检查与阶梯治疗', null, 25.00, 22, 0, 0, '', '2026-03-02 11:09:16', '', null, null);
INSERT INTO ruoyi_hospital.medical_doctor (doctor_id, user_id, doctor_name, doctor_code, dept_id, title, specialty, intro, avatar, fee, max_patients, work_status, status, create_by, create_time, update_by, update_time, remark) VALUES (18, 1018, '何婷', 'DOC018', 9, '医师', '咽喉炎、耳鸣眩晕初筛', '门诊接诊细致，重视随访', null, 20.00, 24, 0, 0, '', '2026-03-02 11:09:16', '', null, null);
