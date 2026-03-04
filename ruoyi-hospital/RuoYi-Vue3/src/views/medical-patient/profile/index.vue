<template>
  <div class="patient-page">
    <el-card class="mb16">
      <template #header>
        <div class="header">
          <div class="header__left">
            <el-button text @click="router.push('/medical-patient/home')"><el-icon><Back/></el-icon>返回</el-button>
            <span class="header__title">个人中心</span>
          </div>
          <div class="header__right">
            <el-button type="danger" @click="handleLogout"><el-icon><Close /></el-icon>&nbsp;退出登录</el-button>
          </div>
        </div>
      </template>

      <div class="user">
        <el-avatar :size="56" :src="userStore.avatar">
          {{ (userStore.nickName || userStore.name || '').slice(0, 1) }}
        </el-avatar>
        <div class="user__info">
          <div class="user__name">{{ userStore.nickName || userStore.name || '用户' }}</div>
          <div class="user__meta">账号：{{ userStore.name || '—' }} · ID：{{ userStore.id || '—' }}</div>
        </div>
      </div>
    </el-card>

    <el-card>
      <template #header>
        <div class="header">
          <span class="header__title">就诊人管理</span>
          <el-button type="primary" icon="Plus" @click="handleAdd">新增就诊人</el-button>
        </div>
      </template>

      <div v-loading="loading" class="visitor-list">
        <el-row :gutter="12">
          <el-col v-for="visitor in visitorList" :key="visitor.visitorId" :xs="24" :sm="12" :md="8" :lg="6">
            <el-card shadow="hover" class="visitor-card mb16">
              <div class="visitor-header">
                <div class="visitor-name">
                  <span>{{ visitor.name }}</span>
                  <el-tag size="small" type="info" class="ml8">{{ visitor.relation }}</el-tag>
                  <el-tag v-if="visitor.isDefault === 1" size="small" type="success" class="ml8">默认</el-tag>
                </div>
                <div class="visitor-action">
                  <el-button link type="primary" size="small" @click="handleEdit(visitor)">编辑</el-button>
                  <el-button link type="danger" size="small" @click="handleDelete(visitor)">删除</el-button>
                </div>
              </div>
              
              <div class="visitor-content">
                <div class="info-item">
                  <el-icon><Iphone /></el-icon>
                  <span>{{ visitor.phone }}</span>
                </div>
                <div class="info-item">
                  <el-icon><Postcard /></el-icon>
                  <span>{{ visitor.idCard }}</span>
                </div>
              </div>

              <div class="visitor-footer" v-if="visitor.isDefault !== 1">
                <el-button 
                  class="btn-block" 
                  type="success" 
                  plain 
                  size="small" 
                  @click="setDefault(visitor)"
                >
                  设为默认就诊人
                </el-button>
              </div>
            </el-card>
          </el-col>
        </el-row>

        <el-empty v-if="!loading && !visitorList.length" description="暂无就诊人，请先新增" />
      </div>
    </el-card>

    <el-dialog v-model="open" :title="dialogTitle" width="860px" append-to-body>
      <el-form ref="formRef" :model="form" :rules="rules" label-width="90px">
        <el-row :gutter="16">
          <el-col :span="12">
            <el-form-item label="姓名" prop="name">
              <el-input v-model="form.name" placeholder="请输入姓名" maxlength="50" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="关系" prop="relation">
              <el-select v-model="form.relation" placeholder="请选择关系" style="width: 100%;">
                <el-option label="本人" value="本人" />
                <el-option label="配偶" value="配偶" />
                <el-option label="子女" value="子女" />
                <el-option label="父母" value="父母" />
                <el-option label="其他" value="其他" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="身份证号" prop="idCard">
              <el-input v-model="form.idCard" placeholder="请输入身份证号" maxlength="18" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="手机号" prop="phone">
              <el-input v-model="form.phone" placeholder="请输入手机号" maxlength="11" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="性别" prop="gender">
              <el-radio-group v-model="form.gender">
                <el-radio :value="0">男</el-radio>
                <el-radio :value="1">女</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="出生日期" prop="birthDate">
              <el-date-picker v-model="form.birthDate" type="date" value-format="YYYY-MM-DD" placeholder="请选择出生日期" style="width: 100%;" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="医保卡号" prop="medicalCardNo">
              <el-input v-model="form.medicalCardNo" placeholder="可选" maxlength="30" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="默认就诊人" prop="isDefault">
              <el-switch v-model="form.isDefault" :active-value="1" :inactive-value="0" />
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="过敏史" prop="allergyHistory">
              <el-input v-model="form.allergyHistory" type="textarea" :rows="2" placeholder="可选" maxlength="500" show-word-limit />
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="既往史" prop="pastHistory">
              <el-input v-model="form.pastHistory" type="textarea" :rows="2" placeholder="可选" maxlength="500" show-word-limit />
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
      <template #footer>
        <el-button @click="open = false">取消</el-button>
        <el-button type="primary" :loading="saving" @click="submitForm">保存</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup name="MedicalPatientProfile">
import { ElMessage, ElMessageBox } from 'element-plus'
import {
  addMedicalPatientVisitor,
  delMedicalPatientVisitor,
  listMedicalPatientVisitors,
  updateMedicalPatientVisitor
} from '@/api/medical/patientVisitor'
import useUserStore from '@/store/modules/user'
import {Back} from "@element-plus/icons-vue";

/**
 * 患者端-个人中心：展示用户信息，并提供就诊人档案的增删改与默认设置。
 */
const router = useRouter()
const userStore = useUserStore()

const loading = ref(false)
const saving = ref(false)
const visitorList = ref([])

const open = ref(false)
const dialogTitle = ref('新增就诊人')
const form = ref({})
const rules = ref({
  name: [{ required: true, message: '姓名不能为空', trigger: 'blur' }],
  relation: [{ required: true, message: '关系不能为空', trigger: 'change' }],
  idCard: [{ required: true, message: '身份证号不能为空', trigger: 'blur' }]
})

const formRef = ref()

function resetForm() {
  form.value = {
    visitorId: undefined,
    patientId: undefined,
    name: '',
    idCard: '',
    phone: '',
    relation: '本人',
    gender: 0,
    birthDate: undefined,
    medicalCardNo: '',
    allergyHistory: '',
    pastHistory: '',
    isDefault: 0,
    status: 0
  }
}

async function getList() {
  const patientId = Number(userStore.id)
  if (!Number.isFinite(patientId)) {
    visitorList.value = []
    return
  }
  loading.value = true
  try {
    const res = await listMedicalPatientVisitors({ pageNum: 1, pageSize: 100, patientId, status: 0 })
    visitorList.value = Array.isArray(res?.rows) ? res.rows : []
  } finally {
    loading.value = false
  }
}

function handleAdd() {
  dialogTitle.value = '新增就诊人'
  resetForm()
  open.value = true
}

function handleEdit(row) {
  dialogTitle.value = '编辑就诊人'
  resetForm()
  form.value = { ...form.value, ...row }
  open.value = true
}

async function ensureSingleDefault(targetId) {
  const tasks = visitorList.value
    .filter(v => v?.isDefault === 1 && v?.visitorId !== targetId)
    .map(v => updateMedicalPatientVisitor(v.visitorId, { ...v, isDefault: 0 }))
  if (tasks.length) {
    await Promise.all(tasks)
  }
}

async function submitForm() {
  if (!formRef.value) return
  await formRef.value.validate()

  const patientId = Number(userStore.id)
  if (!Number.isFinite(patientId)) {
    ElMessage.error('用户信息异常，请重新登录')
    return
  }

  saving.value = true
  try {
    const payload = { ...form.value, patientId }
    if (payload.visitorId) {
      await updateMedicalPatientVisitor(payload.visitorId, payload)
      if (payload.isDefault === 1) {
        await ensureSingleDefault(payload.visitorId)
      }
      ElMessage.success('已保存')
    } else {
      await addMedicalPatientVisitor(payload)
      ElMessage.success('已新增')
    }
    open.value = false
    await getList()

    const currentDefault = visitorList.value.find(v => v?.isDefault === 1)
    if (payload.isDefault === 1 && currentDefault?.visitorId) {
      await ensureSingleDefault(currentDefault.visitorId)
      await getList()
    }
  } finally {
    saving.value = false
  }
}

async function setDefault(row) {
  const id = row?.visitorId
  if (!Number.isFinite(id)) return
  await updateMedicalPatientVisitor(id, { ...row, isDefault: 1 })
  await getList()
  await ensureSingleDefault(id)
  await getList()
  ElMessage.success('已设置默认就诊人')
}

async function handleDelete(row) {
  const id = row?.visitorId
  if (!Number.isFinite(id)) return
  try {
    await ElMessageBox.confirm(`确认删除就诊人「${row?.name || ''}」？`, '提示', { type: 'warning' })
  } catch {
    return
  }
  await delMedicalPatientVisitor(id)
  ElMessage.success('已删除')
  getList()
}

function handleLogout() {
  ElMessageBox.confirm('确认退出登录吗？', '提示', { type: 'warning' })
    .then(() => {
      userStore.logOut()
      router.replace('/login')
    })
    .catch(() => {})
}

onMounted(() => {
  getList()
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

.user {
  display: flex;
  align-items: center;
  gap: 12px;
}

.user__name {
  font-weight: 700;
  color: #303133;
}

.user__meta {
  margin-top: 6px;
  font-size: 12px;
  color: #909399;
}

.visitor-list {
  min-height: 200px;
}

.visitor-card {
  transition: all 0.3s;
  
  &:hover {
    transform: translateY(-4px);
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  }

  :deep(.el-card__body) {
    padding: 16px;
  }
}

.visitor-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 12px;
}

.visitor-name {
  font-weight: 700;
  font-size: 16px;
  color: #303133;
  display: flex;
  align-items: center;
}

.visitor-action {
  display: flex;
  gap: 8px;
}

.visitor-content {
  display: flex;
  flex-direction: column;
  gap: 8px;
  margin-bottom: 12px;
}

.info-item {
  display: flex;
  align-items: center;
  font-size: 14px;
  color: #606266;
  
  .el-icon {
    margin-right: 8px;
    font-size: 16px;
    color: #909399;
  }
}

.visitor-footer {
  padding-top: 12px;
  border-top: 1px solid #ebeef5;
}

.btn-block {
  width: 100%;
}

.ml8 {
  margin-left: 8px;
}
</style>
