import { useState } from 'react'
import Tabs from '../ui/Tabs.jsx'
import Button from '../ui/Button.jsx'
import ChatPanel from './ChatPanel.jsx'
import QAPanel from './QAPanel.jsx'
import './RoomSidePanel.css'

const TABS = [
  { id: 'chat', label: 'Чат' },
  { id: 'qa', label: 'Вопрос / ответ' },
]

// Боковая панель комнаты: статус, вкладки «Чат» и «Вопрос/ответ», приглашение.
export default function RoomSidePanel({
  socket,
  roomId,
  participants,
  online,
  canPost,
  onCopyLink,
  copied,
}) {
  const [tab, setTab] = useState('chat')

  return (
    <aside className="side">
      <div className="side__head">
        <span className="side__status">
          <span className={`side__dot${online ? ' side__dot--on' : ''}`} />
          {online ? 'В эфире' : 'Соединение…'}
        </span>
        <span className="side__viewers">Зрителей: {participants.count}</span>
      </div>

      <Tabs tabs={TABS} active={tab} onChange={setTab} />

      <div className="side__content">
        {tab === 'chat' ? (
          <ChatPanel socket={socket} roomId={roomId} canChat={canPost} />
        ) : (
          <QAPanel socket={socket} roomId={roomId} canPost={canPost} />
        )}
      </div>

      <Button variant="secondary" fullWidth onClick={onCopyLink}>
        {copied ? 'Ссылка скопирована' : 'Скопировать ссылку-приглашение'}
      </Button>
    </aside>
  )
}
