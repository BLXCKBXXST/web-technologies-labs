import { useEffect, useRef, useState } from 'react'
import { useNavigate, useParams } from 'react-router-dom'
import { fetchStream, fetchTitle } from '../api/catalog.js'
import { createRoom } from '../api/rooms.js'
import { extractError } from '../api/errors.js'
import { useAuth } from '../context/AuthContext.jsx'
import VideoPlayer from '../components/player/VideoPlayer.jsx'
import Button from '../components/ui/Button.jsx'
import './CatalogTitlePage.css'

// Страница одного тайтла каталога: обложка, описание, плеер, кнопки.
export default function CatalogTitlePage() {
  const { source, externalId } = useParams()
  const navigate = useNavigate()
  const { isAuthenticated } = useAuth()
  const playerRef = useRef(null)
  const [details, setDetails] = useState(null)
  const [error, setError] = useState('')
  const [stream, setStream] = useState(null)
  const [streamError, setStreamError] = useState('')
  const [streamLoading, setStreamLoading] = useState(false)
  const [creating, setCreating] = useState(false)
  const [season, setSeason] = useState(null)
  const [episode, setEpisode] = useState(null)

  useEffect(() => {
    let cancelled = false
    fetchTitle(source, externalId)
      .then(({ data }) => {
        if (cancelled) return
        setDetails(data)
        if (data.seasons?.length) {
          setSeason(data.seasons[0].number)
          setEpisode(data.seasons[0].episodes?.[0]?.number ?? 1)
        }
      })
      .catch((err) => !cancelled && setError(extractError(err, 'Не удалось загрузить страницу тайтла.')))
    return () => {
      cancelled = true
    }
  }, [source, externalId])

  const watchHere = async () => {
    setStreamLoading(true)
    setStreamError('')
    try {
      const { data } = await fetchStream(source, externalId, { season, episode })
      setStream(data)
    } catch (err) {
      setStreamError(extractError(err, 'Не удалось получить поток.'))
    } finally {
      setStreamLoading(false)
    }
  }

  const startRoom = async () => {
    setCreating(true)
    try {
      const { data } = await createRoom({
        catalog_source: source,
        catalog_external_id: externalId,
        catalog_season: season,
        catalog_episode: episode,
      })
      navigate(`/room/${data.id}`)
    } catch (err) {
      setStreamError(extractError(err, 'Не удалось создать сеанс.'))
    } finally {
      setCreating(false)
    }
  }

  if (error) return <p className="page-state">{error}</p>
  if (!details) return <p className="page-state">Загрузка…</p>

  const isEmbed = stream?.kind === 'embed'

  return (
    <div className="catalog-title">
      <div className="catalog-title__head">
        <div className="catalog-title__poster">
          {details.poster ? (
            <img src={details.poster} alt={details.title} />
          ) : (
            <div className="catalog-title__poster-empty">{details.title.slice(0, 1)}</div>
          )}
        </div>
        <div className="catalog-title__info">
          <h1 className="catalog-title__name">
            {details.title}
            {details.year ? <span className="catalog-title__year"> ({details.year})</span> : null}
          </h1>
          {details.description && (
            <p className="catalog-title__descr">{details.description}</p>
          )}

          {details.seasons?.length > 0 && (
            <div className="catalog-title__series">
              <label>
                Сезон{' '}
                <select value={season ?? ''} onChange={(e) => setSeason(Number(e.target.value))}>
                  {details.seasons.map((s) => (
                    <option key={s.number} value={s.number}>{s.number}</option>
                  ))}
                </select>
              </label>
              {(() => {
                const eps = details.seasons.find((s) => s.number === season)?.episodes || []
                return (
                  <label>
                    Эпизод{' '}
                    <select value={episode ?? ''} onChange={(e) => setEpisode(Number(e.target.value))}>
                      {eps.map((ep) => (
                        <option key={ep.number} value={ep.number}>{ep.number}</option>
                      ))}
                    </select>
                  </label>
                )
              })()}
            </div>
          )}

          <div className="catalog-title__actions">
            <Button onClick={watchHere} loading={streamLoading}>Смотреть здесь</Button>
            {isAuthenticated && (
              <Button variant="secondary" onClick={startRoom} loading={creating}>
                Создать сеанс
              </Button>
            )}
            {details.url && (
              <a className="catalog-title__source" href={details.url} target="_blank" rel="noreferrer">
                Открыть в источнике
              </a>
            )}
          </div>
          {streamError && <p className="form-error">{streamError}</p>}
        </div>
      </div>

      {stream && (
        <div className="catalog-title__player">
          {isEmbed ? (
            <iframe
              src={stream.url}
              className="catalog-title__embed"
              title={stream.title || details.title}
              allow="autoplay; encrypted-media; picture-in-picture; fullscreen"
              allowFullScreen
              referrerPolicy="no-referrer"
            />
          ) : (
            <VideoPlayer
              ref={playerRef}
              src={stream.url}
              poster={stream.thumbnail || details.poster}
              controls
            />
          )}
          {isEmbed && (
            <p className="catalog-title__embed-note">
              Поток встроенного плеера источника. Для синхронного просмотра в
              комнате (с паузой по команде ведущего) нужна прямая ссылка mp4/m3u8 —
              сейчас она недоступна, но можно открыть на сайте источника.
            </p>
          )}
        </div>
      )}
    </div>
  )
}
