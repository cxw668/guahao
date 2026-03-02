package com.ruoyi.medical.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Options;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;
import com.ruoyi.medical.domain.MedicalSchedule;

public interface MedicalScheduleMapper
{
    @Select({
            "<script>",
            "select",
            "schedule_id as scheduleId,",
            "doctor_id as doctorId,",
            "work_date as workDate,",
            "period as period,",
            "start_time as startTime,",
            "end_time as endTime,",
            "total_slots as totalSlots,",
            "booked_slots as bookedSlots,",
            "slot_minutes as slotMinutes,",
            "status as status,",
            "create_by as createBy,",
            "create_time as createTime,",
            "update_by as updateBy,",
            "update_time as updateTime,",
            "remark as remark",
            "from medical_schedule",
            "<where>",
            "  <if test='scheduleId != null'>and schedule_id = #{scheduleId}</if>",
            "  <if test='doctorId != null'>and doctor_id = #{doctorId}</if>",
            "  <if test='workDate != null'>and work_date = #{workDate}</if>",
            "  <if test='period != null'>and period = #{period}</if>",
            "  <if test='status != null'>and status = #{status}</if>",
            "</where>",
            "order by work_date asc, period asc, schedule_id asc",
            "</script>"
    })
    List<MedicalSchedule> selectMedicalScheduleList(MedicalSchedule query);

    @Select({
            "select",
            "schedule_id as scheduleId,",
            "doctor_id as doctorId,",
            "work_date as workDate,",
            "period as period,",
            "start_time as startTime,",
            "end_time as endTime,",
            "total_slots as totalSlots,",
            "booked_slots as bookedSlots,",
            "slot_minutes as slotMinutes,",
            "status as status,",
            "create_by as createBy,",
            "create_time as createTime,",
            "update_by as updateBy,",
            "update_time as updateTime,",
            "remark as remark",
            "from medical_schedule",
            "where schedule_id = #{scheduleId}"
    })
    MedicalSchedule selectMedicalScheduleById(Long scheduleId);

    @Insert({
            "insert into medical_schedule(",
            "doctor_id, work_date, period, start_time, end_time, total_slots, booked_slots, slot_minutes, status, create_by, create_time, remark",
            ") values (",
            "#{doctorId}, #{workDate}, #{period}, #{startTime}, #{endTime}, #{totalSlots}, #{bookedSlots}, #{slotMinutes}, #{status}, #{createBy}, sysdate(), #{remark}",
            ")"
    })
    @Options(useGeneratedKeys = true, keyProperty = "scheduleId")
    int insertMedicalSchedule(MedicalSchedule schedule);

    @Update({
            "update medical_schedule set",
            "doctor_id = #{doctorId},",
            "work_date = #{workDate},",
            "period = #{period},",
            "start_time = #{startTime},",
            "end_time = #{endTime},",
            "total_slots = #{totalSlots},",
            "booked_slots = #{bookedSlots},",
            "slot_minutes = #{slotMinutes},",
            "status = #{status},",
            "update_by = #{updateBy},",
            "update_time = sysdate(),",
            "remark = #{remark}",
            "where schedule_id = #{scheduleId}"
    })
    int updateMedicalSchedule(MedicalSchedule schedule);

    @Delete("delete from medical_schedule where schedule_id = #{scheduleId}")
    int deleteMedicalScheduleById(Long scheduleId);
}
