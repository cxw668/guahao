package com.ruoyi.medical.service;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.medical.domain.MedicalSchedule;
import com.ruoyi.medical.mapper.MedicalScheduleMapper;

@Service
public class MedicalScheduleService
{
    @Autowired
    private MedicalScheduleMapper medicalScheduleMapper;

    public List<MedicalSchedule> selectMedicalScheduleList(MedicalSchedule query)
    {
        return medicalScheduleMapper.selectMedicalScheduleList(query);
    }

    public MedicalSchedule selectMedicalScheduleById(Long scheduleId)
    {
        return medicalScheduleMapper.selectMedicalScheduleById(scheduleId);
    }

    public int insertMedicalSchedule(MedicalSchedule schedule)
    {
        if (schedule.getBookedSlots() == null)
        {
            schedule.setBookedSlots(0);
        }
        if (schedule.getSlotMinutes() == null)
        {
            schedule.setSlotMinutes(30);
        }
        if (schedule.getStatus() == null)
        {
            schedule.setStatus(0);
        }
        schedule.setCreateBy(SecurityUtils.getUsername());
        return medicalScheduleMapper.insertMedicalSchedule(schedule);
    }

    public int updateMedicalSchedule(MedicalSchedule schedule)
    {
        schedule.setUpdateBy(SecurityUtils.getUsername());
        return medicalScheduleMapper.updateMedicalSchedule(schedule);
    }

    public int deleteMedicalScheduleById(Long scheduleId)
    {
        return medicalScheduleMapper.deleteMedicalScheduleById(scheduleId);
    }
}
