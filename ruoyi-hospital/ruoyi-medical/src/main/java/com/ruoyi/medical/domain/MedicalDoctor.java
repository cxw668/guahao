package com.ruoyi.medical.domain;

import java.math.BigDecimal;
import com.ruoyi.common.core.domain.BaseEntity;
import lombok.Data;

@Data
public class MedicalDoctor extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    private Long doctorId;

    private Long userId;

    private String doctorName;

    private String doctorCode;

    private Long deptId;

    private String title;

    private String specialty;

    private String intro;

    private String avatar;

    private BigDecimal fee;

    private Integer maxPatients;

    private Integer workStatus;

    private Integer status;
}
