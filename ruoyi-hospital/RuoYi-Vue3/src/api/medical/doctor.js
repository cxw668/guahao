import request from '@/utils/request'

export function listMedicalDoctors(query) {
  return request({
    url: '/medical/doctors',
    method: 'get',
    params: query
  })
}

export function getMedicalDoctor(doctorId) {
  return request({
    url: `/medical/doctors/${doctorId}`,
    method: 'get'
  })
}

export function addMedicalDoctor(data) {
  return request({
    url: '/medical/doctors',
    method: 'post',
    data
  })
}

export function updateMedicalDoctor(doctorId, data) {
  return request({
    url: `/medical/doctors/${doctorId}`,
    method: 'patch',
    data
  })
}

export function delMedicalDoctor(doctorId) {
  return request({
    url: `/medical/doctors/${doctorId}`,
    method: 'delete'
  })
}
