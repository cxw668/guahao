<template>
  <div class="login">
    <el-form ref="loginRef" :model="loginForm" :rules="loginRules" class="login-form">
      <h3 class="title">欢迎登录 - {{ title }}</h3>
      <el-form-item prop="username">
        <el-input v-model="loginForm.username" type="text" size="large" auto-complete="off" placeholder="账号">
          <template #prefix><svg-icon icon-class="user" class="el-input__icon input-icon" /></template>
        </el-input>
      </el-form-item>
      <el-form-item prop="password">
        <el-input v-model="loginForm.password" type="password" size="large" auto-complete="off" placeholder="密码"
          @keyup.enter="handleLogin">
          <template #prefix><svg-icon icon-class="password" class="el-input__icon input-icon" /></template>
        </el-input>
      </el-form-item>
      <el-form-item prop="code" v-if="captchaEnabled">
        <el-input v-model="loginForm.code" size="large" auto-complete="off" placeholder="验证码" style="width: 63%"
          @keyup.enter="handleLogin">
          <template #prefix><svg-icon icon-class="validCode" class="el-input__icon input-icon" /></template>
        </el-input>
        <div class="login-code">
          <img :src="codeUrl" @click="getCode" class="login-code-img" />
        </div>
      </el-form-item>
      <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 20px;">
        <el-checkbox v-model="loginForm.rememberMe">记住密码</el-checkbox>
        <div style="display: flex; gap: 15px; font-size: 14px;">
          <span class="forgot-password" style="font-weight: bold; color: skyblue; cursor: pointer;" @click="()=>resetDialogVisible=true">
            忘记密码
          </span>
          <span class="register" style="font-weight: bold; color: skyblue;">
            <router-link class="link-type" :to="'/register'">立即注册</router-link>
          </span>
        </div>
      </div>

      <!-- 密码重置弹窗 -->
      <el-dialog v-model="resetDialogVisible" title="密码重置" width="400px" :close-on-click-modal="false" @close="closeResetDialog">
        <el-form ref="resetFormRef" :model="resetForm" :rules="resetRules" label-width="80px">
          <el-form-item label="邮箱" prop="email">
            <el-input v-model="resetForm.email" placeholder="请输入注册邮箱" />
          </el-form-item>
          <el-form-item label="图形验证" prop="captcha">
            <div style="display: flex; gap: 10px; align-items: center;">
              <el-input 
                v-model="resetForm.captcha" 
                placeholder="请输入图形验证码" 
                style="flex: 1;"
                @keyup.enter="verifyCaptcha" />
              <div class="login-code" style="width: 100px; height: 40px;">
                <img :src="resetCodeUrl" @click="getResetCode" class="login-code-img" />
              </div>
              <el-icon v-if="captchaVerified" color="#67c23a" size="24">
                <CircleCheckFilled />
              </el-icon>
            </div>
          </el-form-item>
          <el-form-item label="验证码" prop="code">
            <div style="display: flex; gap: 10px;">
              <el-input v-model="resetForm.code" placeholder="请输入邮箱验证码" style="flex: 1;" />
              <el-button
                :loading="sendingCode"
                :disabled="sendingCode || !resetForm.email || !captchaVerified"
                @click="sendResetCode"
                style="white-space: nowrap;">
                {{ sendingCode ? `${countdown}s` : '发送验证码' }}
              </el-button>
            </div>
          </el-form-item>
          <el-form-item label="新密码" prop="newPassword">
            <el-input v-model="resetForm.newPassword" type="password" placeholder="请输入新密码" show-password />
          </el-form-item>
          <el-form-item label="确认密码" prop="confirmPassword">
            <el-input v-model="resetForm.confirmPassword" type="password" placeholder="请再次输入新密码" show-password />
          </el-form-item>
        </el-form>
        <template #footer>
          <div style="display: flex; justify-content: flex-end; gap: 10px;">
            <el-button @click="resetDialogVisible = false">取消</el-button>
            <el-button type="primary" :loading="resetting" @click="handleResetPassword">重置密码</el-button>
          </div>
        </template>
      </el-dialog>
      <el-form-item style="width:100%;">
        <el-button :loading="loading" size="large" type="primary" style="width:100%;" @click.prevent="handleLogin">
          <span v-if="!loading">登 录</span>
          <span v-else>登 录 中...</span>
        </el-button>
      </el-form-item>
    </el-form>
    <!--  底部  -->
    <div class="el-login-footer">
      <span>{{ footerContent }}</span>
    </div>
  </div>
</template>

<script setup>
import { getCodeImg } from "@/api/login"
import Cookies from "js-cookie"
import { encrypt, decrypt } from "@/utils/jsencrypt"
import useUserStore from '@/store/modules/user'
import defaultSettings from '@/settings'
import request from '@/utils/request'
import { CircleCheckFilled } from '@element-plus/icons-vue'

const title = import.meta.env.VITE_APP_TITLE
const footerContent = defaultSettings.footerContent
const userStore = useUserStore()
const route = useRoute()
const router = useRouter()
const { proxy } = getCurrentInstance()
const resetDialogVisible = ref(false)
/**
 * admin => admin admin123
 * common => common common123
 * doctor => doctor doctor123
 */
const loginForm = ref({
  username: "",
  password: "",
  rememberMe: false,
  code: "",
  uuid: ""
})

const loginRules = {
  username: [{ required: true, trigger: "blur", message: "请输入您的账号" }],
  password: [{ required: true, trigger: "blur", message: "请输入您的密码" }],
  code: [{ required: true, trigger: "change", message: "请输入验证码" }]
}

const codeUrl = ref("")
const loading = ref(false)
// 验证码开关
const captchaEnabled = ref(true)
// 注册开关
const register = ref(false)
const redirect = ref(undefined)

// 密码重置相关
const resetForm = ref({
  email: "",
  captcha: "",
  captchaUuid: "",
  code: "",
  uuid: "",
  newPassword: "",
  confirmPassword: ""
})

const resetCodeUrl = ref("")
const captchaVerified = ref(false)

const resetRules = {
  email: [
    { required: true, trigger: "blur", message: "请输入邮箱" },
    { type: "email", trigger: "blur", message: "邮箱格式不正确" }
  ],
  captcha: [{ required: true, trigger: "change", message: "请输入图形验证码" }],
  code: [{ required: true, trigger: "change", message: "请输入验证码" }],
  newPassword: [
    { required: true, trigger: "blur", message: "请输入新密码" },
    { min: 5, max: 20, trigger: "blur", message: "密码长度必须在 5 到 20 个字符之间" }
  ],
  confirmPassword: [
    { required: true, trigger: "blur", message: "请再次输入新密码" },
    {
      validator: (rule, value) => {
        if (value !== resetForm.value.newPassword) {
          return new Error('两次输入的密码不一致')
        }
        return true
      },
      trigger: "blur"
    }
  ]
}

const sendingCode = ref(false)
const countdown = ref(0)
const resetting = ref(false)
let countdownTimer = null

watch(route, (newRoute) => {
  redirect.value = newRoute.query && newRoute.query.redirect
}, { immediate: true })

function handleLogin() {
  proxy.$refs.loginRef.validate(valid => {
    if (valid) {
      loading.value = true
      // 勾选了需要记住密码设置在 cookie 中设置记住用户名和密码
      if (loginForm.value.rememberMe) {
        Cookies.set("username", loginForm.value.username, { expires: 30 })
        Cookies.set("password", encrypt(loginForm.value.password), { expires: 30 })
        Cookies.set("rememberMe", loginForm.value.rememberMe, { expires: 30 })
      } else {
        // 否则移除
        Cookies.remove("username")
        Cookies.remove("password")
        Cookies.remove("rememberMe")
      }
      // 调用action的登录方法
      userStore.login(loginForm.value).then(() => {
        const query = route.query
        const otherQueryParams = Object.keys(query).reduce((acc, cur) => {
          if (cur !== "redirect") {
            acc[cur] = query[cur]
          }
          return acc
        }, {})
        router.push({ path: '/portal', query: otherQueryParams }) // 登录后跳转到各自的路由
      }).catch(() => {
        loading.value = false
        // 重新获取验证码
        if (captchaEnabled.value) {
          getCode()
        }
      })
    }
  })
}

function getCode() {
  getCodeImg().then(res => {
    captchaEnabled.value = res.captchaEnabled === undefined ? true : res.captchaEnabled
    if (captchaEnabled.value) {
      codeUrl.value = "data:image/gif;base64," + res.img
      loginForm.value.uuid = res.uuid
    }
  })
}

function getCookie() {
  const username = Cookies.get("username")
  const password = Cookies.get("password")
  const rememberMe = Cookies.get("rememberMe")
  loginForm.value = {
    username: username === undefined ? loginForm.value.username : username,
    password: password === undefined ? loginForm.value.password : decrypt(password),
    rememberMe: rememberMe === undefined ? false : Boolean(rememberMe)
  }
}

/**
 * 获取密码重置图形验证码
 */
function getResetCode() {
  console.log('[密码重置] 请求获取图形验证码')
  getCodeImg().then(res => {
    const enabled = res.code === 200
    if (enabled) {
      resetCodeUrl.value = "data:image/gif;base64," + res.img
      resetForm.value.captchaUuid = res.uuid
      // 每次获取新验证码时清空已验证状态
      captchaVerified.value = false
      resetForm.value.captcha = ""
      console.log('[密码重置] 图形验证码已刷新，UUID:', res.uuid)
    }
  })
}

/**
 * 校验图形验证码
 */
async function verifyCaptcha() {
  if (!resetForm.value.captcha || !resetForm.value.captchaUuid) {
    proxy["$modal"].msgError('请先输入验证码')
    return
  }

  console.log('[密码重置] 校验图形验证码:', {
    captcha: resetForm.value.captcha,
    uuid: resetForm.value.captchaUuid
  })

  try {
    const res = await request({
      url: '/verify',
      method: 'post',
      data: {
        captcha: resetForm.value.captcha,
        uuid: resetForm.value.captchaUuid
      }
    })

    if (res && res.code === 200 && res.data === true) {
      captchaVerified.value = true
      proxy["$modal"].msgSuccess('图形验证码正确')
      console.log('[密码重置] 图形验证码校验通过')
    } else {
      captchaVerified.value = false
      proxy["$modal"].msgError('图形验证码错误，请重新输入')
      console.error('[密码重置] 图形验证码校验失败')
      // 重新获取验证码
      getResetCode()
    }
  } catch (error) {
    console.error('[密码重置] 图形验证码校验异常:', error)
    proxy["$modal"].msgError('验证码校验失败')
    captchaVerified.value = false
    // 重新获取验证码
    getResetCode()
  }
}

/**
 * 发送重置密码验证码
 */
async function sendResetCode() {
  // 验证邮箱格式
  try {
    await proxy.$refs.resetFormRef.validateField('email')
  } catch (error) {
    return
  }

  // 检查图形验证码是否已验证
  if (!captchaVerified.value) {
    proxy["$modal"].msgWarning('请先通过图形验证码校验')
    return
  }

  sendingCode.value = true
  countdown.value = 60
  
  console.log('[密码重置] 请求发送验证码到邮箱:', resetForm.value.email)
  
  try {
    // 调用后端发送邮件验证码 API
    const res = await request({
      url: '/captcha/sendResetCode',
      method: 'post',
      data: { email: resetForm.value.email }
    })
    
    console.log('[密码重置] 验证码发送成功，UUID:', res.data.uuid)
    resetForm.value.uuid = res.data.uuid
    
    proxy["$modal"].msgSuccess('验证码已发送至邮箱，请注意查收')
    
    // 开始倒计时
    countdownTimer = setInterval(() => {
      countdown.value--
      if (countdown.value <= 0) {
        clearInterval(countdownTimer)
        sendingCode.value = false
      }
    }, 1000)
  } catch (error) {
    console.error('[密码重置] 验证码发送失败:', error)
    sendingCode.value = false
    countdown.value = 0
  }
}

/**
 * 处理密码重置
 */
async function handleResetPassword() {
  try {
    await proxy.$refs.resetFormRef.validate()
  } catch (error) {
    return
  }

  resetting.value = true
  
  console.log('[密码重置] 提交重置请求:', {
    email: resetForm.value.email,
    code: resetForm.value.code,
    uuid: resetForm.value.uuid,
    newPassword: resetForm.value.newPassword
  })
  
  try {
    // 调用后端密码重置 API
    const res = await request({
      url: '/system/user/resetPwdByEmail',
      method: 'put',
      data: {
        email: resetForm.value.email,
        code: resetForm.value.code,
        uuid: resetForm.value.uuid,
        newPassword: resetForm.value.newPassword
      }
    })
    
    proxy.$modal.msgSuccess('密码重置成功')
    resetDialogVisible.value = false
    // 清空表单
    resetForm.value = {
      email: "",
      code: "",
      uuid: "",
      newPassword: "",
      confirmPassword: ""
    }
  } catch (error) {
    console.error('[密码重置] 失败:', error)
    // 重新获取验证码
    getCode()
  } finally {
    resetting.value = false
  }
}

/**
 * 关闭弹窗时清理定时器
 */
function closeResetDialog() {
  resetDialogVisible.value = false
  if (countdownTimer) {
    clearInterval(countdownTimer)
    countdownTimer = null
  }
  sendingCode.value = false
  countdown.value = 0
  // 清空表单和验证码状态
  resetForm.value = {
    email: "",
    captcha: "",
    captchaUuid: "",
    code: "",
    uuid: "",
    newPassword: "",
    confirmPassword: ""
  }
  captchaVerified.value = false
  resetCodeUrl.value = ""
}

// 初始化时获取密码重置的图形验证码
getResetCode()

getCode()
getCookie()
</script>

<style lang='scss' scoped>
.login {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100%;
  background-image: url("../assets/images/login-background.jpg");
  background-size: cover;
}

.title {
  margin: 0px auto 30px auto;
  text-align: center;
  color: #707070;
}

.login-form {
  border-radius: 6px;
  background: #ffffff;
  width: 400px;
  padding: 25px 25px 5px 25px;
  z-index: 1;

  .el-input {
    height: 40px;

    input {
      height: 40px;
    }
  }

  .input-icon {
    height: 39px;
    width: 14px;
    margin-left: 0px;
  }
}

.login-tip {
  font-size: 13px;
  text-align: center;
  color: #bfbfbf;
}

.login-code {
  width: 33%;
  height: 40px;
  float: right;

  img {
    cursor: pointer;
    vertical-align: middle;
  }
}

.el-login-footer {
  height: 40px;
  line-height: 40px;
  position: fixed;
  bottom: 0;
  width: 100%;
  text-align: center;
  color: #fff;
  font-family: Arial;
  font-size: 12px;
  letter-spacing: 1px;
}

.login-code-img {
  height: 40px;
  padding-left: 12px;
}
</style>
