import request from '@/utils/request'

export function listMedicalAppointments(query) {
  return request({
    url: '/medical/appointments',
    method: 'get',
    params: query
  })
}

export function getMedicalAppointment(appointmentId) {
  return request({
    url: `/medical/appointments/${appointmentId}`,
    method: 'get'
  })
}

export function addMedicalAppointment(data) {
  return request({
    url: '/medical/appointments',
    method: 'post',
    data
  })
}

export function updateMedicalAppointment(appointmentId, data) {
  return request({
    url: `/medical/appointments/${appointmentId}`,
    method: 'patch',
    data
  })
}

export function cancelMedicalAppointment(appointmentId, data) {
  return request({
    url: `/medical/appointments/${appointmentId}/cancellation`,
    method: 'patch',
    data
  })
}

export function payMedicalAppointment(appointmentId, data) {
  return request({
    url: `/medical/appointments/${appointmentId}/payment`,
    method: 'patch',
    data
  })
}

export function checkinMedicalAppointment(appointmentId) {
  return request({
    url: `/medical/appointments/${appointmentId}/check-in`,
    method: 'patch'
  })
}

export function finishMedicalAppointment(appointmentId) {
  return request({
    url: `/medical/appointments/${appointmentId}/completion`,
    method: 'patch'
  })
}

/**
 * 查询患者当天取消预约次数
 * @param patientId 患者 ID
 */
export function getTodayCancelCount(patientId) {
  return request({
    url: '/medical/appointments/cancel-count',
    method: 'get',
    params: { patientId }
  })
}
