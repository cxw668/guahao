<template>
  <div class="patient-page">
    <el-card class="mb16">
      <template #header>
        <div class="header">
          <div class="header__left">
            <el-button text @click="router.push('/medical-patient/home')">返回</el-button>
            <span class="header__title">科室列表</span>
          </div>
        </div>
      </template>

      <el-form :model="queryParams" inline>
        <el-form-item label="科室名称">
          <el-input
            v-model="queryParams.deptName"
            placeholder="请输入科室名称"
            clearable
            style="width: 260px;"
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
      <el-table v-loading="loading" :data="deptList" row-key="deptId">
        <el-table-column label="科室" prop="deptName" min-width="200" />
        <el-table-column label="位置" prop="location" min-width="200" />
        <el-table-column label="电话" prop="phone" width="140" />
        <el-table-column label="操作" width="120" fixed="right">
          <template #default="{ row }">
            <el-button link type="primary" @click="goDoctors(row)">查看医生</el-button>
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

<script setup name="MedicalPatientDepartment">
import { listMedicalDepartments } from '@/api/medical/department'

/**
 * 患者端-科室：科室列表与搜索，并可跳转到医生列表。
 */
const router = useRouter()
const route = useRoute()

const loading = ref(false)
const total = ref(0)
const deptList = ref([])

const queryParams = ref({
  pageNum: 1,
  pageSize: 20,
  deptName: undefined,
  status: 0
})

function handleQuery() {
  queryParams.value.pageNum = 1
  getList()
}

function resetQuery() {
  queryParams.value.deptName = undefined
  handleQuery()
}

function goDoctors(dept) {
  router.push({ path: '/medical-patient/doctor/list', query: { deptId: String(dept.deptId || '') } })
}

async function getList() {
  loading.value = true
  try {
    const res = await listMedicalDepartments(queryParams.value)
    deptList.value = Array.isArray(res?.rows) ? res.rows : []
    total.value = typeof res?.total === 'number' ? res.total : 0
  } finally {
    loading.value = false
  }
}

watch(
  () => route.query.keyword,
  (val) => {
    const keyword = typeof val === 'string' ? val.trim() : ''
    queryParams.value.deptName = keyword || undefined
    queryParams.value.pageNum = 1
    getList()
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
</style>
