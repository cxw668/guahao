package com.ruoyi.medical.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Options;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;
import com.ruoyi.medical.domain.MedicalPatientVisitor;

public interface MedicalPatientVisitorMapper
{
    @Select({
            "<script>",
            "select",
            "visitor_id as visitorId,",
            "patient_id as patientId,",
            "name as name,",
            "id_card as idCard,",
            "phone as phone,",
            "relation as relation,",
            "gender as gender,",
            "birth_date as birthDate,",
            "medical_card_no as medicalCardNo,",
            "allergy_history as allergyHistory,",
            "past_history as pastHistory,",
            "is_default as isDefault,",
            "status as status,",
            "create_time as createTime,",
            "update_time as updateTime",
            "from medical_patient_visitor",
            "<where>",
            "  <if test='visitorId != null'>and visitor_id = #{visitorId}</if>",
            "  <if test='patientId != null'>and patient_id = #{patientId}</if>",
            "  <if test='name != null and name != \"\"'>and name like concat('%', #{name}, '%')</if>",
            "  <if test='phone != null and phone != \"\"'>and phone = #{phone}</if>",
            "  <if test='isDefault != null'>and is_default = #{isDefault}</if>",
            "  <if test='status != null'>and status = #{status}</if>",
            "</where>",
            "order by is_default desc, visitor_id desc",
            "</script>"
    })
    List<MedicalPatientVisitor> selectMedicalPatientVisitorList(MedicalPatientVisitor query);

    @Select({
            "select",
            "visitor_id as visitorId,",
            "patient_id as patientId,",
            "name as name,",
            "id_card as idCard,",
            "phone as phone,",
            "relation as relation,",
            "gender as gender,",
            "birth_date as birthDate,",
            "medical_card_no as medicalCardNo,",
            "allergy_history as allergyHistory,",
            "past_history as pastHistory,",
            "is_default as isDefault,",
            "status as status,",
            "create_time as createTime,",
            "update_time as updateTime",
            "from medical_patient_visitor",
            "where visitor_id = #{visitorId}"
    })
    MedicalPatientVisitor selectMedicalPatientVisitorById(Long visitorId);

    @Insert({
            "insert into medical_patient_visitor(",
            "patient_id, name, id_card, phone, relation, gender, birth_date, medical_card_no, allergy_history, past_history, is_default, status, create_time",
            ") values (",
            "#{patientId}, #{name}, #{idCard}, #{phone}, #{relation}, #{gender}, #{birthDate}, #{medicalCardNo}, #{allergyHistory}, #{pastHistory}, #{isDefault}, #{status}, sysdate()",
            ")"
    })
    @Options(useGeneratedKeys = true, keyProperty = "visitorId")
    int insertMedicalPatientVisitor(MedicalPatientVisitor visitor);

    @Update({
            "update medical_patient_visitor set",
            "patient_id = #{patientId},",
            "name = #{name},",
            "id_card = #{idCard},",
            "phone = #{phone},",
            "relation = #{relation},",
            "gender = #{gender},",
            "birth_date = #{birthDate},",
            "medical_card_no = #{medicalCardNo},",
            "allergy_history = #{allergyHistory},",
            "past_history = #{pastHistory},",
            "is_default = #{isDefault},",
            "status = #{status},",
            "update_time = sysdate()",
            "where visitor_id = #{visitorId}"
    })
    int updateMedicalPatientVisitor(MedicalPatientVisitor visitor);

    @Update({
            "update medical_patient_visitor set",
            "status = 1,",
            "update_time = sysdate()",
            "where visitor_id = #{visitorId}"
    })
    int softDeleteMedicalPatientVisitorById(Long visitorId);
}
