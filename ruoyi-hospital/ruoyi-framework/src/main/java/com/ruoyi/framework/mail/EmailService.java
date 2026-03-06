package com.ruoyi.framework.mail;

import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Component;

/**
 * 邮件发送服务
 * 
 * @author ruoyi
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class EmailService
{
    private final JavaMailSender mailSender;
    
    @Value("${spring.mail.username}")
    private String fromEmail;
    
    /**
     * 发送 HTML 格式的邮件
     * 
     * @param to 收件人邮箱
     * @param subject 邮件主题
     * @param content 邮件内容（HTML 格式）
     * @return 是否发送成功
     */
    public boolean sendHtmlEmail(String to, String subject, String content)
    {
        try
        {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
            
            helper.setFrom(fromEmail);
            helper.setTo(to);
            helper.setSubject(subject);
            helper.setText(content, true); // true 表示 HTML 格式
            
            mailSender.send(message);
            
            log.info("邮件发送成功，收件人：{}, 主题：{}", to, subject);
            return true;
        }
        catch (MessagingException e)
        {
            log.error("邮件发送失败，收件人：{}, 主题：{}, 错误：{}", to, subject, e.getMessage());
            return false;
        }
    }
    
    /**
     * 发送简单文本邮件
     * 
     * @param to 收件人邮箱
     * @param subject 邮件主题
     * @param content 邮件内容
     * @return 是否发送成功
     */
    public boolean sendSimpleEmail(String to, String subject, String content)
    {
        try
        {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
            
            helper.setFrom(fromEmail);
            helper.setTo(to);
            helper.setSubject(subject);
            helper.setText(content);
            
            mailSender.send(message);
            
            log.info("简单邮件发送成功，收件人：{}, 主题：{}", to, subject);
            return true;
        }
        catch (MessagingException e)
        {
            log.error("简单邮件发送失败，收件人：{}, 主题：{}, 错误：{}", to, subject, e.getMessage());
            return false;
        }
    }
}
