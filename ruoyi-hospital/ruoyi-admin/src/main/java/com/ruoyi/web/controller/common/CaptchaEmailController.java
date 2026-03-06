package com.ruoyi.web.controller.common;

import java.util.HashMap;
import java.util.Map;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.redis.RedisCache;
import com.ruoyi.framework.mail.CaptchaEmailService;

/**
 * 验证码邮件控制器
 * 
 * @author ruoyi
 */
@RestController
@RequestMapping("/captcha")
@RequiredArgsConstructor
public class CaptchaEmailController
{
    private final CaptchaEmailService captchaEmailService;
    private final RedisCache redisCache;
    
    /**
     * 发送密码重置验证码
     * 
     * @param params 请求参数（包含 email）
     * @return 结果
     */
    @PostMapping("/sendResetCode")
    public AjaxResult sendResetCode(@RequestBody Map<String, String> params)
    {
        String email = params.get("email");
        
        try
        {
            // 发送邮件并获取 UUID
            String uuid = captchaEmailService.sendPasswordResetCaptcha(email);
            
            Map<String, Object> result = new HashMap<>();
            result.put("uuid", uuid);
            result.put("expireTime", 300); // 5 分钟，单位秒
            
            return AjaxResult.success("验证码已发送至您的邮箱", result);
        }
        catch (RuntimeException e)
        {
            return AjaxResult.error(e.getMessage());
        }
        catch (Exception e)
        {
            return AjaxResult.error("验证码发送失败，请稍后重试");
        }
    }
}
