import request from '@/utils/request'

export function listMedicalSchedules(query) {
  return request({
    url: '/medical/schedules',
    method: 'get',
    params: query
  })
}

export function getMedicalSchedule(scheduleId) {
  return request({
    url: `/medical/schedules/${scheduleId}`,
    method: 'get'
  })
}

export function addMedicalSchedule(data) {
  return request({
    url: '/medical/schedules',
    method: 'post',
    data
  })
}

export function updateMedicalSchedule(scheduleId, data) {
  return request({
    url: `/medical/schedules/${scheduleId}`,
    method: 'patch',
    data
  })
}

export function delMedicalSchedule(scheduleId) {
  return request({
    url: `/medical/schedules/${scheduleId}`,
    method: 'delete'
  })
}
