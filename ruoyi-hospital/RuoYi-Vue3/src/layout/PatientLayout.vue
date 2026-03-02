<template>
  <el-container class="patient-layout">
    <el-header class="patient-header">
      <div class="patient-brand" @click="router.push('/medical-patient/home')">
        <span class="patient-brand__title">挂号系统</span>
        <span class="patient-brand__subtitle">患者端</span>
      </div>
      <el-menu
        class="patient-menu"
        mode="horizontal"
        :default-active="activeMenu"
        :ellipsis="false"
        @select="handleSelect"
      >
        <el-menu-item index="/medical-patient/home">首页</el-menu-item>
        <el-menu-item index="/medical-patient/order/list">我的预约</el-menu-item>
        <el-menu-item index="/medical-patient/profile">个人中心</el-menu-item>
      </el-menu>
    </el-header>
    <el-main class="patient-main">
      <router-view />
    </el-main>
  </el-container>
</template>

<script setup>
const route = useRoute()
const router = useRouter()

const activeMenu = computed(() => {
  const path = route.path || ''
  if (path.startsWith('/medical-patient/order')) return '/medical-patient/order/list'
  if (path.startsWith('/medical-patient/profile')) return '/medical-patient/profile'
  return '/medical-patient/home'
})

function handleSelect(path) {
  if (path && path !== route.path) {
    router.push(path)
  }
}
</script>

<style scoped>
.patient-layout {
  min-height: 100vh;
  background: #f6f7fb;
}

.patient-header {
  display: flex;
  align-items: center;
  gap: 16px;
  background: #fff;
  border-bottom: 1px solid #ebeef5;
}

.patient-brand {
  display: flex;
  align-items: baseline;
  gap: 8px;
  cursor: pointer;
  user-select: none;
}

.patient-brand__title {
  font-size: 16px;
  font-weight: 700;
  color: #303133;
}

.patient-brand__subtitle {
  font-size: 12px;
  color: #909399;
}

.patient-menu {
  flex: 1;
  border-bottom: 0;
}

.patient-main {
  padding: 16px;
}
</style>

