create table medical_appointment
(
    appointment_id    bigint auto_increment comment '预约ID'
        primary key,
    appointment_no    varchar(32)                 not null comment '预约单号（业务唯一）',
    patient_id        bigint                      not null comment '患者ID（关联sys_user）',
    visitor_id        bigint                      null comment '就诊人ID（0表示本人）',
    doctor_id         bigint                      not null comment '医生ID',
    schedule_id       bigint                      not null comment '排班ID',
    appointment_date  date                        not null comment '预约就诊日期',
    period tinyint not null comment '时段',
    time_slot         varchar(20)                 null comment '具体时间段（如08:00-08:30）',
    status            tinyint        default 0    null comment '状态：0待支付 1待就诊 2就诊中 3已完成 4已取消 5失约',
    fee               decimal(10, 2) default 0.00 null comment '挂号费',
    pay_status        tinyint        default 0    null comment '支付状态：0未支付 1已支付 2已退款',
    pay_time          datetime                    null comment '支付时间',
    pay_way           varchar(20)                 null comment '支付方式：wechat/alipay',
    checkin_time      datetime                    null comment '签到时间',
    finish_time       datetime                    null comment '就诊完成时间',
    cancel_time       datetime                    null comment '取消时间',
    cancel_reason     varchar(200)                null comment '取消原因',
    medical_record_id bigint                      null comment '关联病历ID',
    create_by         varchar(64)    default ''   null comment '创建者',
    create_time       datetime                    null comment '创建时间',
    update_by         varchar(64)    default ''   null comment '更新者',
    update_time       datetime                    null comment '更新时间',
    remark            varchar(500)                null comment '备注',
    constraint uk_appointment_no
        unique (appointment_no)
)
    comment '预约订单表' charset = utf8mb4;

create index idx_doctor_date
    on medical_appointment (doctor_id, appointment_date);

create index idx_patient_id
    on medical_appointment (patient_id);

create index idx_status
    on medical_appointment (status);

INSERT INTO ruoyi_hospital.medical_appointment (appointment_id, appointment_no, patient_id, visitor_id, doctor_id, schedule_id, appointment_date, period, time_slot, status, fee, pay_status, pay_time, pay_way, checkin_time, finish_time, cancel_time, cancel_reason, medical_record_id, create_by, create_time, update_by, update_time, remark) VALUES (1, 'APT20231028001', 1001, 1, 1, 1, '2026-03-03', 1, '08:00-08:15', 5, 50.00, 0, null, null, null, null, null, null, null, '', '2026-03-02 11:09:16', 'system_job', '2026-03-04 15:03:57', null);
INSERT INTO ruoyi_hospital.medical_appointment (appointment_id, appointment_no, patient_id, visitor_id, doctor_id, schedule_id, appointment_date, period, time_slot, status, fee, pay_status, pay_time, pay_way, checkin_time, finish_time, cancel_time, cancel_reason, medical_record_id, create_by, create_time, update_by, update_time, remark) VALUES (2, 'APT20231028002', 1001, 2, 1, 1, '2026-03-03', 1, '08:15-08:30', 5, 50.00, 1, '2026-03-02 11:09:16', 'wechat', null, null, null, null, null, '', '2026-03-02 11:09:16', 'system_job', '2026-03-04 15:03:57', null);
INSERT INTO ruoyi_hospital.medical_appointment (appointment_id, appointment_no, patient_id, visitor_id, doctor_id, schedule_id, appointment_date, period, time_slot, status, fee, pay_status, pay_time, pay_way, checkin_time, finish_time, cancel_time, cancel_reason, medical_record_id, create_by, create_time, update_by, update_time, remark) VALUES (3, 'APT20231028003', 1001, 3, 4, 8, '2026-03-03', 1, '09:00-09:10', 5, 40.00, 1, '2026-03-02 11:09:16', 'alipay', null, null, null, null, null, '', '2026-03-02 11:09:16', 'system_job', '2026-03-04 15:03:57', null);
INSERT INTO ruoyi_hospital.medical_appointment (appointment_id, appointment_no, patient_id, visitor_id, doctor_id, schedule_id, appointment_date, period, time_slot, status, fee, pay_status, pay_time, pay_way, checkin_time, finish_time, cancel_time, cancel_reason, medical_record_id, create_by, create_time, update_by, update_time, remark) VALUES (4, 'APT20231028004', 1002, 4, 3, 6, '2026-03-03', 1, '09:00-09:20', 4, 20.00, 2, null, null, null, null, '2026-03-02 11:09:16', '行程冲突', null, '', '2026-03-02 11:09:16', '', null, null);
INSERT INTO ruoyi_hospital.medical_appointment (appointment_id, appointment_no, patient_id, visitor_id, doctor_id, schedule_id, appointment_date, period, time_slot, status, fee, pay_status, pay_time, pay_way, checkin_time, finish_time, cancel_time, cancel_reason, medical_record_id, create_by, create_time, update_by, update_time, remark) VALUES (5, 'APT20231028005', 1001, 1, 2, 4, '2026-03-03', 2, '14:00-14:15', 5, 30.00, 1, '2026-03-02 13:21:58', 'wechat', null, null, null, null, null, '', '2026-03-02 11:09:16', 'system_job', '2026-03-04 15:03:57', null);
INSERT INTO ruoyi_hospital.medical_appointment (appointment_id, appointment_no, patient_id, visitor_id, doctor_id, schedule_id, appointment_date, period, time_slot, status, fee, pay_status, pay_time, pay_way, checkin_time, finish_time, cancel_time, cancel_reason, medical_record_id, create_by, create_time, update_by, update_time, remark) VALUES (6, 'APT17725219518548092', 2, 5, 3, 6, '2026-03-03', 1, '08:30-12:00', 5, 20.00, 1, '2026-03-03 15:12:31', 'wechat', '2026-03-04 14:35:38', null, null, null, null, 'common', '2026-03-03 15:12:31', 'system_job', '2026-03-04 15:03:57', null);
INSERT INTO ruoyi_hospital.medical_appointment (appointment_id, appointment_no, patient_id, visitor_id, doctor_id, schedule_id, appointment_date, period, time_slot, status, fee, pay_status, pay_time, pay_way, checkin_time, finish_time, cancel_time, cancel_reason, medical_record_id, create_by, create_time, update_by, update_time, remark) VALUES (7, 'APT17727608194364778', 2, 5, 9, 138, '2026-03-09', 1, '08:00-12:00', 4, 15.00, 0, null, null, null, null, '2026-03-06 09:34:02', '11', null, 'common', '2026-03-06 09:33:39', 'common', '2026-03-06 09:34:02', null);
INSERT INTO ruoyi_hospital.medical_appointment (appointment_id, appointment_no, patient_id, visitor_id, doctor_id, schedule_id, appointment_date, period, time_slot, status, fee, pay_status, pay_time, pay_way, checkin_time, finish_time, cancel_time, cancel_reason, medical_record_id, create_by, create_time, update_by, update_time, remark) VALUES (8, 'APT17727608543523681', 2, 5, 10, 124, '2026-03-09', 1, '08:00-12:00', 4, 25.00, 1, '2026-03-06 09:34:14', 'alipay', null, null, '2026-03-06 09:34:38', '11', null, 'common', '2026-03-06 09:34:14', 'common', '2026-03-06 09:34:38', null);
INSERT INTO ruoyi_hospital.medical_appointment (appointment_id, appointment_no, patient_id, visitor_id, doctor_id, schedule_id, appointment_date, period, time_slot, status, fee, pay_status, pay_time, pay_way, checkin_time, finish_time, cancel_time, cancel_reason, medical_record_id, create_by, create_time, update_by, update_time, remark) VALUES (12, 'APT17727635597362095', 2, 5, 3, 222, '2026-03-09', 1, '08:00-12:00', 4, 20.00, 1, '2026-03-06 10:19:19', 'wechat', null, null, '2026-03-06 10:20:48', '11', null, 'common', '2026-03-06 10:19:19', 'common', '2026-03-06 10:20:48', null);
