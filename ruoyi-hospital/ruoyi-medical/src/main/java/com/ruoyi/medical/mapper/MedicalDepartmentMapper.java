package com.ruoyi.medical.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Options;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;
import com.ruoyi.medical.domain.MedicalDepartment;

public interface MedicalDepartmentMapper
{
    @Select({
            "<script>",
            "select",
            "dept_id as deptId,",
            "dept_name as deptName,",
            "dept_code as deptCode,",
            "parent_id as parentId,",
            "dept_type as deptType,",
            "location as location,",
            "phone as phone,",
            "intro as intro,",
            "sort_order as sortOrder,",
            "status as status,",
            "create_by as createBy,",
            "create_time as createTime,",
            "update_by as updateBy,",
            "update_time as updateTime,",
            "remark as remark",
            "from medical_department",
            "<where>",
            "  <if test='deptId != null'>and dept_id = #{deptId}</if>",
            "  <if test='deptName != null and deptName != \"\"'>and dept_name like concat('%', #{deptName}, '%')</if>",
            "  <if test='deptCode != null and deptCode != \"\"'>and dept_code = #{deptCode}</if>",
            "  <if test='parentId != null'>and parent_id = #{parentId}</if>",
            "  <if test='deptType != null'>and dept_type = #{deptType}</if>",
            "  <if test='status != null'>and status = #{status}</if>",
            "</where>",
            "order by sort_order asc, dept_id asc",
            "</script>"
    })
    List<MedicalDepartment> selectMedicalDepartmentList(MedicalDepartment query);

    @Select({
            "select",
            "dept_id as deptId,",
            "dept_name as deptName,",
            "dept_code as deptCode,",
            "parent_id as parentId,",
            "dept_type as deptType,",
            "location as location,",
            "phone as phone,",
            "intro as intro,",
            "sort_order as sortOrder,",
            "status as status,",
            "create_by as createBy,",
            "create_time as createTime,",
            "update_by as updateBy,",
            "update_time as updateTime,",
            "remark as remark",
            "from medical_department",
            "where dept_id = #{deptId}"
    })
    MedicalDepartment selectMedicalDepartmentById(Long deptId);

    @Insert({
            "insert into medical_department(",
            "dept_name, dept_code, parent_id, dept_type, location, phone, intro, sort_order, status, create_by, create_time, remark",
            ") values (",
            "#{deptName}, #{deptCode}, #{parentId}, #{deptType}, #{location}, #{phone}, #{intro}, #{sortOrder}, #{status}, #{createBy}, sysdate(), #{remark}",
            ")"
    })
    @Options(useGeneratedKeys = true, keyProperty = "deptId")
    int insertMedicalDepartment(MedicalDepartment department);

    @Update({
            "update medical_department set",
            "dept_name = #{deptName},",
            "dept_code = #{deptCode},",
            "parent_id = #{parentId},",
            "dept_type = #{deptType},",
            "location = #{location},",
            "phone = #{phone},",
            "intro = #{intro},",
            "sort_order = #{sortOrder},",
            "status = #{status},",
            "update_by = #{updateBy},",
            "update_time = sysdate(),",
            "remark = #{remark}",
            "where dept_id = #{deptId}"
    })
    int updateMedicalDepartment(MedicalDepartment department);

    @Delete("delete from medical_department where dept_id = #{deptId}")
    int deleteMedicalDepartmentById(Long deptId);
}
