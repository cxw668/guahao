<template>
  <div class="app-container">
    <el-row :gutter="16">
      <el-col :xs="24" :sm="12" :md="8">
        <el-card shadow="hover" @click="go('/medical/dashboard')" style="cursor: pointer;">
          <template #header>
            <span>数据大屏</span>
          </template>
          <div>快速查看医疗业务关键指标。</div>
        </el-card>
      </el-col>
      <el-col :xs="24" :sm="12" :md="8">
        <el-card shadow="hover" @click="go('/medical/department')" style="cursor: pointer;">
          <template #header>
            <span>科室管理</span>
          </template>
          <div>树形维护科室信息与上下级结构。</div>
        </el-card>
      </el-col>
      <el-col :xs="24" :sm="12" :md="8">
        <el-card shadow="hover" @click="go('/medical/doctor')" style="cursor: pointer;">
          <template #header>
            <span>医生管理</span>
          </template>
          <div>维护医生档案并关联科室。</div>
        </el-card>
      </el-col>
    </el-row>
    <el-row :gutter="16" style="margin-top: 16px;">
      <el-col :xs="24" :sm="12" :md="8">
        <el-card shadow="hover" @click="go('/medical/schedule')" style="cursor: pointer;">
          <template #header>
            <span>号源管理</span>
          </template>
          <div>维护排班号源与状态。</div>
        </el-card>
      </el-col>
      <el-col :xs="24" :sm="12" :md="8">
        <el-card shadow="hover" @click="go('/medical/appointment')" style="cursor: pointer;">
          <template #header>
            <span>预约管理</span>
          </template>
          <div>查询与操作预约订单状态。</div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script setup name="MedicalIndex">
const router = useRouter()

function go(path) {
  router.push(path)
}
</script>
