import request from '@/utils/request'

export function listMedicalDepartments(query) {
  return request({
    url: '/medical/departments',
    method: 'get',
    params: query
  })
}

export function getMedicalDepartment(deptId) {
  return request({
    url: `/medical/departments/${deptId}`,
    method: 'get'
  })
}

export function addMedicalDepartment(data) {
  return request({
    url: '/medical/departments',
    method: 'post',
    data
  })
}

export function updateMedicalDepartment(deptId, data) {
  return request({
    url: `/medical/departments/${deptId}`,
    method: 'patch',
    data
  })
}

export function delMedicalDepartment(deptId) {
  return request({
    url: `/medical/departments/${deptId}`,
    method: 'delete'
  })
}
