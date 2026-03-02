package com.ruoyi.medical.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Options;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;
import com.ruoyi.medical.domain.MedicalDoctor;

public interface MedicalDoctorMapper
{
    @Select({
            "<script>",
            "select",
            "doctor_id as doctorId,",
            "user_id as userId,",
            "doctor_name as doctorName,",
            "doctor_code as doctorCode,",
            "dept_id as deptId,",
            "title as title,",
            "specialty as specialty,",
            "intro as intro,",
            "avatar as avatar,",
            "fee as fee,",
            "max_patients as maxPatients,",
            "work_status as workStatus,",
            "status as status,",
            "create_by as createBy,",
            "create_time as createTime,",
            "update_by as updateBy,",
            "update_time as updateTime,",
            "remark as remark",
            "from medical_doctor",
            "<where>",
            "  <if test='doctorId != null'>and doctor_id = #{doctorId}</if>",
            "  <if test='userId != null'>and user_id = #{userId}</if>",
            "  <if test='doctorName != null and doctorName != \"\"'>and doctor_name like concat('%', #{doctorName}, '%')</if>",
            "  <if test='doctorCode != null and doctorCode != \"\"'>and doctor_code = #{doctorCode}</if>",
            "  <if test='deptId != null'>and dept_id = #{deptId}</if>",
            "  <if test='workStatus != null'>and work_status = #{workStatus}</if>",
            "  <if test='status != null'>and status = #{status}</if>",
            "</where>",
            "order by doctor_id desc",
            "</script>"
    })
    List<MedicalDoctor> selectMedicalDoctorList(MedicalDoctor query);

    @Select({
            "select",
            "doctor_id as doctorId,",
            "user_id as userId,",
            "doctor_name as doctorName,",
            "doctor_code as doctorCode,",
            "dept_id as deptId,",
            "title as title,",
            "specialty as specialty,",
            "intro as intro,",
            "avatar as avatar,",
            "fee as fee,",
            "max_patients as maxPatients,",
            "work_status as workStatus,",
            "status as status,",
            "create_by as createBy,",
            "create_time as createTime,",
            "update_by as updateBy,",
            "update_time as updateTime,",
            "remark as remark",
            "from medical_doctor",
            "where doctor_id = #{doctorId}"
    })
    MedicalDoctor selectMedicalDoctorById(Long doctorId);

    @Insert({
            "insert into medical_doctor(",
            "user_id, doctor_name, doctor_code, dept_id, title, specialty, intro, avatar, fee, max_patients, work_status, status, create_by, create_time, remark",
            ") values (",
            "#{userId}, #{doctorName}, #{doctorCode}, #{deptId}, #{title}, #{specialty}, #{intro}, #{avatar}, #{fee}, #{maxPatients}, #{workStatus}, #{status}, #{createBy}, sysdate(), #{remark}",
            ")"
    })
    @Options(useGeneratedKeys = true, keyProperty = "doctorId")
    int insertMedicalDoctor(MedicalDoctor doctor);

    @Update({
            "update medical_doctor set",
            "user_id = #{userId},",
            "doctor_name = #{doctorName},",
            "doctor_code = #{doctorCode},",
            "dept_id = #{deptId},",
            "title = #{title},",
            "specialty = #{specialty},",
            "intro = #{intro},",
            "avatar = #{avatar},",
            "fee = #{fee},",
            "max_patients = #{maxPatients},",
            "work_status = #{workStatus},",
            "status = #{status},",
            "update_by = #{updateBy},",
            "update_time = sysdate(),",
            "remark = #{remark}",
            "where doctor_id = #{doctorId}"
    })
    int updateMedicalDoctor(MedicalDoctor doctor);

    @Delete("delete from medical_doctor where doctor_id = #{doctorId}")
    int deleteMedicalDoctorById(Long doctorId);
}
