package com.ruoyi.medical.service;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.uuid.Seq;
import com.ruoyi.medical.domain.MedicalAppointment;
import com.ruoyi.medical.mapper.MedicalAppointmentMapper;

@Service
public class MedicalAppointmentService
{
    @Autowired
    private MedicalAppointmentMapper medicalAppointmentMapper;

    public List<MedicalAppointment> selectMedicalAppointmentList(MedicalAppointment query)
    {
        return medicalAppointmentMapper.selectMedicalAppointmentList(query);
    }

    public MedicalAppointment selectMedicalAppointmentById(Long appointmentId)
    {
        return medicalAppointmentMapper.selectMedicalAppointmentById(appointmentId);
    }

    public int insertMedicalAppointment(MedicalAppointment appointment)
    {
        if (appointment.getAppointmentNo() == null || appointment.getAppointmentNo().isBlank())
        {
            appointment.setAppointmentNo("APT" + Seq.getId());
        }
        if (appointment.getStatus() == null)
        {
            appointment.setStatus(0);
        }
        if (appointment.getPayStatus() == null)
        {
            appointment.setPayStatus(0);
        }
        appointment.setCreateBy(SecurityUtils.getUsername());
        return medicalAppointmentMapper.insertMedicalAppointment(appointment);
    }

    public int updateMedicalAppointment(MedicalAppointment appointment)
    {
        appointment.setUpdateBy(SecurityUtils.getUsername());
        return medicalAppointmentMapper.updateMedicalAppointment(appointment);
    }

    public int cancelMedicalAppointment(Long appointmentId, String cancelReason)
    {
        return medicalAppointmentMapper.cancelMedicalAppointment(appointmentId, cancelReason, SecurityUtils.getUsername());
    }

    public int markMedicalAppointmentPaid(Long appointmentId, String payWay)
    {
        return medicalAppointmentMapper.markMedicalAppointmentPaid(appointmentId, payWay, SecurityUtils.getUsername());
    }

    public int checkinMedicalAppointment(Long appointmentId)
    {
        return medicalAppointmentMapper.checkinMedicalAppointment(appointmentId, SecurityUtils.getUsername());
    }

    public int finishMedicalAppointment(Long appointmentId)
    {
        return medicalAppointmentMapper.finishMedicalAppointment(appointmentId, SecurityUtils.getUsername());
    }
}
