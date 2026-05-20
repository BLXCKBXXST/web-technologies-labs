import client from './client.js'

// Функции обращения к эндпоинтам авторизации и профиля.
export const register = (data) => client.post('/auth/register/', data)
export const requestCode = (email) => client.post('/auth/request-code/', { email })
export const verify = (email, code) => client.post('/auth/verify/', { email, code })
export const getMe = () => client.get('/auth/me/')
export const updateMe = (data) => client.patch('/auth/me/', data)
