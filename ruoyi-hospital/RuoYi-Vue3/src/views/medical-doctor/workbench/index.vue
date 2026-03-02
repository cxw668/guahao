<template>
  <div class="app-container">
    <el-form :inline="true" label-width="68px" class="mb8">
      <el-form-item label="医生">
        <el-select v-model="selectedDoctorId" placeholder="请选择医生" clearable style="width: 240px;" @change="handleQuery">
          <el-option v-for="d in doctorOptions" :key="d.doctorId" :label="d.doctorName" :value="d.doctorId" />
        </el-select>
      </el-form-item>
      <el-form-item label="日期">
        <el-date-picker
          v-model="queryDate"
          type="date"
          value-format="YYYY-MM-DD"
          placeholder="请选择日期"
          style="width: 240px;"
          clearable
          @change="handleQuery"
        />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Refresh" :loading="loading" @click="refreshAll">刷新</el-button>
      </el-form-item>
      <el-form-item v-if="lastRefreshTime">
        <el-text type="info">最近刷新：{{ lastRefreshTime }}</el-text>
      </el-form-item>
    </el-form>

    <el-row :gutter="12" class="mb8">
      <el-col :span="6">
        <el-card shadow="never">
          <template #header>
            <span>今日预约</span>
          </template>
          <div class="stat-value">{{ stats.total }}</div>
          <div class="stat-desc">当天预约总数</div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card shadow="never">
          <template #header>
            <span>待就诊</span>
          </template>
          <div class="stat-value stat-warn">{{ stats.waiting }}</div>
          <div class="stat-desc">等待签到 / 候诊</div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card shadow="never">
          <template #header>
            <span>就诊中</span>
          </template>
          <div class="stat-value stat-primary">{{ stats.consulting }}</div>
          <div class="stat-desc">正在接诊</div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card shadow="never">
          <template #header>
            <span>已完成</span>
          </template>
          <div class="stat-value stat-success">{{ stats.finished }}</div>
          <div class="stat-desc">已完成就诊</div>
        </el-card>
      </el-col>
    </el-row>

    <el-row :gutter="12" class="mb8">
      <el-col :span="12">
        <el-card shadow="never">
          <template #header>
            <span>今日号源</span>
          </template>
          <el-row :gutter="12">
            <el-col :span="8">
              <div class="stat-mini">
                <div class="stat-mini-label">总号源</div>
                <div class="stat-mini-value">{{ scheduleStats.totalSlots }}</div>
              </div>
            </el-col>
            <el-col :span="8">
              <div class="stat-mini">
                <div class="stat-mini-label">已预约</div>
                <div class="stat-mini-value">{{ scheduleStats.bookedSlots }}</div>
              </div>
            </el-col>
            <el-col :span="8">
              <div class="stat-mini">
                <div class="stat-mini-label">剩余</div>
                <div class="stat-mini-value">{{ scheduleStats.remainingSlots }}</div>
              </div>
            </el-col>
          </el-row>
          <el-divider content-position="left">排班明细</el-divider>
          <el-table v-loading="scheduleLoading" :data="todayScheduleList" size="small">
            <el-table-column label="日期" align="center" prop="workDate" width="120" />
            <el-table-column label="时段" align="center" prop="period" width="90">
              <template #default="scope">
                <span>{{ periodLabel(scope.row.period) }}</span>
              </template>
            </el-table-column>
            <el-table-column label="开始" align="center" prop="startTime" width="110" />
            <el-table-column label="结束" align="center" prop="endTime" width="110" />
            <el-table-column label="总号源" align="center" prop="totalSlots" width="90" />
            <el-table-column label="已约" align="center" prop="bookedSlots" width="80" />
            <el-table-column label="状态" align="center" prop="status" width="90">
              <template #default="scope">
                <el-tag v-if="scope.row.status === 0" type="success">正常</el-tag>
                <el-tag v-else-if="scope.row.status === 1" type="warning">停诊</el-tag>
                <el-tag v-else type="info">已满</el-tag>
              </template>
            </el-table-column>
          </el-table>
        </el-card>
      </el-col>

      <el-col :span="12">
        <el-card shadow="never">
          <template #header>
            <span>今日预约列表</span>
          </template>
          <el-table v-loading="loading" :data="todayAppointmentList" size="small">
            <el-table-column label="预约单号" align="center" prop="appointmentNo" width="170" :show-overflow-tooltip="true" />
            <el-table-column label="时间段" align="center" prop="timeSlot" width="120" />
            <el-table-column label="就诊人ID" align="center" prop="visitorId" width="100" />
            <el-table-column label="支付" align="center" prop="payStatus" width="80">
              <template #default="scope">
                <el-tag v-if="scope.row.payStatus === 0" type="info">未付</el-tag>
                <el-tag v-else-if="scope.row.payStatus === 1" type="success">已付</el-tag>
                <el-tag v-else type="warning">退款</el-tag>
              </template>
            </el-table-column>
            <el-table-column label="状态" align="center" prop="status" width="90">
              <template #default="scope">
                <span>{{ statusLabel(scope.row.status) }}</span>
              </template>
            </el-table-column>
            <el-table-column label="创建时间" align="center" prop="createTime" width="170">
              <template #default="scope">
                <span>{{ parseTime(scope.row.createTime) }}</span>
              </template>
            </el-table-column>
          </el-table>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script setup name="DoctorWorkbench">
import useUserStore from '@/store/modules/user'
import { listMedicalDoctors } from '@/api/medical/doctor'
import { listMedicalAppointments } from '@/api/medical/appointment'
import { listMedicalSchedules } from '@/api/medical/schedule'

const userStore = useUserStore()
const loading = ref(false)
const scheduleLoading = ref(false)
const doctorOptions = ref([])
const selectedDoctorId = ref(undefined)
const queryDate = ref(getTodayString())
const lastRefreshTime = ref('')

const stats = ref({
  total: 0,
  waiting: 0,
  consulting: 0,
  finished: 0
})

const scheduleStats = ref({
  totalSlots: 0,
  bookedSlots: 0,
  remainingSlots: 0
})

const todayAppointmentList = ref([])
const todayScheduleList = ref([])

function statusLabel(value) {
  const map = { 0: '待支付', 1: '待就诊', 2: '就诊中', 3: '已完成', 4: '已取消', 5: '失约' }
  return map[value] || '-'
}

function periodLabel(value) {
  const map = { 1: '上午', 2: '下午', 3: '晚间' }
  return map[value] || '-'
}

/**
 * 获取本地“今天”日期字符串（YYYY-MM-DD）。
 * 用于与后端 medical 模块的日期查询字段对齐。
 * @returns {string}
 */
function getTodayString() {
  const d = new Date()
  const yyyy = d.getFullYear()
  const mm = String(d.getMonth() + 1).padStart(2, '0')
  const dd = String(d.getDate()).padStart(2, '0')
  return `${yyyy}-${mm}-${dd}`
}

function setRefreshTime() {
  const d = new Date()
  const hh = String(d.getHours()).padStart(2, '0')
  const mm = String(d.getMinutes()).padStart(2, '0')
  const ss = String(d.getSeconds()).padStart(2, '0')
  lastRefreshTime.value = `${hh}:${mm}:${ss}`
}

function handleQuery() {
  refreshAll()
}

function getDoctorOptions() {
  return listMedicalDoctors({ pageNum: 1, pageSize: 9999, status: 0 }).then(res => {
    doctorOptions.value = res.rows || []
    if (!selectedDoctorId.value) {
      const match = doctorOptions.value.find(d => String(d.doctorId) === String(userStore.id))
      selectedDoctorId.value = match ? match.doctorId : (doctorOptions.value[0]?.doctorId ?? undefined)
    }
  })
}

function refreshAppointments() {
  const doctorId = selectedDoctorId.value
  if (!doctorId || !queryDate.value) {
    todayAppointmentList.value = []
    stats.value = { total: 0, waiting: 0, consulting: 0, finished: 0 }
    return Promise.resolve()
  }

  loading.value = true
  return listMedicalAppointments({
    pageNum: 1,
    pageSize: 9999,
    doctorId,
    appointmentDate: queryDate.value
  }).then(res => {
    const rows = res.rows || []
    todayAppointmentList.value = rows
    stats.value = {
      total: rows.length,
      waiting: rows.filter(r => r.status === 1).length,
      consulting: rows.filter(r => r.status === 2).length,
      finished: rows.filter(r => r.status === 3).length
    }
    loading.value = false
  }).catch(() => {
    loading.value = false
  })
}

function refreshSchedules() {
  const doctorId = selectedDoctorId.value
  if (!doctorId || !queryDate.value) {
    todayScheduleList.value = []
    scheduleStats.value = { totalSlots: 0, bookedSlots: 0, remainingSlots: 0 }
    return Promise.resolve()
  }

  scheduleLoading.value = true
  return listMedicalSchedules({
    pageNum: 1,
    pageSize: 9999,
    doctorId,
    workDate: queryDate.value
  }).then(res => {
    const rows = res.rows || []
    todayScheduleList.value = rows
    const totalSlots = rows.reduce((acc, cur) => acc + (Number(cur.totalSlots) || 0), 0)
    const bookedSlots = rows.reduce((acc, cur) => acc + (Number(cur.bookedSlots) || 0), 0)
    scheduleStats.value = {
      totalSlots,
      bookedSlots,
      remainingSlots: Math.max(0, totalSlots - bookedSlots)
    }
    scheduleLoading.value = false
  }).catch(() => {
    scheduleLoading.value = false
  })
}

function refreshAll() {
  return Promise.resolve()
    .then(() => refreshAppointments())
    .then(() => refreshSchedules())
    .then(() => setRefreshTime())
}

getDoctorOptions().then(() => refreshAll())
</script>

<style scoped>
.stat-value {
  font-size: 28px;
  font-weight: 600;
  line-height: 32px;
}
.stat-desc {
  margin-top: 6px;
  font-size: 12px;
  color: var(--el-text-color-secondary);
}
.stat-warn {
  color: var(--el-color-warning);
}
.stat-primary {
  color: var(--el-color-primary);
}
.stat-success {
  color: var(--el-color-success);
}
.stat-mini {
  padding: 6px 0;
}
.stat-mini-label {
  font-size: 12px;
  color: var(--el-text-color-secondary);
}
.stat-mini-value {
  margin-top: 4px;
  font-size: 20px;
  font-weight: 600;
}
</style>
