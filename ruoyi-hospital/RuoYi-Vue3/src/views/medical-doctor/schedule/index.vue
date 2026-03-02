<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="医生" prop="doctorId">
        <el-select v-model="queryParams.doctorId" placeholder="请选择医生" clearable style="width: 240px;">
          <el-option v-for="d in doctorOptions" :key="d.doctorId" :label="d.doctorName" :value="d.doctorId" />
        </el-select>
      </el-form-item>
      <el-form-item label="日期" prop="workDate">
        <el-date-picker
          v-model="queryParams.workDate"
          type="date"
          value-format="YYYY-MM-DD"
          placeholder="请选择日期"
          style="width: 240px;"
          clearable
        />
      </el-form-item>
      <el-form-item label="时段" prop="period">
        <el-select v-model="queryParams.period" placeholder="请选择时段" clearable style="width: 240px;">
          <el-option label="上午" :value="1" />
          <el-option label="下午" :value="2" />
          <el-option label="晚间" :value="3" />
        </el-select>
      </el-form-item>
      <el-form-item label="状态" prop="status">
        <el-select v-model="queryParams.status" placeholder="请选择状态" clearable style="width: 240px;">
          <el-option label="正常" :value="0" />
          <el-option label="停诊" :value="1" />
          <el-option label="已满" :value="2" />
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
      <right-toolbar v-model:showSearch="showSearch" @queryTable="getList" />
    </el-row>

    <el-table v-loading="loading" :data="scheduleList">
      <el-table-column label="排班ID" align="center" prop="scheduleId" width="90" />
      <el-table-column label="医生" align="center" prop="doctorId" width="140">
        <template #default="scope">
          <span>{{ doctorNameById(scope.row.doctorId) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="日期" align="center" prop="workDate" width="120" />
      <el-table-column label="时段" align="center" prop="period" width="90">
        <template #default="scope">
          <span>{{ periodLabel(scope.row.period) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="开始" align="center" prop="startTime" width="110" />
      <el-table-column label="结束" align="center" prop="endTime" width="110" />
      <el-table-column label="总号源" align="center" prop="totalSlots" width="90" />
      <el-table-column label="已约" align="center" prop="bookedSlots" width="80" />
      <el-table-column label="号源时长" align="center" prop="slotMinutes" width="90" />
      <el-table-column label="状态" align="center" prop="status" width="90">
        <template #default="scope">
          <el-tag v-if="scope.row.status === 0" type="success">正常</el-tag>
          <el-tag v-else-if="scope.row.status === 1" type="warning">停诊</el-tag>
          <el-tag v-else type="info">已满</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" width="180" fixed="right">
        <template #default="scope">
          <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)">修改</el-button>
          <el-button link type="danger" icon="Delete" @click="handleDelete(scope.row)">删除</el-button>
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

    <el-dialog v-model="open" :title="title" width="760px" append-to-body>
      <el-form ref="formRef" :model="form" :rules="rules" label-width="90px">
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="医生" prop="doctorId">
              <el-select v-model="form.doctorId" placeholder="请选择医生" style="width: 100%;">
                <el-option v-for="d in doctorOptions" :key="d.doctorId" :label="d.doctorName" :value="d.doctorId" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="日期" prop="workDate">
              <el-date-picker v-model="form.workDate" type="date" value-format="YYYY-MM-DD" placeholder="请选择日期" style="width: 100%;" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="时段" prop="period">
              <el-select v-model="form.period" placeholder="请选择时段" style="width: 100%;">
                <el-option label="上午" :value="1" />
                <el-option label="下午" :value="2" />
                <el-option label="晚间" :value="3" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="状态" prop="status">
              <el-select v-model="form.status" placeholder="请选择状态" style="width: 100%;">
                <el-option label="正常" :value="0" />
                <el-option label="停诊" :value="1" />
                <el-option label="已满" :value="2" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="开始时间" prop="startTime">
              <el-time-picker v-model="form.startTime" value-format="HH:mm:ss" placeholder="开始时间" style="width: 100%;" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="结束时间" prop="endTime">
              <el-time-picker v-model="form.endTime" value-format="HH:mm:ss" placeholder="结束时间" style="width: 100%;" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="总号源" prop="totalSlots">
              <el-input-number v-model="form.totalSlots" :min="0" controls-position="right" style="width: 100%;" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="已约" prop="bookedSlots">
              <el-input-number v-model="form.bookedSlots" :min="0" controls-position="right" style="width: 100%;" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="号源时长" prop="slotMinutes">
              <el-input-number v-model="form.slotMinutes" :min="5" controls-position="right" style="width: 100%;" />
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

<script setup name="DoctorSchedule">
import useUserStore from '@/store/modules/user'
import { listMedicalDoctors } from '@/api/medical/doctor'
import { listMedicalSchedules, addMedicalSchedule, updateMedicalSchedule, delMedicalSchedule } from '@/api/medical/schedule'

const userStore = useUserStore()
const { proxy } = getCurrentInstance()

const loading = ref(false)
const showSearch = ref(true)
const total = ref(0)
const scheduleList = ref([])
const doctorOptions = ref([])

const queryParams = ref({
  pageNum: 1,
  pageSize: 10,
  doctorId: undefined,
  workDate: undefined,
  period: undefined,
  status: undefined
})

const open = ref(false)
const title = ref('')
const form = ref({})
const rules = ref({
  doctorId: [{ required: true, message: '医生不能为空', trigger: 'change' }],
  workDate: [{ required: true, message: '日期不能为空', trigger: 'change' }],
  period: [{ required: true, message: '时段不能为空', trigger: 'change' }],
  startTime: [{ required: true, message: '开始时间不能为空', trigger: 'change' }],
  endTime: [{ required: true, message: '结束时间不能为空', trigger: 'change' }],
  totalSlots: [{ required: true, message: '总号源不能为空', trigger: 'blur' }],
  slotMinutes: [{ required: true, message: '号源时长不能为空', trigger: 'blur' }],
  status: [{ required: true, message: '状态不能为空', trigger: 'change' }]
})

function periodLabel(value) {
  const map = { 1: '上午', 2: '下午', 3: '晚间' }
  return map[value] || '-'
}

function doctorNameById(doctorId) {
  const found = doctorOptions.value.find(d => d.doctorId === doctorId)
  return found ? found.doctorName : doctorId
}

function resetFormData() {
  form.value = {
    scheduleId: undefined,
    doctorId: queryParams.value.doctorId,
    workDate: undefined,
    period: 1,
    startTime: undefined,
    endTime: undefined,
    totalSlots: 0,
    bookedSlots: 0,
    slotMinutes: 30,
    status: 0
  }
  proxy.resetForm('formRef')
}

function getDoctorOptions() {
  return listMedicalDoctors({ pageNum: 1, pageSize: 9999, status: 0 }).then(res => {
    doctorOptions.value = res.rows || []
    if (!queryParams.value.doctorId) {
      const match = doctorOptions.value.find(d => String(d.doctorId) === String(userStore.id))
      queryParams.value.doctorId = match ? match.doctorId : (doctorOptions.value[0]?.doctorId ?? undefined)
    }
  })
}

function getList() {
  loading.value = true
  listMedicalSchedules(queryParams.value).then(res => {
    scheduleList.value = res.rows || []
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
  resetFormData()
  open.value = true
  title.value = '新增排班'
}

function handleUpdate(row) {
  resetFormData()
  form.value = { ...form.value, ...row }
  open.value = true
  title.value = '修改排班'
}

function cancel() {
  open.value = false
  resetFormData()
}

function submitForm() {
  proxy.$refs['formRef'].validate(valid => {
    if (!valid) return
    const payload = { ...form.value }
    if (payload.scheduleId) {
      updateMedicalSchedule(payload.scheduleId, payload).then(() => {
        proxy.$modal.msgSuccess('修改成功')
        open.value = false
        getList()
      })
      return
    }
    addMedicalSchedule(payload).then(() => {
      proxy.$modal.msgSuccess('新增成功')
      open.value = false
      getList()
    })
  })
}

function handleDelete(row) {
  const scheduleId = row.scheduleId
  proxy.$modal.confirm(`是否确认删除排班ID为"${scheduleId}"的数据项？`).then(() => {
    return delMedicalSchedule(scheduleId)
  }).then(() => {
    proxy.$modal.msgSuccess('删除成功')
    getList()
  }).catch(() => {})
}

getDoctorOptions().then(() => getList())
</script>
