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
      <el-form-item label="队列">
        <el-radio-group v-model="activeQueue" @change="handleQuery">
          <el-radio-button v-for="opt in queueOptions" :key="opt.value" :label="opt.value">
            {{ opt.label }}
          </el-radio-button>
        </el-radio-group>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Refresh" :loading="loading" @click="getList">刷新</el-button>
      </el-form-item>
      <el-form-item>
        <el-tag :type="connectionTagType" effect="plain">{{ connectionLabel }}</el-tag>
      </el-form-item>
      <el-form-item>
        <el-button v-if="!isRealtimeEnabled" type="success" plain icon="VideoPlay" @click="startRealtime">开启实时</el-button>
        <el-button v-else type="warning" plain icon="VideoPause" @click="stopRealtime">停止实时</el-button>
      </el-form-item>
    </el-form>

    <el-table v-loading="loading" :data="appointmentList" highlight-current-row @current-change="handleCurrentChange">
      <el-table-column label="预约单号" align="center" prop="appointmentNo" width="170" :show-overflow-tooltip="true" />
      <el-table-column label="时间段" align="center" prop="timeSlot" width="120" />
      <el-table-column label="患者ID" align="center" prop="patientId" width="90" />
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
      <el-table-column label="创建时间" align="center" prop="createTime" width="180">
        <template #default="scope">
          <span>{{ parseTime(scope.row.createTime) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" width="240" fixed="right">
        <template #default="scope">
          <el-button link type="primary" @click="handleCall(scope.row)">叫号</el-button>
          <el-button v-if="scope.row.status === 1" link type="success" @click="handleCheckin(scope.row)">签到</el-button>
          <el-button link type="primary" @click="goConsult(scope.row)">接诊</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination
      v-show="total > 0"
      :total="total"
      v-model:page="queryParams.pageNum"
      v-model:limit="queryParams.pageSize"
      @pagination="getList"
    />

    <el-drawer v-model="detailOpen" title="当前选择" size="420px" append-to-body>
      <el-descriptions v-if="currentRow" :column="1" border>
        <el-descriptions-item label="预约单号">{{ currentRow.appointmentNo }}</el-descriptions-item>
        <el-descriptions-item label="患者ID">{{ currentRow.patientId }}</el-descriptions-item>
        <el-descriptions-item label="就诊人ID">{{ currentRow.visitorId }}</el-descriptions-item>
        <el-descriptions-item label="就诊日期">{{ currentRow.appointmentDate }}</el-descriptions-item>
        <el-descriptions-item label="时间段">{{ currentRow.timeSlot }}</el-descriptions-item>
        <el-descriptions-item label="状态">{{ statusLabel(currentRow.status) }}</el-descriptions-item>
      </el-descriptions>
      <el-empty v-else description="请在表格中选择一条记录" />
      <template #footer>
        <div class="drawer-footer">
          <el-button type="primary" :disabled="!currentRow" @click="goConsult(currentRow)">进入接诊</el-button>
          <el-button @click="detailOpen = false">关闭</el-button>
        </div>
      </template>
    </el-drawer>
  </div>
</template>

<script setup name="DoctorQueue">
import useUserStore from '@/store/modules/user'
import { getToken } from '@/utils/auth'
import { listMedicalDoctors } from '@/api/medical/doctor'
import { listMedicalAppointments, checkinMedicalAppointment } from '@/api/medical/appointment'

const userStore = useUserStore()
const router = useRouter()
const { proxy } = getCurrentInstance()

const showSearch = ref(true)
const loading = ref(false)
const total = ref(0)
const appointmentList = ref([])
const doctorOptions = ref([])
const selectedDoctorId = ref(undefined)
const queryDate = ref(getTodayString())
const activeQueue = ref('waiting')

const queryParams = ref({
  pageNum: 1,
  pageSize: 10
})

const currentRow = ref(undefined)
const detailOpen = ref(false)

const wsUrl = (import.meta.env.VITE_APP_MEDICAL_QUEUE_WS_URL || '').trim()
const realtimeMode = ref('off') // off | polling | ws
const connectionState = ref('offline') // offline | connecting | connected | error | polling
let pollingTimer = undefined
let ws = undefined

const queueOptions = [
  { label: '待就诊', value: 'waiting' },
  { label: '就诊中', value: 'consulting' },
  { label: '已完成', value: 'finished' }
]

const isRealtimeEnabled = computed(() => realtimeMode.value !== 'off')

const connectionLabel = computed(() => {
  if (realtimeMode.value === 'polling') return '实时：轮询'
  if (realtimeMode.value === 'ws' && connectionState.value === 'connected') return '实时：WebSocket 已连接'
  if (realtimeMode.value === 'ws' && connectionState.value === 'connecting') return '实时：WebSocket 连接中'
  if (realtimeMode.value === 'ws' && connectionState.value === 'error') return '实时：WebSocket 异常'
  return '实时：关闭'
})

const connectionTagType = computed(() => {
  if (realtimeMode.value === 'polling') return 'warning'
  if (realtimeMode.value === 'ws' && connectionState.value === 'connected') return 'success'
  if (realtimeMode.value === 'ws' && connectionState.value === 'connecting') return 'info'
  if (realtimeMode.value === 'ws' && connectionState.value === 'error') return 'danger'
  return 'info'
})

function statusLabel(value) {
  const map = { 0: '待支付', 1: '待就诊', 2: '就诊中', 3: '已完成', 4: '已取消', 5: '失约' }
  return map[value] || '-'
}

function getTodayString() {
  const d = new Date()
  const yyyy = d.getFullYear()
  const mm = String(d.getMonth() + 1).padStart(2, '0')
  const dd = String(d.getDate()).padStart(2, '0')
  return `${yyyy}-${mm}-${dd}`
}

function queueStatusFilter() {
  const map = {
    waiting: 1,
    consulting: 2,
    finished: 3
  }
  return map[activeQueue.value]
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

function handleQuery() {
  queryParams.value.pageNum = 1
  getList()
}

function getList() {
  const doctorId = selectedDoctorId.value
  if (!doctorId || !queryDate.value) {
    appointmentList.value = []
    total.value = 0
    return
  }

  loading.value = true
  listMedicalAppointments({
    ...queryParams.value,
    doctorId,
    appointmentDate: queryDate.value,
    status: queueStatusFilter()
  }).then(res => {
    appointmentList.value = res.rows || []
    total.value = res.total || 0
    loading.value = false
  }).catch(() => {
    loading.value = false
  })
}

function handleCurrentChange(row) {
  currentRow.value = row
  if (row) detailOpen.value = true
}

function handleCall(row) {
  if (!row) return
  proxy.$modal.msgSuccess(`已叫号：${row.appointmentNo}`)
}

function handleCheckin(row) {
  const appointmentId = row?.appointmentId
  if (!appointmentId) return
  proxy.$modal.confirm(`是否确认签到预约ID为"${appointmentId}"的数据项？`).then(() => {
    return checkinMedicalAppointment(appointmentId)
  }).then(() => {
    proxy.$modal.msgSuccess('签到成功')
    getList()
  }).catch(() => {})
}

function goConsult(row) {
  const appointmentId = row?.appointmentId
  if (!appointmentId) return
  router.push({ path: '/medical-doctor/consult', query: { appointmentId } })
}

/**
 * 实时刷新策略：
 * - 若配置了 VITE_APP_MEDICAL_QUEUE_WS_URL，则优先尝试 WebSocket。
 * - 未配置或连接失败时，自动降级为轮询（每 5 秒拉取一次现有 medical 接口）。
 */
function startRealtime() {
  stopRealtime()
  if (wsUrl) {
    startWebSocket()
    return
  }
  startPolling()
}

function stopRealtime() {
  stopPolling()
  stopWebSocket()
  realtimeMode.value = 'off'
  connectionState.value = 'offline'
}

function startPolling() {
  realtimeMode.value = 'polling'
  connectionState.value = 'polling'
  getList()
  pollingTimer = window.setInterval(() => getList(), 5000)
}

function stopPolling() {
  if (!pollingTimer) return
  window.clearInterval(pollingTimer)
  pollingTimer = undefined
}

function startWebSocket() {
  realtimeMode.value = 'ws'
  connectionState.value = 'connecting'

  const token = encodeURIComponent(getToken() || '')
  const url = wsUrl.includes('?') ? `${wsUrl}&token=${token}` : `${wsUrl}?token=${token}`

  try {
    ws = new WebSocket(url)
  } catch (e) {
    connectionState.value = 'error'
    startPolling()
    return
  }

  ws.onopen = () => {
    connectionState.value = 'connected'
    getList()
  }
  ws.onerror = () => {
    connectionState.value = 'error'
    stopWebSocket()
    startPolling()
  }
  ws.onclose = () => {
    if (realtimeMode.value !== 'ws') return
    connectionState.value = 'error'
    stopWebSocket()
    startPolling()
  }
  ws.onmessage = (evt) => {
    const raw = String(evt?.data ?? '')
    if (!raw) return
    try {
      const payload = JSON.parse(raw)
      if (Array.isArray(payload?.appointments)) {
        appointmentList.value = payload.appointments
        total.value = payload.total ?? payload.appointments.length
        return
      }
      if (payload?.action === 'refresh') {
        getList()
      }
    } catch (e) {
      getList()
    }
  }
}

function stopWebSocket() {
  if (!ws) return
  try {
    ws.close()
  } catch (e) {}
  ws = undefined
}

onBeforeUnmount(() => stopRealtime())

getDoctorOptions().then(() => getList())
</script>

<style scoped>
.drawer-footer {
  display: flex;
  justify-content: flex-end;
  gap: 8px;
}
</style>
