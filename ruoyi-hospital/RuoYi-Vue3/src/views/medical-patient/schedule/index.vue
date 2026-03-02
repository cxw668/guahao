<template>
  <div class="patient-page">
    <el-card class="mb16">
      <template #header>
        <div class="header">
          <div class="header__left">
            <el-button text @click="router.back()">返回</el-button>
            <span class="header__title">排班选择</span>
          </div>
        </div>
      </template>

      <el-alert
        v-if="!doctorId"
        title="缺少 doctorId 参数，无法查询排班"
        type="warning"
        show-icon
        :closable="false"
      />
      <div v-else class="doctor-bar">
        <div class="doctor-bar__left">
          <div class="doctor-bar__name">{{ doctor?.doctorName || '医生' }}</div>
          <div class="doctor-bar__meta">
            <span v-if="doctor?.title">{{ doctor.title }}</span>
            <span v-if="doctor?.fee !== undefined && doctor?.fee !== null"> · 挂号费 {{ doctor.fee }}</span>
          </div>
        </div>
        <div class="doctor-bar__right">
          <el-button type="primary" plain @click="refresh">刷新</el-button>
        </div>
      </div>
    </el-card>

    <el-card v-loading="loading">
      <el-table v-if="doctorId" :data="scheduleList" row-key="scheduleId">
        <el-table-column label="日期" prop="workDate" width="140" />
        <el-table-column label="时段" width="120">
          <template #default="{ row }">
            <el-tag :type="periodTagType(row.period)" effect="plain">{{ periodText(row.period) }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="时间" min-width="160">
          <template #default="{ row }">
            <span v-if="row.startTime && row.endTime">{{ row.startTime }} - {{ row.endTime }}</span>
            <span v-else>—</span>
          </template>
        </el-table-column>
        <el-table-column label="剩余号源" width="120">
          <template #default="{ row }">
            <span :class="{ danger: remainingSlots(row) <= 0 }">{{ remainingSlots(row) }}</span>
          </template>
        </el-table-column>
        <el-table-column label="状态" width="120">
          <template #default="{ row }">
            <el-tag v-if="row.status === 0" type="success">可约</el-tag>
            <el-tag v-else-if="row.status === 1" type="info">停诊</el-tag>
            <el-tag v-else type="warning">已满</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="120" fixed="right">
          <template #default="{ row }">
            <el-button
              type="success"
              link
              :disabled="row.status !== 0 || remainingSlots(row) <= 0"
              @click="goConfirm(row)"
            >
              选择
            </el-button>
          </template>
        </el-table-column>
      </el-table>

      <el-empty v-if="doctorId && !scheduleList.length && !loading" description="暂无可预约排班" />
    </el-card>
  </div>
</template>

<script setup name="MedicalPatientSchedule">
import { getMedicalDoctor } from '@/api/medical/doctor'
import { listMedicalSchedules } from '@/api/medical/schedule'

/**
 * 患者端-排班：基于 doctorId 查询排班号源，并进入确认预约页。
 */
const route = useRoute()
const router = useRouter()

const loading = ref(false)
const doctor = ref(null)
const scheduleList = ref([])

const doctorId = computed(() => {
  const raw = route.query.doctorId
  const id = typeof raw === 'string' ? Number(raw) : NaN
  return Number.isFinite(id) ? id : null
})

function periodText(period) {
  if (period === 1) return '上午'
  if (period === 2) return '下午'
  if (period === 3) return '晚间'
  return '未知'
}

function periodTagType(period) {
  if (period === 1) return 'success'
  if (period === 2) return 'warning'
  if (period === 3) return 'info'
  return 'info'
}

function remainingSlots(row) {
  const total = Number(row?.totalSlots)
  const booked = Number(row?.bookedSlots)
  const totalSafe = Number.isFinite(total) ? total : 0
  const bookedSafe = Number.isFinite(booked) ? booked : 0
  return totalSafe - bookedSafe
}

function goConfirm(row) {
  router.push({
    path: '/medical-patient/appointment/confirm',
    query: { scheduleId: String(row.scheduleId || ''), doctorId: String(doctorId.value || '') }
  })
}

async function refresh() {
  if (!doctorId.value) return
  loading.value = true
  try {
    const [doctorRes, scheduleRes] = await Promise.all([
      getMedicalDoctor(doctorId.value),
      listMedicalSchedules({ pageNum: 1, pageSize: 50, doctorId: doctorId.value, status: 0 })
    ])
    doctor.value = doctorRes?.data || null
    scheduleList.value = Array.isArray(scheduleRes?.rows) ? scheduleRes.rows : []
  } finally {
    loading.value = false
  }
}

watch(
  () => doctorId.value,
  (val) => {
    doctor.value = null
    scheduleList.value = []
    if (val) refresh()
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

.doctor-bar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
}

.doctor-bar__name {
  font-weight: 700;
  color: #303133;
}

.doctor-bar__meta {
  margin-top: 6px;
  color: #909399;
  font-size: 12px;
}

.danger {
  color: #f56c6c;
  font-weight: 700;
}
</style>
