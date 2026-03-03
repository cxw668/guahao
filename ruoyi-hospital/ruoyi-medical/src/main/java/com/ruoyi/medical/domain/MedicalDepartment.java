package com.ruoyi.medical.domain;

import com.ruoyi.common.core.domain.BaseEntity;
import lombok.Data;

@Data
public class MedicalDepartment extends BaseEntity
{
    // 序列化版本验证 + 反序列化检查 => 数据持久化
    private static final long serialVersionUID = 1L;

    private Long deptId;

    private String deptName;

    private String deptCode;

    private Long parentId;

    private Integer deptType;

    private String location;

    private String phone;

    private String intro;

    private Integer sortOrder;

    private Integer status;
}
