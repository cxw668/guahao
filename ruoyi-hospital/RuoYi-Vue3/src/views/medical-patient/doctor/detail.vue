<template>
  <div class="patient-page">
    <el-card v-loading="loading">
      <template #header>
        <div class="header">
          <div class="header__left">
            <el-button text @click="router.back()"><el-icon><Back/></el-icon>返回</el-button>
            <span class="header__title">医生详情</span>
          </div>
          <div class="header__right">
            <el-button type="success" @click="goSchedule" :disabled="!doctor?.doctorId">选择排班</el-button>
          </div>
        </div>
      </template>

      <el-empty v-if="!doctor" description="未找到医生信息" />
      <div v-else class="doctor">
        <el-avatar :size="72" :src="resolveUrl(doctor.avatar)">
          {{ (doctor.doctorName || '').slice(0, 1) }}
        </el-avatar>
        <div class="doctor__main">
          <div class="doctor__title">
            <span class="doctor__name">{{ doctor.doctorName }}</span>
            <el-tag v-if="doctor.title" class="ml8" type="info">{{ doctor.title }}</el-tag>
          </div>
          <div class="doctor__meta">
            <span v-if="deptName">{{ deptName }}</span>
            <span v-if="doctor.specialty"> · {{ doctor.specialty }}</span>
          </div>
          <div class="doctor__fee" v-if="doctor.fee !== undefined && doctor.fee !== null">
            挂号费：<span class="doctor__fee-value">{{ doctor.fee }}</span>
          </div>
        </div>
      </div>

      <el-divider />
      <div class="section">
        <div class="section__title">医生简介</div>
        <div class="section__content">{{ doctor?.intro || '暂无简介' }}</div>
      </div>
    </el-card>
  </div>
</template>

<script setup name="MedicalPatientDoctorDetail">
import { getMedicalDepartment } from '@/api/medical/department'
import { getMedicalDoctor } from '@/api/medical/doctor'
import { isHttp } from '@/utils/validate'
import {Back} from "@element-plus/icons-vue";

/**
 * 患者端-医生详情：展示医生信息，并可进入排班选择。
 */
const route = useRoute()
const router = useRouter()

const loading = ref(false)
const doctor = ref(null)
const deptName = ref('')

function resolveUrl(url) {
  const raw = typeof url === 'string' ? url.trim() : ''
  if (!raw) return ''
  return isHttp(raw) ? raw : import.meta.env.VITE_APP_BASE_API + raw
}

function goSchedule() {
  if (!doctor.value?.doctorId) return
  router.push({ path: '/medical-patient/schedule', query: { doctorId: String(doctor.value.doctorId) } })
}

async function loadDoctor(doctorId) {
  loading.value = true
  try {
    const res = await getMedicalDoctor(doctorId)
    doctor.value = res?.data || null
    deptName.value = ''
    const deptId = doctor.value?.deptId
    if (Number.isFinite(deptId)) {
      const deptRes = await getMedicalDepartment(deptId)
      deptName.value = deptRes?.data?.deptName || ''
    }
  } finally {
    loading.value = false
  }
}

watch(
  () => route.params.doctorId,
  (val) => {
    const doctorId = typeof val === 'string' ? Number(val) : NaN
    doctor.value = null
    deptName.value = ''
    if (Number.isFinite(doctorId)) {
      loadDoctor(doctorId)
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

.doctor {
  display: flex;
  gap: 14px;
  align-items: flex-start;
}

.doctor__main {
  flex: 1;
  min-width: 0;
}

.doctor__title {
  display: flex;
  align-items: center;
}

.doctor__name {
  font-size: 18px;
  font-weight: 700;
  color: #303133;
}

.doctor__meta {
  margin-top: 6px;
  color: #909399;
}

.doctor__fee {
  margin-top: 10px;
  color: #606266;
}

.doctor__fee-value {
  color: #f56c6c;
  font-weight: 700;
}

.section__title {
  font-weight: 700;
  margin-bottom: 8px;
}

.section__content {
  color: #606266;
  line-height: 1.7;
  white-space: pre-line;
}

.ml8 {
  margin-left: 8px;
}
</style>
