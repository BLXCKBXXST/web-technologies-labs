import { Routes, Route } from 'react-router-dom'
import { useAuth } from './context/AuthContext.jsx'
import Layout from './components/Layout.jsx'
import ProtectedRoute from './components/ProtectedRoute.jsx'
import HomePage from './pages/HomePage.jsx'
import WatchPage from './pages/WatchPage.jsx'
import WatchRoomPage from './pages/WatchRoomPage.jsx'
import UploadPage from './pages/UploadPage.jsx'
import ProfilePage from './pages/ProfilePage.jsx'
import RegisterPage from './pages/RegisterPage.jsx'
import CodeLoginPage from './pages/CodeLoginPage.jsx'
import NotFoundPage from './pages/NotFoundPage.jsx'

function App() {
  const { loading } = useAuth()

  // Пока восстанавливается сессия — не мигаем экраном входа.
  if (loading) {
    return <div className="app-loading">Загрузка…</div>
  }

  return (
    <Routes>
      {/* Страницы с шапкой */}
      <Route element={<Layout />}>
        <Route path="/" element={<HomePage />} />
        <Route path="/video/:id" element={<WatchPage />} />
        <Route path="/room/:roomId" element={<WatchRoomPage />} />
        <Route
          path="/upload"
          element={
            <ProtectedRoute>
              <UploadPage />
            </ProtectedRoute>
          }
        />
        <Route
          path="/profile"
          element={
            <ProtectedRoute>
              <ProfilePage />
            </ProtectedRoute>
          }
        />
        <Route path="*" element={<NotFoundPage />} />
      </Route>

      {/* Экраны авторизации — без шапки */}
      <Route path="/register" element={<RegisterPage />} />
      <Route path="/login" element={<CodeLoginPage />} />
    </Routes>
  )
}

export default App
