create table sys_job_log
(
    job_log_id     bigint auto_increment comment '任务日志ID'
        primary key,
    job_name       varchar(64)               not null comment '任务名称',
    job_group      varchar(64)               not null comment '任务组名',
    invoke_target  varchar(500)              not null comment '调用目标字符串',
    job_message    varchar(500)              null comment '日志信息',
    status         char          default '0' null comment '执行状态（0正常 1失败）',
    exception_info varchar(2000) default ''  null comment '异常信息',
    create_time    datetime                  null comment '创建时间'
)
    comment '定时任务调度日志表';

INSERT INTO ruoyi_hospital.sys_job_log (job_log_id, job_name, job_group, invoke_target, job_message, status, exception_info, create_time) VALUES (1, '自动排班测试', 'SYSTEM', 'ryTask.generateNextWeekSchedule()', '自动排班测试 总共耗时：33毫秒', '1', 'java.lang.reflect.InvocationTargetException
	at java.base/jdk.internal.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
	at java.base/jdk.internal.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:77)
	at java.base/jdk.internal.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
	at java.base/java.lang.reflect.Method.invoke(Method.java:569)
	at com.ruoyi.quartz.util.JobInvokeUtil.invokeMethod(JobInvokeUtil.java:61)
	at com.ruoyi.quartz.util.JobInvokeUtil.invokeMethod(JobInvokeUtil.java:33)
	at com.ruoyi.quartz.util.QuartzDisallowConcurrentExecution.doExecute(QuartzDisallowConcurrentExecution.java:19)
	at com.ruoyi.quartz.util.AbstractQuartzJob.execute(AbstractQuartzJob.java:42)
	at org.quartz.core.JobRunShell.run(JobRunShell.java:203)
	at org.quartz.simpl.SimpleThreadPool$WorkerThread.run(SimpleThreadPool.java:566)
Caused by: java.lang.IllegalArgumentException
	at java.sql/java.sql.Date.valueOf(Date.java:141)
	at com.ruoyi.medical.service.MedicalScheduleService.createScheduleIfAbsent(MedicalScheduleService.java:118)
	at com.ruoyi.medical.service.MedicalScheduleService.generateNextWeekSchedule(MedicalScheduleService.java:95)
	at com.ruoyi.quartz.task.RyTask.generateNextWeekSchedule(RyTask.java:36)
	... 10 more
', '2026-03-04 12:00:00');
INSERT INTO ruoyi_hospital.sys_job_log (job_log_id, job_name, job_group, invoke_target, job_message, status, exception_info, create_time) VALUES (2, '自动排班测试', 'SYSTEM', 'ryTask.generateNextWeekSchedule()', '自动排班测试 总共耗时：3208毫秒', '0', '', '2026-03-04 13:03:37');
INSERT INTO ruoyi_hospital.sys_job_log (job_log_id, job_name, job_group, invoke_target, job_message, status, exception_info, create_time) VALUES (3, '自动排班测试', 'SYSTEM', 'ryTask.generateNextWeekSchedule()', '自动排班测试 总共耗时：807毫秒', '0', '', '2026-03-04 13:04:00');
INSERT INTO ruoyi_hospital.sys_job_log (job_log_id, job_name, job_group, invoke_target, job_message, status, exception_info, create_time) VALUES (4, '后台自动更新预约状态', 'SYSTEM', 'ryTask.checkAppointmentStatus()', '后台自动更新预约状态 总共耗时：8毫秒', '1', 'java.lang.reflect.InvocationTargetException
	at java.base/jdk.internal.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
	at java.base/jdk.internal.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:77)
	at java.base/jdk.internal.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
	at java.base/java.lang.reflect.Method.invoke(Method.java:569)
	at com.ruoyi.quartz.util.JobInvokeUtil.invokeMethod(JobInvokeUtil.java:61)
	at com.ruoyi.quartz.util.JobInvokeUtil.invokeMethod(JobInvokeUtil.java:33)
	at com.ruoyi.quartz.util.QuartzDisallowConcurrentExecution.doExecute(QuartzDisallowConcurrentExecution.java:19)
	at com.ruoyi.quartz.util.AbstractQuartzJob.execute(AbstractQuartzJob.java:42)
	at org.quartz.core.JobRunShell.run(JobRunShell.java:203)
	at org.quartz.simpl.SimpleThreadPool$WorkerThread.run(SimpleThreadPool.java:566)
Caused by: com.ruoyi.common.exception.ServiceException: 获取用户账户异常
	at com.ruoyi.common.utils.SecurityUtils.getUsername(SecurityUtils.java:65)
	at com.ruoyi.medical.service.MedicalAppointmentService.checkAndUpdateExpiredAppointments(MedicalAppointmentService.java:80)
	at com.ruoyi.quartz.task.RyTask.checkAppointmentStatus(RyTask.java:46)
	... 10 more
', '2026-03-04 14:59:29');
INSERT INTO ruoyi_hospital.sys_job_log (job_log_id, job_name, job_group, invoke_target, job_message, status, exception_info, create_time) VALUES (5, '后台自动更新预约状态', 'SYSTEM', 'ryTask.checkAppointmentStatus()', '后台自动更新预约状态 总共耗时：41毫秒', '0', '', '2026-03-04 15:03:58');
INSERT INTO ruoyi_hospital.sys_job_log (job_log_id, job_name, job_group, invoke_target, job_message, status, exception_info, create_time) VALUES (6, '自动排班测试', 'SYSTEM', 'ryTask.generateNextWeekSchedule()', '自动排班测试 总共耗时：3116毫秒', '0', '', '2026-03-08 14:24:22');
