package com.ruoyi.medical.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.medical.domain.MedicalAppointment;
import com.ruoyi.medical.domain.MedicalDepartment;
import com.ruoyi.medical.domain.MedicalDoctor;
import com.ruoyi.medical.domain.MedicalPatientVisitor;
import com.ruoyi.medical.domain.MedicalSchedule;
import com.ruoyi.medical.service.MedicalAppointmentService;
import com.ruoyi.medical.service.MedicalDepartmentService;
import com.ruoyi.medical.service.MedicalDoctorService;
import com.ruoyi.medical.service.MedicalPatientVisitorService;
import com.ruoyi.medical.service.MedicalScheduleService;

/**
 * 医疗模块控制器
 * 提供科室、医生、排班、患者访客、预约等核心医疗业务管理接口
 */
@RestController
@RequestMapping("/medical")
@RequiredArgsConstructor
public class MedicalController extends BaseController
{
    /**
     * 科室管理服务
     */
    private final MedicalDepartmentService medicalDepartmentService;

    /**
     * 医生管理服务
     */
    private final MedicalDoctorService medicalDoctorService;

    /**
     * 排班管理服务
     */
    private final MedicalScheduleService medicalScheduleService;

    /**
     * 患者访客管理服务
     */
    private final MedicalPatientVisitorService medicalPatientVisitorService;

    /**
     * 预约管理服务
     */
    private final MedicalAppointmentService medicalAppointmentService;

    /**
     * 查询科室列表
     * @param query 科室查询条件
     * @return 科室分页数据
     */
    @GetMapping("/departments")
    public TableDataInfo listDepartments(MedicalDepartment query)
    {
        startPage();
        return getDataTable(medicalDepartmentService.selectMedicalDepartmentList(query));
    }

    /**
     * 根据 ID 查询科室详情
     * @param deptId 科室 ID
     * @return 科室信息
     */
    @GetMapping("/departments/{deptId}")
    public AjaxResult getDepartment(@PathVariable Long deptId)
    {
        return success(medicalDepartmentService.selectMedicalDepartmentById(deptId));
    }

    /**
     * 新增科室
     * @param department 科室信息
     * @return 操作结果
     */
    @PostMapping("/departments")
    public AjaxResult createDepartment(@RequestBody MedicalDepartment department)
    {
        return toAjax(medicalDepartmentService.insertMedicalDepartment(department));
    }

    /**
     * 修改科室信息
     * @param deptId 科室 ID
     * @param department 更新后的科室信息
     * @return 操作结果
     */
    @PatchMapping("/departments/{deptId}")
    public AjaxResult updateDepartment(@PathVariable Long deptId, @RequestBody MedicalDepartment department)
    {
        department.setDeptId(deptId);
        return toAjax(medicalDepartmentService.updateMedicalDepartment(department));
    }

    /**
     * 删除科室
     * @param deptId 科室 ID
     * @return 操作结果
     */
    @DeleteMapping("/departments/{deptId}")
    public AjaxResult deleteDepartment(@PathVariable Long deptId)
    {
        return toAjax(medicalDepartmentService.deleteMedicalDepartmentById(deptId));
    }

    /**
     * 查询医生列表
     * @param query 医生查询条件
     * @return 医生分页数据
     */
    @GetMapping("/doctors")
    public TableDataInfo listDoctors(MedicalDoctor query)
    {
        startPage();
        return getDataTable(medicalDoctorService.selectMedicalDoctorList(query));
    }

    /**
     * 根据 ID 查询医生详情
     * @param doctorId 医生 ID
     * @return 医生信息
     */
    @GetMapping("/doctors/{doctorId}")
    public AjaxResult getDoctor(@PathVariable Long doctorId)
    {
        return success(medicalDoctorService.selectMedicalDoctorById(doctorId));
    }

    /**
     * 新增医生
     * @param doctor 医生信息
     * @return 操作结果
     */
    @PostMapping("/doctors")
    public AjaxResult createDoctor(@RequestBody MedicalDoctor doctor)
    {
        return toAjax(medicalDoctorService.insertMedicalDoctor(doctor));
    }

    /**
     * 修改医生信息
     * @param doctorId 医生 ID
     * @param doctor 更新后的医生信息
     * @return 操作结果
     */
    @PatchMapping("/doctors/{doctorId}")
    public AjaxResult updateDoctor(@PathVariable Long doctorId, @RequestBody MedicalDoctor doctor)
    {
        doctor.setDoctorId(doctorId);
        return toAjax(medicalDoctorService.updateMedicalDoctor(doctor));
    }

    /**
     * 删除医生
     * @param doctorId 医生 ID
     * @return 操作结果
     */
    @DeleteMapping("/doctors/{doctorId}")
    public AjaxResult deleteDoctor(@PathVariable Long doctorId)
    {
        return toAjax(medicalDoctorService.deleteMedicalDoctorById(doctorId));
    }

    /**
     * 查询排班列表
     * @param query 排班查询条件
     * @return 排班分页数据
     */
    @GetMapping("/schedules")
    public TableDataInfo listSchedules(MedicalSchedule query)
    {
        startPage();
        return getDataTable(medicalScheduleService.selectMedicalScheduleList(query));
    }

    /**
     * 根据 ID 查询排班详情
     * @param scheduleId 排班 ID
     * @return 排班信息
     */
    @GetMapping("/schedules/{scheduleId}")
    public AjaxResult getSchedule(@PathVariable Long scheduleId)
    {
        return success(medicalScheduleService.selectMedicalScheduleById(scheduleId));
    }

    /**
     * 新增排班
     * @param schedule 排班信息
     * @return 操作结果
     */
    @PostMapping("/schedules")
    public AjaxResult createSchedule(@RequestBody MedicalSchedule schedule)
    {
        return toAjax(medicalScheduleService.insertMedicalSchedule(schedule));
    }

    /**
     * 修改排班信息
     * @param scheduleId 排班 ID
     * @param schedule 更新后的排班信息
     * @return 操作结果
     */
    @PatchMapping("/schedules/{scheduleId}")
    public AjaxResult updateSchedule(@PathVariable Long scheduleId, @RequestBody MedicalSchedule schedule)
    {
        schedule.setScheduleId(scheduleId);
        return toAjax(medicalScheduleService.updateMedicalSchedule(schedule));
    }

    /**
     * 删除排班
     * @param scheduleId 排班 ID
     * @return 操作结果
     */
    @DeleteMapping("/schedules/{scheduleId}")
    public AjaxResult deleteSchedule(@PathVariable Long scheduleId)
    {
        return toAjax(medicalScheduleService.deleteMedicalScheduleById(scheduleId));
    }

    /**
     * 查询患者访客列表
     * @param query 患者访客查询条件
     * @return 患者访客分页数据
     */
    @GetMapping("/patient-visitors")
    public TableDataInfo listPatientVisitors(MedicalPatientVisitor query)
    {
        startPage();
        return getDataTable(medicalPatientVisitorService.selectMedicalPatientVisitorList(query));
    }

    /**
     * 根据 ID 查询患者访客详情
     * @param visitorId 访客 ID
     * @return 患者访客信息
     */
    @GetMapping("/patient-visitors/{visitorId}")
    public AjaxResult getPatientVisitor(@PathVariable Long visitorId)
    {
        return success(medicalPatientVisitorService.selectMedicalPatientVisitorById(visitorId));
    }

    /**
     * 新增患者访客
     * @param visitor 患者访客信息
     * @return 操作结果
     */
    @PostMapping("/patient-visitors")
    public AjaxResult createPatientVisitor(@RequestBody MedicalPatientVisitor visitor)
    {
        return toAjax(medicalPatientVisitorService.insertMedicalPatientVisitor(visitor));
    }

    /**
     * 修改患者访客信息
     * @param visitorId 访客 ID
     * @param visitor 更新后的患者访客信息
     * @return 操作结果
     */
    @PatchMapping("/patient-visitors/{visitorId}")
    public AjaxResult updatePatientVisitor(@PathVariable Long visitorId, @RequestBody MedicalPatientVisitor visitor)
    {
        visitor.setVisitorId(visitorId);
        return toAjax(medicalPatientVisitorService.updateMedicalPatientVisitor(visitor));
    }

    /**
     * 删除患者访客 (软删除)
     * @param visitorId 访客 ID
     * @return 操作结果
     */
    @DeleteMapping("/patient-visitors/{visitorId}")
    public AjaxResult deletePatientVisitor(@PathVariable Long visitorId)
    {
        return toAjax(medicalPatientVisitorService.softDeleteMedicalPatientVisitorById(visitorId));
    }

    /**
     * 查询预约列表
     * @param query 预约查询条件
     * @return 预约分页数据
     */
    @GetMapping("/appointments")
    public TableDataInfo listAppointments(MedicalAppointment query)
    {
        startPage();
        return getDataTable(medicalAppointmentService.selectMedicalAppointmentList(query));
    }

    /**
     * 根据 ID 查询预约详情
     * @param appointmentId 预约 ID
     * @return 预约信息
     */
    @GetMapping("/appointments/{appointmentId}")
    public AjaxResult getAppointment(@PathVariable Long appointmentId)
    {
        return success(medicalAppointmentService.selectMedicalAppointmentById(appointmentId));
    }

    /**
     * 新增预约
     * @param appointment 预约信息
     * @return 操作结果
     */
    @PostMapping("/appointments")
    public AjaxResult createAppointment(@RequestBody MedicalAppointment appointment)
    {
        return toAjax(medicalAppointmentService.insertMedicalAppointment(appointment));
    }

    /**
     * 修改预约信息
     * @param appointmentId 预约 ID
     * @param appointment 更新后的预约信息
     * @return 操作结果
     */
    @PatchMapping("/appointments/{appointmentId}")
    public AjaxResult updateAppointment(@PathVariable Long appointmentId, @RequestBody MedicalAppointment appointment)
    {
        appointment.setAppointmentId(appointmentId);
        return toAjax(medicalAppointmentService.updateMedicalAppointment(appointment));
    }

    /**
     * 取消预约
     * @param appointmentId 预约 ID
     * @param body 包含取消原因
     * @return 操作结果
     */
    @PatchMapping("/appointments/{appointmentId}/cancellation")
    public AjaxResult cancelAppointment(@PathVariable Long appointmentId, @RequestBody MedicalAppointment body)
    {
        return toAjax(medicalAppointmentService.cancelMedicalAppointment(appointmentId, body.getCancelReason()));
    }

    /**
     * 支付预约费用
     * @param appointmentId 预约 ID
     * @param body 包含支付方式
     * @return 操作结果
     */
    @PatchMapping("/appointments/{appointmentId}/payment")
    public AjaxResult payAppointment(@PathVariable Long appointmentId, @RequestBody MedicalAppointment body)
    {
        return toAjax(medicalAppointmentService.markMedicalAppointmentPaid(appointmentId, body.getPayWay()));
    }

    /**
     * 患者就诊报到
     * @param appointmentId 预约 ID
     * @return 操作结果
     */
    @PatchMapping("/appointments/{appointmentId}/check-in")
    public AjaxResult checkinAppointment(@PathVariable Long appointmentId)
    {
        return toAjax(medicalAppointmentService.checkinMedicalAppointment(appointmentId));
    }

    /**
     * 完成就诊
     * @param appointmentId 预约 ID
     * @return 操作结果
     */
    @PatchMapping("/appointments/{appointmentId}/completion")
    public AjaxResult finishAppointment(@PathVariable Long appointmentId)
    {
        return toAjax(medicalAppointmentService.finishMedicalAppointment(appointmentId));
    }
}
