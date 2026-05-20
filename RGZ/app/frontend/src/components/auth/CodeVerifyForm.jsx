import { useState } from 'react'
import TextField from '../ui/TextField.jsx'
import Button from '../ui/Button.jsx'
import { verify } from '../../api/auth.js'
import { extractError } from '../../api/errors.js'

// Шаг ввода одноразового кода — общий для регистрации и входа.
export default function CodeVerifyForm({ email, onSuccess, onResend }) {
  const [code, setCode] = useState('')
  const [error, setError] = useState('')
  const [loading, setLoading] = useState(false)

  const submit = async (e) => {
    e.preventDefault()
    setError('')
    setLoading(true)
    try {
      const { data } = await verify(email, code)
      onSuccess(data)
    } catch (err) {
      setError(extractError(err, 'Неверный или просроченный код.'))
      setLoading(false)
    }
  }

  return (
    <form className="auth-form" onSubmit={submit} noValidate>
      <p className="auth-note">
        Код отправлен на <b>{email}</b>. Введите 6 цифр из письма.
      </p>
      <TextField
        label="Код из письма"
        name="code"
        inputMode="numeric"
        maxLength={6}
        placeholder="Подсказка"
        value={code}
        onChange={(e) => setCode(e.target.value.replace(/\D/g, '').slice(0, 6))}
        error={error}
        required
        autoFocus
      />
      <Button type="submit" fullWidth loading={loading} disabled={code.length !== 6}>
        Подтвердить
      </Button>
      {onResend && (
        <button type="button" className="auth-link" onClick={onResend}>
          Отправить код повторно
        </button>
      )}
    </form>
  )
}
