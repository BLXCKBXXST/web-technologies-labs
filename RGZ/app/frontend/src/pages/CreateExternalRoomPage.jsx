import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { createRoom } from '../api/rooms.js'
import { extractError, extractFieldErrors } from '../api/errors.js'
import TextField from '../components/ui/TextField.jsx'
import Button from '../components/ui/Button.jsx'
import './CreateExternalRoomPage.css'

// Создание комнаты совместного просмотра с произвольной веб-страницей.
// Бэк через yt-dlp извлекает прямой URL потока — для пользователя достаточно
// дать ссылку на страницу с видео.
export default function CreateExternalRoomPage() {
  const navigate = useNavigate()
  const [url, setUrl] = useState('')
  const [title, setTitle] = useState('')
  const [errors, setErrors] = useState({})
  const [formError, setFormError] = useState('')
  const [submitting, setSubmitting] = useState(false)

  const submit = async (e) => {
    e.preventDefault()
    setErrors({})
    setFormError('')
    if (!url.trim()) {
      setErrors({ external_url: 'Укажите ссылку на страницу с видео.' })
      return
    }
    setSubmitting(true)
    try {
      const { data } = await createRoom({
        external_url: url.trim(),
        title: title.trim(),
      })
      navigate(`/room/${data.id}`)
    } catch (err) {
      setErrors(extractFieldErrors(err))
      setFormError(extractError(err, 'Не удалось создать комнату.'))
      setSubmitting(false)
    }
  }

  return (
    <div className="ext-room">
      <h1 className="page-title">Сеанс по ссылке</h1>
      <p className="ext-room__hint">
        Вставьте ссылку на страницу с видео — YouTube, RuTube, VK Video,
        Dailymotion и многие другие. Сервер сам извлечёт прямой поток, а
        участники комнаты будут смотреть синхронно с ведущим.
      </p>
      <form className="ext-room__form" onSubmit={submit} noValidate>
        <TextField
          label="Ссылка на страницу или видео"
          name="external_url"
          type="url"
          placeholder="https://www.youtube.com/watch?v=…"
          value={url}
          onChange={(e) => setUrl(e.target.value)}
          error={errors.external_url}
          required
        />
        <TextField
          label="Название комнаты (необязательно)"
          name="title"
          placeholder="Подставится из заголовка ролика"
          value={title}
          onChange={(e) => setTitle(e.target.value)}
          error={errors.title}
        />
        {formError && <p className="form-error">{formError}</p>}
        <Button type="submit" loading={submitting}>
          {submitting ? 'Создаём…' : 'Создать комнату'}
        </Button>
      </form>
    </div>
  )
}
