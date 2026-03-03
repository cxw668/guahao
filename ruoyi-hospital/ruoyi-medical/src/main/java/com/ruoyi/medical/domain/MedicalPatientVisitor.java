package com.ruoyi.medical.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.ruoyi.common.core.domain.BaseEntity;
import lombok.Data;

@Data
public class MedicalPatientVisitor extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    private Long visitorId;

    private Long patientId;

    private String name;

    private String idCard;

    private String phone;

    private String relation;

    private Integer gender;

    @JsonFormat(pattern = "yyyy-MM-dd")
    private Date birthDate;

    private String medicalCardNo;

    private String allergyHistory;

    private String pastHistory;

    private Integer isDefault;

    private Integer status;
}
