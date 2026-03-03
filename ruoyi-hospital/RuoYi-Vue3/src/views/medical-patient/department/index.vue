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

    <div v-loading="loading" class="dept-list">
      <el-row :gutter="12">
        <el-col v-for="dept in deptList" :key="dept.deptId" :xs="24" :sm="12" :md="8" :lg="6">
          <el-card shadow="hover" class="dept-card mb16" @click="goDoctors(dept)">
            <div class="dept-info">
              <div class="dept-name">{{ dept.deptName }}</div>
              <div class="dept-meta">
                <div class="meta-item">
                  <el-icon><Location /></el-icon>
                  <span>{{ dept.location || '暂无位置信息' }}</span>
                </div>
                <div class="meta-item">
                  <el-icon><Phone /></el-icon>
                  <span>{{ dept.phone || '暂无联系电话' }}</span>
                </div>
              </div>
            </div>
            <div class="dept-action">
              <el-icon><ArrowRight /></el-icon>
            </div>
          </el-card>
        </el-col>
      </el-row>

      <el-empty v-if="!loading && deptList.length === 0" description="暂无科室数据" />

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

.dept-list {
  min-height: 400px;
}

.dept-card {
  cursor: pointer;
  transition: all 0.3s;
  display: flex;
  flex-direction: column;
  position: relative;
  
  &:hover {
    transform: translateY(-4px);
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
    border-color: var(--el-color-primary-light-5);
    
    .dept-name {
      color: var(--el-color-primary);
    }
    
    .dept-action {
      opacity: 1;
      transform: translateX(0);
    }
  }

  :deep(.el-card__body) {
    padding: 20px;
    display: flex;
    justify-content: space-between;
    align-items: center;
  }
}

.dept-info {
  flex: 1;
  min-width: 0;
}

.dept-name {
  font-size: 18px;
  font-weight: 700;
  color: #303133;
  margin-bottom: 12px;
  transition: color 0.3s;
}

.dept-meta {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.meta-item {
  display: flex;
  align-items: center;
  font-size: 13px;
  color: #909399;
  
  .el-icon {
    margin-right: 6px;
    font-size: 14px;
  }
}

.dept-action {
  opacity: 0;
  transform: translateX(-10px);
  transition: all 0.3s;
  color: #c0c4cc;
  font-size: 20px;
  
  @media screen and (max-width: 768px) {
    opacity: 1;
    transform: none;
  }
}

</style>