import request from './request'

export const loginUser = (phone, password) =>
  request.post('/auth/login', { phone, password })

export const registerUser = (phone, code, password) =>
  request.post('/auth/register', { phone, code, password })
