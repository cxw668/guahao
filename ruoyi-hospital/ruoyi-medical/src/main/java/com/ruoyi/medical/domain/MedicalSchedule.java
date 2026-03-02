package com.ruoyi.medical.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.ruoyi.common.core.domain.BaseEntity;

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

    public Long getScheduleId()
    {
        return scheduleId;
    }

    public void setScheduleId(Long scheduleId)
    {
        this.scheduleId = scheduleId;
    }

    public Long getDoctorId()
    {
        return doctorId;
    }

    public void setDoctorId(Long doctorId)
    {
        this.doctorId = doctorId;
    }

    public Date getWorkDate()
    {
        return workDate;
    }

    public void setWorkDate(Date workDate)
    {
        this.workDate = workDate;
    }

    public Integer getPeriod()
    {
        return period;
    }

    public void setPeriod(Integer period)
    {
        this.period = period;
    }

    public String getStartTime()
    {
        return startTime;
    }

    public void setStartTime(String startTime)
    {
        this.startTime = startTime;
    }

    public String getEndTime()
    {
        return endTime;
    }

    public void setEndTime(String endTime)
    {
        this.endTime = endTime;
    }

    public Integer getTotalSlots()
    {
        return totalSlots;
    }

    public void setTotalSlots(Integer totalSlots)
    {
        this.totalSlots = totalSlots;
    }

    public Integer getBookedSlots()
    {
        return bookedSlots;
    }

    public void setBookedSlots(Integer bookedSlots)
    {
        this.bookedSlots = bookedSlots;
    }

    public Integer getSlotMinutes()
    {
        return slotMinutes;
    }

    public void setSlotMinutes(Integer slotMinutes)
    {
        this.slotMinutes = slotMinutes;
    }

    public Integer getStatus()
    {
        return status;
    }

    public void setStatus(Integer status)
    {
        this.status = status;
    }
}
