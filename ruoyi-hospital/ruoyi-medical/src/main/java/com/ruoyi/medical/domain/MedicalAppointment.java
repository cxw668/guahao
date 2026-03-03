package com.ruoyi.medical.domain;

import java.math.BigDecimal;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.ruoyi.common.core.domain.BaseEntity;
import lombok.Data;

@Data
public class MedicalAppointment extends BaseEntity {
    private static final long serialVersionUID = 1L;

    private Long appointmentId;

    private String appointmentNo;

    private Long patientId;

    private Long visitorId;

    private Long doctorId;

    private Long scheduleId;

    @JsonFormat(pattern = "yyyy-MM-dd")
    private Date appointmentDate;

    private Integer period;

    private String timeSlot;

    private Integer status;

    private BigDecimal fee;

    private Integer payStatus;

    private Date payTime;

    private String payWay;

    private Date checkinTime;

    private Date finishTime;

    private Date cancelTime;

    private String cancelReason;

    private Long medicalRecordId;
}
