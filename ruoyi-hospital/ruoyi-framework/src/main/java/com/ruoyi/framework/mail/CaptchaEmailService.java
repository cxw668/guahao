package com.ruoyi.framework.mail;

import java.util.concurrent.TimeUnit;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import com.ruoyi.common.constant.CacheConstants;
import com.ruoyi.common.core.redis.RedisCache;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.common.utils.uuid.IdUtils;

/**
 * 验证码邮件服务
 * 
 * @author ruoyi
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class CaptchaEmailService
{
    private final EmailService emailService;
    private final RedisCache redisCache;
    
    @Value("${spring.mail.username}")
    private String fromEmail;
    
    // 验证码有效期（分钟）
    private static final int CAPTCHA_EXPIRATION = 5;
    
    // 验证码冷却时间（秒）
    private static final int COOLDOWN_TIME = 60;
    
    /**
     * 发送密码重置验证码
     * 
     * @param email 收件人邮箱
     * @return 验证码 UUID，用于后续验证
     */
    public String sendPasswordResetCaptcha(String email)
    {
        if (StringUtils.isEmpty(email))
        {
            throw new IllegalArgumentException("邮箱不能为空");
        }
        
        // 检查是否在冷却时间内
        String cooldownKey = CacheConstants.CAPTCHA_CODE_KEY + "cooldown:" + email;
        if (redisCache.hasKey(cooldownKey))
        {
            long remainingTime = redisCache.getExpire(cooldownKey);
            throw new RuntimeException(String.format("发送过于频繁，请%d秒后再试", remainingTime));
        }
        
        // 生成 6 位数字验证码
        String captcha = generateNumericCaptcha(6);
        String uuid = IdUtils.simpleUUID();
        
        // 保存到 Redis
        String verifyKey = CacheConstants.CAPTCHA_CODE_KEY + uuid;
        redisCache.setCacheObject(verifyKey, captcha, CAPTCHA_EXPIRATION, TimeUnit.MINUTES);
        
        // 设置冷却时间
        redisCache.setCacheObject(cooldownKey, "1", COOLDOWN_TIME, TimeUnit.SECONDS);
        
        // 构建邮件内容
        String subject = "【挂号系统】密码重置验证码";
        String content = buildPasswordResetEmailContent(captcha, email);
        
        // 发送邮件
        boolean success = emailService.sendHtmlEmail(email, subject, content);
        
        if (!success)
        {
            // 删除 Redis 中的验证码
            redisCache.deleteObject(verifyKey);
            throw new RuntimeException("邮件发送失败，请稍后重试");
        }
        
        log.info("密码重置验证码已发送至：{}, UUID: {}", email, uuid);
        return uuid;
    }
    
    /**
     * 验证验证码
     * 
     * @param uuid 验证码 UUID
     * @param code 用户输入的验证码
     * @return 是否验证成功
     */
    public boolean validateCaptcha(String uuid, String code)
    {
        if (uuid == null || StringUtils.isEmpty(uuid) || code == null  || StringUtils.isEmpty(code))
        {
            return false;
        }
        
        String verifyKey = CacheConstants.CAPTCHA_CODE_KEY + uuid;
        String captcha = redisCache.getCacheObject(verifyKey);
        
        if (captcha == null)
        {
            return false;
        }
        
        // 验证成功后删除验证码
        redisCache.deleteObject(verifyKey);
        return code.equalsIgnoreCase(captcha);
    }
    
    /**
     * 生成指定位数的数字验证码
     * 
     * @param length 位数
     * @return 验证码
     */
    private String generateNumericCaptcha(int length)
    {
        StringBuilder captcha = new StringBuilder();
        for (int i = 0; i < length; i++)
        {
            captcha.append((int) ((Math.random() * 10)));
        }
        return captcha.toString();
    }
    
    /**
     * 构建密码重置邮件内容
     * 
     * @param captcha 验证码
     * @param email 收件人邮箱
     * @return HTML 格式的邮件内容
     */
    private String buildPasswordResetEmailContent(String captcha, String email)
    {
        return "<!DOCTYPE html>" +
                "<html>" +
                "<head>" +
                "<meta charset='UTF-8'>" +
                "<style>" +
                "body { font-family: 'Microsoft YaHei', Arial, sans-serif; line-height: 1.6; color: #333; }" +
                ".container { max-width: 600px; margin: 0 auto; padding: 20px; }" +
                ".header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 30px; text-align: center; border-radius: 10px 10px 0 0; }" +
                ".content { background: #f9f9f9; padding: 30px; border-radius: 0 0 10px 10px; }" +
                ".captcha-box { background: white; border-left: 4px solid #667eea; padding: 20px; margin: 20px 0; }" +
                ".captcha { font-size: 32px; font-weight: bold; color: #667eea; letter-spacing: 5px; text-align: center; display: block; margin: 15px 0; }" +
                ".warning { background: #fff3cd; border: 1px solid #ffc107; padding: 15px; border-radius: 5px; margin: 20px 0; }" +
                ".footer { text-align: center; margin-top: 30px; color: #999; font-size: 12px; }" +
                "</style>" +
                "</head>" +
                "<body>" +
                "<div class='container'>" +
                "<div class='header'>" +
                "<h1>密码重置验证码</h1>" +
                "</div>" +
                "<div class='content'>" +
                "<p>尊敬的用户：</p>" +
                "<p>您好！您正在申请密码重置，请使用以下验证码完成操作：</p>" +
                "<div class='captcha-box'>" +
                "<span class='captcha'>" + captcha + "</span>" +
                "<p style='color: #666; font-size: 14px; margin: 0;'>验证码有效期为<strong>" + CAPTCHA_EXPIRATION + "分钟</strong></p>" +
                "</div>" +
                "<p>如果这不是您的操作，请忽略此邮件，您的账号安全不会受到影响。</p>" +
                "<div class='warning'>" +
                "<strong>安全提示：</strong>" +
                "<ul style='margin: 10px 0; padding-left: 20px;'>" +
                "<li>请勿将验证码泄露给他人</li>" +
                "<li>系统工作人员不会向您索取验证码</li>" +
                "<li>如收到可疑邮件，请及时联系我们</li>" +
                "</ul>" +
                "</div>" +
                "<p>此致<br>敬礼</p>" +
                "<p><strong>挂号系统管理团队</strong></p>" +
                "<div class='footer'>" +
                "<p>本邮件由系统自动发送，请勿直接回复</p>" +
                "<p>&copy; " + java.time.Year.now().getValue() + " 挂号系统。All rights reserved.</p>" +
                "</div>" +
                "</div>" +
                "</body>" +
                "</html>";
    }
}
