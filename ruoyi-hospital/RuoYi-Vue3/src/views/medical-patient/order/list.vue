<template>
  <div class="patient-page">
    <el-card class="mb16">
      <template #header>
        <div class="header">
          <div class="header__left">
            <el-button text @click="router.push('/medical-patient/home')"><el-icon><Back/></el-icon>返回</el-button>
            <span class="header__title">我的预约</span>
          </div>
        </div>
      </template>

      <el-form :model="queryParams" class="search-form">
        <el-row :gutter="10">
          <el-col :xs="24" :sm="8" :md="6">
            <el-form-item label="状态" prop="status">
              <el-select v-model="queryParams.status" placeholder="全部" clearable style="width: 100%;">
                <el-option label="待支付" :value="0" />
                <el-option label="待就诊" :value="1" />
                <el-option label="就诊中" :value="2" />
                <el-option label="已完成" :value="3" />
                <el-option label="已取消" :value="4" />
                <el-option label="失约" :value="5" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :xs="24" :sm="8" :md="6">
            <el-form-item label="支付" prop="payStatus">
              <el-select v-model="queryParams.payStatus" placeholder="全部" clearable style="width: 100%;">
                <el-option label="未支付" :value="0" />
                <el-option label="已支付" :value="1" />
                <el-option label="已退款" :value="2" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :xs="24" :sm="8" :md="12">
            <el-form-item label-width="0">
              <div class="search-btns">
                <el-button type="primary" icon="Search" @click="handleQuery">查询</el-button>
                <el-button icon="Refresh" @click="resetQuery">重置</el-button>
              </div>
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
    </el-card>

    <div v-loading="loading" class="order-list">
      <el-row :gutter="12">
        <el-col v-for="order in orderList" :key="order.appointmentId" :xs="24" :sm="12" :md="8" :lg="8">
          <el-card shadow="hover" class="order-card mb16">
            <template #header>
              <div class="order-header">
                <span class="order-no">订单号：{{ order.appointmentNo }}</span>
                <div class="header-tags">
                  <el-tag v-if="isExpired(order.appointmentDate)" class="mr-2" type="danger" size="small" effect="plain">已过期</el-tag>
                  <el-tag :type="statusTagType(order.status)" size="small">{{ statusText(order.status) }}</el-tag>
                </div>
              </div>
            </template>
            
            <div class="order-content" @click="openDetail(order)">
              <div class="order-item">
                <span class="label">就诊时间</span>
                <span class="value">{{ order.appointmentDate }} {{ periodText(order.period) }}</span>
              </div>
              <div class="order-item">
                <span class="label">具体时段</span>
                <span class="value">{{ order.timeSlot || '—' }}</span>
              </div>
              <div class="order-item">
                <span class="label">挂号费用</span>
                <span class="value fee">¥{{ order.fee ?? 0 }}</span>
              </div>
              <div class="order-item">
                <span class="label">支付状态</span>
                <span class="value">
                  <el-tag :type="payTagType(order.payStatus)" size="small" effect="plain">
                    {{ payText(order.payStatus) }}
                  </el-tag>
                </span>
              </div>
            </div>

            <div class="order-footer">
              <el-button link type="primary" size="small" @click="openDetail(order)">查看详情</el-button>
              <div class="actions">
                <el-button
                  v-if="order.payStatus === 0 && order.status === 0"
                  type="success"
                  size="small"
                  plain
                  :disabled="isExpired(order.appointmentDate)"
                  @click="openPay(order)"
                >
                  去支付
                </el-button>
                <el-button
                  v-if="order.status === 1 && order.payStatus === 1"
                  type="warning"
                  size="small"
                  plain
                  :disabled="isExpired(order.appointmentDate)"
                  @click="checkin(order)"
                >
                  签到
                </el-button>
                <el-button
                  v-if="order.status === 0 || order.status === 1"
                  type="danger"
                  size="small"
                  plain
                  :disabled="isExpired(order.appointmentDate)"
                  @click="cancelOrder(order)"
                >
                  取消
                </el-button>
              </div>
            </div>
          </el-card>
        </el-col>
      </el-row>

      <el-empty v-if="!loading && orderList.length === 0" description="暂无预约记录" />

      <pagination
        v-show="total > 0"
        :total="total"
        v-model:page="queryParams.pageNum"
        v-model:limit="queryParams.pageSize"
        @pagination="getList"
      />
    </div>

    <el-dialog 
      v-model="detailOpen" 
      title="订单详情" 
      width="90%" 
      :style="{ maxWidth: '520px' }"
      append-to-body
      class="mobile-dialog"
    >
      <div v-if="detail" class="detail-container">
        <el-descriptions :column="1" border>
          <el-descriptions-item label="订单号">{{ detail.appointmentNo }}</el-descriptions-item>
          <el-descriptions-item label="状态">{{ statusText(detail.status) }}</el-descriptions-item>
          <el-descriptions-item label="就诊日期">{{ detail.appointmentDate }}</el-descriptions-item>
          <el-descriptions-item label="时段">{{ periodText(detail.period) }}</el-descriptions-item>
          <el-descriptions-item label="时间">{{ detail.timeSlot || '—' }}</el-descriptions-item>
          <el-descriptions-item label="费用"><span class="fee">{{ detail.fee ?? 0 }}</span></el-descriptions-item>
          <el-descriptions-item label="支付状态">{{ payText(detail.payStatus) }}</el-descriptions-item>
          <el-descriptions-item label="支付方式">{{ detail.payWay || '—' }}</el-descriptions-item>
          <el-descriptions-item label="取消原因" v-if="detail.cancelReason">{{ detail.cancelReason }}</el-descriptions-item>
        </el-descriptions>
      </div>
      <el-empty v-else description="暂无详情" />
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="detailOpen = false" style="width: 100%">关闭</el-button>
        </div>
      </template>
    </el-dialog>

    <el-dialog v-model="payOpen" title="订单支付" width="520px" append-to-body>
      <el-form :model="payForm" label-width="90px">
        <el-form-item label="支付方式" required>
          <el-radio-group v-model="payForm.payWay">
            <el-radio value="wechat">微信</el-radio>
            <el-radio value="alipay">支付宝</el-radio>
          </el-radio-group>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="payOpen = false">取消</el-button>
        <el-button type="primary" :loading="paying" @click="doPay">确认支付</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup name="MedicalPatientOrderList">
import { ElMessage, ElMessageBox } from 'element-plus'
import {
  cancelMedicalAppointment,
  checkinMedicalAppointment,
  getMedicalAppointment,
  listMedicalAppointments,
  payMedicalAppointment
} from '@/api/medical/appointment'
import useUserStore from '@/store/modules/user'
import {Back} from "@element-plus/icons-vue";

/**
 * 患者端-我的预约：展示个人预约订单，支持支付/取消/签到与详情查看。
 */
const router = useRouter()
const userStore = useUserStore()

const loading = ref(false)
const total = ref(0)
const orderList = ref([])

const queryParams = ref({
  pageNum: 1,
  pageSize: 10,
  patientId: undefined,
  status: undefined,
  payStatus: undefined
})

const detailOpen = ref(false)
const detail = ref(null)

const payOpen = ref(false)
const paying = ref(false)
const payForm = ref({
  appointmentId: undefined,
  payWay: 'wechat'
})

function statusText(status) {
  if (status === 0) return '待支付'
  if (status === 1) return '待就诊'
  if (status === 2) return '就诊中'
  if (status === 3) return '已完成'
  if (status === 4) return '已取消'
  if (status === 5) return '失约'
  return '未知'
}

function statusTagType(status) {
  if (status === 0) return 'warning'
  if (status === 1) return 'success'
  if (status === 2) return 'primary'
  if (status === 3) return 'info'
  if (status === 4) return 'danger'
  return 'info'
}

function isExpired(dateStr) {
  if (!dateStr) return false
  const now = new Date()
  const year = now.getFullYear()
  const month = String(now.getMonth() + 1).padStart(2, '0')
  const day = String(now.getDate()).padStart(2, '0')
  const today = `${year}-${month}-${day}`
  // 如果预约日期小于今天，则视为过期
  // 注意：字符串比较 '2023-10-20' < '2023-10-21' 是有效的
  return dateStr < today
}

function payText(payStatus) {
  if (payStatus === 0) return '未支付'
  if (payStatus === 1) return '已支付'
  if (payStatus === 2) return '已退款'
  return '未知'
}

function payTagType(payStatus) {
  if (payStatus === 0) return 'warning'
  if (payStatus === 1) return 'success'
  if (payStatus === 2) return 'info'
  return 'info'
}

function periodText(period) {
  if (period === 1) return '上午'
  if (period === 2) return '下午'
  if (period === 3) return '晚间'
  return '—'
}

function handleQuery() {
  queryParams.value.pageNum = 1
  getList()
}

function resetQuery() {
  queryParams.value.status = undefined
  queryParams.value.payStatus = undefined
  handleQuery()
}

async function getList() {
  const patientId = Number(userStore.id)
  if (!Number.isFinite(patientId)) {
    orderList.value = []
    total.value = 0
    return
  }
  queryParams.value.patientId = patientId
  loading.value = true
  try {
    const res = await listMedicalAppointments(queryParams.value)
    orderList.value = Array.isArray(res?.rows) ? res.rows : []
    total.value = typeof res?.total === 'number' ? res.total : 0
  } finally {
    loading.value = false
  }
}

async function openDetail(row) {
  detailOpen.value = true
  detail.value = null
  const id = row?.appointmentId
  if (!Number.isFinite(id)) return
  const res = await getMedicalAppointment(id)
  detail.value = res?.data || null
}

function openPay(row) {
  payForm.value.appointmentId = row?.appointmentId
  payForm.value.payWay = 'wechat'
  payOpen.value = true
}

async function doPay() {
  const appointmentId = payForm.value.appointmentId
  if (!Number.isFinite(appointmentId)) return
  paying.value = true
  try {
    await payMedicalAppointment(appointmentId, { payWay: payForm.value.payWay })
    ElMessage.success('支付成功')
    payOpen.value = false
    getList()
  } finally {
    paying.value = false
  }
}

async function cancelOrder(row) {
  const appointmentId = row?.appointmentId
  if (!Number.isFinite(appointmentId)) return
  let value = ''
  try {
    const res = await ElMessageBox.prompt('请输入取消原因', '取消预约', {
      confirmButtonText: '确认取消',
      cancelButtonText: '返回',
      inputPlaceholder: '如：临时有事无法前往',
      inputPattern: /^.{2,200}$/,
      inputErrorMessage: '取消原因长度需在 2-200 之间'
    })
    value = res?.value || ''
  } catch {
    return
  }
  await cancelMedicalAppointment(appointmentId, { cancelReason: value })
  ElMessage.success('已取消')
  getList()
}

async function checkin(row) {
  const appointmentId = row?.appointmentId
  if (!Number.isFinite(appointmentId)) return
  await checkinMedicalAppointment(appointmentId)
  ElMessage.success('签到成功')
  getList()
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

.fee {
  color: #f56c6c;
  font-weight: 700;
}

.order-list {
  min-height: 400px;
}

.order-card {
  transition: all 0.3s;
  
  &:hover {
    transform: translateY(-4px);
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  }

  :deep(.el-card__header) {
    padding: 12px 16px;
    background-color: #fafafa;
  }

  :deep(.el-card__body) {
    padding: 16px;
  }
}

.order-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.header-tags {
  display: flex;
  align-items: center;
}

.mr-2 {
  margin-right: 8px;
}

.order-no {
  font-size: 13px;
  color: #606266;
  font-weight: 500;
}

.order-content {
  cursor: pointer;
}

.order-item {
  display: flex;
  justify-content: space-between;
  margin-bottom: 8px;
  font-size: 14px;
  
  &:last-child {
    margin-bottom: 0;
  }
  
  .label {
    color: #909399;
  }
  
  .value {
    color: #303133;
    font-weight: 500;
  }
}

.order-footer {
  margin-top: 16px;
  padding-top: 12px;
  border-top: 1px solid #ebeef5;
  display: flex;
  justify-content: space-between;
  align-items: center;
  
  .actions {
    display: flex;
    gap: 8px;
  }
}

.search-form {
  :deep(.el-form-item) {
    margin-bottom: 12px;
    margin-right: 0;
  }
  
  :deep(.el-select) {
    width: 100%;
  }
}

.search-btns {
  display: flex;
  gap: 8px;
  
  @media screen and (max-width: 768px) {
    width: 100%;
    
    .el-button {
      flex: 1;
    }
  }
}

.mobile-dialog {
  border-radius: 8px;
  
  :deep(.el-dialog__body) {
    padding: 10px 16px;
    max-height: 70vh;
    overflow-y: auto;
  }
  
  :deep(.el-descriptions__label) {
    width: 80px;
    color: #909399;
  }
}

.dialog-footer {
  width: 100%;
}
</style>
