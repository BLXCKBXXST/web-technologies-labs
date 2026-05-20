import { forwardRef, useImperativeHandle, useRef } from 'react'
import './VideoPlayer.css'

// Плеер-обёртка над <video>. Через ref наружу выдаёт императивное управление —
// это нужно для синхронизации в комнатах совместного просмотра (этап M3).
const VideoPlayer = forwardRef(function VideoPlayer(
  {
    src,
    poster,
    controls = true,
    autoPlay = false,
    className = '',
    onPlay,
    onPause,
    onSeeked,
    onTimeUpdate,
    onEnded,
  },
  ref,
) {
  const videoRef = useRef(null)

  useImperativeHandle(
    ref,
    () => ({
      play: () => videoRef.current?.play().catch(() => {}),
      pause: () => videoRef.current?.pause(),
      seek: (time) => {
        if (videoRef.current) videoRef.current.currentTime = time
      },
      getTime: () => videoRef.current?.currentTime ?? 0,
      getDuration: () => videoRef.current?.duration ?? 0,
      isPaused: () => videoRef.current?.paused ?? true,
      setPlaybackRate: (rate) => {
        if (videoRef.current) videoRef.current.playbackRate = rate
      },
    }),
    [],
  )

  return (
    <div className={`player ${className}`.trim()}>
      <video
        ref={videoRef}
        src={src}
        poster={poster}
        controls={controls}
        autoPlay={autoPlay}
        playsInline
        className="player__video"
        onPlay={onPlay}
        onPause={onPause}
        onSeeked={onSeeked}
        onTimeUpdate={onTimeUpdate}
        onEnded={onEnded}
      />
    </div>
  )
})

export default VideoPlayer
