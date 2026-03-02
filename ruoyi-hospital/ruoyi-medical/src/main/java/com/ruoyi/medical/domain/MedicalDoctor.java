package com.ruoyi.medical.domain;

import java.math.BigDecimal;
import com.ruoyi.common.core.domain.BaseEntity;

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

    public Long getDoctorId()
    {
        return doctorId;
    }

    public void setDoctorId(Long doctorId)
    {
        this.doctorId = doctorId;
    }

    public Long getUserId()
    {
        return userId;
    }

    public void setUserId(Long userId)
    {
        this.userId = userId;
    }

    public String getDoctorName()
    {
        return doctorName;
    }

    public void setDoctorName(String doctorName)
    {
        this.doctorName = doctorName;
    }

    public String getDoctorCode()
    {
        return doctorCode;
    }

    public void setDoctorCode(String doctorCode)
    {
        this.doctorCode = doctorCode;
    }

    public Long getDeptId()
    {
        return deptId;
    }

    public void setDeptId(Long deptId)
    {
        this.deptId = deptId;
    }

    public String getTitle()
    {
        return title;
    }

    public void setTitle(String title)
    {
        this.title = title;
    }

    public String getSpecialty()
    {
        return specialty;
    }

    public void setSpecialty(String specialty)
    {
        this.specialty = specialty;
    }

    public String getIntro()
    {
        return intro;
    }

    public void setIntro(String intro)
    {
        this.intro = intro;
    }

    public String getAvatar()
    {
        return avatar;
    }

    public void setAvatar(String avatar)
    {
        this.avatar = avatar;
    }

    public BigDecimal getFee()
    {
        return fee;
    }

    public void setFee(BigDecimal fee)
    {
        this.fee = fee;
    }

    public Integer getMaxPatients()
    {
        return maxPatients;
    }

    public void setMaxPatients(Integer maxPatients)
    {
        this.maxPatients = maxPatients;
    }

    public Integer getWorkStatus()
    {
        return workStatus;
    }

    public void setWorkStatus(Integer workStatus)
    {
        this.workStatus = workStatus;
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
