import { useEffect, useState } from 'react'
import { useParams } from 'react-router-dom'
import { getVideo } from '../api/videos.js'
import VideoPlayer from '../components/player/VideoPlayer.jsx'
import { formatDate, formatViews } from '../lib/format.js'
import './WatchPage.css'

// Страница одиночного просмотра видео.
export default function WatchPage() {
  const { id } = useParams()
  const [video, setVideo] = useState(null)
  const [error, setError] = useState('')

  useEffect(() => {
    let cancelled = false
    getVideo(id)
      .then(({ data }) => {
        if (cancelled) return
        setVideo(data)
        setError('')
      })
      .catch(() => {
        if (!cancelled) setError('Видео не найдено или недоступно.')
      })
    return () => {
      cancelled = true
    }
  }, [id])

  if (error) return <p className="page-state">{error}</p>
  // Пока грузится видео или открыт ещё прежний ролик — показываем заглушку.
  if (!video || video.id !== id) return <p className="page-state">Загрузка…</p>

  return (
    <div className="watch">
      <VideoPlayer src={video.stream_url} poster={video.thumbnail_url} />

      <h1 className="watch__title">{video.title}</h1>
      <div className="watch__meta">
        <span className="watch__owner">{video.owner.display_name}</span>
        <span>
          {formatViews(video.views_count)} просмотров · {formatDate(video.created_at)}
        </span>
      </div>

      {video.description && (
        <p className="watch__description">{video.description}</p>
      )}
    </div>
  )
}
