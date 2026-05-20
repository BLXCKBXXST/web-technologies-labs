import { useEffect, useState } from 'react'
import { Link } from 'react-router-dom'
import { listVideos } from '../api/videos.js'
import { useAuth } from '../context/AuthContext.jsx'
import VideoGrid from '../components/video/VideoGrid.jsx'
import Button from '../components/ui/Button.jsx'

// Главная страница — лента опубликованных видео с подгрузкой по страницам.
export default function HomePage() {
  const { isAuthenticated } = useAuth()
  const [videos, setVideos] = useState([])
  const [page, setPage] = useState(1)
  const [hasMore, setHasMore] = useState(false)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')

  const load = async (nextPage) => {
    setLoading(true)
    try {
      const { data } = await listVideos({ page: nextPage })
      setVideos((prev) => (nextPage === 1 ? data.results : [...prev, ...data.results]))
      setHasMore(Boolean(data.next))
      setPage(nextPage)
    } catch {
      setError('Не удалось загрузить ленту видео.')
    } finally {
      setLoading(false)
    }
  }

  useEffect(() => {
    load(1)
  }, [])

  return (
    <div>
      <h1 className="page-title">Лента видео</h1>

      {error && <p className="page-state">{error}</p>}

      {!error && videos.length === 0 && !loading && (
        <p className="page-state">
          Пока нет ни одного видео.{' '}
          {isAuthenticated ? (
            <Link to="/upload">Загрузите первое</Link>
          ) : (
            <Link to="/register">Зарегистрируйтесь и загрузите первое</Link>
          )}
          .
        </p>
      )}

      {videos.length > 0 && <VideoGrid videos={videos} />}

      {loading && videos.length === 0 && <p className="page-state">Загрузка…</p>}

      {hasMore && (
        <div style={{ textAlign: 'center', marginTop: 'var(--space-6)' }}>
          <Button variant="secondary" loading={loading} onClick={() => load(page + 1)}>
            Показать ещё
          </Button>
        </div>
      )}
    </div>
  )
}
