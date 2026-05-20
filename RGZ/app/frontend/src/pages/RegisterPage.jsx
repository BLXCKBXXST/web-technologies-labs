import { useState } from 'react'
import { Navigate, useNavigate } from 'react-router-dom'
import AuthLayout from '../components/auth/AuthLayout.jsx'
import CodeVerifyForm from '../components/auth/CodeVerifyForm.jsx'
import TextField from '../components/ui/TextField.jsx'
import Button from '../components/ui/Button.jsx'
import { useAuth } from '../context/AuthContext.jsx'
import { register, requestCode } from '../api/auth.js'
import { extractError, extractFieldErrors } from '../api/errors.js'

// Экран регистрации: шаг 1 — анкета, шаг 2 — ввод кода из письма.
export default function RegisterPage() {
  const { isAuthenticated, login } = useAuth()
  const navigate = useNavigate()
  const [step, setStep] = useState('form')
  const [form, setForm] = useState({ email: '', last_name: '', first_name: '' })
  const [errors, setErrors] = useState({})
  const [formError, setFormError] = useState('')
  const [loading, setLoading] = useState(false)

  if (isAuthenticated) {
    return <Navigate to="/" replace />
  }

  const update = (field) => (e) => setForm({ ...form, [field]: e.target.value })

  const submitForm = async (e) => {
    e.preventDefault()
    setErrors({})
    setFormError('')
    setLoading(true)
    try {
      await register(form)
      setStep('code')
    } catch (err) {
      setErrors(extractFieldErrors(err))
      setFormError(extractError(err, 'Не удалось зарегистрироваться.'))
    } finally {
      setLoading(false)
    }
  }

  const onVerified = (data) => {
    login(data)
    navigate('/', { replace: true })
  }

  return (
    <AuthLayout>
      {step === 'form' ? (
        <form className="auth-form" onSubmit={submitForm} noValidate>
          <p className="auth-section-title">Данные для авторизации</p>
          <TextField
            label="Электронная почта"
            name="email"
            type="email"
            placeholder="my_email@mail.com"
            value={form.email}
            onChange={update('email')}
            error={errors.email}
            required
          />
          <p className="auth-section-title">Прочие данные</p>
          <TextField
            label="Фамилия"
            name="last_name"
            placeholder="Ваша фамилия"
            value={form.last_name}
            onChange={update('last_name')}
            error={errors.last_name}
            required
          />
          <TextField
            label="Имя"
            name="first_name"
            placeholder="Ваше имя"
            value={form.first_name}
            onChange={update('first_name')}
            error={errors.first_name}
            required
          />
          {formError && Object.keys(errors).length === 0 && (
            <p className="auth-error">{formError}</p>
          )}
          <Button type="submit" fullWidth loading={loading}>
            Отправить
          </Button>
          <p className="auth-required-note">* поле, обязательное для заполнения</p>
        </form>
      ) : (
        <CodeVerifyForm
          email={form.email}
          onSuccess={onVerified}
          onResend={() => requestCode(form.email)}
        />
      )}
    </AuthLayout>
  )
}
