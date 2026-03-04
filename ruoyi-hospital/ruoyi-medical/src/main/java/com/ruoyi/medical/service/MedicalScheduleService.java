package com.ruoyi.medical.service;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.util.List;
import java.time.temporal.TemporalAdjusters;
import com.ruoyi.common.utils.spring.SpringUtils;
import com.ruoyi.medical.domain.MedicalDoctor;
import com.ruoyi.medical.mapper.MedicalDoctorMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.medical.domain.MedicalSchedule;
import com.ruoyi.medical.mapper.MedicalScheduleMapper;

@Service
@RequiredArgsConstructor
public class MedicalScheduleService
{
    private final MedicalScheduleMapper medicalScheduleMapper;

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

    /**
     * 生成下一周的排班数据
     * 规则：
     * 1. 遍历所有状态正常的医生
     * 2. 为每位医生生成下周一至周日的排班
     * 3. 默认生成上午(08:00-12:00)和下午(14:00-18:00)两个时段
     * 4. 如果排班已存在则跳过
     */
    public void generateNextWeekSchedule()
    {
        // 1. 获取所有状态正常且在职的医生
        MedicalDoctor queryDoctor = new MedicalDoctor();
        queryDoctor.setStatus(0); // 状态正常
        queryDoctor.setWorkStatus(0); // 在职
        List<MedicalDoctor> doctors = MedicalDoctorMapper.class.cast(SpringUtils.getBean(MedicalDoctorMapper.class)).selectMedicalDoctorList(queryDoctor);

        // 2. 计算下周一的日期
        LocalDate today = LocalDate.now();
    
        
        // 业务通常理解为：每周日凌晨生成"下周一至下周日"的排班
        // 假设定时任务每周日运行，生成的起始日期应为 today.plusDays(1)
        
        // 修正逻辑：无论哪天运行，都生成"下个自然周"（周一到周日）的排班
        // 找到当前日期之后的第一个周一
        LocalDate startDay = today.with(TemporalAdjusters.next(DayOfWeek.MONDAY));
        
        for (com.ruoyi.medical.domain.MedicalDoctor doctor : doctors)
        {
            // 生成周一到周日（7天）
            for (int i = 0; i < 7; i++)
            {
                LocalDate workDate = startDay.plusDays(i);
                
                // 生成上午排班 (Period=1)
                createScheduleIfAbsent(doctor, workDate, 1, "08:00:00", "12:00:00");
                
                // 生成下午排班 (Period=2)
                createScheduleIfAbsent(doctor, workDate, 2, "14:00:00", "18:00:00");
            }
        }
    }

    private void createScheduleIfAbsent(com.ruoyi.medical.domain.MedicalDoctor doctor, LocalDate workDate, Integer period, String startTime, String endTime)
    {
        // 检查是否已存在
        MedicalSchedule query = new MedicalSchedule();
        query.setDoctorId(doctor.getDoctorId());
        query.setWorkDate(java.sql.Date.valueOf(workDate));
        query.setPeriod(period);
        List<MedicalSchedule> existList = medicalScheduleMapper.selectMedicalScheduleList(query);
        
        if (existList.isEmpty())
        {
            MedicalSchedule schedule = new MedicalSchedule();
            schedule.setDoctorId(doctor.getDoctorId());
            schedule.setWorkDate(java.sql.Date.valueOf(workDate));
            schedule.setPeriod(period);
            schedule.setStartTime(startTime);
            schedule.setEndTime(endTime);
            // 默认号源数量，可根据医生级别配置，这里暂定统一值
            schedule.setTotalSlots(30); 
            schedule.setBookedSlots(0);
            schedule.setSlotMinutes(30);
            schedule.setStatus(0); // 正常
            schedule.setCreateBy("system_job");
            
            medicalScheduleMapper.insertMedicalSchedule(schedule);
        }
    }
}
