<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="科室名称" prop="deptName">
        <el-input
          v-model="queryParams.deptName"
          placeholder="请输入科室名称"
          clearable
          style="width: 240px;"
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="科室编码" prop="deptCode">
        <el-input
          v-model="queryParams.deptCode"
          placeholder="请输入科室编码"
          clearable
          style="width: 240px;"
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="状态" prop="status">
        <el-select v-model="queryParams.status" placeholder="请选择状态" clearable style="width: 240px;">
          <el-option label="正常" :value="0" />
          <el-option label="停用" :value="1" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
        <el-button icon="Refresh" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button type="primary" plain icon="Plus" @click="handleAdd">新增</el-button>
      </el-col>
      <!-- <right-toolbar v-model:showSearch="showSearch" @queryTable="getList" /> -->
    </el-row>

    <el-table
      v-loading="loading"
      :data="deptTree"
      row-key="deptId"
      :tree-props="{ children: 'children' }"
    >
      <el-table-column label="科室名称" align="left" prop="deptName" min-width="200" :show-overflow-tooltip="true" />
      <el-table-column label="科室编码" align="center" prop="deptCode" width="140" />
      <el-table-column label="类型" align="center" prop="deptType" width="90">
        <template #default="scope">
          <span>{{ deptTypeLabel(scope.row.deptType) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="位置" align="center" prop="location" min-width="160" :show-overflow-tooltip="true" />
      <el-table-column label="电话" align="center" prop="phone" width="120" />
      <el-table-column label="排序" align="center" prop="sortOrder" width="80" />
      <el-table-column label="状态" align="center" prop="status" width="80">
        <template #default="scope">
          <el-tag v-if="scope.row.status === 0" type="success">正常</el-tag>
          <el-tag v-else type="info">停用</el-tag>
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

    <el-dialog v-model="open" :title="title" width="720px" append-to-body>
      <el-form ref="formRef" :model="form" :rules="rules" label-width="90px">
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="科室名称" prop="deptName">
              <el-input v-model="form.deptName" placeholder="请输入科室名称" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="科室编码" prop="deptCode">
              <el-input v-model="form.deptCode" placeholder="请输入科室编码" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="父科室" prop="parentId">
              <el-select v-model="form.parentId" placeholder="请选择父科室" clearable style="width: 100%;">
                <el-option label="顶级" :value="0" />
                <el-option v-for="d in deptOptions" :key="d.deptId" :label="d.deptName" :value="d.deptId" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="科室类型" prop="deptType">
              <el-select v-model="form.deptType" placeholder="请选择类型" style="width: 100%;">
                <el-option label="门诊" :value="1" />
                <el-option label="急诊" :value="2" />
                <el-option label="住院" :value="3" />
                <el-option label="医技" :value="4" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="位置" prop="location">
              <el-input v-model="form.location" placeholder="如：门诊楼3层" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="电话" prop="phone">
              <el-input v-model="form.phone" placeholder="请输入电话" />
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="简介" prop="intro">
              <el-input v-model="form.intro" type="textarea" :rows="3" placeholder="请输入简介" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="排序" prop="sortOrder">
              <el-input-number v-model="form.sortOrder" :min="0" controls-position="right" style="width: 100%;" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="状态" prop="status">
              <el-radio-group v-model="form.status">
                <el-radio :value="0">正常</el-radio>
                <el-radio :value="1">停用</el-radio>
              </el-radio-group>
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

<script setup name="MedicalDepartment">
import { listMedicalDepartments, addMedicalDepartment, updateMedicalDepartment, delMedicalDepartment } from '@/api/medical/department'

const { proxy } = getCurrentInstance()

const loading = ref(false)
const showSearch = ref(true)

const deptTree = ref([])
const deptOptions = ref([])

const queryParams = ref({
  deptName: undefined,
  deptCode: undefined,
  status: undefined
})

const open = ref(false)
const title = ref('')
const form = ref({})
const rules = ref({
  deptName: [{ required: true, message: '科室名称不能为空', trigger: 'blur' }],
  deptCode: [{ required: true, message: '科室编码不能为空', trigger: 'blur' }],
  parentId: [{ required: true, message: '父科室不能为空', trigger: 'change' }],
  deptType: [{ required: true, message: '科室类型不能为空', trigger: 'change' }],
  sortOrder: [{ required: true, message: '排序不能为空', trigger: 'blur' }],
  status: [{ required: true, message: '状态不能为空', trigger: 'change' }]
})

function deptTypeLabel(value) {
  const map = { 1: '门诊', 2: '急诊', 3: '住院', 4: '医技' }
  return map[value] || '-'
}

function resetFormData() {
  form.value = {
    deptId: undefined,
    deptName: undefined,
    deptCode: undefined,
    parentId: 0,
    deptType: 1,
    location: undefined,
    phone: undefined,
    intro: undefined,
    sortOrder: 0,
    status: 0
  }
  proxy.resetForm('formRef')
}

function getList() {
  loading.value = true
  listMedicalDepartments({ ...queryParams.value, pageNum: 1, pageSize: 9999 }).then(res => {
    const rows = res.rows || []
    deptOptions.value = rows
    deptTree.value = proxy.handleTree(rows, 'deptId', 'parentId', 'children')
    loading.value = false
  }).catch(() => {
    loading.value = false
  })
}

function handleQuery() {
  getList()
}

function resetQuery() {
  proxy.resetForm('queryRef')
  handleQuery()
}

function handleAdd() {
  resetFormData()
  open.value = true
  title.value = '新增科室'
}

function handleUpdate(row) {
  resetFormData()
  form.value = { ...form.value, ...row }
  open.value = true
  title.value = '修改科室'
}

function cancel() {
  open.value = false
  resetFormData()
}

function submitForm() {
  proxy.$refs['formRef'].validate(valid => {
    if (!valid) return
    const payload = { ...form.value }
    if (payload.deptId) {
      updateMedicalDepartment(payload.deptId, payload).then(() => {
        proxy.$modal.msgSuccess('修改成功')
        open.value = false
        getList()
      })
      return
    }
    addMedicalDepartment(payload).then(() => {
      proxy.$modal.msgSuccess('新增成功')
      open.value = false
      getList()
    })
  })
}

function handleDelete(row) {
  const deptId = row.deptId
  proxy.$modal.confirm(`是否确认删除科室ID为"${deptId}"的数据项？`).then(() => {
    return delMedicalDepartment(deptId)
  }).then(() => {
    proxy.$modal.msgSuccess('删除成功')
    getList()
  }).catch(() => {})
}

getList()
</script>
