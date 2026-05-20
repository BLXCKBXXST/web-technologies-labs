import { useEffect, useRef, useState } from 'react'
import { useParams } from 'react-router-dom'
import { getRoom } from '../api/rooms.js'
import { getAccessToken, refreshAccess } from '../api/client.js'
import { useAuth } from '../context/AuthContext.jsx'
import { useRoomSync } from '../hooks/useRoomSync.js'
import RoomSocket from '../ws/roomSocket.js'
import VideoPlayer from '../components/player/VideoPlayer.jsx'
import Button from '../components/ui/Button.jsx'
import './WatchRoomPage.css'

// Страница комнаты совместного просмотра: синхронный плеер и боковая панель.
export default function WatchRoomPage() {
  const { roomId } = useParams()
  const { isAuthenticated } = useAuth()
  const playerRef = useRef(null)
  const [room, setRoom] = useState(null)
  const [error, setError] = useState('')
  const [socket, setSocket] = useState(null)
  const [participants, setParticipants] = useState({ count: 0, viewers: [] })
  const [online, setOnline] = useState(false)
  const [started, setStarted] = useState(false)
  const [copied, setCopied] = useState(false)

  // Загрузка комнаты по ссылке.
  useEffect(() => {
    let cancelled = false
    getRoom(roomId)
      .then(({ data }) => {
        if (!cancelled) setRoom(data)
      })
      .catch(() => {
        if (!cancelled) setError('Комната не найдена или закрыта.')
      })
    return () => {
      cancelled = true
    }
  }, [roomId])

  // Открытие WebSocket-соединения после загрузки комнаты.
  useEffect(() => {
    if (!room) return undefined
    let cancelled = false
    let activeSocket = null
    ;(async () => {
      // Освежаем access-токен, чтобы ведущий не потерял роль из-за истёкшего JWT.
      if (isAuthenticated) await refreshAccess()
      if (cancelled) return
      activeSocket = new RoomSocket(roomId, getAccessToken())
      activeSocket.on('room.participants', (m) =>
        setParticipants({ count: m.count, viewers: m.viewers }),
      )
      activeSocket.on('socket.status', (m) => setOnline(m.online))
      activeSocket.connect()
      setSocket(activeSocket)
    })()
    return () => {
      cancelled = true
      if (activeSocket) activeSocket.close()
    }
  }, [room, roomId, isAuthenticated])

  const isHost = Boolean(room?.is_host)
  const { hostHandlers } = useRoomSync({ socket, playerRef, isHost })

  const join = () => {
    setStarted(true)
    playerRef.current?.play()
    socket?.send('player.sync_request')
  }

  const copyLink = () => {
    navigator.clipboard.writeText(window.location.href).then(() => {
      setCopied(true)
      setTimeout(() => setCopied(false), 2000)
    })
  }

  if (error) return <p className="page-state">{error}</p>
  if (!room) return <p className="page-state">Загрузка комнаты…</p>

  return (
    <div className="room">
      <div className="room__main">
        <div className="room__player">
          <VideoPlayer
            ref={playerRef}
            src={room.video.stream_url}
            poster={room.video.thumbnail_url}
            controls={isHost}
            {...(hostHandlers || {})}
          />
          {!isHost && !started && (
            <button type="button" className="room__gate" onClick={join}>
              <span className="room__gate-icon">▶</span>
              Присоединиться к просмотру
            </button>
          )}
          {!isHost && started && (
            <div className="room__viewer-badge">Ведущий управляет просмотром</div>
          )}
        </div>
        <h1 className="room__title">{room.video.title}</h1>
        <p className="room__sub">
          {isHost
            ? 'Вы ведущий — управляйте плеером, зрители синхронизируются автоматически.'
            : `Ведущий: ${room.host.display_name}`}
        </p>
      </div>

      <aside className="room__panel">
        <div className="room__panel-head">
          <span className={`room__dot${online ? ' room__dot--on' : ''}`} />
          {online ? 'В эфире' : 'Соединение…'}
        </div>
        <div className="room__participants">
          <h2 className="room__panel-title">Зрители · {participants.count}</h2>
          <ul className="room__viewers">
            {participants.viewers.map((name, index) => (
              <li key={`${name}-${index}`}>{name}</li>
            ))}
          </ul>
        </div>
        <Button variant="secondary" fullWidth onClick={copyLink}>
          {copied ? 'Ссылка скопирована' : 'Скопировать ссылку-приглашение'}
        </Button>
      </aside>
    </div>
  )
}
