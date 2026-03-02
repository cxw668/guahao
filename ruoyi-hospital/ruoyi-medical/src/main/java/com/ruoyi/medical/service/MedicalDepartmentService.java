package com.ruoyi.medical.service;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.medical.domain.MedicalDepartment;
import com.ruoyi.medical.mapper.MedicalDepartmentMapper;

@Service
public class MedicalDepartmentService
{
    @Autowired
    private MedicalDepartmentMapper medicalDepartmentMapper;

    public List<MedicalDepartment> selectMedicalDepartmentList(MedicalDepartment query)
    {
        return medicalDepartmentMapper.selectMedicalDepartmentList(query);
    }

    public MedicalDepartment selectMedicalDepartmentById(Long deptId)
    {
        return medicalDepartmentMapper.selectMedicalDepartmentById(deptId);
    }

    public int insertMedicalDepartment(MedicalDepartment department)
    {
        if (department.getStatus() == null)
        {
            department.setStatus(0);
        }
        department.setCreateBy(SecurityUtils.getUsername());
        return medicalDepartmentMapper.insertMedicalDepartment(department);
    }

    public int updateMedicalDepartment(MedicalDepartment department)
    {
        department.setUpdateBy(SecurityUtils.getUsername());
        return medicalDepartmentMapper.updateMedicalDepartment(department);
    }

    public int deleteMedicalDepartmentById(Long deptId)
    {
        return medicalDepartmentMapper.deleteMedicalDepartmentById(deptId);
    }
}
