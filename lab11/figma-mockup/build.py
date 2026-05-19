#!/usr/bin/env python3
"""Build 15 HTML mockup files for lab11 (5 pages x 3 widths).
Images embedded as base64 data URIs so html.to.design can ingest them offline.
"""
import base64
import os
import pathlib

ROOT = "/home/blxck/my-projects/github-repos/web-technologies-labs/lab11/figma-mockup"
IMG_DIR = f"{ROOT}/img"

def b64(name):
    with open(f"{IMG_DIR}/{name}", "rb") as fp:
        return "data:image/jpeg;base64," + base64.b64encode(fp.read()).decode()

IMG = {n: b64(n) for n in sorted(os.listdir(IMG_DIR)) if n.endswith(".jpg")}

TEAM_NAMES = [
    ("MSK United",   "Москва",       "team-1.jpg"),
    ("SPB Storm",    "Санкт-Петербург", "team-2.jpg"),
    ("NSK Phantoms", "Новосибирск",  "team-3.jpg"),
    ("KZN Eagles",   "Казань",       "team-4.jpg"),
    ("EKB Wolves",   "Екатеринбург", "team-5.jpg"),
    ("KRD Sharks",   "Краснодар",    "team-6.jpg"),
]

PLAYERS = [
    ("Михаил Климов",    "GK",  "01", "player-1.jpg"),
    ("Артём Беляев",     "DEF", "07", "player-2.jpg"),
    ("Денис Литвинов",   "MID", "10", "player-3.jpg"),
    ("Никита Соловьёв",  "MID", "17", "player-4.jpg"),
    ("Илья Григорьев",   "FWD", "23", "player-5.jpg"),
]

NEWS = [
    ("18.05",   "Восемь команд прошли отбор в группу A",        "news-1.jpg"),
    ("17.05",   "Арена «Сибирь» примет финальный уикенд",       "news-2.jpg"),
    ("16.05",   "Игрок недели: Денис «delta» Литвинов",         "news-3.jpg"),
    ("15.05",   "Опубликовано расписание Fan Zone и дегустаций","news-4.jpg"),
]

MERCH = [
    ("Игровая форма", "4 990 ₽", "merch-1.jpg"),
    ("Фан-шарф",      "1 290 ₽", "merch-2.jpg"),
    ("Кепка",         "1 690 ₽", "merch-3.jpg"),
    ("Худи",          "5 490 ₽", "merch-4.jpg"),
    ("Кружка",          "790 ₽", "merch-5.jpg"),
    ("Значок",          "390 ₽", "merch-6.jpg"),
]

MATCHES_UPCOMING = [
    ("NSK Phantoms", "MSK United", "team-3.jpg", "team-1.jpg", "Сб · 19:00", "Арена «Сибирь»", "match-1.jpg"),
    ("SPB Storm",    "EKB Wolves", "team-2.jpg", "team-5.jpg", "Вс · 17:00", "Арена «Сибирь»", "match-2.jpg"),
    ("KZN Eagles",   "KRD Sharks", "team-4.jpg", "team-6.jpg", "Пн · 20:30", "Арена «Сибирь»", "match-3.jpg"),
]

GROUP_A = [
    # name, M, W, D, L, GF, GA, Pts, file
    ("NSK Phantoms", 5, 4, 1, 0, 14, 4, 13, "team-3.jpg", True),
    ("MSK United",   5, 3, 1, 1, 11, 6, 10, "team-1.jpg", False),
    ("SPB Storm",    5, 2, 2, 1,  9, 7,  8, "team-2.jpg", False),
    ("KZN Eagles",   5, 1, 1, 3,  6,10,  4, "team-4.jpg", False),
    ("EKB Wolves",   5, 0, 2, 3,  3, 9,  2, "team-5.jpg", False),
    ("KRD Sharks",   5, 0, 1, 4,  4,11,  1, "team-6.jpg", False),
]


def settings(w):
    """Per-width layout settings. cols_* keys control grid columns only;
    all data lists are iterated in full regardless of width."""
    if w == 1440:
        return dict(
            cols_match=3, cols_news=4, cols_player=5, cols_merch=3,
            container_pad=80, hero_h1=72, hero_h2=20, header_pad=24,
            show_full_nav=True, hero_min=520, footer_cols="2fr 1fr 1fr 1fr",
            stats_cols=4, shop_layout="1fr 340px", grid_n=12, grid_margin=80, grid_gutter=24,
            ticket_grid="repeat(2, 1fr)", news_h=180,
        )
    if w == 768:
        return dict(
            cols_match=2, cols_news=2, cols_player=3, cols_merch=3,
            container_pad=32, hero_h1=48, hero_h2=18, header_pad=20,
            show_full_nav=True, hero_min=360, footer_cols="2fr 1fr 1fr",
            stats_cols=4, shop_layout="1fr", grid_n=6, grid_margin=32, grid_gutter=16,
            ticket_grid="repeat(2, 1fr)", news_h=160,
        )
    # mobile 360
    return dict(
        cols_match=1, cols_news=1, cols_player=2, cols_merch=2,
        container_pad=16, hero_h1=36, hero_h2=16, header_pad=14,
        show_full_nav=False, hero_min=300, footer_cols="1fr",
        stats_cols=2, shop_layout="1fr", grid_n=4, grid_margin=16, grid_gutter=8,
        ticket_grid="1fr", news_h=140,
    )


def css(w):
    s = settings(w)
    nav_d = "flex" if s["show_full_nav"] else "none"
    nav_m = "none" if s["show_full_nav"] else "inline-flex"
    base = f"""
:root{{
  --bg-deep:#0B1024;--bg-mid:#11183A;--blue:#3A8DFF;--lime:#C7FF4F;
  --coral:#FF5A7A;--white:#fff;--soft:rgba(255,255,255,.72);
  --softer:rgba(255,255,255,.45);--glass:rgba(255,255,255,.06);
  --glass2:rgba(255,255,255,.10);--border:rgba(255,255,255,.12);
}}
*{{box-sizing:border-box;}}
html,body{{margin:0;padding:0;}}
html{{width:{w}px;}}
body{{width:{w}px;min-height:100vh;color:var(--white);font-family:'Inter',system-ui,sans-serif;
  background:linear-gradient(180deg,var(--bg-deep) 0%,var(--bg-mid) 60%,#0E1530 100%);
  -webkit-font-smoothing:antialiased;line-height:1.45;}}
h1,h2,h3,h4{{font-family:'Space Grotesk',sans-serif;font-weight:700;margin:0;letter-spacing:-.02em;}}
.mono{{font-family:'JetBrains Mono',monospace;}}
a{{color:inherit;text-decoration:none;}}
.glass{{background:var(--glass);border:1px solid var(--border);backdrop-filter:blur(20px);
  -webkit-backdrop-filter:blur(20px);border-radius:16px;}}
.glass-strong{{background:var(--glass2);border:1px solid var(--border);backdrop-filter:blur(20px);
  -webkit-backdrop-filter:blur(20px);border-radius:16px;}}
.btn{{display:inline-flex;align-items:center;justify-content:center;gap:8px;
  padding:12px 22px;border-radius:12px;font-weight:600;font-family:'Inter',sans-serif;
  font-size:14px;border:1px solid transparent;cursor:pointer;}}
.btn-primary{{background:var(--blue);color:#fff;}}
.btn-ghost{{background:transparent;color:#fff;border-color:var(--border);}}
.btn-lime{{background:var(--lime);color:var(--bg-deep);}}
.chip{{display:inline-flex;align-items:center;padding:6px 14px;border-radius:999px;
  background:var(--glass);border:1px solid var(--border);font-size:12px;color:var(--soft);}}
.chip.active{{background:var(--blue);border-color:var(--blue);color:#fff;}}
/* HEADER */
.site-header{{display:flex;align-items:center;justify-content:space-between;
  padding:{s["header_pad"]}px {s["container_pad"]}px;border-bottom:1px solid var(--border);
  background:rgba(11,16,36,.6);backdrop-filter:blur(14px);position:sticky;top:0;z-index:10;}}
.logo{{font-family:'Space Grotesk',sans-serif;font-weight:700;font-size:18px;letter-spacing:.06em;}}
.logo .accent{{color:var(--blue);}}
.nav-desktop{{display:{nav_d};gap:28px;}}
.nav-desktop a{{color:var(--soft);font-size:14px;font-weight:500;}}
.nav-desktop a.active{{color:#fff;}}
.nav-hamburger{{display:{nav_m};align-items:center;justify-content:center;width:40px;height:40px;
  border-radius:10px;background:var(--glass);border:1px solid var(--border);}}
.header-right{{display:flex;align-items:center;gap:12px;}}
.icon-btn{{width:36px;height:36px;border-radius:10px;background:var(--glass);
  border:1px solid var(--border);display:inline-flex;align-items:center;justify-content:center;color:#fff;}}
/* HERO */
.hero{{position:relative;margin:24px {s["container_pad"]}px;border-radius:24px;
  overflow:hidden;min-height:{s["hero_min"]}px;isolation:isolate;border:1px solid var(--border);}}
.hero img.bg{{position:absolute;inset:0;width:100%;height:100%;object-fit:cover;z-index:-2;}}
.hero::before{{content:'';position:absolute;inset:0;
  background:linear-gradient(180deg,rgba(11,16,36,.35) 0%,rgba(11,16,36,.85) 100%);z-index:-1;}}
.hero-inner{{padding:40px;max-width:720px;display:flex;flex-direction:column;justify-content:flex-end;height:100%;}}
.hero .badge{{display:inline-flex;align-items:center;gap:6px;padding:6px 14px;
  border-radius:999px;background:rgba(199,255,79,.18);color:var(--lime);
  font-size:12px;font-weight:600;letter-spacing:.06em;text-transform:uppercase;
  margin-bottom:24px;align-self:flex-start;}}
.hero h1{{font-size:{s["hero_h1"]}px;line-height:1.04;}}
.hero p{{color:var(--soft);font-size:{s["hero_h2"]}px;margin-top:18px;}}
.hero .actions{{margin-top:28px;display:flex;gap:12px;flex-wrap:wrap;}}
.hero .meta{{margin-top:16px;display:flex;gap:18px;color:var(--soft);font-size:13px;}}
.hero .meta .dot{{color:var(--lime);}}
/* SECTIONS */
.section{{padding:36px {s["container_pad"]}px;}}
.section-head{{display:flex;align-items:baseline;justify-content:space-between;margin-bottom:18px;flex-wrap:wrap;gap:8px;}}
.section-head h2{{font-size:28px;}}
.section-head a{{color:var(--blue);font-size:14px;}}
.grid-match{{display:grid;grid-template-columns:repeat({s["cols_match"]},1fr);gap:16px;}}
.grid-news{{display:grid;grid-template-columns:repeat({s["cols_news"]},1fr);gap:16px;}}
.grid-player{{display:grid;grid-template-columns:repeat({s["cols_player"]},1fr);gap:16px;}}
.grid-merch{{display:grid;grid-template-columns:repeat({s["cols_merch"]},1fr);gap:16px;}}
.grid-stats{{display:grid;grid-template-columns:repeat({s["stats_cols"]},1fr);gap:14px;margin:18px 0 28px;}}
/* CARDS */
.card{{padding:18px;}}
.card-match{{display:flex;flex-direction:column;gap:14px;}}
.card-match .teams{{display:flex;align-items:center;gap:8px;}}
.card-match .team{{display:flex;flex-direction:column;align-items:center;gap:6px;flex:1;}}
.card-match .team img{{width:56px;height:56px;border-radius:12px;}}
.card-match .team span{{font-size:11px;color:var(--soft);text-align:center;line-height:1.2;}}
.card-match .vs{{font-family:'Space Grotesk',sans-serif;font-weight:700;color:var(--lime);font-size:16px;}}
.card-match .meta{{display:flex;justify-content:space-between;color:var(--soft);font-size:12px;
  border-top:1px solid var(--border);padding-top:12px;}}
.card-match .actions{{display:flex;gap:8px;}}
.card-news{{overflow:hidden;padding:0;display:flex;flex-direction:column;}}
.card-news img{{width:100%;height:{s["news_h"]}px;object-fit:cover;display:block;}}
.card-news .body{{padding:14px 16px 18px;}}
.card-news .date{{color:var(--softer);font-size:11px;text-transform:uppercase;letter-spacing:.06em;}}
.card-news h3{{font-size:15px;margin-top:8px;line-height:1.3;}}
.card-player{{overflow:hidden;padding:0;}}
.card-player img{{width:100%;aspect-ratio:1/1;object-fit:cover;display:block;}}
.card-player .body{{padding:12px 14px 14px;display:flex;justify-content:space-between;align-items:flex-end;}}
.card-player .name{{font-weight:600;font-size:14px;}}
.card-player .role{{color:var(--softer);font-size:11px;text-transform:uppercase;letter-spacing:.05em;}}
.card-player .number{{font-family:'Space Grotesk',sans-serif;font-weight:700;font-size:28px;color:var(--blue);}}
.stat-card{{padding:16px 18px;}}
.stat-card .num{{font-family:'Space Grotesk',sans-serif;font-size:32px;font-weight:700;}}
.stat-card .num.lime{{color:var(--lime);}}
.stat-card .label{{color:var(--softer);font-size:11px;text-transform:uppercase;letter-spacing:.06em;margin-top:4px;}}
.card-merch{{overflow:hidden;padding:0;display:flex;flex-direction:column;}}
.card-merch img{{width:100%;aspect-ratio:1/1;object-fit:cover;}}
.card-merch .body{{padding:14px 16px;display:flex;flex-direction:column;gap:6px;}}
.card-merch .title{{font-weight:600;font-size:14px;}}
.card-merch .desc{{color:var(--softer);font-size:12px;}}
.card-merch .row{{display:flex;justify-content:space-between;align-items:center;margin-top:6px;}}
.card-merch .price{{font-family:'Space Grotesk',sans-serif;font-weight:700;font-size:18px;}}
.card-merch button{{padding:8px 14px;font-size:12px;}}
/* TABLES */
.standings-wrap{{padding:8px 16px;overflow-x:auto;}}
table.standings{{width:100%;border-collapse:collapse;}}
table.standings th,table.standings td{{padding:12px 8px;text-align:left;font-size:13px;}}
table.standings th{{color:var(--softer);text-transform:uppercase;letter-spacing:.06em;font-size:11px;
  font-weight:600;border-bottom:1px solid var(--border);}}
table.standings td.num,table.standings th.num{{text-align:right;font-family:'JetBrains Mono',monospace;}}
table.standings tr:not(:last-child) td{{border-bottom:1px solid var(--border);}}
table.standings tr.lead td{{background:rgba(58,141,255,.07);}}
table.standings .pill{{display:inline-flex;align-items:center;justify-content:center;width:22px;height:22px;
  border-radius:6px;background:var(--glass);font-size:12px;color:var(--soft);margin-right:8px;}}
table.standings tr.lead .pill{{background:var(--blue);color:#fff;}}
table.standings .name{{display:flex;align-items:center;gap:10px;}}
table.standings .name img{{width:28px;height:28px;border-radius:6px;}}
/* BRACKET */
.bracket{{display:grid;grid-template-columns:{ 'repeat(3,1fr)' if w >= 768 else '1fr' };
  gap:16px;padding:24px;}}
.bracket-col{{display:flex;flex-direction:column;gap:18px;justify-content:space-around;}}
.bracket-col h4{{color:var(--softer);font-size:11px;text-transform:uppercase;letter-spacing:.08em;text-align:center;font-weight:600;}}
.bracket-match{{padding:12px 14px;display:flex;flex-direction:column;gap:6px;}}
.bracket-team{{display:flex;justify-content:space-between;font-size:13px;color:var(--soft);}}
.bracket-team.win{{color:var(--lime);font-weight:600;}}
.bracket-team .score{{font-family:'JetBrains Mono',monospace;}}
/* FOOTER */
.site-footer{{margin-top:48px;padding:36px {s["container_pad"]}px 28px;
  border-top:1px solid var(--border);background:rgba(11,16,36,.6);}}
.footer-grid{{display:grid;grid-template-columns:{s["footer_cols"]};gap:28px;margin-bottom:24px;}}
.footer-col h4{{font-size:14px;margin-bottom:14px;}}
.footer-col a{{display:block;color:var(--soft);font-size:13px;margin:8px 0;}}
.subscribe{{display:flex;gap:8px;margin-top:14px;flex-wrap:wrap;}}
.subscribe input{{flex:1;min-width:140px;padding:10px 14px;border-radius:10px;
  background:var(--glass);border:1px solid var(--border);color:#fff;font-family:'Inter',sans-serif;font-size:13px;}}
.subscribe input::placeholder{{color:var(--softer);}}
.copyright{{color:var(--softer);font-size:12px;padding-top:18px;border-top:1px solid var(--border);
  display:flex;justify-content:space-between;align-items:center;gap:12px;flex-wrap:wrap;}}
.social{{display:flex;gap:10px;}}
.social a{{width:34px;height:34px;border-radius:10px;background:var(--glass);
  border:1px solid var(--border);display:inline-flex;align-items:center;justify-content:center;}}
/* TEAM PAGE */
.team-hero{{position:relative;height:{ 280 if w>=1440 else 220 if w>=768 else 180 }px;
  overflow:hidden;border-radius:24px;margin:24px {s["container_pad"]}px;border:1px solid var(--border);}}
.team-hero img{{width:100%;height:100%;object-fit:cover;}}
.team-hero::after{{content:'';position:absolute;inset:0;
  background:linear-gradient(180deg,rgba(11,16,36,.3),rgba(11,16,36,.9));}}
.team-hero .info{{position:absolute;left:32px;bottom:24px;z-index:1;}}
.team-hero h1{{font-size:{ 56 if w>=1440 else 36 if w>=768 else 26 }px;line-height:1.05;}}
.team-hero .city{{color:var(--soft);margin-top:8px;font-size:14px;}}
.team-hero .tag{{display:inline-block;padding:5px 12px;border-radius:999px;
  background:rgba(58,141,255,.18);color:var(--blue);font-size:11px;font-weight:600;
  letter-spacing:.06em;text-transform:uppercase;margin-bottom:12px;}}
/* PLAYER PAGE */
.player-head{{display:grid;grid-template-columns:{ 'auto 1fr' if w>=768 else '1fr' };
  gap:28px;padding:28px;align-items:center;margin:24px {s["container_pad"]}px;}}
.player-head img{{width:{ 320 if w>=1440 else 240 if w>=768 else 220 }px;
  aspect-ratio:1/1;border-radius:20px;object-fit:cover;}}
.player-head h1{{font-size:{ 48 if w>=1440 else 36 if w>=768 else 26 }px;}}
.player-head .role{{color:var(--soft);margin-top:8px;font-size:14px;}}
.player-head .nick{{font-family:'JetBrains Mono',monospace;color:var(--lime);margin-top:14px;font-size:14px;}}
.player-head .club{{margin-top:14px;display:flex;align-items:center;gap:8px;color:var(--soft);font-size:14px;}}
.player-head .club img{{width:32px;height:32px;border-radius:8px;}}
.player-head .number{{display:inline-flex;align-items:center;justify-content:center;
  width:64px;height:64px;border-radius:14px;background:var(--glass);font-family:'Space Grotesk',sans-serif;
  font-size:32px;font-weight:700;color:var(--blue);margin-top:14px;}}
.match-row{{padding:14px 18px;display:flex;align-items:center;justify-content:space-between;
  border-bottom:1px solid var(--border);font-size:13px;}}
.match-row:last-child{{border-bottom:0;}}
.match-row .res{{font-family:'JetBrains Mono',monospace;font-weight:600;}}
.match-row .res.win{{color:var(--lime);}}
.match-row .res.loss{{color:var(--coral);}}
.match-row .res.draw{{color:var(--soft);}}
/* SHOP */
.tabs-row{{display:flex;gap:8px;padding:24px {s["container_pad"]}px 0;flex-wrap:wrap;}}
.tab{{padding:10px 18px;border-radius:999px;background:var(--glass);border:1px solid var(--border);
  color:var(--soft);font-weight:600;font-size:13px;}}
.tab.active{{background:var(--blue);color:#fff;border-color:var(--blue);}}
.shop-layout{{display:grid;grid-template-columns:{s["shop_layout"]};gap:24px;
  padding:24px {s["container_pad"]}px;align-items:start;}}
.match-pick{{display:grid;grid-template-columns:repeat({s["cols_match"]},1fr);gap:14px;margin-bottom:24px;}}
.match-pick .card{{cursor:pointer;}}
.match-pick .card.active{{border-color:var(--blue);box-shadow:0 0 0 1px var(--blue) inset;}}
.match-pick .card img{{width:100%;height:120px;object-fit:cover;border-radius:12px;margin-bottom:12px;}}
.ticket-types{{display:grid;grid-template-columns:{s["ticket_grid"]};gap:12px;}}
.ticket-type{{padding:18px;cursor:pointer;}}
.ticket-type.active{{border-color:var(--blue);background:rgba(58,141,255,.08);}}
.ticket-type .label{{font-weight:600;font-size:15px;}}
.ticket-type .desc{{color:var(--soft);font-size:12px;margin-top:6px;}}
.ticket-type .price{{font-family:'Space Grotesk',sans-serif;font-weight:700;font-size:24px;
  color:var(--lime);margin-top:12px;}}
.summary{{padding:22px;align-self:start;}}
.summary h3{{font-size:18px;margin-bottom:14px;}}
.summary .row{{display:flex;justify-content:space-between;padding:8px 0;
  border-bottom:1px dashed var(--border);font-size:13px;color:var(--soft);}}
.summary .row span:last-child{{color:#fff;}}
.summary .total{{font-family:'Space Grotesk',sans-serif;font-size:32px;font-weight:700;color:var(--lime);margin:14px 0;}}
.summary .btn{{width:100%;}}
.filters{{display:flex;gap:8px;padding:0 {s["container_pad"]}px 16px;flex-wrap:wrap;}}
/* SECTION TITLE */
.section h2.small{{font-size:22px;}}
"""
    if w <= 360:
        base += """
/* ───── MOBILE OVERRIDES (360px) ───── */
.hero-inner{padding:20px 18px;}
.hero .badge{margin-bottom:16px;}
.hero .meta{flex-direction:column;gap:6px;}
.hero .actions{gap:8px;}
.hero .actions .btn{padding:10px 18px;font-size:13px;}
.section{padding:24px 16px;}
.section-head h2{font-size:22px;}
.section-head h2.small{font-size:18px;}
.card{padding:14px;}
.card-match .teams{gap:6px;}
.card-match .team{min-width:0;}
.card-match .team img{width:44px;height:44px;}
.card-match .team span{min-width:0;overflow-wrap:anywhere;line-height:1.2;}
.card-match .meta{font-size:11px;gap:8px;flex-wrap:wrap;}
.card-match .actions{gap:6px;}
.card-match .actions .btn{padding:10px 12px;font-size:12px;}
.card-news .body{padding:12px 14px 14px;}
.card-news h3{font-size:14px;}
.card-player .name{font-size:13px;}
.card-player .role{font-size:10px;}
.card-player .number{font-size:22px;}
.card-merch .body{padding:12px 14px;}
.card-merch .title{font-size:13px;}
.card-merch .price{font-size:16px;}
.card-merch .row{flex-direction:column;align-items:flex-start;gap:8px;}
.card-merch .btn{padding:8px 12px;font-size:11px;width:100%;}
.stat-card{padding:14px;}
.stat-card .num{font-size:26px;}
.stat-card .label{font-size:10px;}
.team-hero{height:160px;margin:18px 16px;}
.team-hero .info{left:16px;right:16px;bottom:16px;}
.team-hero h1{font-size:24px;letter-spacing:-0.03em;}
.team-hero .city{font-size:12px;}
.player-head{padding:18px;gap:14px;margin:18px 16px;}
.player-head img{width:160px;}
.player-head h1{font-size:24px;}
.player-head .role{font-size:13px;}
.player-head .club{font-size:13px;}
.match-row{padding:12px 14px;font-size:12px;}
.bracket{padding:14px;gap:12px;}
.bracket-match{padding:10px 12px;}
.bracket-team{font-size:12px;}
.tabs-row{padding:18px 16px 0;}
.shop-layout{padding:16px;gap:18px;}
.match-pick{gap:12px;}
.match-pick img{height:90px;}
.match-pick .card{padding:14px;}
.ticket-type{padding:14px;}
.ticket-type .label{font-size:14px;}
.ticket-type .desc{font-size:11px;}
.ticket-type .price{font-size:20px;}
.summary{padding:16px;}
.summary h3{font-size:16px;margin-bottom:10px;}
.summary .row{font-size:12px;padding:7px 0;}
.summary .total{font-size:28px;}
.subscribe{flex-direction:column;}
.subscribe input{min-width:0;width:100%;}
.subscribe .btn{width:100%;}
.copyright{flex-direction:column;align-items:flex-start;font-size:11px;}
.standings-wrap{padding:6px 10px;}
table.standings th,table.standings td{padding:10px 6px;font-size:12px;}
.grid-match>*,.grid-news>*,.grid-player>*,.grid-merch>*{min-width:0;}
"""
    elif w == 768:
        base += """
/* ───── TABLET OVERRIDES (768px) ───── */
.hero-inner{padding:32px;}
.section{padding:32px;}
.section-head h2{font-size:24px;}
.section-head h2.small{font-size:20px;}
.team-hero{margin:24px 32px;}
.player-head{margin:24px 32px;}
.grid-match>*,.grid-news>*,.grid-player>*,.grid-merch>*{min-width:0;}
"""
    return base


# ====================== HEADER / FOOTER ============================

NAV_ITEMS = [
    ("home.html", "Главная"),
    ("team.html", "Команды"),
    ("tournament.html", "Турнир"),
    ("shop.html", "Магазин"),
]

ICON_USER = """<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><circle cx="12" cy="8" r="4"/><path d="M4 21c0-4.4 3.6-8 8-8s8 3.6 8 8"/></svg>"""
ICON_MENU = """<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><path d="M3 6h18M3 12h18M3 18h18"/></svg>"""
ICON_SEARCH = """<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><circle cx="11" cy="11" r="7"/><path d="m20 20-3.5-3.5"/></svg>"""
ICON_TG = """<svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor"><path d="M21.4 4.6 2.9 11.7c-1.1.4-1 1.9.1 2.3l4.4 1.4 1.7 5.6c.2.7 1.1 1 1.6.5l2.6-2.5 4.7 3.4c.7.5 1.7.2 2-.7l3.4-15.5c.3-1.2-.8-2.2-2-1.6Z"/></svg>"""
ICON_VK = """<svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor"><path d="M3 5h4v6c1 0 1.7-.5 2.3-1.5l2-3c.3-.5.8-1 1.5-1H15v5c0 .8.4 1 .9.5.9-.9 2-3 2.6-4.5.2-.5.6-1 1.3-1H22c-.4 2-1.9 4.5-3.4 6.2-.4.5-.4.7 0 1.2 1.4 1.7 2.6 3.5 3.1 5.6H18c-.7 0-1-.4-1.4-1.2-.6-1.1-1.6-2.3-2.2-2.3-.4 0-.4.4-.4 1V16c0 .7-.3 1.2-1.6 1.2-2.5 0-5-1.5-6.7-3.6C3.9 11.5 3 8.4 3 6V5Z"/></svg>"""
ICON_YT = """<svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor"><path d="M21.6 7.2a2.5 2.5 0 0 0-1.8-1.8C18 5 12 5 12 5s-6 0-7.8.4A2.5 2.5 0 0 0 2.4 7.2 26 26 0 0 0 2 12c0 1.7.1 3.3.4 4.8.2.9.9 1.6 1.8 1.8C6 19 12 19 12 19s6 0 7.8-.4c.9-.2 1.6-.9 1.8-1.8.3-1.5.4-3.1.4-4.8 0-1.7-.1-3.3-.4-4.8Zm-11.6 7.6V9.2L15 12l-5 2.8Z"/></svg>"""
ICON_TWITCH = """<svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor"><path d="M4 4h16v10l-4 4h-4l-3 3H7v-3H3V6l1-2Zm2 2v10h3v3h1l3-3h4l3-3V6H6Zm5 3h2v5h-2V9Zm5 0h2v5h-2V9Z"/></svg>"""


def header_html(w, active):
    s = settings(w)
    nav = "".join(
        f'<a href="{href}" class="{"active" if href == active else ""}">{label}</a>'
        for href, label in NAV_ITEMS
    )
    if s["show_full_nav"]:
        right = f'''
      <button class="icon-btn" aria-label="Поиск">{ICON_SEARCH}</button>
      <button class="icon-btn" aria-label="Профиль">{ICON_USER}</button>
      <button class="btn btn-primary">Купить билет</button>'''
    else:
        right = f'<button class="icon-btn" aria-label="Профиль">{ICON_USER}</button>'
    return f"""
<header class="site-header">
  <div class="logo">PHYGITAL<span class="accent">·FC</span></div>
  <nav class="nav-desktop">{nav}</nav>
  <button class="nav-hamburger" aria-label="Меню">{ICON_MENU}</button>
  <div class="header-right">{right}</div>
</header>"""


def footer_html(w):
    return f"""
<footer class="site-footer">
  <div class="footer-grid">
    <div class="footer-col">
      <div class="logo" style="margin-bottom:12px">PHYGITAL<span class="accent">·FC</span></div>
      <p style="color:var(--soft);font-size:13px;margin:0 0 14px 0;max-width:340px;">
        Чемпионат России по фиджитал-футболу. Цифровое поле FIFA + физический турнир в Арене «Сибирь».
      </p>
      <div class="subscribe">
        <input type="email" placeholder="email для анонсов">
        <button class="btn btn-primary">Подписаться</button>
      </div>
    </div>
    <div class="footer-col">
      <h4>Чемпионат</h4>
      <a href="#">О турнире</a>
      <a href="#">Регламент</a>
      <a href="#">Расписание</a>
      <a href="#">Партнёры</a>
    </div>
    <div class="footer-col">
      <h4>Команды</h4>
      <a href="team.html">Все клубы</a>
      <a href="#">Игроки</a>
      <a href="#">Тренеры</a>
      <a href="#">Статистика</a>
    </div>
    <div class="footer-col">
      <h4>Помощь</h4>
      <a href="#">Возврат билетов</a>
      <a href="#">Контакты</a>
      <a href="#">FAQ</a>
      <a href="#">Пресс-центр</a>
    </div>
  </div>
  <div class="copyright">
    <span>© 2024 PHYGITAL FC. Все права защищены.</span>
    <div class="social">
      <a href="#" aria-label="Telegram">{ICON_TG}</a>
      <a href="#" aria-label="VK">{ICON_VK}</a>
      <a href="#" aria-label="YouTube">{ICON_YT}</a>
      <a href="#" aria-label="Twitch">{ICON_TWITCH}</a>
    </div>
  </div>
</footer>
"""


# ====================== PAGE BODIES ============================

def home_body(w):
    s = settings(w)
    match_cards = "".join(
        f"""
    <article class="glass card card-match">
      <div class="teams">
        <div class="team"><img src="{IMG[a_logo]}" alt=""><span>{a}</span></div>
        <span class="vs">VS</span>
        <div class="team"><img src="{IMG[b_logo]}" alt=""><span>{b}</span></div>
      </div>
      <div class="meta"><span>{when}</span><span>{venue}</span></div>
      <div class="actions">
        <button class="btn btn-ghost" style="flex:1">Билеты</button>
        <button class="btn btn-primary" style="flex:1">Трансляция</button>
      </div>
    </article>"""
        for a, b, a_logo, b_logo, when, venue, _ in MATCHES_UPCOMING
    )

    news_cards = "".join(
        f"""
    <article class="glass card-news">
      <img src="{IMG[img]}" alt="">
      <div class="body">
        <div class="date">{date}</div>
        <h3>{title}</h3>
      </div>
    </article>"""
        for date, title, img in NEWS
    )

    return f"""
<section class="hero">
  <img class="bg" src="{IMG['hero-stadium.jpg']}" alt="">
  <div class="hero-inner">
    <span class="badge">Фиджитал · FIFA 24 + Футбол</span>
    <h1>Чемпионат по&nbsp;киберфутболу.<br>Новосибирск, 2024</h1>
    <p>Шесть команд. Цифровое поле FIFA и физический матч 5×5. Арена «Сибирь», 14–17 ноября.</p>
    <div class="meta">
      <span><span class="dot">●</span> 14–17 ноября</span>
      <span><span class="dot">●</span> Арена «Сибирь», Новосибирск</span>
      <span><span class="dot">●</span> Призовой фонд 1,5 млн ₽</span>
    </div>
    <div class="actions">
      <button class="btn btn-primary">Купить билет</button>
      <button class="btn btn-ghost">Программа турнира</button>
    </div>
  </div>
</section>

<section class="section">
  <div class="section-head"><h2>Ближайшие матчи</h2><a href="tournament.html">Календарь →</a></div>
  <div class="grid-match">{match_cards}</div>
</section>

<section class="section">
  <div class="section-head"><h2>Новости и медиа</h2><a href="#">Все материалы →</a></div>
  <div class="grid-news">{news_cards}</div>
</section>
"""


def team_body(w):
    s = settings(w)
    players = "".join(
        f"""
    <article class="glass card-player">
      <img src="{IMG[img]}" alt="">
      <div class="body">
        <div>
          <div class="name">{name}</div>
          <div class="role">{role}</div>
        </div>
        <div class="number">{num}</div>
      </div>
    </article>"""
        for name, role, num, img in PLAYERS
    )
    history = """
      <div class="match-row"><span>16.05 · vs MSK United</span><span class="res win">3 : 1</span></div>
      <div class="match-row"><span>13.05 · vs KZN Eagles</span><span class="res win">2 : 0</span></div>
      <div class="match-row"><span>10.05 · vs SPB Storm</span><span class="res draw">1 : 1</span></div>
      <div class="match-row"><span>07.05 · vs EKB Wolves</span><span class="res win">4 : 2</span></div>
      <div class="match-row"><span>04.05 · vs KRD Sharks</span><span class="res win">2 : 1</span></div>"""
    return f"""
<section class="team-hero">
  <img src="{IMG['team-cover.jpg']}" alt="">
  <div class="info">
    <div class="tag">Группа A · Лидер</div>
    <h1>NSK Phantoms</h1>
    <div class="city">Новосибирск · основан в 2022 · тренер: А. Воронов</div>
  </div>
</section>

<section class="section">
  <div class="grid-stats">
    <div class="glass stat-card"><div class="num lime">13</div><div class="label">Очки</div></div>
    <div class="glass stat-card"><div class="num">14</div><div class="label">Голы</div></div>
    <div class="glass stat-card"><div class="num">04</div><div class="label">Победы</div></div>
    <div class="glass stat-card"><div class="num">1 / 6</div><div class="label">Позиция</div></div>
  </div>
  <div class="section-head"><h2 class="small">Состав</h2><a href="#">Все игроки →</a></div>
  <div class="grid-player">{players}</div>
</section>

<section class="section">
  <div class="section-head"><h2 class="small">История матчей</h2><a href="tournament.html">Турнирная сетка →</a></div>
  <div class="glass">{history}</div>
</section>
"""


def player_body(w):
    return f"""
<section class="glass player-head">
  <img src="{IMG['player-main.jpg']}" alt="">
  <div>
    <div style="color:var(--blue);font-size:13px;font-weight:600;letter-spacing:.06em;text-transform:uppercase;">Полузащитник · NSK Phantoms</div>
    <h1>Денис Литвинов</h1>
    <div class="nick">@delta_10</div>
    <div class="role">Возраст 23 · левая нога · игровая позиция CAM</div>
    <div class="club"><img src="{IMG['team-3.jpg']}" alt=""> NSK Phantoms · номер 10</div>
    <div style="margin-top:18px;display:flex;gap:10px;flex-wrap:wrap;">
      <button class="btn btn-primary">Карточка FUT</button>
      <button class="btn btn-ghost">Поделиться</button>
    </div>
  </div>
</section>

<section class="section">
  <div class="grid-stats">
    <div class="glass stat-card"><div class="num">05</div><div class="label">Матчи</div></div>
    <div class="glass stat-card"><div class="num lime">06</div><div class="label">Голы</div></div>
    <div class="glass stat-card"><div class="num">08</div><div class="label">Передачи</div></div>
    <div class="glass stat-card"><div class="num">8.4</div><div class="label">Рейтинг</div></div>
  </div>

  <div class="section-head"><h2 class="small">Последние матчи</h2><a href="team.html">Профиль команды →</a></div>
  <div class="glass">
    <div class="match-row"><span>16.05 · vs MSK United · 90′</span><span class="res win">9.1</span></div>
    <div class="match-row"><span>13.05 · vs KZN Eagles · 87′</span><span class="res win">8.7</span></div>
    <div class="match-row"><span>10.05 · vs SPB Storm · 90′</span><span class="res draw">7.9</span></div>
    <div class="match-row"><span>07.05 · vs EKB Wolves · 76′</span><span class="res win">8.5</span></div>
    <div class="match-row"><span>04.05 · vs KRD Sharks · 90′</span><span class="res win">8.2</span></div>
  </div>
</section>

<section class="section">
  <div class="section-head"><h2 class="small">Медиа и соцсети</h2></div>
  <div style="display:flex;gap:10px;flex-wrap:wrap;">
    <a href="#" class="chip">Telegram · @delta_10</a>
    <a href="#" class="chip">VK · delta10</a>
    <a href="#" class="chip">Twitch · delta_phygital</a>
    <a href="#" class="chip">YouTube · DELTA10</a>
  </div>
</section>
"""


def tournament_body(w):
    rows = "".join(
        f"""
    <tr class="{'lead' if lead else ''}">
      <td><span class="pill">{i+1}</span></td>
      <td class="name"><img src="{IMG[img]}" alt="">{name}</td>
      <td class="num">{M}</td>
      <td class="num">{W}</td>
      <td class="num">{D}</td>
      <td class="num">{L}</td>
      <td class="num">{GF}:{GA}</td>
      <td class="num"><strong>{Pts}</strong></td>
    </tr>"""
        for i, (name, M, W, D, L, GF, GA, Pts, img, lead) in enumerate(GROUP_A)
    )

    bracket = f"""
<section class="section">
  <div class="section-head"><h2 class="small">Плей-офф</h2><a href="#">Регламент →</a></div>
  <div class="glass bracket">
    <div class="bracket-col">
      <h4>1/4 финала</h4>
      <div class="glass-strong bracket-match">
        <div class="bracket-team win"><span>NSK Phantoms</span><span class="score">3</span></div>
        <div class="bracket-team"><span>KRD Sharks</span><span class="score">1</span></div>
      </div>
      <div class="glass-strong bracket-match">
        <div class="bracket-team win"><span>MSK United</span><span class="score">2</span></div>
        <div class="bracket-team"><span>EKB Wolves</span><span class="score">0</span></div>
      </div>
      <div class="glass-strong bracket-match">
        <div class="bracket-team win"><span>SPB Storm</span><span class="score">2</span></div>
        <div class="bracket-team"><span>KZN Eagles</span><span class="score">1</span></div>
      </div>
      <div class="glass-strong bracket-match">
        <div class="bracket-team"><span>—</span><span class="score">·</span></div>
        <div class="bracket-team"><span>—</span><span class="score">·</span></div>
      </div>
    </div>
    <div class="bracket-col">
      <h4>1/2 финала</h4>
      <div class="glass-strong bracket-match">
        <div class="bracket-team win"><span>NSK Phantoms</span><span class="score">4</span></div>
        <div class="bracket-team"><span>MSK United</span><span class="score">2</span></div>
      </div>
      <div class="glass-strong bracket-match">
        <div class="bracket-team"><span>SPB Storm</span><span class="score">—</span></div>
        <div class="bracket-team"><span>TBD</span><span class="score">—</span></div>
      </div>
    </div>
    <div class="bracket-col">
      <h4>Финал</h4>
      <div class="glass-strong bracket-match" style="border-color:var(--lime);">
        <div class="bracket-team win"><span>NSK Phantoms</span><span class="score">—</span></div>
        <div class="bracket-team"><span>TBD</span><span class="score">—</span></div>
      </div>
    </div>
  </div>
</section>"""

    return f"""
<section class="section">
  <div class="section-head">
    <div>
      <h2>Турнирная таблица</h2>
      <div style="color:var(--soft);font-size:13px;margin-top:6px;">Группа A · после 5 туров</div>
    </div>
    <div style="display:flex;gap:8px;flex-wrap:wrap;">
      <span class="chip active">Группа A</span>
      <span class="chip">Группа B</span>
      <span class="chip">Плей-офф</span>
    </div>
  </div>
  <div class="glass standings-wrap">
    <table class="standings">
      <thead>
        <tr>
          <th>#</th>
          <th>Команда</th>
          <th class="num">M</th>
          <th class="num">W</th>
          <th class="num">D</th>
          <th class="num">L</th>
          <th class="num">GF:GA</th>
          <th class="num">Pts</th>
        </tr>
      </thead>
      <tbody>{rows}</tbody>
    </table>
  </div>
</section>
{bracket}
"""


def shop_body(w):
    s = settings(w)
    match_picks = "".join(
        f"""
    <article class="glass card{ ' active' if i == 0 else '' }">
      <img src="{IMG[poster]}" alt="">
      <div style="display:flex;justify-content:space-between;align-items:center;font-size:13px;">
        <strong>{a} – {b}</strong>
        <span style="color:var(--soft);">{when}</span>
      </div>
      <div style="color:var(--softer);font-size:12px;margin-top:6px;">{venue}</div>
    </article>"""
        for i, (a, b, _, _, when, venue, poster) in enumerate(MATCHES_UPCOMING)
    )

    merch_cards = "".join(
        f"""
    <article class="glass card-merch">
      <img src="{IMG[img]}" alt="">
      <div class="body">
        <span class="title">{title}</span>
        <span class="desc">Лимитированная серия чемпионата 2024</span>
        <div class="row">
          <span class="price">{price}</span>
          <button class="btn btn-lime">В корзину</button>
        </div>
      </div>
    </article>"""
        for title, price, img in MERCH[: 6]
    )

    return f"""
<div class="tabs-row">
  <button class="tab active">Билеты</button>
  <button class="tab">Сувениры</button>
</div>

<div class="shop-layout">
  <div>
    <h2 style="font-size:22px;margin-bottom:6px;">Выбор матча</h2>
    <p style="color:var(--soft);font-size:13px;margin:0 0 16px 0;">Активная карточка — матч, на который оформляется билет.</p>
    <div class="match-pick">{match_picks}</div>

    <h2 style="font-size:22px;margin:24px 0 6px 0;">Тип билета</h2>
    <p style="color:var(--soft);font-size:13px;margin:0 0 16px 0;">Выберите формат посещения мероприятия.</p>
    <div class="ticket-types">
      <article class="glass ticket-type active">
        <div class="label">Только просмотр</div>
        <div class="desc">Место в зрительном зале, доступ ко всем матчам дня. Без зоны дегустаций.</div>
        <div class="price">1 990 ₽</div>
      </article>
      <article class="glass ticket-type">
        <div class="label">Просмотр + дегустация</div>
        <div class="desc">Место в зрительном зале + Fan Zone с напитками и снеками от партнёров.</div>
        <div class="price">3 490 ₽</div>
      </article>
    </div>
  </div>

  <aside class="glass summary">
    <h3>Ваш заказ</h3>
    <div class="row"><span>Матч</span><span>NSK – MSK</span></div>
    <div class="row"><span>Дата</span><span>Сб · 19:00</span></div>
    <div class="row"><span>Сектор</span><span>B · ряд 12</span></div>
    <div class="row"><span>Тип</span><span>Только просмотр</span></div>
    <div class="row"><span>Цена</span><span class="mono">1 990 ₽</span></div>
    <div class="total">1 990 ₽</div>
    <button class="btn btn-primary">Оплатить</button>
    <div style="color:var(--softer);font-size:11px;margin-top:10px;text-align:center;">
      Возврат до 24 ч до начала · все цены с НДС
    </div>
  </aside>
</div>

<div class="filters">
  <span class="chip active">Все</span>
  <span class="chip">Одежда</span>
  <span class="chip">Аксессуары</span>
  <span class="chip">Коллекционное</span>
</div>

<section class="section" style="padding-top:0;">
  <div class="section-head"><h2 class="small">Каталог сувениров</h2><a href="#">Все товары →</a></div>
  <div class="grid-merch">{merch_cards}</div>
</section>
"""


PAGES = {
    "home":       ("home.html",       "Главная — PHYGITAL FC",           home_body),
    "team":       ("team.html",       "NSK Phantoms — PHYGITAL FC",      team_body),
    "player":     ("player.html",     "Денис Литвинов — PHYGITAL FC",    player_body),
    "tournament": ("tournament.html", "Турнирная таблица — PHYGITAL FC", tournament_body),
    "shop":       ("shop.html",       "Магазин — PHYGITAL FC",           shop_body),
}


def page_html(w, key):
    fname, title, body_fn = PAGES[key]
    return f"""<!doctype html>
<html lang="ru">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width={w}, initial-scale=1">
<title>{title}</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Space+Grotesk:wght@500;600;700&family=JetBrains+Mono:wght@400;600&display=swap" rel="stylesheet">
<style>{css(w)}</style>
</head>
<body>
{header_html(w, fname)}
{body_fn(w)}
{footer_html(w)}
</body>
</html>
"""


def build():
    for w, sub in WIDTHS.items():
        out_dir = f"{ROOT}/{sub}"
        pathlib.Path(out_dir).mkdir(parents=True, exist_ok=True)
        for key, (fname, _, _) in PAGES.items():
            html = page_html(w, key)
            with open(f"{out_dir}/{fname}", "w", encoding="utf-8") as fp:
                fp.write(html)
            print(f"  {sub:8s}/{fname:18s}  {len(html)//1024:4d} KB")


WIDTHS = {1440: "desktop", 768: "tablet", 360: "mobile"}

if __name__ == "__main__":
    print("Building 15 HTML mockups...")
    build()
    print("Done.")
