import request from '@/utils/request'

export function listMedicalPatientVisitors(query) {
  return request({
    url: '/medical/patient-visitors',
    method: 'get',
    params: query
  })
}

export function getMedicalPatientVisitor(visitorId) {
  return request({
    url: `/medical/patient-visitors/${visitorId}`,
    method: 'get'
  })
}

export function addMedicalPatientVisitor(data) {
  return request({
    url: '/medical/patient-visitors',
    method: 'post',
    data
  })
}

export function updateMedicalPatientVisitor(visitorId, data) {
  return request({
    url: `/medical/patient-visitors/${visitorId}`,
    method: 'patch',
    data
  })
}

export function delMedicalPatientVisitor(visitorId) {
  return request({
    url: `/medical/patient-visitors/${visitorId}`,
    method: 'delete'
  })
}
