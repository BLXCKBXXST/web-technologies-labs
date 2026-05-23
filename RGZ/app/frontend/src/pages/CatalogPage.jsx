import { useCallback, useEffect, useState } from 'react'
import { fetchFeed, listSources, searchCatalog } from '../api/catalog.js'
import { extractError } from '../api/errors.js'
import TitleCard from '../components/catalog/TitleCard.jsx'
import Button from '../components/ui/Button.jsx'
import TextField from '../components/ui/TextField.jsx'
import './CatalogPage.css'

// Лента каталога с переключателем источника и поиском.
export default function CatalogPage() {
  const [sources, setSources] = useState([])
  const [active, setActive] = useState('kinogo')
  const [items, setItems] = useState([])
  const [page, setPage] = useState(1)
  const [hasNext, setHasNext] = useState(false)
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState('')
  const [query, setQuery] = useState('')
  const [submittedQuery, setSubmittedQuery] = useState('')

  useEffect(() => {
    listSources()
      .then(({ data }) => setSources(data.sources))
      .catch(() => {})
  }, [])

  const load = useCallback(
    async (source, nextPage, q) => {
      setLoading(true)
      setError('')
      try {
        const req = q
          ? searchCatalog(source, q, nextPage)
          : fetchFeed(source, { page: nextPage })
        const { data } = await req
        setItems((prev) => (nextPage === 1 ? data.items : [...prev, ...data.items]))
        setHasNext(Boolean(data.has_next))
        setPage(nextPage)
      } catch (err) {
        setError(extractError(err, 'Источник недоступен. Попробуйте позже или поменяйте зеркало в админке.'))
        if (nextPage === 1) setItems([])
        setHasNext(false)
      } finally {
        setLoading(false)
      }
    },
    [],
  )

  // Загрузка ленты при смене источника или сбросе поиска.
  useEffect(() => {
    load(active, 1, submittedQuery)
  }, [active, submittedQuery, load])

  const submitSearch = (e) => {
    e.preventDefault()
    setSubmittedQuery(query.trim())
  }

  const resetSearch = () => {
    setQuery('')
    setSubmittedQuery('')
  }

  const sourceTabs = sources.length > 0 ? sources : [
    { id: 'kinogo', label: 'Kinogo', available: true },
    { id: 'zona', label: 'Zona', available: false },
  ]

  return (
    <div className="catalog">
      <h1 className="page-title">Каталог</h1>
      <p className="catalog__hint">
        Фильмы и сериалы с внешних источников. Один клик — и кино уже
        играет в нашем плеере; ещё клик — и комната совместного просмотра
        готова.
      </p>

      <div className="catalog__tabs">
        {sourceTabs.map((s) => (
          <button
            key={s.id}
            type="button"
            className={
              'catalog__tab' + (s.id === active ? ' catalog__tab--active' : '')
            }
            onClick={() => s.available && setActive(s.id)}
            disabled={!s.available}
            title={s.available ? '' : 'Источник временно недоступен'}
          >
            {s.label}
            {!s.available && <span className="catalog__tab-off">недоступен</span>}
          </button>
        ))}
      </div>

      <form className="catalog__search" onSubmit={submitSearch}>
        <TextField
          name="q"
          placeholder={`Поиск в ${sourceTabs.find((s) => s.id === active)?.label || ''}`}
          value={query}
          onChange={(e) => setQuery(e.target.value)}
        />
        <Button type="submit" disabled={loading}>Найти</Button>
        {submittedQuery && (
          <Button type="button" variant="ghost" onClick={resetSearch}>
            Сбросить
          </Button>
        )}
      </form>

      {error && <p className="form-error">{error}</p>}

      {items.length === 0 && !loading && !error && (
        <p className="page-state">Ничего не найдено.</p>
      )}

      <div className="catalog__grid">
        {items.map((t) => (
          <TitleCard key={`${active}-${t.id}`} source={active} title={t} />
        ))}
      </div>

      {hasNext && (
        <div className="catalog__more">
          <Button
            variant="secondary"
            onClick={() => load(active, page + 1, submittedQuery)}
            loading={loading}
          >
            Показать ещё
          </Button>
        </div>
      )}
      {loading && items.length === 0 && (
        <p className="page-state">Загрузка…</p>
      )}
    </div>
  )
}
