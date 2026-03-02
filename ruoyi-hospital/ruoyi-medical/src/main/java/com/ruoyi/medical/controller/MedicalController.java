package com.ruoyi.medical.controller;

import org.springframework.beans.factory.annotation.Autowired;
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

@RestController
@RequestMapping("/medical")
public class MedicalController extends BaseController
{
    @Autowired
    private MedicalDepartmentService medicalDepartmentService;

    @Autowired
    private MedicalDoctorService medicalDoctorService;

    @Autowired
    private MedicalScheduleService medicalScheduleService;

    @Autowired
    private MedicalPatientVisitorService medicalPatientVisitorService;

    @Autowired
    private MedicalAppointmentService medicalAppointmentService;

    @GetMapping("/departments")
    public TableDataInfo listDepartments(MedicalDepartment query)
    {
        startPage();
        return getDataTable(medicalDepartmentService.selectMedicalDepartmentList(query));
    }

    @GetMapping("/departments/{deptId}")
    public AjaxResult getDepartment(@PathVariable Long deptId)
    {
        return success(medicalDepartmentService.selectMedicalDepartmentById(deptId));
    }

    @PostMapping("/departments")
    public AjaxResult createDepartment(@RequestBody MedicalDepartment department)
    {
        return toAjax(medicalDepartmentService.insertMedicalDepartment(department));
    }

    @PatchMapping("/departments/{deptId}")
    public AjaxResult updateDepartment(@PathVariable Long deptId, @RequestBody MedicalDepartment department)
    {
        department.setDeptId(deptId);
        return toAjax(medicalDepartmentService.updateMedicalDepartment(department));
    }

    @DeleteMapping("/departments/{deptId}")
    public AjaxResult deleteDepartment(@PathVariable Long deptId)
    {
        return toAjax(medicalDepartmentService.deleteMedicalDepartmentById(deptId));
    }

    @GetMapping("/doctors")
    public TableDataInfo listDoctors(MedicalDoctor query)
    {
        startPage();
        return getDataTable(medicalDoctorService.selectMedicalDoctorList(query));
    }

    @GetMapping("/doctors/{doctorId}")
    public AjaxResult getDoctor(@PathVariable Long doctorId)
    {
        return success(medicalDoctorService.selectMedicalDoctorById(doctorId));
    }

    @PostMapping("/doctors")
    public AjaxResult createDoctor(@RequestBody MedicalDoctor doctor)
    {
        return toAjax(medicalDoctorService.insertMedicalDoctor(doctor));
    }

    @PatchMapping("/doctors/{doctorId}")
    public AjaxResult updateDoctor(@PathVariable Long doctorId, @RequestBody MedicalDoctor doctor)
    {
        doctor.setDoctorId(doctorId);
        return toAjax(medicalDoctorService.updateMedicalDoctor(doctor));
    }

    @DeleteMapping("/doctors/{doctorId}")
    public AjaxResult deleteDoctor(@PathVariable Long doctorId)
    {
        return toAjax(medicalDoctorService.deleteMedicalDoctorById(doctorId));
    }

    @GetMapping("/schedules")
    public TableDataInfo listSchedules(MedicalSchedule query)
    {
        startPage();
        return getDataTable(medicalScheduleService.selectMedicalScheduleList(query));
    }

    @GetMapping("/schedules/{scheduleId}")
    public AjaxResult getSchedule(@PathVariable Long scheduleId)
    {
        return success(medicalScheduleService.selectMedicalScheduleById(scheduleId));
    }

    @PostMapping("/schedules")
    public AjaxResult createSchedule(@RequestBody MedicalSchedule schedule)
    {
        return toAjax(medicalScheduleService.insertMedicalSchedule(schedule));
    }

    @PatchMapping("/schedules/{scheduleId}")
    public AjaxResult updateSchedule(@PathVariable Long scheduleId, @RequestBody MedicalSchedule schedule)
    {
        schedule.setScheduleId(scheduleId);
        return toAjax(medicalScheduleService.updateMedicalSchedule(schedule));
    }

    @DeleteMapping("/schedules/{scheduleId}")
    public AjaxResult deleteSchedule(@PathVariable Long scheduleId)
    {
        return toAjax(medicalScheduleService.deleteMedicalScheduleById(scheduleId));
    }

    @GetMapping("/patient-visitors")
    public TableDataInfo listPatientVisitors(MedicalPatientVisitor query)
    {
        startPage();
        return getDataTable(medicalPatientVisitorService.selectMedicalPatientVisitorList(query));
    }

    @GetMapping("/patient-visitors/{visitorId}")
    public AjaxResult getPatientVisitor(@PathVariable Long visitorId)
    {
        return success(medicalPatientVisitorService.selectMedicalPatientVisitorById(visitorId));
    }

    @PostMapping("/patient-visitors")
    public AjaxResult createPatientVisitor(@RequestBody MedicalPatientVisitor visitor)
    {
        return toAjax(medicalPatientVisitorService.insertMedicalPatientVisitor(visitor));
    }

    @PatchMapping("/patient-visitors/{visitorId}")
    public AjaxResult updatePatientVisitor(@PathVariable Long visitorId, @RequestBody MedicalPatientVisitor visitor)
    {
        visitor.setVisitorId(visitorId);
        return toAjax(medicalPatientVisitorService.updateMedicalPatientVisitor(visitor));
    }

    @DeleteMapping("/patient-visitors/{visitorId}")
    public AjaxResult deletePatientVisitor(@PathVariable Long visitorId)
    {
        return toAjax(medicalPatientVisitorService.softDeleteMedicalPatientVisitorById(visitorId));
    }

    @GetMapping("/appointments")
    public TableDataInfo listAppointments(MedicalAppointment query)
    {
        startPage();
        return getDataTable(medicalAppointmentService.selectMedicalAppointmentList(query));
    }

    @GetMapping("/appointments/{appointmentId}")
    public AjaxResult getAppointment(@PathVariable Long appointmentId)
    {
        return success(medicalAppointmentService.selectMedicalAppointmentById(appointmentId));
    }

    @PostMapping("/appointments")
    public AjaxResult createAppointment(@RequestBody MedicalAppointment appointment)
    {
        return toAjax(medicalAppointmentService.insertMedicalAppointment(appointment));
    }

    @PatchMapping("/appointments/{appointmentId}")
    public AjaxResult updateAppointment(@PathVariable Long appointmentId, @RequestBody MedicalAppointment appointment)
    {
        appointment.setAppointmentId(appointmentId);
        return toAjax(medicalAppointmentService.updateMedicalAppointment(appointment));
    }

    @PatchMapping("/appointments/{appointmentId}/cancellation")
    public AjaxResult cancelAppointment(@PathVariable Long appointmentId, @RequestBody MedicalAppointment body)
    {
        return toAjax(medicalAppointmentService.cancelMedicalAppointment(appointmentId, body.getCancelReason()));
    }

    @PatchMapping("/appointments/{appointmentId}/payment")
    public AjaxResult payAppointment(@PathVariable Long appointmentId, @RequestBody MedicalAppointment body)
    {
        return toAjax(medicalAppointmentService.markMedicalAppointmentPaid(appointmentId, body.getPayWay()));
    }

    @PatchMapping("/appointments/{appointmentId}/check-in")
    public AjaxResult checkinAppointment(@PathVariable Long appointmentId)
    {
        return toAjax(medicalAppointmentService.checkinMedicalAppointment(appointmentId));
    }

    @PatchMapping("/appointments/{appointmentId}/completion")
    public AjaxResult finishAppointment(@PathVariable Long appointmentId)
    {
        return toAjax(medicalAppointmentService.finishMedicalAppointment(appointmentId));
    }
}
