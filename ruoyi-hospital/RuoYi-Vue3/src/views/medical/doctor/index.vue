<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="医生姓名" prop="doctorName">
        <el-input v-model="queryParams.doctorName" placeholder="请输入医生姓名" clearable style="width: 240px;"
          @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item label="工号" prop="doctorCode">
        <el-input v-model="queryParams.doctorCode" placeholder="请输入工号" clearable style="width: 240px;"
          @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item label="科室" prop="deptId">
        <el-select v-model="queryParams.deptId" placeholder="请选择科室" clearable style="width: 240px;">
          <el-option v-for="d in deptOptions" :key="d.deptId" :label="d.deptName" :value="d.deptId" />
        </el-select>
      </el-form-item>
      <el-form-item label="状态" prop="status">
        <el-select v-model="queryParams.status" placeholder="请选择状态" clearable style="width: 240px;">
          <el-option label="可约" :value="0" />
          <el-option label="暂停" :value="1" />
        </el-select>
      </el-form-item>
      <el-form-item style="width: 100vw">
        <div class="btn-container" style="display: flex; justify-content: space-between; width: calc(100% - 300px); align-items: center;">
          <div class="left-btns">
            <el-button type="primary" plain icon="Plus" @click="handleAdd">新增</el-button>
          </div>
          <div class="right-btns">
            <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
            <el-button icon="Refresh" @click="resetQuery">重置</el-button>
          </div>
        </div>
      </el-form-item>
    </el-form>

    <el-table v-loading="loading" :data="doctorList">
      <el-table-column label="医生ID" align="center" prop="doctorId" width="90" />
      <el-table-column label="姓名" align="center" prop="doctorName" :show-overflow-tooltip="true" />
      <el-table-column label="工号" align="center" prop="doctorCode" width="120" />
      <el-table-column label="科室" align="center" prop="deptId" width="140">
        <template #default="scope">
          <span>{{ deptNameById(scope.row.deptId) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="职称" align="center" prop="title" width="120" />
      <el-table-column label="挂号费" align="center" prop="fee" width="100" />
      <el-table-column label="最大接诊" align="center" prop="maxPatients" width="100" />
      <el-table-column label="在职状态" align="center" prop="workStatus" width="100">
        <template #default="scope">
          <el-tag v-if="scope.row.workStatus === 0" type="success">在职</el-tag>
          <el-tag v-else-if="scope.row.workStatus === 1" type="warning">休假</el-tag>
          <el-tag v-else type="info">离职</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="预约状态" align="center" prop="status" width="100">
        <template #default="scope">
          <el-tag v-if="scope.row.status === 0" type="success">可约</el-tag>
          <el-tag v-else type="info">暂停</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="创建时间" align="center" prop="createTime" width="180">
        <template #default="scope">
          <span>{{ parseTime(scope.row.createTime) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" width="180" fixed="right">
        <template #default="scope">
          <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)">修改</el-button>
          <el-button link type="danger" icon="Delete" @click="handleDelete(scope.row)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total > 0" :total="total" v-model:page="queryParams.pageNum"
      v-model:limit="queryParams.pageSize" @pagination="getList" />
    <el-dialog v-model="open" :title="title" width="880px" append-to-body>
      <el-form ref="formRef" :model="form" :rules="rules" label-width="90px">
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="姓名" prop="doctorName">
              <el-input v-model="form.doctorName" placeholder="请输入医生姓名" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="工号" prop="doctorCode">
              <el-input v-model="form.doctorCode" placeholder="请输入工号" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="科室" prop="deptId">
              <el-select v-model="form.deptId" placeholder="请选择科室" style="width: 100%;">
                <el-option v-for="d in deptOptions" :key="d.deptId" :label="d.deptName" :value="d.deptId" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="职称" prop="title">
              <el-input v-model="form.title" placeholder="如：主任医师" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="挂号费" prop="fee">
              <el-input-number v-model="form.fee" :min="0" :precision="2" controls-position="right"
                style="width: 100%;" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="最大接诊" prop="maxPatients">
              <el-input-number v-model="form.maxPatients" :min="1" controls-position="right" style="width: 100%;" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="在职状态" prop="workStatus">
              <el-select v-model="form.workStatus" placeholder="请选择状态" style="width: 100%;">
                <el-option label="在职" :value="0" />
                <el-option label="休假" :value="1" />
                <el-option label="离职" :value="2" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="预约状态" prop="status">
              <el-radio-group v-model="form.status">
                <el-radio :value="0">可约</el-radio>
                <el-radio :value="1">暂停</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="擅长" prop="specialty">
              <el-input v-model="form.specialty" type="textarea" :rows="2" placeholder="请输入擅长领域" />
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="简介" prop="intro">
              <el-input v-model="form.intro" type="textarea" :rows="3" placeholder="请输入医生简介" />
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="头像URL" prop="avatar">
              <el-input v-model="form.avatar" placeholder="请输入头像URL" />
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button type="primary" @click="submitForm">确 定</el-button>
          <el-button @click="cancel">取 消</el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup name="MedicalDoctor">
import { listMedicalDepartments } from '@/api/medical/department'
import { listMedicalDoctors, addMedicalDoctor, updateMedicalDoctor, delMedicalDoctor } from '@/api/medical/doctor'

const { proxy } = getCurrentInstance()

const loading = ref(false)
const showSearch = ref(true)
const total = ref(0)
const doctorList = ref([])
const deptOptions = ref([])

const queryParams = ref({
  pageNum: 1,
  pageSize: 10,
  doctorName: undefined,
  doctorCode: undefined,
  deptId: undefined,
  status: undefined
})

const open = ref(false)
const title = ref('')
const form = ref({})
const rules = ref({
  doctorName: [{ required: true, message: '医生姓名不能为空', trigger: 'blur' }],
  doctorCode: [{ required: true, message: '工号不能为空', trigger: 'blur' }],
  deptId: [{ required: true, message: '科室不能为空', trigger: 'change' }],
  fee: [{ required: true, message: '挂号费不能为空', trigger: 'blur' }],
  maxPatients: [{ required: true, message: '最大接诊不能为空', trigger: 'blur' }],
  workStatus: [{ required: true, message: '在职状态不能为空', trigger: 'change' }],
  status: [{ required: true, message: '预约状态不能为空', trigger: 'change' }]
})

function deptNameById(deptId) {
  const found = deptOptions.value.find(d => d.deptId === deptId)
  return found ? found.deptName : deptId
}

function reset() {
  form.value = {
    doctorId: undefined,
    userId: undefined,
    doctorName: undefined,
    doctorCode: undefined,
    deptId: undefined,
    title: undefined,
    specialty: undefined,
    intro: undefined,
    avatar: undefined,
    fee: 0,
    maxPatients: 20,
    workStatus: 0,
    status: 0
  }
  proxy.resetForm('formRef')
}

function getDeptOptions() {
  listMedicalDepartments({ pageNum: 1, pageSize: 9999, status: 0 }).then(res => {
    deptOptions.value = res.rows || []
  })
}

function getList() {
  loading.value = true
  listMedicalDoctors(queryParams.value).then(res => {
    doctorList.value = res.rows || []
    total.value = res.total || 0
    loading.value = false
  }).catch(() => {
    loading.value = false
  })
}

function handleQuery() {
  queryParams.value.pageNum = 1
  getList()
}

function resetQuery() {
  proxy.resetForm('queryRef')
  handleQuery()
}

function handleAdd() {
  reset()
  open.value = true
  title.value = '新增医生'
}

function handleUpdate(row) {
  reset()
  form.value = { ...form.value, ...row }
  open.value = true
  title.value = '修改医生'
}

function cancel() {
  open.value = false
  reset()
}

function submitForm() {
  proxy.$refs['formRef'].validate(valid => {
    if (!valid) return
    const payload = { ...form.value }
    if (payload.doctorId) {
      updateMedicalDoctor(payload.doctorId, payload).then(() => {
        proxy.$modal.msgSuccess('修改成功')
        open.value = false
        getList()
      })
      return
    }
    addMedicalDoctor(payload).then(() => {
      proxy.$modal.msgSuccess('新增成功')
      open.value = false
      getList()
    })
  })
}

function handleDelete(row) {
  const doctorId = row.doctorId
  proxy.$modal.confirm(`是否确认删除医生ID为"${doctorId}"的数据项？`).then(() => {
    return delMedicalDoctor(doctorId)
  }).then(() => {
    proxy.$modal.msgSuccess('删除成功')
    getList()
  }).catch(() => { })
}

getDeptOptions()
getList()
</script>