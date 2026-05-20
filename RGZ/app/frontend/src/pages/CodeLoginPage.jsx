import { useState } from 'react'
import { Navigate, useNavigate } from 'react-router-dom'
import AuthLayout from '../components/auth/AuthLayout.jsx'
import CodeVerifyForm from '../components/auth/CodeVerifyForm.jsx'
import TextField from '../components/ui/TextField.jsx'
import Button from '../components/ui/Button.jsx'
import { useAuth } from '../context/AuthContext.jsx'
import { requestCode } from '../api/auth.js'
import { extractError } from '../api/errors.js'

// Экран входа по коду: шаг 1 — ввод e-mail, шаг 2 — ввод кода из письма.
export default function CodeLoginPage() {
  const { isAuthenticated, login } = useAuth()
  const navigate = useNavigate()
  const [step, setStep] = useState('email')
  const [email, setEmail] = useState('')
  const [error, setError] = useState('')
  const [loading, setLoading] = useState(false)

  if (isAuthenticated) {
    return <Navigate to="/" replace />
  }

  const submitEmail = async (e) => {
    e.preventDefault()
    setError('')
    setLoading(true)
    try {
      await requestCode(email)
      setStep('code')
    } catch (err) {
      setError(extractError(err, 'Не удалось отправить код.'))
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
      {step === 'email' ? (
        <form className="auth-form" onSubmit={submitEmail} noValidate>
          <p className="auth-section-title">Вход по одноразовому коду</p>
          <p className="auth-note">
            Укажите электронную почту — мы вышлем на неё код для входа.
          </p>
          <TextField
            label="Электронная почта"
            name="email"
            type="email"
            placeholder="mail@mail.com"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            error={error}
            required
          />
          <Button type="submit" fullWidth loading={loading}>
            Отправить код
          </Button>
        </form>
      ) : (
        <CodeVerifyForm
          email={email}
          onSuccess={onVerified}
          onResend={() => requestCode(email)}
        />
      )}
    </AuthLayout>
  )
}
