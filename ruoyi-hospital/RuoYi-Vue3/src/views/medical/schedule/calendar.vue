<template>
  <div>
    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button type="primary" plain icon="List" @click="goList">返回列表</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="success" plain icon="Refresh" @click="refresh">刷新</el-button>
      </el-col>
    </el-row>

    <el-row :gutter="12">
      <el-col :xs="24" :sm="24" :md="14">
        <el-card>
          <template #header>
            <span>排班日历</span>
          </template>
          <el-calendar v-model="calendarDate">
            <template #date-cell="{ data }">
              <div class="calendar-cell" :class="{ 'is-selected': data.isSelected }" @click="selectDate(data.day)">
                <div class="calendar-day">{{ dayText(data.day) }}</div>
                <div v-if="data.isSelected" class="calendar-tip">已选</div>
              </div>
            </template>
          </el-calendar>
        </el-card>
      </el-col>
      <el-col :xs="24" :sm="24" :md="10">
        <el-card>
          <template #header>
            <span>当日排班</span>
          </template>

          <el-form :model="queryParams" :inline="true" label-width="0">
            <el-form-item>
              <el-select v-model="queryParams.doctorId" placeholder="筛选医生" clearable style="width: 220px;">
                <el-option v-for="d in props.doctorOptions" :key="d.doctorId" :label="d.doctorName" :value="d.doctorId" />
              </el-select>
            </el-form-item>
            <el-form-item>
              <el-button type="primary" icon="Search" @click="getList">查询</el-button>
            </el-form-item>
          </el-form>

          <el-empty v-if="!loading && scheduleList.length === 0" description="暂无排班" />

          <el-table v-else v-loading="loading" :data="scheduleList" size="small">
            <el-table-column label="医生" prop="doctorId" min-width="120">
              <template #default="scope">
                <span>{{ doctorNameById(scope.row.doctorId) }}</span>
              </template>
            </el-table-column>
            <el-table-column label="时段" prop="period" width="80">
              <template #default="scope">
                <span>{{ periodLabel(scope.row.period) }}</span>
              </template>
            </el-table-column>
            <el-table-column label="时间" min-width="120">
              <template #default="scope">
                <span>{{ scope.row.startTime }} - {{ scope.row.endTime }}</span>
              </template>
            </el-table-column>
            <el-table-column label="号源" width="90">
              <template #default="scope">
                <span>{{ scope.row.bookedSlots }}/{{ scope.row.totalSlots }}</span>
              </template>
            </el-table-column>
          </el-table>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script setup name="MedicalScheduleCalendar">
import { listMedicalSchedules } from '@/api/medical/schedule'

const props = defineProps({
  doctorOptions: {
    type: Array,
    default: () => []
  }
})

const emit = defineEmits(['back'])

const calendarDate = ref(new Date())
const selectedDay = ref('')

const loading = ref(false)
const scheduleList = ref([])

const queryParams = ref({
  doctorId: undefined
})

function dayText(day) {
  const parts = String(day).split('-')
  return parts[2]
}

function periodLabel(value) {
  const map = { 1: '上午', 2: '下午', 3: '晚间' }
  return map[value] || '-'
}

function doctorNameById(doctorId) {
  const found = props.doctorOptions.find(d => d.doctorId === doctorId)
  return found ? found.doctorName : doctorId
}

function selectDate(day) {
  selectedDay.value = day
  getList()
}

function getDoctorOptions() {
  return
}

function getList() {
  if (!selectedDay.value) {
    const y = calendarDate.value.getFullYear()
    const m = String(calendarDate.value.getMonth() + 1).padStart(2, '0')
    const d = String(calendarDate.value.getDate()).padStart(2, '0')
    selectedDay.value = `${y}-${m}-${d}`
  }
  loading.value = true
  listMedicalSchedules({
    pageNum: 1,
    pageSize: 9999,
    doctorId: queryParams.value.doctorId,
    workDate: selectedDay.value
  }).then(res => {
    scheduleList.value = res.rows || []
    loading.value = false
  }).catch(() => {
    loading.value = false
  })
}

function refresh() {
  getList()
}

function goList() {
  emit('back')
}

getList()
</script>

<style scoped>
.calendar-cell {
  height: 54px;
  padding: 4px;
  cursor: pointer;
}
.calendar-cell.is-selected {
  background: var(--el-color-primary-light-9);
  border-radius: 4px;
}
.calendar-day {
  font-size: 14px;
  line-height: 18px;
}
.calendar-tip {
  font-size: 12px;
  color: var(--el-color-primary);
}
</style>
