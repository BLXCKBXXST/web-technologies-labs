import { Link } from 'react-router-dom'
import { useAuth } from '../context/AuthContext.jsx'
import Button from './ui/Button.jsx'
import './Header.css'

const APP_NAME = import.meta.env.VITE_APP_NAME || 'Видеохостинг'

// Шапка приложения: логотип, кнопка загрузки, профиль и выход.
export default function Header() {
  const { user, isAuthenticated, isGuest, logout } = useAuth()

  return (
    <header className="header">
      <div className="header__inner">
        <Link to="/" className="header__brand">
          {APP_NAME}
        </Link>

        <nav className="header__nav">
          {isAuthenticated ? (
            <>
              <Link to="/upload">
                <Button variant="secondary">Загрузить видео</Button>
              </Link>
              {isGuest && (
                <span
                  className="header__guest"
                  title="Гостевой аккаунт удаляется после 24 часов простоя"
                >
                  гость
                </span>
              )}
              <Link to="/profile" className="header__user" title="Профиль">
                <span className="header__avatar">
                  {user.display_name.slice(0, 1).toUpperCase()}
                </span>
                <span className="header__user-name">{user.display_name}</span>
              </Link>
              <Button variant="ghost" onClick={logout}>
                Выйти
              </Button>
            </>
          ) : (
            <Link to="/login">
              <Button>Войти</Button>
            </Link>
          )}
        </nav>
      </div>
    </header>
  )
}
