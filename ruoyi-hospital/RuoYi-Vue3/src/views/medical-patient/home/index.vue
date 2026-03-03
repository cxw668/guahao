<template>
  <div class="patient-page">
    <el-card class="mb16">
      <template #header>
        <div class="header">
          <span class="header__title">快速挂号</span>
          <el-button link type="primary" @click="router.push('/medical-patient/department')">查看全部科室</el-button>
        </div>
      </template>

      <el-input
        v-model="keyword"
        placeholder="搜索医生/科室"
        clearable
        @keyup.enter="handleSearchDoctor"
      >
        <template #append>
          <div class="s-btns">
            <el-button type="primary" class="s-btns__doctor" @click="handleSearchDoctor">搜医生</el-button>
            <el-button type="info" class="s-btns__dept" @click="handleSearchDepartment">搜科室</el-button>
          </div>
        </template>
      </el-input>
    </el-card>

    <el-card>
      <template #header>
        <div class="header">
          <span class="header__title">科室入口</span>
        </div>
      </template>

      <el-skeleton :loading="loading" animated>
        <template #template>
          <el-row :gutter="12">
            <el-col v-for="i in 8" :key="i" :span="6">
              <el-skeleton-item variant="rect" style="height: 72px;" />
            </el-col>
          </el-row>
        </template>
        <template #default>
          <el-row :gutter="12">
            <el-col v-for="d in deptList" :key="d.deptId" :span="6">
              <el-card class="dept-card" shadow="hover" @click="goDept(d)">
                <div class="dept-card__name">{{ d.deptName }}</div>
                <div class="dept-card__meta">
                  <span v-if="d.location">{{ d.location }}</span>
                  <span v-else>点击查看医生</span>
                </div>
              </el-card>
            </el-col>
          </el-row>
          <el-empty v-if="!deptList.length" description="暂无可用科室" />
        </template>
      </el-skeleton>
    </el-card>
  </div>
</template>

<script setup name="MedicalPatientHome">
import { listMedicalDepartments } from '@/api/medical/department'

/**
 * 患者端-首页：提供搜索入口与科室快捷入口。
 */
const router = useRouter()

const loading = ref(false)
const keyword = ref('')
const deptList = ref([])

function handleSearchDoctor() {
  const q = (keyword.value || '').trim()
  router.push({ path: '/medical-patient/doctor/list', query: q ? { keyword: q } : {} })
}

function handleSearchDepartment() {
  const q = (keyword.value || '').trim()
  router.push({ path: '/medical-patient/department', query: q ? { keyword: q } : {} })
}

function goDept(dept) {
  router.push({ path: '/medical-patient/doctor/list', query: { deptId: String(dept.deptId || '') } })
}

async function loadDeptPreview() {
  loading.value = true
  try {
    const res = await listMedicalDepartments({ pageNum: 1, pageSize: 8, status: 0 })
    deptList.value = Array.isArray(res?.rows) ? res.rows : []
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  loadDeptPreview()
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

.header__title {
  font-weight: 700;
}

.dept-card {
  cursor: pointer;
}

.dept-card__name {
  font-weight: 700;
  color: #303133;
}

.dept-card__meta {
  margin-top: 6px;
  font-size: 12px;
  color: #909399;
}

.s-btns {
  display: flex;
  align-items: center;
  gap: 18px;

  :deep(.el-button) {
    border-radius: 4px;
    height: 40px;
    padding: 0 20px;
    font-weight: 500;
    margin: 0;
    transition: all 0.3s;
    border: 1px solid #606266;
  }

  .s-btns__doctor {
    background-color: var(--el-color-primary);
    color: #ffffff;

    &:hover {
      background-color: var(--el-color-primary-light-3);
    }
  }

  .s-btns__dept {
    background-color: #f2f3f5;
    color: #606266;

    &:hover {
      background-color: #e6e8eb;
      color: #303133;
    }
  }

  @media screen and (max-width: 768px) {
    gap: 8px;
    
    :deep(.el-button) {
      padding: 0 12px;
      font-size: 13px;
    }
  }
}
</style>
