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

    <div v-loading="loading" class="schedule-list">
      <el-row :gutter="12" v-if="doctorId">
        <el-col v-for="schedule in scheduleList" :key="schedule.scheduleId" :xs="24" :sm="12" :md="8" :lg="6">
          <el-card 
            shadow="hover" 
            class="schedule-card mb16" 
            :class="{ 'is-disabled': schedule.status !== 0 || remainingSlots(schedule) <= 0 }"
            @click="goConfirm(schedule)"
          >
            <div class="schedule-header">
              <span class="date">{{ schedule.workDate }}</span>
              <el-tag :type="periodTagType(schedule.period)" size="small" effect="dark">{{ periodText(schedule.period) }}</el-tag>
            </div>
            
            <div class="schedule-body">
              <div class="time-range">{{ schedule.startTime }} - {{ schedule.endTime }}</div>
              <div class="slots-info">
                <span class="label">剩余号源</span>
                <span class="value" :class="{ danger: remainingSlots(schedule) <= 0 }">
                  {{ remainingSlots(schedule) }}
                </span>
              </div>
            </div>

            <div class="schedule-footer">
              <div class="status-tag">
                <el-tag v-if="schedule.status === 0" type="success" size="small" effect="plain">可预约</el-tag>
                <el-tag v-else-if="schedule.status === 1" type="info" size="small" effect="plain">停诊</el-tag>
                <el-tag v-else type="warning" size="small" effect="plain">已约满</el-tag>
              </div>
              <el-button 
                type="primary" 
                size="small" 
                :disabled="schedule.status !== 0 || remainingSlots(schedule) <= 0"
              >
                选择
              </el-button>
            </div>
          </el-card>
        </el-col>
      </el-row>

      <el-empty v-if="doctorId && !scheduleList.length && !loading" description="暂无可预约排班" />
    </div>
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

<style lang="scss" scoped>
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

.schedule-list {
  min-height: 400px;
}

.schedule-card {
  transition: all 0.3s;
  cursor: pointer;
  border: 1px solid #ebeef5;
  
  &:hover {
    transform: translateY(-4px);
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
    border-color: var(--el-color-primary-light-5);
  }
  
  &.is-disabled {
    cursor: not-allowed;
    background-color: #f5f7fa;
    
    &:hover {
      transform: none;
      box-shadow: none;
      border-color: #ebeef5;
    }
  }

  :deep(.el-card__body) {
    padding: 16px;
  }
}

.schedule-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 12px;
  
  .date {
    font-size: 16px;
    font-weight: 700;
    color: #303133;
  }
}

.schedule-body {
  margin-bottom: 16px;
}

.time-range {
  font-size: 14px;
  color: #606266;
  margin-bottom: 8px;
  display: flex;
  align-items: center;
  
  &::before {
    content: '';
    display: inline-block;
    width: 6px;
    height: 6px;
    border-radius: 50%;
    background-color: #909399;
    margin-right: 8px;
  }
}

.slots-info {
  display: flex;
  justify-content: space-between;
  align-items: center;
  background-color: #f2f6fc;
  padding: 8px 12px;
  border-radius: 4px;
  
  .label {
    font-size: 13px;
    color: #909399;
  }
  
  .value {
    font-size: 16px;
    font-weight: 700;
    color: var(--el-color-primary);
    
    &.danger {
      color: #f56c6c;
    }
  }
}

.schedule-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-top: 12px;
  border-top: 1px solid #ebeef5;
}

.danger {
  color: #f56c6c;
  font-weight: 700;
}
</style>
