<template>
  <div class="app-container">
    <el-row :gutter="12">
      <el-col :span="10">
        <el-card shadow="never">
          <template #header>
            <div class="card-header">
              <span>接诊信息</span>
              <div class="card-actions">
                <el-button plain icon="Back" @click="goQueue">返回队列</el-button>
                <el-button type="primary" icon="Refresh" :loading="loading" @click="loadDetail">刷新</el-button>
              </div>
            </div>
          </template>

          <el-empty v-if="!appointmentId" description="请从候诊队列进入（缺少 appointmentId）" />
          <template v-else>
            <el-skeleton v-if="loading" :rows="6" animated />
            <template v-else>
              <el-descriptions v-if="detail" :column="1" border>
                <el-descriptions-item label="预约ID">{{ detail.appointmentId }}</el-descriptions-item>
                <el-descriptions-item label="预约单号">{{ detail.appointmentNo }}</el-descriptions-item>
                <el-descriptions-item label="医生ID">{{ detail.doctorId }}</el-descriptions-item>
                <el-descriptions-item label="患者ID">{{ detail.patientId }}</el-descriptions-item>
                <el-descriptions-item label="就诊人ID">{{ detail.visitorId }}</el-descriptions-item>
                <el-descriptions-item label="就诊日期">{{ detail.appointmentDate }}</el-descriptions-item>
                <el-descriptions-item label="时间段">{{ detail.timeSlot }}</el-descriptions-item>
                <el-descriptions-item label="状态">{{ statusLabel(detail.status) }}</el-descriptions-item>
                <el-descriptions-item label="创建时间">{{ parseTime(detail.createTime) }}</el-descriptions-item>
              </el-descriptions>
              <el-empty v-else description="未查询到预约详情" />

              <el-divider />
              <div class="action-row">
                <el-button type="primary" :disabled="!detail" @click="handleStart">开始接诊</el-button>
                <el-button type="success" :disabled="!detail" @click="handleFinish">完成接诊</el-button>
              </div>
              <el-text type="info">提示：当前页面仅使用现有 medical 接口，病历数据默认保存为本地草稿。</el-text>
            </template>
          </template>
        </el-card>
      </el-col>

      <el-col :span="14">
        <el-card shadow="never">
          <template #header>
            <div class="card-header">
              <span>病历草稿（本地）</span>
              <div class="card-actions">
                <el-button plain icon="Download" :disabled="!appointmentId" @click="loadDraft">加载草稿</el-button>
                <el-button plain icon="DocumentAdd" :disabled="!appointmentId" @click="saveDraft">保存草稿</el-button>
                <el-button plain icon="Delete" :disabled="!appointmentId" @click="clearDraft">清空草稿</el-button>
              </div>
            </div>
          </template>

          <el-form ref="formRef" :model="form" label-width="90px">
            <el-form-item label="主诉">
              <el-input v-model="form.chiefComplaint" type="textarea" :rows="2" placeholder="请输入主诉" />
            </el-form-item>
            <el-form-item label="现病史">
              <el-input v-model="form.presentIllness" type="textarea" :rows="3" placeholder="请输入现病史" />
            </el-form-item>
            <el-form-item label="诊断">
              <el-input v-model="form.diagnosis" type="textarea" :rows="2" placeholder="请输入诊断" />
            </el-form-item>
            <el-form-item label="处置方案">
              <el-input v-model="form.treatmentPlan" type="textarea" :rows="3" placeholder="请输入处置方案" />
            </el-form-item>
            <el-form-item label="处方">
              <el-input v-model="form.prescription" type="textarea" :rows="3" placeholder="请输入处方内容" />
            </el-form-item>
            <el-form-item label="备注">
              <el-input v-model="form.note" type="textarea" :rows="2" placeholder="请输入备注" />
            </el-form-item>
          </el-form>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script setup name="DoctorConsult">
import { getMedicalAppointment, updateMedicalAppointment, finishMedicalAppointment } from '@/api/medical/appointment'

const router = useRouter()
const route = useRoute()
const { proxy } = getCurrentInstance()

const loading = ref(false)
const detail = ref(undefined)
const appointmentId = computed(() => route.query.appointmentId)

const formRef = ref()
const form = ref({
  chiefComplaint: '',
  presentIllness: '',
  diagnosis: '',
  treatmentPlan: '',
  prescription: '',
  note: ''
})

function statusLabel(value) {
  const map = { 0: '待支付', 1: '待就诊', 2: '就诊中', 3: '已完成', 4: '已取消', 5: '失约' }
  return map[value] || '-'
}

function draftKey() {
  return `medical:consult:draft:${String(appointmentId.value || '')}`
}

function loadDetail() {
  const id = appointmentId.value
  if (!id) {
    detail.value = undefined
    return
  }
  loading.value = true
  getMedicalAppointment(id).then(res => {
    detail.value = res.data
    loading.value = false
  }).catch(() => {
    loading.value = false
  })
}

function goQueue() {
  router.push({ path: '/medical-doctor/queue' })
}

function handleStart() {
  const d = detail.value
  if (!d?.appointmentId) return
  if (d.status === 2) {
    proxy.$modal.msgSuccess('当前已是就诊中')
    return
  }
  proxy.$modal.confirm(`是否确认开始接诊预约ID为"${d.appointmentId}"的数据项？`).then(() => {
    return updateMedicalAppointment(d.appointmentId, { status: 2 })
  }).then(() => {
    proxy.$modal.msgSuccess('已开始接诊')
    loadDetail()
  }).catch(() => {})
}

function handleFinish() {
  const d = detail.value
  if (!d?.appointmentId) return
  proxy.$modal.confirm(`是否确认完成接诊预约ID为"${d.appointmentId}"的数据项？`).then(() => {
    return finishMedicalAppointment(d.appointmentId)
  }).then(() => {
    proxy.$modal.msgSuccess('已完成接诊')
    loadDetail()
  }).catch(() => {})
}

/**
 * 本地草稿仅用于医生端页面演示与防丢失。
 * 后续如需落库，可新增 medical 接口（如 /medical/medical-records）承载病历数据。
 */
function saveDraft() {
  if (!appointmentId.value) return
  try {
    localStorage.setItem(draftKey(), JSON.stringify(form.value))
    proxy.$modal.msgSuccess('草稿已保存')
  } catch (e) {
    proxy.$modal.msgError('草稿保存失败')
  }
}

function loadDraft() {
  if (!appointmentId.value) return
  try {
    const raw = localStorage.getItem(draftKey())
    if (!raw) {
      proxy.$modal.msgWarning('暂无草稿')
      return
    }
    const parsed = JSON.parse(raw)
    form.value = { ...form.value, ...parsed }
    proxy.$modal.msgSuccess('草稿已加载')
  } catch (e) {
    proxy.$modal.msgError('草稿加载失败')
  }
}

function clearDraft() {
  if (!appointmentId.value) return
  proxy.$modal.confirm('是否确认清空本地草稿？').then(() => {
    localStorage.removeItem(draftKey())
    form.value = {
      chiefComplaint: '',
      presentIllness: '',
      diagnosis: '',
      treatmentPlan: '',
      prescription: '',
      note: ''
    }
    proxy.$modal.msgSuccess('草稿已清空')
  }).catch(() => {})
}

watch(() => appointmentId.value, () => {
  detail.value = undefined
  loadDetail()
  loadDraft()
}, { immediate: true })
</script>

<style scoped>
.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 12px;
}
.card-actions {
  display: flex;
  align-items: center;
  gap: 8px;
}
.action-row {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 8px;
}
</style>
