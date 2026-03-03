package com.ruoyi.medical.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.ruoyi.common.core.domain.BaseEntity;
import lombok.Data;

@Data
public class MedicalSchedule extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    private Long scheduleId;

    private Long doctorId;

    @JsonFormat(pattern = "yyyy-MM-dd")
    private Date workDate;

    private Integer period;

    private String startTime;

    private String endTime;

    private Integer totalSlots;

    private Integer bookedSlots;

    private Integer slotMinutes;

    private Integer status;
}
