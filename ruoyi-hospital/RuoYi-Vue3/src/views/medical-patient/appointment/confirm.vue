<template>
  <div class="patient-page">
    <el-card v-loading="loading" class="mb16">
      <template #header>
        <div class="header">
          <div class="header__left">
            <el-button text @click="router.back()"><el-icon><Back /></el-icon>返回</el-button>
            <span class="header__title">确认预约</span>
          </div>
        </div>
      </template>

      <el-alert
        v-if="!scheduleId"
        title="缺少 scheduleId 参数，无法确认预约"
        type="warning"
        show-icon
        :closable="false"
      />

      <el-descriptions v-else :column="2" border>
        <el-descriptions-item label="医生">
          <span>{{ doctor?.doctorName || '—' }}</span>
          <el-tag v-if="doctor?.title" class="ml8" size="small" type="info">{{ doctor.title }}</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="挂号费">
          <span class="fee">{{ doctor?.fee ?? 0 }}</span>
        </el-descriptions-item>
        <el-descriptions-item label="日期">
          <span>{{ schedule?.workDate || '—' }}</span>
        </el-descriptions-item>
        <el-descriptions-item label="时段">
          <span>{{ periodText(schedule?.period) }}</span>
        </el-descriptions-item>
        <el-descriptions-item label="时间" :span="2">
          <span>{{ timeSlotText }}</span>
        </el-descriptions-item>
      </el-descriptions>
    </el-card>

    <el-card v-if="scheduleId">
      <template #header>
        <div class="header">
          <span class="header__title">就诊信息</span>
          <el-button link type="primary" @click="router.push('/medical-patient/profile')">管理就诊人</el-button>
        </div>
      </template>

      <el-form :model="form" label-width="90px">
        <el-form-item label="就诊人" required>
          <el-select v-model="form.visitorId" placeholder="请选择就诊人" style="width: 320px;">
            <el-option
              v-for="v in visitorList"
              :key="v.visitorId"
              :label="visitorLabel(v)"
              :value="v.visitorId"
            />
          </el-select>
          <el-text v-if="!visitorList.length" type="warning" class="ml8">
            还没有就诊人档案，请先去个人中心新增
          </el-text>
        </el-form-item>

        <el-form-item label="支付方式" required>
          <el-radio-group v-model="form.payWay">
            <el-radio value="wechat">微信</el-radio>
            <el-radio value="alipay">支付宝</el-radio>
          </el-radio-group>
        </el-form-item>

        <el-form-item label="备注">
          <el-input v-model="form.remark" placeholder="可选：填写备注信息" maxlength="200" show-word-limit />
        </el-form-item>
      </el-form>

      <div class="actions">
        <el-button
          type="primary"
          :disabled="!canSubmit"
          :loading="submitting"
          @click="submit(false)"
        >
          提交订单
        </el-button>
        <el-button
          type="success"
          :disabled="!canSubmit"
          :loading="submitting"
          @click="submit(true)"
        >
          提交并支付
        </el-button>
      </div>
    </el-card>
  </div>
</template>

<script setup name="MedicalPatientAppointmentConfirm">
import { ElMessage } from 'element-plus'
import { addMedicalAppointment, listMedicalAppointments, payMedicalAppointment } from '@/api/medical/appointment'
import { getMedicalDoctor } from '@/api/medical/doctor'
import { getMedicalSchedule } from '@/api/medical/schedule'
import { listMedicalPatientVisitors } from '@/api/medical/patientVisitor'
import useUserStore from '@/store/modules/user'
import {Back} from "@element-plus/icons-vue";

/**
 * 患者端-确认预约：根据 scheduleId 生成预约单，并可选择立即支付。
 * 注意：后端创建预约接口不返回 appointmentId，这里通过前端生成 appointmentNo 再回查拿到 appointmentId。
 */
const route = useRoute()
const router = useRouter()
const userStore = useUserStore()

const loading = ref(false)
const submitting = ref(false)

const schedule = ref(null)
const doctor = ref(null)
const visitorList = ref([])

const form = ref({
  visitorId: undefined,
  payWay: 'wechat',
  remark: ''
})

const scheduleId = computed(() => {
  const raw = route.query.scheduleId
  const id = typeof raw === 'string' ? Number(raw) : NaN
  return Number.isFinite(id) ? id : null
})

const timeSlotText = computed(() => {
  const start = normalizeTime(schedule.value?.startTime)
  const end = normalizeTime(schedule.value?.endTime)
  if (start && end) return `${start}-${end}`
  return '—'
})

const canSubmit = computed(() => {
  return Boolean(scheduleId.value && schedule.value && doctor.value && form.value.visitorId && visitorList.value.length)
})

function visitorLabel(v) {
  const name = v?.name || '未命名'
  const relation = v?.relation ? `（${v.relation}）` : ''
  const flag = v?.isDefault === 1 ? ' · 默认' : ''
  return `${name}${relation}${flag}`
}

function normalizeTime(val) {
  const raw = typeof val === 'string' ? val.trim() : ''
  if (!raw) return ''
  const parts = raw.split(':')
  if (parts.length >= 2) return `${parts[0]}:${parts[1]}`
  return raw
}

function periodText(period) {
  if (period === 1) return '上午'
  if (period === 2) return '下午'
  if (period === 3) return '晚间'
  return '—'
}

function generateAppointmentNo() {
  const rand = Math.floor(Math.random() * 9000) + 1000
  return `APT${Date.now()}${rand}`
}

async function loadVisitors() {
  const patientId = Number(userStore.id)
  if (!Number.isFinite(patientId)) {
    visitorList.value = []
    form.value.visitorId = undefined
    return
  }
  const res = await listMedicalPatientVisitors({ pageNum: 1, pageSize: 100, patientId, status: 0 })
  visitorList.value = Array.isArray(res?.rows) ? res.rows : []
  const defaultOne = visitorList.value.find(v => v?.isDefault === 1)
  form.value.visitorId = defaultOne?.visitorId || visitorList.value[0]?.visitorId
}

async function loadScheduleAndDoctor() {
  if (!scheduleId.value) return
  loading.value = true
  try {
    const scheduleRes = await getMedicalSchedule(scheduleId.value)
    schedule.value = scheduleRes?.data || null

    const doctorId = schedule.value?.doctorId
    doctor.value = null
    if (Number.isFinite(doctorId)) {
      const doctorRes = await getMedicalDoctor(doctorId)
      doctor.value = doctorRes?.data || null
    }
  } finally {
    loading.value = false
  }
}

async function fetchAppointmentIdByNo(appointmentNo) {
  const res = await listMedicalAppointments({ pageNum: 1, pageSize: 1, appointmentNo })
  const row = Array.isArray(res?.rows) ? res.rows[0] : null
  const appointmentId = row?.appointmentId
  return Number.isFinite(appointmentId) ? appointmentId : null
}

async function submit(isPayNow) {
  if (!canSubmit.value || submitting.value) return
  submitting.value = true
  try {
    const patientId = Number(userStore.id)
    if (!Number.isFinite(patientId)) {
      ElMessage.error('用户信息异常，请重新登录')
      return
    }
    const appointmentNo = generateAppointmentNo()
    const payload = {
      appointmentNo,
      patientId,
      visitorId: form.value.visitorId,
      doctorId: doctor.value.doctorId,
      scheduleId: schedule.value.scheduleId,
      appointmentDate: schedule.value.workDate,
      period: schedule.value.period,
      timeSlot: timeSlotText.value === '—' ? undefined : timeSlotText.value,
      fee: doctor.value.fee ?? 0,
      remark: form.value.remark || undefined
    }
    await addMedicalAppointment(payload)

    const appointmentId = await fetchAppointmentIdByNo(appointmentNo)
    if (!appointmentId) {
      ElMessage.warning('订单已提交，但未获取到订单ID，请前往“我的预约”查看')
      router.push('/medical-patient/appointment/success')
      return
    }

    if (isPayNow) {
      await payMedicalAppointment(appointmentId, { payWay: form.value.payWay })
    }

    router.push({ path: '/medical-patient/appointment/success', query: { appointmentId: String(appointmentId) } })
  } finally {
    submitting.value = false
  }
}

watch(
  () => scheduleId.value,
  (val) => {
    schedule.value = null
    doctor.value = null
    if (val) {
      loadScheduleAndDoctor()
      loadVisitors()
    }
  },
  { immediate: true }
)
</script>

<style scoped>
.patient-page {
  max-width: 1100px;
  margin: 0 auto;
}

.mb16 {
  margin-bottom: 16px;
}

.header {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.header__left {
  display: flex;
  align-items: center;
  gap: 8px;
}

.header__title {
  font-weight: 700;
}

.fee {
  color: #f56c6c;
  font-weight: 700;
}

.actions {
  display: flex;
  gap: 12px;
  justify-content: flex-end;
}

.ml8 {
  margin-left: 8px;
}
</style>
