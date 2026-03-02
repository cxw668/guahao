<template>
  <div class="patient-page">
    <el-card class="mb16">
      <template #header>
        <div class="header">
          <div class="header__left">
            <el-button text @click="router.back()">返回</el-button>
            <span class="header__title">医生列表</span>
          </div>
        </div>
      </template>

      <el-form :model="queryParams" inline>
        <el-form-item label="科室">
          <el-select v-model="queryParams.deptId" placeholder="全部科室" clearable style="width: 220px;">
            <el-option v-for="d in deptOptions" :key="d.deptId" :label="d.deptName" :value="d.deptId" />
          </el-select>
        </el-form-item>
        <el-form-item label="医生">
          <el-input
            v-model="queryParams.doctorName"
            placeholder="请输入医生姓名"
            clearable
            style="width: 240px;"
            @keyup.enter="handleQuery"
          />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
          <el-button icon="Refresh" @click="resetQuery">重置</el-button>
        </el-form-item>
      </el-form>
    </el-card>

    <el-card>
      <el-table v-loading="loading" :data="doctorList" row-key="doctorId">
        <el-table-column label="医生" min-width="220">
          <template #default="{ row }">
            <div class="doctor-cell">
              <el-avatar :size="40" :src="resolveUrl(row.avatar)">
                {{ (row.doctorName || '').slice(0, 1) }}
              </el-avatar>
              <div class="doctor-cell__info">
                <div class="doctor-cell__name">
                  <span>{{ row.doctorName }}</span>
                  <el-tag v-if="row.title" class="ml8" size="small" type="info">{{ row.title }}</el-tag>
                </div>
                <div class="doctor-cell__meta">
                  <span v-if="row.deptId">{{ deptNameById(row.deptId) }}</span>
                  <span v-if="row.specialty"> · {{ row.specialty }}</span>
                </div>
              </div>
            </div>
          </template>
        </el-table-column>
        <el-table-column label="挂号费" prop="fee" width="110" />
        <el-table-column label="操作" width="200" fixed="right">
          <template #default="{ row }">
            <el-button link type="primary" @click="goDetail(row)">详情</el-button>
            <el-button link type="success" @click="goSchedule(row)">选排班</el-button>
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
    </el-card>
  </div>
</template>

<script setup name="MedicalPatientDoctorList">
import { listMedicalDepartments } from '@/api/medical/department'
import { listMedicalDoctors } from '@/api/medical/doctor'
import { isHttp } from '@/utils/validate'

/**
 * 患者端-医生列表：支持按科室与姓名筛选，并可跳转详情/排班。
 */
const route = useRoute()
const router = useRouter()

const loading = ref(false)
const total = ref(0)
const doctorList = ref([])
const deptOptions = ref([])

const queryParams = ref({
  pageNum: 1,
  pageSize: 10,
  deptId: undefined,
  doctorName: undefined,
  status: 0
})

function resolveUrl(url) {
  const raw = typeof url === 'string' ? url.trim() : ''
  if (!raw) return ''
  return isHttp(raw) ? raw : import.meta.env.VITE_APP_BASE_API + raw
}

function deptNameById(deptId) {
  const found = deptOptions.value.find(d => d.deptId === deptId)
  return found ? found.deptName : deptId
}

function handleQuery() {
  queryParams.value.pageNum = 1
  getList()
}

function resetQuery() {
  queryParams.value.deptId = undefined
  queryParams.value.doctorName = undefined
  handleQuery()
}

function goDetail(row) {
  router.push(`/medical-patient/doctor/detail/${row.doctorId}`)
}

function goSchedule(row) {
  router.push({ path: '/medical-patient/schedule', query: { doctorId: String(row.doctorId || '') } })
}

async function loadDeptOptions() {
  const res = await listMedicalDepartments({ pageNum: 1, pageSize: 200, status: 0 })
  deptOptions.value = Array.isArray(res?.rows) ? res.rows : []
}

async function getList() {
  loading.value = true
  try {
    const res = await listMedicalDoctors(queryParams.value)
    doctorList.value = Array.isArray(res?.rows) ? res.rows : []
    total.value = typeof res?.total === 'number' ? res.total : 0
  } finally {
    loading.value = false
  }
}

watch(
  () => route.query,
  (q) => {
    const deptId = typeof q?.deptId === 'string' ? Number(q.deptId) : undefined
    const keyword = typeof q?.keyword === 'string' ? q.keyword.trim() : ''
    queryParams.value.deptId = Number.isFinite(deptId) ? deptId : undefined
    queryParams.value.doctorName = keyword || undefined
    queryParams.value.pageNum = 1
    getList()
  },
  { immediate: true }
)

onMounted(() => {
  loadDeptOptions()
})
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

.doctor-cell {
  display: flex;
  align-items: center;
  gap: 10px;
}

.doctor-cell__info {
  min-width: 0;
}

.doctor-cell__name {
  display: flex;
  align-items: center;
  min-width: 0;
}

.doctor-cell__meta {
  margin-top: 4px;
  font-size: 12px;
  color: #909399;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.ml8 {
  margin-left: 8px;
}
</style>
