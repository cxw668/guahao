package com.ruoyi.medical.service;

import java.util.List;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.medical.domain.MedicalPatientVisitor;
import com.ruoyi.medical.mapper.MedicalPatientVisitorMapper;

@Service
@RequiredArgsConstructor
public class MedicalPatientVisitorService
{
    private final MedicalPatientVisitorMapper medicalPatientVisitorMapper;

    public List<MedicalPatientVisitor> selectMedicalPatientVisitorList(MedicalPatientVisitor query)
    {
        return medicalPatientVisitorMapper.selectMedicalPatientVisitorList(query);
    }

    public MedicalPatientVisitor selectMedicalPatientVisitorById(Long visitorId)
    {
        return medicalPatientVisitorMapper.selectMedicalPatientVisitorById(visitorId);
    }

    public int insertMedicalPatientVisitor(MedicalPatientVisitor visitor)
    {
        if (visitor.getIsDefault() == null)
        {
            visitor.setIsDefault(0);
        }
        if (visitor.getStatus() == null)
        {
            visitor.setStatus(0);
        }
        return medicalPatientVisitorMapper.insertMedicalPatientVisitor(visitor);
    }

    public int updateMedicalPatientVisitor(MedicalPatientVisitor visitor)
    {
        return medicalPatientVisitorMapper.updateMedicalPatientVisitor(visitor);
    }

    public int softDeleteMedicalPatientVisitorById(Long visitorId)
    {
        return medicalPatientVisitorMapper.softDeleteMedicalPatientVisitorById(visitorId);
    }
}
