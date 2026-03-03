package com.ruoyi.medical.service;

import java.util.List;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.medical.domain.MedicalDoctor;
import com.ruoyi.medical.mapper.MedicalDoctorMapper;

@Service
@RequiredArgsConstructor
public class MedicalDoctorService
{
    private final MedicalDoctorMapper medicalDoctorMapper;

    public List<MedicalDoctor> selectMedicalDoctorList(MedicalDoctor query)
    {
        return medicalDoctorMapper.selectMedicalDoctorList(query);
    }

    public MedicalDoctor selectMedicalDoctorById(Long doctorId)
    {
        return medicalDoctorMapper.selectMedicalDoctorById(doctorId);
    }

    public int insertMedicalDoctor(MedicalDoctor doctor)
    {
        if (doctor.getStatus() == null)
        {
            doctor.setStatus(0);
        }
        if (doctor.getWorkStatus() == null)
        {
            doctor.setWorkStatus(0);
        }
        doctor.setCreateBy(SecurityUtils.getUsername());
        return medicalDoctorMapper.insertMedicalDoctor(doctor);
    }

    public int updateMedicalDoctor(MedicalDoctor doctor)
    {
        doctor.setUpdateBy(SecurityUtils.getUsername());
        return medicalDoctorMapper.updateMedicalDoctor(doctor);
    }

    public int deleteMedicalDoctorById(Long doctorId)
    {
        return medicalDoctorMapper.deleteMedicalDoctorById(doctorId);
    }
}
