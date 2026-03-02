<template>
  <div class="app-container">
    <div class="flow-panel" role="navigation" aria-label="医疗管理快捷入口">
      <div class="flow-item" @click="go('/medical/dashboard')">
        <div class="flow-badge">01</div>
        <div class="flow-card">
          <div class="flow-title">数据大屏</div>
          <div class="flow-desc">快速查看医疗业务关键指标。</div>
        </div>
      </div>

      <div class="flow-item" @click="go('/medical/department')">
        <div class="flow-badge">02</div>
        <div class="flow-card">
          <div class="flow-title">科室管理</div>
          <div class="flow-desc">树形维护科室信息与上下级结构。</div>
        </div>
      </div>

      <div class="flow-item" @click="go('/medical/doctor')">
        <div class="flow-badge">03</div>
        <div class="flow-card">
          <div class="flow-title">医生管理</div>
          <div class="flow-desc">维护医生档案并关联科室。</div>
        </div>
      </div>

      <div class="flow-item" @click="go('/medical/schedule')">
        <div class="flow-badge">04</div>
        <div class="flow-card">
          <div class="flow-title">号源管理</div>
          <div class="flow-desc">维护排班号源与状态。</div>
        </div>
      </div>

      <div class="flow-item" @click="go('/medical/appointment')">
        <div class="flow-badge">05</div>
        <div class="flow-card">
          <div class="flow-title">预约管理</div>
          <div class="flow-desc">查询与操作预约订单状态。</div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup name="MedicalIndex">
import { onMounted } from 'vue';
import { listRole } from '../../api/system/role';
const router = useRouter()
onMounted(async () => {
  const {rows} = await listRole()
  console.log(rows)
})
function go(path) {
  router.push(path)
}
</script>

<style scoped>
.flow-panel {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(860px, 1fr));
  align-items: stretch;
  gap: 22px;
  padding: 6px 2px 10px;
}

.flow-item {
  position: relative;
  cursor: pointer;
}

.flow-card {
  height: 100%;
  border: 1px solid var(--el-border-color);
  border-radius: 10px;
  background: var(--el-bg-color);
  padding: 18px 16px 16px;
  transform: translateZ(0);
  will-change: transform;
  transition: transform 0.32s cubic-bezier(0.34, 1.56, 0.64, 1), box-shadow 0.18s ease,
    border-color 0.18s ease;
}

.flow-item:hover .flow-card {
  border-color: var(--el-color-primary);
  box-shadow: 0 10px 24px rgba(0, 0, 0, 0.08);
  transform: translateY(-6px) scale(1.01);
  animation: flow-card-spring 420ms cubic-bezier(0.34, 1.56, 0.64, 1) both;
}

.flow-item:active .flow-card {
  transform: translateY(-2px) scale(0.985);
  transition-duration: 90ms;
  transition-timing-function: ease-out;
}

@keyframes flow-card-spring {
  0% {
    transform: translateY(0) scale(1);
  }
  60% {
    transform: translateY(-10px) scale(1.02);
  }
  100% {
    transform: translateY(-6px) scale(1.01);
  }
}

.flow-badge {
  position: absolute;
  top: -10px;
  left: 12px;
  z-index: 1;
  height: 26px;
  min-width: 52px;
  padding: 0 10px;
  border-radius: 999px;
  background: var(--el-color-primary);
  color: #fff;
  font-weight: 600;
  font-size: 12px;
  line-height: 26px;
  letter-spacing: 0.5px;
  box-shadow: 0 6px 16px rgba(64, 158, 255, 0.28);
}

.flow-title {
  margin-top: 6px;
  font-size: 16px;
  font-weight: 600;
  color: var(--el-text-color-primary);
}

.flow-desc {
  margin-top: 8px;
  font-size: 13px;
  line-height: 1.6;
  color: var(--el-text-color-regular);
}

@media (max-width: 768px) {
  .flow-panel {
    grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
    gap: 18px;
  }
}

@media (prefers-reduced-motion: reduce) {
  .flow-card {
    transition: none;
  }
  .flow-item:hover .flow-card {
    animation: none;
  }
}
</style>
