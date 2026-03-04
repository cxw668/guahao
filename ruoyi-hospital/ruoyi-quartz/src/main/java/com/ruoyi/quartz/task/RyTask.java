package com.ruoyi.quartz.task;
import org.springframework.stereotype.Component;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.medical.service.MedicalScheduleService;
import lombok.RequiredArgsConstructor;
/**
 * 定时任务调度测试
 * 
 * @author ruoyi
 */
@Component("ryTask")
@RequiredArgsConstructor
public class RyTask
{
    private final MedicalScheduleService scheduleService;
    public void ryMultipleParams(String s, Boolean b, Long l, Double d, Integer i)
    {
        System.out.println(StringUtils.format("执行多参方法： 字符串类型{}，布尔类型{}，长整型{}，浮点型{}，整形{}", s, b, l, d, i));
    }

    public void ryParams(String params)
    {
        System.out.println("执行有参方法：" + params);
    }

    public void ryNoParams()
    {
        System.out.println("执行无参方法");
    }

    /**
     * 每周定时生成下周排班
     */
    public void generateNextWeekSchedule()
    {
        scheduleService.generateNextWeekSchedule();
        System.out.println("自动生成下周排班完成");
    }
}
