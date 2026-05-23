import { createContext, useCallback, useContext, useEffect, useState } from 'react'

const ThemeContext = createContext(null)

const STORAGE_KEY = 'blxckhub:theme'

const applyTheme = (theme) => {
  document.documentElement.dataset.theme = theme === 'default' ? '' : theme
}

// Провайдер темы интерфейса: переключает скрытую альтернативную тему
// и помнит выбор в localStorage.
export function ThemeProvider({ children }) {
  const [theme, setTheme] = useState(() => {
    if (typeof window === 'undefined') return 'default'
    return window.localStorage.getItem(STORAGE_KEY) || 'default'
  })

  useEffect(() => {
    applyTheme(theme)
  }, [theme])

  const toggle = useCallback(() => {
    setTheme((current) => {
      const next = current === 'seans' ? 'default' : 'seans'
      window.localStorage.setItem(STORAGE_KEY, next)
      return next
    })
  }, [])

  const value = { theme, toggle }

  return <ThemeContext.Provider value={value}>{children}</ThemeContext.Provider>
}

export function useTheme() {
  const ctx = useContext(ThemeContext)
  if (!ctx) {
    throw new Error('useTheme должен использоваться внутри ThemeProvider')
  }
  return ctx
}
