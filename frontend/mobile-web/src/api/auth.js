import request from './request'

export function loginUser(phone, password) {
  return request.post('/auth/login', { phone, password })
}

export function registerUser(phone, code, password) {
  return request.post('/auth/register', { phone, code, password })
}
