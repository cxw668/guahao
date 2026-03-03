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

    <div v-loading="loading" class="doctor-list">
      <el-row :gutter="12">
        <el-col v-for="doctor in doctorList" :key="doctor.doctorId" :xs="24" :sm="12" :md="8" :lg="6">
          <el-card shadow="hover" class="doctor-card mb16">
            <div class="doctor-card__header">
              <div class="doctor-info">
                <el-avatar :size="50" :src="resolveUrl(doctor.avatar)">
                  {{ (doctor.doctorName || '').slice(0, 1) }}
                </el-avatar>
                <div class="doctor-meta">
                  <div class="doctor-name">
                    <span>{{ doctor.doctorName }}</span>
                    <el-tag v-if="doctor.title" size="small" type="info" class="ml8">{{ doctor.title }}</el-tag>
                  </div>
                  <div class="doctor-dept">
                    <span v-if="doctor.deptId">{{ deptNameById(doctor.deptId) }}</span>
                    <span v-if="doctor.specialty"> · {{ doctor.specialty }}</span>
                  </div>
                </div>
              </div>
              <div class="doctor-fee">
                <span class="fee-label">挂号费</span>
                <span class="fee-value">¥{{ doctor.fee }}</span>
              </div>
            </div>
            
            <div class="doctor-card__footer">
              <el-button type="primary" plain size="small" @click="goDetail(doctor)">查看详情</el-button>
              <el-button type="success" size="small" @click="goSchedule(doctor)">立即预约</el-button>
            </div>
          </el-card>
        </el-col>
      </el-row>
      
      <el-empty v-if="!loading && doctorList.length === 0" description="暂无医生数据" />

      <pagination
        v-show="total > 0"
        :total="total"
        v-model:page="queryParams.pageNum"
        v-model:limit="queryParams.pageSize"
        @pagination="getList"
      />
    </div>
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

.doctor-list {
  min-height: 400px;
}

.doctor-card {
  transition: all 0.3s;
  cursor: pointer;
  
  &:hover {
    transform: translateY(-4px);
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  }
  
  :deep(.el-card__body) {
    padding: 16px;
  }
}

.doctor-card__header {
  display: flex;
  justify-content: space-between;
  margin-bottom: 12px;
}

.doctor-info {
  display: flex;
  gap: 12px;
}

.doctor-meta {
  display: flex;
  flex-direction: column;
  justify-content: center;
}

.doctor-name {
  font-weight: 700;
  font-size: 16px;
  color: #303133;
  margin-bottom: 4px;
  display: flex;
  align-items: center;
}

.doctor-dept {
  font-size: 13px;
  color: #909399;
}

.doctor-fee {
  text-align: right;
  display: flex;
  flex-direction: column;
  justify-content: center;
}

.fee-label {
  font-size: 12px;
  color: #909399;
}

.fee-value {
  color: #f56c6c;
  font-weight: 700;
  font-size: 16px;
}

.doctor-card__footer {
  display: flex;
  justify-content: flex-end;
  gap: 8px;
  padding-top: 12px;
  border-top: 1px solid #ebeef5;
}

.ml8 {
  margin-left: 8px;
}
</style>
