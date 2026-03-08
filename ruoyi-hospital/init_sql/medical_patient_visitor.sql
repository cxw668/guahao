create table medical_patient_visitor
(
    visitor_id      bigint auto_increment comment '就诊人ID'
        primary key,
    patient_id      bigint            not null comment '主账户患者ID',
    name            varchar(50)       not null comment '姓名',
    id_card         varchar(18)       not null comment '身份证号（加密）',
    phone           varchar(11)       null comment '手机号',
    relation        varchar(10)       null comment '与主账户关系：本人/配偶/子女/父母/其他',
    gender          tinyint           null comment '性别：0男 1女',
    birth_date      date              null comment '出生日期',
    medical_card_no varchar(30)       null comment '医保卡号',
    allergy_history text              null comment '过敏史',
    past_history    text              null comment '既往病史',
    is_default      tinyint default 0 null comment '是否默认就诊人：0否 1是',
    status          tinyint default 0 null comment '状态：0正常 1删除',
    create_time     datetime          null comment '创建时间',
    update_time     datetime          null comment '更新时间'
)
    comment '就诊人档案表' charset = utf8mb4;

create index idx_patient_id
    on medical_patient_visitor (patient_id);

INSERT INTO ruoyi_hospital.medical_patient_visitor (visitor_id, patient_id, name, id_card, phone, relation, gender, birth_date, medical_card_no, allergy_history, past_history, is_default, status, create_time, update_time) VALUES (1, 1001, '张三', '110101199001011234', '13800138001', '本人', 0, '1990-01-01', 'BJ12345678', '无', '高血压', 1, 0, '2026-03-02 11:09:16', null);
INSERT INTO ruoyi_hospital.medical_patient_visitor (visitor_id, patient_id, name, id_card, phone, relation, gender, birth_date, medical_card_no, allergy_history, past_history, is_default, status, create_time, update_time) VALUES (2, 1001, '李四', '110101199202022345', '13800138002', '配偶', 1, '1992-02-02', 'BJ87654321', '青霉素过敏', '无', 0, 0, '2026-03-02 11:09:16', null);
INSERT INTO ruoyi_hospital.medical_patient_visitor (visitor_id, patient_id, name, id_card, phone, relation, gender, birth_date, medical_card_no, allergy_history, past_history, is_default, status, create_time, update_time) VALUES (3, 1001, '张小宝', '110101201505053456', '13800138001', '子女', 0, '2015-05-05', 'BJ11223344', '无', '幼年哮喘', 0, 0, '2026-03-02 11:09:16', null);
INSERT INTO ruoyi_hospital.medical_patient_visitor (visitor_id, patient_id, name, id_card, phone, relation, gender, birth_date, medical_card_no, allergy_history, past_history, is_default, status, create_time, update_time) VALUES (4, 1002, '王五', '110101198503034567', '13900139001', '本人', 0, '1985-03-03', 'SH99887766', '磺胺类过敏', '糖尿病', 1, 0, '2026-03-02 11:09:16', null);
INSERT INTO ruoyi_hospital.medical_patient_visitor (visitor_id, patient_id, name, id_card, phone, relation, gender, birth_date, medical_card_no, allergy_history, past_history, is_default, status, create_time, update_time) VALUES (5, 2, '11', '1', '1', '本人', 0, '2008-06-02', '', '', '', 1, 0, '2026-03-03 15:12:19', '2026-03-06 11:40:26');
