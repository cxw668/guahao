<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="预约单号" prop="appointmentNo">
        <el-input
          v-model="queryParams.appointmentNo"
          placeholder="请输入预约单号"
          clearable
          style="width: 240px;"
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="患者ID" prop="patientId">
        <el-input
          v-model="queryParams.patientId"
          placeholder="请输入患者ID"
          clearable
          style="width: 240px;"
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="医生" prop="doctorId">
        <el-select v-model="queryParams.doctorId" placeholder="请选择医生" clearable style="width: 240px;">
          <el-option v-for="d in doctorOptions" :key="d.doctorId" :label="d.doctorName" :value="d.doctorId" />
        </el-select>
      </el-form-item>
      <el-form-item label="就诊日期" prop="appointmentDate">
        <el-date-picker
          v-model="queryParams.appointmentDate"
          type="date"
          value-format="YYYY-MM-DD"
          placeholder="请选择日期"
          style="width: 240px;"
          clearable
        />
      </el-form-item>
      <el-form-item label="状态" prop="status">
        <el-select v-model="queryParams.status" placeholder="请选择状态" clearable style="width: 240px;">
          <el-option label="待支付" :value="0" />
          <el-option label="待就诊" :value="1" />
          <el-option label="就诊中" :value="2" />
          <el-option label="已完成" :value="3" />
          <el-option label="已取消" :value="4" />
          <el-option label="失约" :value="5" />
        </el-select>
      </el-form-item>
      <el-form-item label="支付状态" prop="payStatus">
        <el-select v-model="queryParams.payStatus" placeholder="请选择支付状态" clearable style="width: 240px;">
          <el-option label="未支付" :value="0" />
          <el-option label="已支付" :value="1" />
          <el-option label="已退款" :value="2" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
        <el-button icon="Refresh" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-table v-loading="loading" :data="appointmentList" style="margin-top: 20px;">
      <el-table-column label="预约ID" align="center" prop="appointmentId" width="90" />
      <el-table-column label="预约单号" align="center" prop="appointmentNo" width="170" :show-overflow-tooltip="true" />
      <el-table-column label="患者ID" align="center" prop="patientId" width="90" />
      <el-table-column label="就诊人ID" align="center" prop="visitorId" width="100" />
      <el-table-column label="医生" align="center" prop="doctorId" width="120">
        <template #default="scope">
          <span>{{ doctorNameById(scope.row.doctorId) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="日期" align="center" prop="appointmentDate" width="120" />
      <el-table-column label="时段" align="center" prop="period" width="80">
        <template #default="scope">
          <span>{{ periodLabel(scope.row.period) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="时间段" align="center" prop="timeSlot" width="120" />
      <el-table-column label="费用" align="center" prop="fee" width="90" />
      <el-table-column label="支付" align="center" prop="payStatus" width="80">
        <template #default="scope">
          <el-tag v-if="scope.row.payStatus === 0" type="info">未付</el-tag>
          <el-tag v-else-if="scope.row.payStatus === 1" type="success">已付</el-tag>
          <el-tag v-else type="warning">退款</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="状态" align="center" prop="status" width="90">
        <template #default="scope">
          <span>{{ statusLabel(scope.row.status) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="创建时间" align="center" prop="createTime" width="180">
        <template #default="scope">
          <span>{{ parseTime(scope.row.createTime) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" width="260" fixed="right">
        <template #default="scope">
          <el-button link type="primary" @click="openPayDialog(scope.row)">支付</el-button>
          <el-button link type="warning" @click="openCancelDialog(scope.row)">取消</el-button>
          <el-button link type="success" @click="handleCheckin(scope.row)">签到</el-button>
          <el-button link type="success" @click="handleFinish(scope.row)">完成</el-button>
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

    <el-dialog v-model="payOpen" title="预约支付" width="520px" append-to-body>
      <el-form ref="payFormRef" :model="payForm" :rules="payRules" label-width="90px">
        <el-form-item label="支付方式" prop="payWay">
          <el-select v-model="payForm.payWay" placeholder="请选择支付方式" style="width: 100%;">
            <el-option label="微信" value="wechat" />
            <el-option label="支付宝" value="alipay" />
          </el-select>
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button type="primary" @click="submitPay">确 定</el-button>
          <el-button @click="payCancel">取 消</el-button>
        </div>
      </template>
    </el-dialog>

    <el-dialog v-model="cancelOpen" title="取消预约" width="560px" append-to-body>
      <el-form ref="cancelFormRef" :model="cancelForm" :rules="cancelRules" label-width="90px">
        <el-form-item label="取消原因" prop="cancelReason">
          <el-input v-model="cancelForm.cancelReason" type="textarea" :rows="3" placeholder="请输入取消原因" />
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button type="primary" @click="submitCancel">确 定</el-button>
          <el-button @click="cancelCancel">取 消</el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup name="MedicalAppointment">
import { listMedicalDoctors } from '@/api/medical/doctor'
import { listMedicalAppointments, payMedicalAppointment, cancelMedicalAppointment, checkinMedicalAppointment, finishMedicalAppointment } from '@/api/medical/appointment'

const { proxy } = getCurrentInstance()

const loading = ref(false)
const showSearch = ref(true)
const total = ref(0)
const appointmentList = ref([])
const doctorOptions = ref([])

const queryParams = ref({
  pageNum: 1,
  pageSize: 10,
  appointmentNo: undefined,
  patientId: undefined,
  doctorId: undefined,
  appointmentDate: undefined,
  status: undefined,
  payStatus: undefined
})

const payOpen = ref(false)
const payForm = ref({})
const payRules = ref({
  payWay: [{ required: true, message: '支付方式不能为空', trigger: 'change' }]
})
const payAppointmentId = ref(undefined)

const cancelOpen = ref(false)
const cancelForm = ref({})
const cancelRules = ref({
  cancelReason: [{ required: true, message: '取消原因不能为空', trigger: 'blur' }]
})
const cancelAppointmentId = ref(undefined)

function statusLabel(value) {
  const map = { 0: '待支付', 1: '待就诊', 2: '就诊中', 3: '已完成', 4: '已取消', 5: '失约' }
  return map[value] || '-'
}

function periodLabel(value) {
  const map = { 1: '上午', 2: '下午', 3: '晚间' }
  return map[value] || '-'
}

function doctorNameById(doctorId) {
  const found = doctorOptions.value.find(d => d.doctorId === doctorId)
  return found ? found.doctorName : doctorId
}

function getDoctorOptions() {
  listMedicalDoctors({ pageNum: 1, pageSize: 9999 }).then(res => {
    doctorOptions.value = res.rows || []
  })
}

function getList() {
  loading.value = true
  listMedicalAppointments(queryParams.value).then(res => {
    appointmentList.value = res.rows || []
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

function openPayDialog(row) {
  payAppointmentId.value = row.appointmentId
  payForm.value = { payWay: 'wechat' }
  proxy.resetForm('payFormRef')
  payOpen.value = true
}

function payCancel() {
  payOpen.value = false
  payAppointmentId.value = undefined
  payForm.value = {}
}

function submitPay() {
  proxy.$refs['payFormRef'].validate(valid => {
    if (!valid) return
    const appointmentId = payAppointmentId.value
    payMedicalAppointment(appointmentId, { payWay: payForm.value.payWay }).then(() => {
      proxy.$modal.msgSuccess('支付成功')
      payCancel()
      getList()
    })
  })
}

function openCancelDialog(row) {
  cancelAppointmentId.value = row.appointmentId
  cancelForm.value = { cancelReason: '' }
  proxy.resetForm('cancelFormRef')
  cancelOpen.value = true
}

function cancelCancel() {
  cancelOpen.value = false
  cancelAppointmentId.value = undefined
  cancelForm.value = {}
}

function submitCancel() {
  proxy.$refs['cancelFormRef'].validate(valid => {
    if (!valid) return
    const appointmentId = cancelAppointmentId.value
    cancelMedicalAppointment(appointmentId, { cancelReason: cancelForm.value.cancelReason }).then(() => {
      proxy.$modal.msgSuccess('取消成功')
      cancelCancel()
      getList()
    })
  })
}

function handleCheckin(row) {
  const appointmentId = row.appointmentId
  proxy.$modal.confirm(`是否确认签到预约ID为"${appointmentId}"的数据项？`).then(() => {
    return checkinMedicalAppointment(appointmentId)
  }).then(() => {
    proxy.$modal.msgSuccess('签到成功')
    getList()
  }).catch(() => {})
}

function handleFinish(row) {
  const appointmentId = row.appointmentId
  proxy.$modal.confirm(`是否确认完成预约ID为"${appointmentId}"的数据项？`).then(() => {
    return finishMedicalAppointment(appointmentId)
  }).then(() => {
    proxy.$modal.msgSuccess('完成成功')
    getList()
  }).catch(() => {})
}

getDoctorOptions()
getList()
</script>
