import { createContext, useCallback, useContext, useEffect, useState } from 'react'

const ThemeContext = createContext(null)

const THEME_KEY = 'blxckhub:theme'
const ACCENT_KEY = 'blxckhub:accent'

// Свотчи акцента основной темы. id хранится в localStorage, цвета
// прокидываются в CSS-переменные через inline-стиль на <html>.
export const ACCENTS = [
  { id: 'indigo', label: 'Индиго', color: '#6157ff', hover: '#7a72ff', soft: 'rgba(97, 87, 255, 0.14)' },
  { id: 'teal',   label: 'Бирюза', color: '#22c1c3', hover: '#3fd4d6', soft: 'rgba(34, 193, 195, 0.14)' },
  { id: 'mint',   label: 'Мята',   color: '#3ddc84', hover: '#5be39a', soft: 'rgba(61, 220, 132, 0.14)' },
  { id: 'amber',  label: 'Янтарь', color: '#f5a524', hover: '#f7b748', soft: 'rgba(245, 165, 36, 0.14)' },
  { id: 'ruby',   label: 'Рубин',  color: '#ff5a6a', hover: '#ff7a86', soft: 'rgba(255, 90, 106, 0.14)' },
  { id: 'slate',  label: 'Графит', color: '#8a8a92', hover: '#a0a0a8', soft: 'rgba(138, 138, 146, 0.14)' },
]

const DEFAULT_ACCENT_ID = 'indigo'

const applyTheme = (theme) => {
  document.documentElement.dataset.theme = theme === 'default' ? '' : theme
}

// Провайдер темы интерфейса: переключает скрытую альтернативную тему,
// акцентный цвет основной темы и заголовок вкладки.
export function ThemeProvider({ children }) {
  const [theme, setTheme] = useState(() => {
    if (typeof window === 'undefined') return 'default'
    return window.localStorage.getItem(THEME_KEY) || 'default'
  })
  const [accent, setAccentState] = useState(() => {
    if (typeof window === 'undefined') return DEFAULT_ACCENT_ID
    const stored = window.localStorage.getItem(ACCENT_KEY)
    return ACCENTS.some((a) => a.id === stored) ? stored : DEFAULT_ACCENT_ID
  })

  useEffect(() => {
    applyTheme(theme)
  }, [theme])

  // Под seans-темой свой багряный — снимаем override, чтобы каскад из
  // seans-theme.css снова имел силу.
  useEffect(() => {
    const style = document.documentElement.style
    if (theme === 'default') {
      const swatch = ACCENTS.find((a) => a.id === accent) || ACCENTS[0]
      style.setProperty('--color-accent', swatch.color)
      style.setProperty('--color-accent-hover', swatch.hover)
      style.setProperty('--color-accent-soft', swatch.soft)
    } else {
      style.removeProperty('--color-accent')
      style.removeProperty('--color-accent-hover')
      style.removeProperty('--color-accent-soft')
    }
  }, [theme, accent])

  useEffect(() => {
    document.title = theme === 'seans' ? 'СЕАНС' : 'blxck.hub'
  }, [theme])

  const toggle = useCallback(() => {
    setTheme((current) => {
      const next = current === 'seans' ? 'default' : 'seans'
      window.localStorage.setItem(THEME_KEY, next)
      return next
    })
  }, [])

  const selectTheme = useCallback((next) => {
    setTheme(() => {
      window.localStorage.setItem(THEME_KEY, next)
      return next
    })
  }, [])

  const setAccent = useCallback((id) => {
    if (!ACCENTS.some((a) => a.id === id)) return
    window.localStorage.setItem(ACCENT_KEY, id)
    setAccentState(id)
  }, [])

  const value = { theme, toggle, selectTheme, accent, setAccent, accents: ACCENTS }

  return <ThemeContext.Provider value={value}>{children}</ThemeContext.Provider>
}

export function useTheme() {
  const ctx = useContext(ThemeContext)
  if (!ctx) {
    throw new Error('useTheme должен использоваться внутри ThemeProvider')
  }
  return ctx
}
