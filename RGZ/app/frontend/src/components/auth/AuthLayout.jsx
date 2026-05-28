import { NavLink } from 'react-router-dom'
import './AuthLayout.css'

const APP_NAME = import.meta.env.VITE_APP_NAME || 'Видеохостинг'

const tabClass = ({ isActive }) =>
  isActive ? 'auth__tab auth__tab--active' : 'auth__tab'

// Общий каркас экранов авторизации: фон, логотип, вкладки и карточка с формой.
export default function AuthLayout({ children }) {
  return (
    <div className="auth">
      <div className="auth__backdrop" aria-hidden="true" />
      <div className="auth__inner">
        <div className="auth__brand">{APP_NAME}</div>
        <nav className="auth__tabs">
          <NavLink to="/register" className={tabClass}>
            Регистрация
          </NavLink>
          <NavLink to="/login" className={tabClass}>
            Вход
          </NavLink>
        </nav>
        <div className="auth__card">{children}</div>
      </div>
    </div>
  )
}
