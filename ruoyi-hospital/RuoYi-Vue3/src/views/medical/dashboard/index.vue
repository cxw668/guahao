<template>
  <div class="app-container">
    <el-row :gutter="12" class="mb8">
      <el-col :xs="24" :sm="12" :md="6">
        <el-card shadow="hover">
          <div class="metric">
            <div class="metric-title">科室总数</div>
            <div class="metric-value">{{ metrics.departments }}</div>
          </div>
        </el-card>
      </el-col>
      <el-col :xs="24" :sm="12" :md="6">
        <el-card shadow="hover">
          <div class="metric">
            <div class="metric-title">医生总数</div>
            <div class="metric-value">{{ metrics.doctors }}</div>
          </div>
        </el-card>
      </el-col>
      <el-col :xs="24" :sm="12" :md="6">
        <el-card shadow="hover">
          <div class="metric">
            <div class="metric-title">今日排班</div>
            <div class="metric-value">{{ metrics.todaySchedules }}</div>
          </div>
        </el-card>
      </el-col>
      <el-col :xs="24" :sm="12" :md="6">
        <el-card shadow="hover">
          <div class="metric">
            <div class="metric-title">预约总数</div>
            <div class="metric-value">{{ metrics.appointments }}</div>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <el-row :gutter="12">
      <el-col :xs="24" :sm="24" :md="12">
        <el-card>
          <template #header>
            <span>科室规模 / 忙碌度</span>
          </template>
          <div ref="deptTreemapRef" style="height: 360px;" />
        </el-card>
      </el-col>
      <el-col :xs="24" :sm="24" :md="12">
        <el-card>
          <template #header>
            <div class="card-header">
              <span>医生能力五维</span>
              <el-select v-model="selectedDoctorId" placeholder="选择医生" clearable style="width: 220px;"
                @change="renderDoctorRadar">
                <el-option v-for="d in doctorOptions" :key="d.doctorId" :label="d.doctorName" :value="d.doctorId" />
              </el-select>
            </div>
          </template>
          <div ref="doctorRadarRef" style="height: 360px;" />
        </el-card>
      </el-col>
    </el-row>

    <el-row :gutter="12" style="margin-top: 12px;">
      <el-col :span="24">
        <el-card>
          <template #header>
            <div class="card-header">
              <span>号源分布</span>
              <el-date-picker v-model="heatmapDateRange" type="daterange" value-format="YYYY-MM-DD" range-separator="-"
                start-placeholder="开始日期" end-placeholder="结束日期" style="width: 320px;"
                @change="reloadSchedulesAndCharts" />
            </div>
          </template>
          <div ref="scheduleHeatmapRef" style="height: 420px;" />
        </el-card>
      </el-col>
    </el-row>

    <el-row :gutter="12" style="margin-top: 12px;">
      <el-col :xs="24" :sm="24" :md="12">
        <el-card>
          <template #header>
            <span>预约状态概览</span>
          </template>
          <div ref="statusChartRef" style="height: 320px;" />
        </el-card>
      </el-col>
      <el-col :xs="24" :sm="24" :md="12">
        <el-card>
          <template #header>
            <div class="card-header">
              <span>📊 数据解读与运营建议</span>
            </div>
          </template>

          <el-alert title="图表核心指标说明" type="info" :closable="false" show-icon class="mb-4">
            <template #default>
              <div class="alert-content">
                <p><strong>1. 科室规模 (矩形树图)：</strong> 方块面积代表 <em>医生总数/挂号量占比</em>。面积越大且颜色越红，表示该科室越繁忙或资源越集中，需关注是否需增加人手。</p>

                <p><strong>2. 医生能力 (雷达图)：</strong> 五维模型包含 <em>接诊量、好评率、职称、擅长匹配度、出勤率</em>。图形越饱满代表综合能力强；若某角凹陷，建议针对性培训或调整排班。
                </p>

                <p><strong>3. 号源热度 (热力图)：</strong> 横轴为日期，纵轴为时段。颜色越深（红/紫）代表 <em>剩余号源越少/预约越火爆</em>。建议针对红色区域提前开放号源或增加医生排班。
                </p>

                <p class="tip">💡 <strong>运营提示：</strong> 结合三者数据，若某科室“树图面积大”但“热力图偏绿（号源充足）”，可能存在宣传不足或排班不合理问题。</p>
              </div>
            </template>
          </el-alert>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script setup name="MedicalDashboard">
import * as echarts from 'echarts'
import { listMedicalDepartments } from '@/api/medical/department'
import { listMedicalDoctors } from '@/api/medical/doctor'
import { listMedicalSchedules } from '@/api/medical/schedule'
import { listMedicalAppointments } from '@/api/medical/appointment'

const { proxy } = getCurrentInstance()

const metrics = reactive({
  departments: 0,
  doctors: 0,
  todaySchedules: 0,
  appointments: 0
})

const doctorOptions = ref([])
const selectedDoctorId = ref(undefined)

const heatmapDateRange = ref([])

const statusChartRef = ref(null)
const deptTreemapRef = ref(null)
const doctorRadarRef = ref(null)
const scheduleHeatmapRef = ref(null)

let statusChartInstance
let deptTreemapInstance
let doctorRadarInstance
let scheduleHeatmapInstance

const departments = ref([])
const doctors = ref([])
const appointments = ref([])
const schedulesByDay = ref([])
const doctorMetricsMap = ref(new Map())

function todayString() {
  const now = new Date()
  const y = now.getFullYear()
  const m = String(now.getMonth() + 1).padStart(2, '0')
  const d = String(now.getDate()).padStart(2, '0')
  return `${y}-${m}-${d}`
}

function addDays(dateString, deltaDays) {
  const [y, m, d] = dateString.split('-').map(Number)
  const dt = new Date(y, m - 1, d)
  dt.setDate(dt.getDate() + deltaDays)
  const yy = dt.getFullYear()
  const mm = String(dt.getMonth() + 1).padStart(2, '0')
  const dd = String(dt.getDate()).padStart(2, '0')
  return `${yy}-${mm}-${dd}`
}

function daysBetween(start, end) {
  const [sy, sm, sd] = start.split('-').map(Number)
  const [ey, em, ed] = end.split('-').map(Number)
  const s = new Date(sy, sm - 1, sd)
  const e = new Date(ey, em - 1, ed)
  const days = []
  const cur = new Date(s)
  while (cur <= e) {
    const yy = cur.getFullYear()
    const mm = String(cur.getMonth() + 1).padStart(2, '0')
    const dd = String(cur.getDate()).padStart(2, '0')
    days.push(`${yy}-${mm}-${dd}`)
    cur.setDate(cur.getDate() + 1)
  }
  return days
}

function statusLabel(value) {
  const map = { 0: '待支付', 1: '待就诊', 2: '就诊中', 3: '已完成', 4: '已取消', 5: '失约' }
  return map[value] || String(value)
}

function periodLabel(value) {
  const map = { 1: '上午', 2: '下午', 3: '晚间' }
  return map[value] || String(value)
}

function buildStatusChart(rows) {
  const counter = new Map()
  rows.forEach(r => {
    const key = r.status ?? 'unknown'
    counter.set(key, (counter.get(key) || 0) + 1)
  })

  const keys = Array.from(counter.keys()).sort((a, b) => Number(a) - Number(b))
  const xAxisData = keys.map(k => statusLabel(k))
  const seriesData = keys.map(k => counter.get(k))

  if (!statusChartInstance) {
    statusChartInstance = echarts.init(statusChartRef.value, 'macarons')
  }
  statusChartInstance.setOption({
    tooltip: { trigger: 'axis' },
    grid: { left: 40, right: 20, top: 20, bottom: 40 },
    xAxis: { type: 'category', data: xAxisData, axisLabel: { interval: 0, rotate: 20 } },
    yAxis: { type: 'value' },
    series: [{ type: 'bar', data: seriesData, barMaxWidth: 44 }]
  })
}

function buildDeptTreemap() {
  const doctorCountByDept = new Map()
  doctors.value.forEach(d => {
    const deptId = d.deptId
    if (deptId == null) return
    doctorCountByDept.set(deptId, (doctorCountByDept.get(deptId) || 0) + 1)
  })

  const doctorById = new Map(doctors.value.map(d => [d.doctorId, d]))
  const apptCountByDept = new Map()
  appointments.value.forEach(a => {
    const doctor = doctorById.get(a.doctorId)
    if (!doctor || doctor.deptId == null) return
    apptCountByDept.set(doctor.deptId, (apptCountByDept.get(doctor.deptId) || 0) + 1)
  })

  const scheduleCountByDept = new Map()
  schedulesByDay.value.forEach(({ rows }) => {
    rows.forEach(s => {
      const doctor = doctorById.get(s.doctorId)
      if (!doctor || doctor.deptId == null) return
      scheduleCountByDept.set(doctor.deptId, (scheduleCountByDept.get(doctor.deptId) || 0) + 1)
    })
  })

  const nodesById = new Map()
  departments.value.forEach(dep => {
    const deptId = dep.deptId
    const doctorCount = doctorCountByDept.get(deptId) || 0
    const apptCount = apptCountByDept.get(deptId) || 0
    const scheduleCount = scheduleCountByDept.get(deptId) || 0
    const score = apptCount * 1.0 + scheduleCount * 0.6 + doctorCount * 0.4
    nodesById.set(deptId, {
      name: dep.deptName || String(deptId),
      value: Math.max(1, Number(score.toFixed(2))),
      deptId,
      doctorCount,
      apptCount,
      scheduleCount,
      children: []
    })
  })

  const roots = []
  nodesById.forEach(node => {
    const dep = departments.value.find(d => d.deptId === node.deptId)
    const parentId = dep ? dep.parentId : undefined
    if (parentId && nodesById.has(parentId)) {
      nodesById.get(parentId).children.push(node)
    } else {
      roots.push(node)
    }
  })

  if (!deptTreemapInstance) {
    deptTreemapInstance = echarts.init(deptTreemapRef.value, 'macarons')
  }

  deptTreemapInstance.setOption({
    tooltip: {
      formatter: (info) => {
        const v = info.data || {}
        const name = info.name || ''
        const doctorCount = v.doctorCount ?? 0
        const scheduleCount = v.scheduleCount ?? 0
        const apptCount = v.apptCount ?? 0
        return `${name}<br/>医生数：${doctorCount}<br/>排班数：${scheduleCount}<br/>预约数：${apptCount}`
      }
    },
    series: [
      {
        type: 'treemap',
        roam: false,
        nodeClick: false,
        breadcrumb: { show: false },
        label: { show: true, formatter: '{b}' },
        upperLabel: { show: true, height: 24 },
        itemStyle: { borderColor: '#fff' },
        levels: [
          { itemStyle: { borderWidth: 0, gapWidth: 2 } },
          { itemStyle: { gapWidth: 2 } },
          { itemStyle: { gapWidth: 1 } }
        ],
        data: roots
      }
    ]
  })
}

function buildDoctorMetrics() {
  const scheduleCountByDoctor = new Map()
  schedulesByDay.value.forEach(({ rows }) => {
    rows.forEach(s => {
      const id = s.doctorId
      if (id == null) return
      scheduleCountByDoctor.set(id, (scheduleCountByDoctor.get(id) || 0) + 1)
    })
  })

  const apptCountByDoctor = new Map()
  const completedCountByDoctor = new Map()
  appointments.value.forEach(a => {
    const id = a.doctorId
    if (id == null) return
    apptCountByDoctor.set(id, (apptCountByDoctor.get(id) || 0) + 1)
    if (a.status === 3) {
      completedCountByDoctor.set(id, (completedCountByDoctor.get(id) || 0) + 1)
    }
  })

  const maxPatientsVals = []
  const feeVals = []
  const apptVals = []
  const scheduleVals = []
  const completionVals = []

  const list = doctors.value.map(d => {
    const maxPatients = Number(d.maxPatients || 0)
    const fee = Number(d.fee || 0)
    const apptCount = apptCountByDoctor.get(d.doctorId) || 0
    const scheduleCount = scheduleCountByDoctor.get(d.doctorId) || 0
    const completed = completedCountByDoctor.get(d.doctorId) || 0
    const completionRate = apptCount > 0 ? completed / apptCount : 0
    maxPatientsVals.push(maxPatients)
    feeVals.push(fee)
    apptVals.push(apptCount)
    scheduleVals.push(scheduleCount)
    completionVals.push(completionRate)
    return {
      doctorId: d.doctorId,
      doctorName: d.doctorName,
      maxPatients,
      fee,
      apptCount,
      scheduleCount,
      completionRate
    }
  })

  const minMax = (arr) => {
    const nums = arr.map(Number).filter(n => Number.isFinite(n))
    if (!nums.length) return { min: 0, max: 1 }
    return { min: Math.min(...nums), max: Math.max(...nums) }
  }

  const normalize = (v, mm) => {
    if (!Number.isFinite(v)) return 0
    const span = mm.max - mm.min
    if (span <= 0) return 50
    return Math.round(((v - mm.min) / span) * 100)
  }

  const mmPatients = minMax(maxPatientsVals)
  const mmFee = minMax(feeVals)
  const mmAppt = minMax(apptVals)
  const mmSchedule = minMax(scheduleVals)
  const mmCompletion = minMax(completionVals)

  const map = new Map()
  list.forEach(m => {
    map.set(m.doctorId, {
      ...m,
      dims: [
        normalize(m.maxPatients, mmPatients),
        normalize(m.apptCount, mmAppt),
        normalize(m.scheduleCount, mmSchedule),
        normalize(m.fee, mmFee),
        normalize(m.completionRate, mmCompletion)
      ]
    })
  })
  doctorMetricsMap.value = map

  const sorted = [...list].sort((a, b) => (b.apptCount || 0) - (a.apptCount || 0))
  selectedDoctorId.value = sorted.length ? sorted[0].doctorId : undefined
  doctorOptions.value = doctors.value
    .filter(d => d.doctorId != null)
    .map(d => ({ doctorId: d.doctorId, doctorName: d.doctorName }))
}

function renderDoctorRadar() {
  if (!doctorRadarInstance) {
    doctorRadarInstance = echarts.init(doctorRadarRef.value, 'macarons')
  }

  const metric = selectedDoctorId.value != null ? doctorMetricsMap.value.get(selectedDoctorId.value) : undefined
  const name = metric ? metric.doctorName : '未选择'
  const value = metric ? metric.dims : [0, 0, 0, 0, 0]

  doctorRadarInstance.setOption({
    tooltip: { trigger: 'item' },
    radar: {
      indicator: [
        { name: '接诊能力', max: 100 },
        { name: '人气', max: 100 },
        { name: '出诊频次', max: 100 },
        { name: '费用水平', max: 100 },
        { name: '完成率', max: 100 }
      ],
      splitNumber: 5,
      shape: 'polygon'
    },
    series: [
      {
        type: 'radar',
        data: [
          {
            name,
            value,
            areaStyle: { opacity: 0.15 }
          }
        ]
      }
    ]
  })
}

function buildScheduleHeatmap() {
  if (!Array.isArray(heatmapDateRange.value) || heatmapDateRange.value.length !== 2) {
    return
  }
  const [start, end] = heatmapDateRange.value
  const days = daysBetween(start, end)
  const xAxisData = days.map(d => d.slice(5))
  const yAxisData = ['上午', '下午', '晚间']
  const periodValues = [1, 2, 3]

  const agg = new Map()
  schedulesByDay.value.forEach(({ day, rows }) => {
    rows.forEach(s => {
      if (s.period == null) return
      const remain = Math.max(0, Number(s.totalSlots || 0) - Number(s.bookedSlots || 0))
      const key = `${day}|${s.period}`
      agg.set(key, (agg.get(key) || 0) + remain)
    })
  })

  const data = []
  let maxValue = 0
  days.forEach((day, xi) => {
    periodValues.forEach((p, yi) => {
      const key = `${day}|${p}`
      const v = agg.get(key) || 0
      maxValue = Math.max(maxValue, v)
      data.push([xi, yi, v])
    })
  })

  if (!scheduleHeatmapInstance) {
    scheduleHeatmapInstance = echarts.init(scheduleHeatmapRef.value, 'macarons')
  }

  scheduleHeatmapInstance.setOption({
    tooltip: {
      position: 'top',
      formatter: (params) => {
        const xi = params.value[0]
        const yi = params.value[1]
        const v = params.value[2]
        const day = days[xi]
        const period = yAxisData[yi]
        return `${day} ${period}<br/>余号：${v}`
      }
    },
    grid: { left: 60, right: 20, top: 20, bottom: 50 },
    xAxis: { type: 'category', data: xAxisData, splitArea: { show: true } },
    yAxis: { type: 'category', data: yAxisData, splitArea: { show: true } },
    visualMap: {
      min: 0,
      max: Math.max(1, maxValue),
      calculable: true,
      orient: 'horizontal',
      left: 'center',
      bottom: 10,
      inRange: { color: ['#d73027', '#fee08b', '#1a9850'] }
    },
    series: [
      {
        name: '余号',
        type: 'heatmap',
        data,
        label: { show: false },
        emphasis: { itemStyle: { borderColor: '#333', borderWidth: 1 } }
      }
    ]
  })
}

async function reloadSchedulesAndCharts() {
  if (!Array.isArray(heatmapDateRange.value) || heatmapDateRange.value.length !== 2) {
    return
  }
  const [start, end] = heatmapDateRange.value
  const days = daysBetween(start, end)
  const tasks = days.map(day => listMedicalSchedules({ pageNum: 1, pageSize: 9999, workDate: day }).then(res => ({ day, rows: res.rows || [] })))
  try {
    schedulesByDay.value = await Promise.all(tasks)
    const today = todayString()
    const todayItem = schedulesByDay.value.find(d => d.day === today)
    metrics.todaySchedules = todayItem ? todayItem.rows.length : 0
    buildDeptTreemap()
    buildDoctorMetrics()
    renderDoctorRadar()
    buildScheduleHeatmap()
  } catch {
    proxy.$modal.msgError('加载排班数据失败')
  }
}

function handleResize() {
  statusChartInstance && statusChartInstance.resize()
  deptTreemapInstance && deptTreemapInstance.resize()
  doctorRadarInstance && doctorRadarInstance.resize()
  scheduleHeatmapInstance && scheduleHeatmapInstance.resize()
}

async function initDashboard() {
  try {
    const today = todayString()
    heatmapDateRange.value = [addDays(today, -6), addDays(today, 6)]

    const [deptRes, doctorRes, apptRes] = await Promise.all([
      listMedicalDepartments({ pageNum: 1, pageSize: 9999 }),
      listMedicalDoctors({ pageNum: 1, pageSize: 9999 }),
      listMedicalAppointments({ pageNum: 1, pageSize: 2000 })
    ])

    departments.value = deptRes.rows || []
    doctors.value = doctorRes.rows || []
    appointments.value = apptRes.rows || []

    metrics.departments = deptRes.total || departments.value.length
    metrics.doctors = doctorRes.total || doctors.value.length
    metrics.appointments = apptRes.total || 0

    buildStatusChart(appointments.value)
    await reloadSchedulesAndCharts()
  } catch {
    proxy.$modal.msgError('加载大屏数据失败')
  }
}

onMounted(() => {
  initDashboard()
  window.addEventListener('resize', handleResize)
})

onBeforeUnmount(() => {
  statusChartInstance && statusChartInstance.dispose()
  statusChartInstance = undefined
  deptTreemapInstance && deptTreemapInstance.dispose()
  deptTreemapInstance = undefined
  doctorRadarInstance && doctorRadarInstance.dispose()
  doctorRadarInstance = undefined
  scheduleHeatmapInstance && scheduleHeatmapInstance.dispose()
  scheduleHeatmapInstance = undefined
  window.removeEventListener('resize', handleResize)
})
</script>

<style scoped>
.card-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
}

.metric {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.metric-title {
  color: var(--el-text-color-secondary);
  font-size: 14px;
}

.metric-value {
  font-size: 28px;
  font-weight: 600;
}

.alert-content p {
  margin-bottom: 12px;
  line-height: 1.6;
  font-size: 13px;
  color: #606266;
}
.alert-content p:last-child {
  margin-bottom: 0;
}
.alert-content strong {
  color: #409EFF;
  font-weight: 600;
}
.alert-content em {
  font-style: normal;
  background-color: #f4f4f5;
  padding: 2px 4px;
  border-radius: 4px;
  color: #333;
}
.tip {
  margin-top: 15px !important;
  padding: 10px;
  background-color: #ecf5ff;
  border-left: 4px solid #409EFF;
  border-radius: 4px;
  color: #409EFF !important;
}
.card-header {
  font-weight: bold;
  color: #303133;
}
</style>
