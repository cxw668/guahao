<template>
  <div class="patient-page">
    <el-result icon="success" title="预约提交成功" sub-title="可在「我的预约」查看订单详情">
      <template #extra>
        <el-button type="primary" @click="router.push('/medical-patient/order/list')">查看我的预约</el-button>
        <el-button @click="router.push('/medical-patient/home')">返回首页</el-button>
      </template>
    </el-result>

    <el-card v-loading="loading" class="mt16" v-if="appointmentId">
      <template #header>
        <span class="card-title">订单信息</span>
      </template>
      <el-descriptions v-if="appointment" :column="2" border>
        <el-descriptions-item label="订单号">{{ appointment.appointmentNo }}</el-descriptions-item>
        <el-descriptions-item label="支付状态">
          <el-tag v-if="appointment.payStatus === 1" type="success">已支付</el-tag>
          <el-tag v-else type="warning">未支付</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="就诊日期">{{ appointment.appointmentDate }}</el-descriptions-item>
        <el-descriptions-item label="时段">{{ periodText(appointment.period) }}</el-descriptions-item>
        <el-descriptions-item label="时间" :span="2">{{ appointment.timeSlot || '—' }}</el-descriptions-item>
        <el-descriptions-item label="挂号费" :span="2">
          <span class="fee">{{ appointment.fee ?? 0 }}</span>
        </el-descriptions-item>
      </el-descriptions>
      <el-empty v-else description="未获取到订单详情" />
    </el-card>
  </div>
</template>

<script setup name="MedicalPatientAppointmentSuccess">
import { getMedicalAppointment } from '@/api/medical/appointment'

const router = useRouter()
const route = useRoute()

/**
 * 患者端-预约成功：展示提交结果，并在可用时展示订单信息摘要。
 */
const loading = ref(false)
const appointment = ref(null)

const appointmentId = computed(() => {
  const raw = route.query.appointmentId
  const id = typeof raw === 'string' ? Number(raw) : NaN
  return Number.isFinite(id) ? id : null
})

function periodText(period) {
  if (period === 1) return '上午'
  if (period === 2) return '下午'
  if (period === 3) return '晚间'
  return '—'
}

async function loadAppointment(id) {
  loading.value = true
  try {
    const res = await getMedicalAppointment(id)
    appointment.value = res?.data || null
  } finally {
    loading.value = false
  }
}

watch(
  () => appointmentId.value,
  (val) => {
    appointment.value = null
    if (val) loadAppointment(val)
  },
  { immediate: true }
)
</script>

<style scoped>
.patient-page {
  max-width: 900px;
  margin: 0 auto;
  background: #fff;
  padding: 24px 16px;
  border-radius: 8px;
}

.mt16 {
  margin-top: 16px;
}

.card-title {
  font-weight: 700;
}

.fee {
  color: #f56c6c;
  font-weight: 700;
}
</style>
