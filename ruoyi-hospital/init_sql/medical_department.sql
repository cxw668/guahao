create table medical_department
(
    dept_id     bigint auto_increment comment '科室ID'
        primary key,
    dept_name   varchar(50)            not null comment '科室名称',
    dept_code   varchar(20)            not null comment '科室编码',
    parent_id   bigint      default 0  null comment '父科室ID（0为顶级）',
    dept_type   tinyint     default 1  null comment '科室类型：1门诊 2急诊 3住院 4医技',
    location    varchar(100)           null comment '科室位置（如：门诊楼3层）',
    phone       varchar(20)            null comment '科室电话',
    intro       text                   null comment '科室简介',
    sort_order  int         default 0  null comment '排序',
    status      tinyint     default 0  null comment '状态：0正常 1停用',
    create_by   varchar(64) default '' null comment '创建者',
    create_time datetime               null comment '创建时间',
    update_by   varchar(64) default '' null comment '更新者',
    update_time datetime               null comment '更新时间',
    remark      varchar(500)           null comment '备注',
    constraint uk_dept_code
        unique (dept_code)
)
    comment '科室信息表' charset = utf8mb4;

create index idx_parent_id
    on medical_department (parent_id);

INSERT INTO ruoyi_hospital.medical_department (dept_id, dept_name, dept_code, parent_id, dept_type, location, phone, intro, sort_order, status, create_by, create_time, update_by, update_time, remark) VALUES (1, '内科', 'NK001', 0, 4, '门诊楼2层', '010-88881001', '主要诊治呼吸、消化、心血管等内部系统疾病', 1, 0, '', '2026-03-02 11:09:16', 'admin', '2026-03-03 14:33:31', null);
INSERT INTO ruoyi_hospital.medical_department (dept_id, dept_name, dept_code, parent_id, dept_type, location, phone, intro, sort_order, status, create_by, create_time, update_by, update_time, remark) VALUES (2, '外科', 'WK001', 0, 1, '门诊楼3层', '010-88881002', '涵盖普外、骨科、神经外科等手术治疗', 2, 0, '', '2026-03-02 11:09:16', '', null, null);
INSERT INTO ruoyi_hospital.medical_department (dept_id, dept_name, dept_code, parent_id, dept_type, location, phone, intro, sort_order, status, create_by, create_time, update_by, update_time, remark) VALUES (3, '儿科', 'EK001', 0, 1, '门诊楼1层', '010-88881003', '专为0-14岁儿童提供医疗服务', 3, 0, '', '2026-03-02 11:09:16', '', null, null);
INSERT INTO ruoyi_hospital.medical_department (dept_id, dept_name, dept_code, parent_id, dept_type, location, phone, intro, sort_order, status, create_by, create_time, update_by, update_time, remark) VALUES (4, '眼科', 'YK001', 0, 1, '门诊楼4层', '010-88881004', '近视矫正、白内障、青光眼等眼部疾病', 4, 0, '', '2026-03-02 11:09:16', '', null, null);
INSERT INTO ruoyi_hospital.medical_department (dept_id, dept_name, dept_code, parent_id, dept_type, location, phone, intro, sort_order, status, create_by, create_time, update_by, update_time, remark) VALUES (5, '口腔科', 'KQ001', 0, 1, '门诊楼4层', '010-88881005', '牙齿种植、正畸、牙周治疗', 5, 0, '', '2026-03-02 11:09:16', '', null, null);
INSERT INTO ruoyi_hospital.medical_department (dept_id, dept_name, dept_code, parent_id, dept_type, location, phone, intro, sort_order, status, create_by, create_time, update_by, update_time, remark) VALUES (6, '心血管内科', 'XXGNK', 1, 1, '门诊楼2层A区', '010-88881006', '高血压、冠心病、心律失常专病门诊', 10, 0, '', '2026-03-02 11:09:16', '', null, null);
INSERT INTO ruoyi_hospital.medical_department (dept_id, dept_name, dept_code, parent_id, dept_type, location, phone, intro, sort_order, status, create_by, create_time, update_by, update_time, remark) VALUES (7, '呼吸内科', 'HXNK', 1, 1, '门诊楼2层B区', '010-88881007', '哮喘、慢阻肺、肺炎等呼吸道疾病', 11, 0, '', '2026-03-02 11:09:16', '', null, null);
INSERT INTO ruoyi_hospital.medical_department (dept_id, dept_name, dept_code, parent_id, dept_type, location, phone, intro, sort_order, status, create_by, create_time, update_by, update_time, remark) VALUES (8, '皮肤科', 'PFK001', 0, 1, '门诊楼1层', '010-88881008', '常见皮肤病、过敏性皮炎、痤疮等诊疗', 6, 0, '', '2026-03-02 11:09:16', '', null, null);
INSERT INTO ruoyi_hospital.medical_department (dept_id, dept_name, dept_code, parent_id, dept_type, location, phone, intro, sort_order, status, create_by, create_time, update_by, update_time, remark) VALUES (9, '耳鼻喉科', 'EBHK01', 0, 1, '门诊楼2层', '010-88881009', '鼻炎、咽喉炎、耳鸣耳聋等诊疗', 7, 0, '', '2026-03-02 11:09:16', '', null, null);
