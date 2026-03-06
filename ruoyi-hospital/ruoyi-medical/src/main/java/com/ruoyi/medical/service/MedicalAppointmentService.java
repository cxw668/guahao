package com.ruoyi.medical.service;

import java.util.List;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.common.constant.HttpStatus;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.uuid.Seq;
import com.ruoyi.medical.domain.MedicalAppointment;
import com.ruoyi.medical.mapper.MedicalAppointmentMapper;

@Service
@RequiredArgsConstructor
public class MedicalAppointmentService
{
    private final MedicalAppointmentMapper medicalAppointmentMapper;

    /**
     * 预约取消次数限制常量
     */
    private static final int MAX_CANCEL_TIMES_PER_DAY = 3;

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
        // 检查患者当天取消预约次数是否超过限制
        Long patientId = appointment.getPatientId();
        if (patientId != null)
        {
            int cancelledCount = medicalAppointmentMapper.countTodayCancelledAppointments(patientId);
            if (cancelledCount >= MAX_CANCEL_TIMES_PER_DAY)
            {
                throw new ServiceException("您今天取消预约次数已达 3 次，无法继续预约", HttpStatus.WARN);
            }
        }
        
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

    /**
     * 检查并更新过期预约
     * 将 appointmentDate 早于当前日期的未完结预约状态更新为 5（已过期）
     * @return 更新的记录数
     */
    public int checkAndUpdateExpiredAppointments()
    {
        return medicalAppointmentMapper.checkAndUpdateExpiredAppointments("system_job");
    }

    /**
     * 查询所有未完结的预约列表
     * @param query 查询条件
     * @return 预约列表
     */
    public List<MedicalAppointment> selectActiveMedicalAppointmentList(MedicalAppointment query)
    {
        return medicalAppointmentMapper.selectActiveMedicalAppointmentList(query);
    }

    /**
     * 查询患者当天取消的预约次数
     * @param patientId 患者 ID
     * @return 取消次数
     */
    public int getTodayCancelledCount(Long patientId)
    {
        return medicalAppointmentMapper.countTodayCancelledAppointments(patientId);
    }
}
