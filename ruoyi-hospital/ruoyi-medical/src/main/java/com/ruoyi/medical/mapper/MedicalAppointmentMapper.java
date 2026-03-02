package com.ruoyi.medical.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Options;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;
import com.ruoyi.medical.domain.MedicalAppointment;

public interface MedicalAppointmentMapper
{
    @Select({
            "<script>",
            "select",
            "appointment_id as appointmentId,",
            "appointment_no as appointmentNo,",
            "patient_id as patientId,",
            "visitor_id as visitorId,",
            "doctor_id as doctorId,",
            "schedule_id as scheduleId,",
            "appointment_date as appointmentDate,",
            "period as period,",
            "time_slot as timeSlot,",
            "status as status,",
            "fee as fee,",
            "pay_status as payStatus,",
            "pay_time as payTime,",
            "pay_way as payWay,",
            "checkin_time as checkinTime,",
            "finish_time as finishTime,",
            "cancel_time as cancelTime,",
            "cancel_reason as cancelReason,",
            "medical_record_id as medicalRecordId,",
            "create_by as createBy,",
            "create_time as createTime,",
            "update_by as updateBy,",
            "update_time as updateTime,",
            "remark as remark",
            "from medical_appointment",
            "<where>",
            "  <if test='appointmentId != null'>and appointment_id = #{appointmentId}</if>",
            "  <if test='appointmentNo != null and appointmentNo != \"\"'>and appointment_no = #{appointmentNo}</if>",
            "  <if test='patientId != null'>and patient_id = #{patientId}</if>",
            "  <if test='visitorId != null'>and visitor_id = #{visitorId}</if>",
            "  <if test='doctorId != null'>and doctor_id = #{doctorId}</if>",
            "  <if test='scheduleId != null'>and schedule_id = #{scheduleId}</if>",
            "  <if test='appointmentDate != null'>and appointment_date = #{appointmentDate}</if>",
            "  <if test='period != null'>and period = #{period}</if>",
            "  <if test='status != null'>and status = #{status}</if>",
            "  <if test='payStatus != null'>and pay_status = #{payStatus}</if>",
            "</where>",
            "order by appointment_id desc",
            "</script>"
    })
    List<MedicalAppointment> selectMedicalAppointmentList(MedicalAppointment query);

    @Select({
            "select",
            "appointment_id as appointmentId,",
            "appointment_no as appointmentNo,",
            "patient_id as patientId,",
            "visitor_id as visitorId,",
            "doctor_id as doctorId,",
            "schedule_id as scheduleId,",
            "appointment_date as appointmentDate,",
            "period as period,",
            "time_slot as timeSlot,",
            "status as status,",
            "fee as fee,",
            "pay_status as payStatus,",
            "pay_time as payTime,",
            "pay_way as payWay,",
            "checkin_time as checkinTime,",
            "finish_time as finishTime,",
            "cancel_time as cancelTime,",
            "cancel_reason as cancelReason,",
            "medical_record_id as medicalRecordId,",
            "create_by as createBy,",
            "create_time as createTime,",
            "update_by as updateBy,",
            "update_time as updateTime,",
            "remark as remark",
            "from medical_appointment",
            "where appointment_id = #{appointmentId}"
    })
    MedicalAppointment selectMedicalAppointmentById(Long appointmentId);

    @Insert({
            "insert into medical_appointment(",
            "appointment_no, patient_id, visitor_id, doctor_id, schedule_id, appointment_date, period, time_slot, status, fee, pay_status, create_by, create_time, remark",
            ") values (",
            "#{appointmentNo}, #{patientId}, #{visitorId}, #{doctorId}, #{scheduleId}, #{appointmentDate}, #{period}, #{timeSlot}, #{status}, #{fee}, #{payStatus}, #{createBy}, sysdate(), #{remark}",
            ")"
    })
    @Options(useGeneratedKeys = true, keyProperty = "appointmentId")
    int insertMedicalAppointment(MedicalAppointment appointment);

    @Update({
            "update medical_appointment set",
            "status = #{status},",
            "pay_status = #{payStatus},",
            "pay_time = #{payTime},",
            "pay_way = #{payWay},",
            "checkin_time = #{checkinTime},",
            "finish_time = #{finishTime},",
            "cancel_time = #{cancelTime},",
            "cancel_reason = #{cancelReason},",
            "medical_record_id = #{medicalRecordId},",
            "update_by = #{updateBy},",
            "update_time = sysdate(),",
            "remark = #{remark}",
            "where appointment_id = #{appointmentId}"
    })
    int updateMedicalAppointment(MedicalAppointment appointment);

    @Update({
            "update medical_appointment set",
            "status = 4,",
            "cancel_time = sysdate(),",
            "cancel_reason = #{cancelReason},",
            "update_by = #{updateBy},",
            "update_time = sysdate()",
            "where appointment_id = #{appointmentId}"
    })
    int cancelMedicalAppointment(@Param("appointmentId") Long appointmentId, @Param("cancelReason") String cancelReason,
            @Param("updateBy") String updateBy);

    @Update({
            "update medical_appointment set",
            "pay_status = 1,",
            "pay_time = sysdate(),",
            "pay_way = #{payWay},",
            "status = 1,",
            "update_by = #{updateBy},",
            "update_time = sysdate()",
            "where appointment_id = #{appointmentId}"
    })
    int markMedicalAppointmentPaid(@Param("appointmentId") Long appointmentId, @Param("payWay") String payWay,
            @Param("updateBy") String updateBy);

    @Update({
            "update medical_appointment set",
            "status = 2,",
            "checkin_time = sysdate(),",
            "update_by = #{updateBy},",
            "update_time = sysdate()",
            "where appointment_id = #{appointmentId}"
    })
    int checkinMedicalAppointment(@Param("appointmentId") Long appointmentId, @Param("updateBy") String updateBy);

    @Update({
            "update medical_appointment set",
            "status = 3,",
            "finish_time = sysdate(),",
            "update_by = #{updateBy},",
            "update_time = sysdate()",
            "where appointment_id = #{appointmentId}"
    })
    int finishMedicalAppointment(@Param("appointmentId") Long appointmentId, @Param("updateBy") String updateBy);
}
