package com.ruoyi.medical.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.ruoyi.common.core.domain.BaseEntity;

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

    public Long getVisitorId()
    {
        return visitorId;
    }

    public void setVisitorId(Long visitorId)
    {
        this.visitorId = visitorId;
    }

    public Long getPatientId()
    {
        return patientId;
    }

    public void setPatientId(Long patientId)
    {
        this.patientId = patientId;
    }

    public String getName()
    {
        return name;
    }

    public void setName(String name)
    {
        this.name = name;
    }

    public String getIdCard()
    {
        return idCard;
    }

    public void setIdCard(String idCard)
    {
        this.idCard = idCard;
    }

    public String getPhone()
    {
        return phone;
    }

    public void setPhone(String phone)
    {
        this.phone = phone;
    }

    public String getRelation()
    {
        return relation;
    }

    public void setRelation(String relation)
    {
        this.relation = relation;
    }

    public Integer getGender()
    {
        return gender;
    }

    public void setGender(Integer gender)
    {
        this.gender = gender;
    }

    public Date getBirthDate()
    {
        return birthDate;
    }

    public void setBirthDate(Date birthDate)
    {
        this.birthDate = birthDate;
    }

    public String getMedicalCardNo()
    {
        return medicalCardNo;
    }

    public void setMedicalCardNo(String medicalCardNo)
    {
        this.medicalCardNo = medicalCardNo;
    }

    public String getAllergyHistory()
    {
        return allergyHistory;
    }

    public void setAllergyHistory(String allergyHistory)
    {
        this.allergyHistory = allergyHistory;
    }

    public String getPastHistory()
    {
        return pastHistory;
    }

    public void setPastHistory(String pastHistory)
    {
        this.pastHistory = pastHistory;
    }

    public Integer getIsDefault()
    {
        return isDefault;
    }

    public void setIsDefault(Integer isDefault)
    {
        this.isDefault = isDefault;
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
