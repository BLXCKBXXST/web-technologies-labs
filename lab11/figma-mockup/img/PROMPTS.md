# Промты для генерации картинок (lab11 — PHYGITAL FC)

27 готовых самодостаточных промтов для визуальной AI-модели (Midjourney, Flux, SDXL, DALL-E 3 и т. п.). Каждый промт — единый блок: внутри уже зашит стиль (палитра, glassmorphism), целевые размеры в пикселях и пропорции, и негативные ограничения. **Копируй блок целиком и вставляй в нейросеть.**

После генерации:
1. Привести каждую картинку к точному `WxH` (если модель отдаёт другой формат — кропнуть/масштабировать в Photoshop / GIMP / `convert` ImageMagick).
2. Пересохранить как JPG (quality 75–82) — уложиться в указанный диапазон KB.
3. Положить в `lab11/figma-mockup/img/` под именем из заголовка.
4. Пересобрать HTML: `cd lab11/figma-mockup && python3 build.py`.

Bash-проверка размеров и веса после раскладки:
```bash
cd lab11/figma-mockup/img
for f in *.jpg; do
  identify -format "%f  %wx%h  %b\n" "$f" 2>/dev/null || \
    printf "%-22s %s\n" "$f" "$(du -h "$f" | cut -f1)"
done
```

---

## Группа 1. Hero-фоны

### `hero-stadium.jpg` — 1440×600, 60–120 KB
**Где:** главная страница, Hero-блок (фон под заголовком чемпионата).

```
Wide cinematic shot of a futuristic indoor esports football arena, view from upper spectator seats. Empty green football pitch at the center, ringed by glowing LED panels in electric blue (#3A8DFF) and lime green (#C7FF4F). Stadium seats fade into deep navy (#0B1024) haze. Volumetric light beams from the ceiling, dust particles drifting through the air, a distant scoreboard glowing softly. Atmospheric, moody, prestigious championship ambiance. Camera at 30 degree angle, wide-angle lens. Hybrid esports aesthetic, glassmorphism inspired, cinematic atmospheric lighting, modern professional sports brand visual identity. High detail, sharp focus, photographic quality. Aspect ratio 12:5, image size 1440 by 600 pixels. No text overlay, no watermark, no real brand logos, no real person likeness.
```

### `team-cover.jpg` — 1440×400, 50–90 KB
**Где:** страница команды, обложка-баннер под названием клуба.

```
Wide cinematic banner background for an esports football team page. Abstract dark environment with ethereal blue smoke trails forming a vague ghost-like silhouette in the right third of the frame. Subtle football pitch line geometry reflecting in the haze, electric blue (#3A8DFF) rim lighting from below. Empty negative space in the left two-thirds for text overlay. Color palette: deep navy (#0B1024), electric blue accents, lime green (#C7FF4F) highlight. Atmospheric, moody, premium sports brand aesthetic, glassmorphism inspired, cinematic lighting. High detail, sharp focus, photographic quality. Aspect ratio 18:5, image size 1440 by 400 pixels. No text overlay, no watermark, no real brand logos, no real person likeness.
```

---

## Группа 2. Эмблемы команд (320×320, 8–20 KB каждая)

### `team-1.jpg` — MSK United
```
Modern circular crest emblem for a fictional esports football team called "MSK United". Flat vector style, geometric design, centered and symmetrical. Stylized abstract M-letter shaped like a goal frame as the central motif, rendered in electric blue (#3A8DFF) gradient on a deep navy (#0B1024) background. Subtle digital-circuit pattern inside the shield outline. Clean lines, sharp angles, premium sports brand identity. Aspect ratio 1:1, image size 320 by 320 pixels. No text inside the crest, no watermark, no real brand logos.
```

### `team-2.jpg` — SPB Storm
```
Modern circular crest emblem for a fictional esports football team called "SPB Storm". Flat vector style, geometric design, centered and symmetrical. Lightning bolt motif piercing a stylized abstract S-shape, rendered in lime green (#C7FF4F) and white on a deep navy (#0B1024) background. Subtle electrical-energy lines radiating outward from the center. Clean lines, sharp angles, premium sports brand identity. Aspect ratio 1:1, image size 320 by 320 pixels. No text inside the crest, no watermark, no real brand logos.
```

### `team-3.jpg` — NSK Phantoms
```
Modern circular crest emblem for a fictional esports football team called "NSK Phantoms". Flat vector style, geometric design, centered and symmetrical. Abstract translucent ghost silhouette holding a stylized football, rendered with a soft coral pink (#FF5A7A) glow on a deep navy (#0B1024) background. Mystic, slightly ethereal, wisps of energy around the figure. Clean lines, premium sports brand identity. Aspect ratio 1:1, image size 320 by 320 pixels. No text inside the crest, no watermark, no real brand logos.
```

### `team-4.jpg` — KZN Eagles
```
Modern circular crest emblem for a fictional esports football team called "KZN Eagles". Flat vector style, geometric design, centered and symmetrical. Stylized eagle wing forming an abstract K-letter as the central motif, rendered in amber-gold (#FFC850) on a deep navy (#0B1024) background. Low-poly inspired, sharp angles, predatory yet noble aesthetic. Clean lines, premium sports brand identity. Aspect ratio 1:1, image size 320 by 320 pixels. No text inside the crest, no watermark, no real brand logos.
```

### `team-5.jpg` — EKB Wolves
```
Modern circular crest emblem for a fictional esports football team called "EKB Wolves". Flat vector style, geometric design, centered and symmetrical. Abstract wolf head silhouette with glowing purple (#B478FF) eyes as the central motif, rendered on a deep navy (#0B1024) background. Low-poly inspired, sharp angles, predatory aura. Clean lines, premium sports brand identity. Aspect ratio 1:1, image size 320 by 320 pixels. No text inside the crest, no watermark, no real brand logos.
```

### `team-6.jpg` — KRD Sharks
```
Modern circular crest emblem for a fictional esports football team called "KRD Sharks". Flat vector style, geometric design, centered and symmetrical. Stylized shark fin cutting through abstract wave patterns as the central motif, rendered in teal (#50DCC8) and white on a deep navy (#0B1024) background. Sharp, aggressive, dynamic energy. Clean lines, premium sports brand identity. Aspect ratio 1:1, image size 320 by 320 pixels. No text inside the crest, no watermark, no real brand logos.
```

---

## Группа 3. Портреты игроков

### `player-1.jpg` — 320×320, 10–25 KB · Вратарь
```
Stylized studio portrait of a young fictional male esports football player, age 22 to 25, goalkeeper role. Confident pose with arms crossed in front of the chest, goalkeeper gloves visible in one hand. Short dark hair, determined facial expression looking slightly off-camera. Wearing a dark navy team jersey with electric blue (#3A8DFF) and lime green (#C7FF4F) accents. Background: deep navy (#0B1024) studio backdrop with subtle electric blue rim lighting from the side. Sharp focus on the face, soft bokeh background. Professional sports portrait photography style, three-point lighting, premium magazine cover quality. Aspect ratio 1:1, image size 320 by 320 pixels. Fictional character, no real person likeness, no text overlay, no watermark, no real brand logos.
```

### `player-2.jpg` — 320×320, 10–25 KB · Защитник
```
Stylized studio portrait of a young fictional male esports football player, age 20 to 24, defender role. Three-quarter view, looking off-camera with a stoic serious expression. Buzz-cut hair, esports headphones resting around the neck. Wearing a dark navy team jersey with electric blue (#3A8DFF) and lime green (#C7FF4F) accents. Background: deep navy (#0B1024) studio backdrop with subtle electric blue rim lighting from behind. Sharp focus on the face, soft bokeh background. Professional sports portrait photography style, three-point lighting. Aspect ratio 1:1, image size 320 by 320 pixels. Fictional character, no real person likeness, no text overlay, no watermark, no real brand logos.
```

### `player-3.jpg` — 320×320, 10–25 KB · ПЗ №10
```
Stylized studio portrait of a young fictional male esports football player, age 21 to 24, midfielder role. Confident half-smile, holding a gaming controller in one hand. Curly dark-brown hair, alert focused eyes looking directly at the camera. Wearing a dark navy team jersey with electric blue (#3A8DFF) and lime green (#C7FF4F) accents, the number 10 partially visible on the jersey. Background: deep navy (#0B1024) studio backdrop with subtle electric blue rim lighting. Sharp focus on the face, soft bokeh background. Professional sports portrait photography style, three-point lighting. Aspect ratio 1:1, image size 320 by 320 pixels. Fictional character, no real person likeness, no text overlay, no watermark, no real brand logos.
```

### `player-4.jpg` — 320×320, 10–25 KB · ПЗ №17
```
Stylized studio portrait of a young fictional male esports football player, age 19 to 23, midfielder role. Head slightly tilted to one side, concentrated thoughtful expression. An esports headset earpiece visible at one ear. Wearing a dark navy team jersey with electric blue (#3A8DFF) and lime green (#C7FF4F) accents. Background: deep navy (#0B1024) studio backdrop with subtle electric blue rim lighting. Sharp focus on the face, soft bokeh background. Professional sports portrait photography style, three-point lighting. Aspect ratio 1:1, image size 320 by 320 pixels. Fictional character, no real person likeness, no text overlay, no watermark, no real brand logos.
```

### `player-5.jpg` — 320×320, 10–25 KB · Нападающий
```
Stylized studio portrait of a young fictional male esports football player, age 20 to 24, forward role. Energetic mid-celebration pose with one fist raised, exuberant emotional facial expression. Long hair tied back in a ponytail. Wearing a dark navy team jersey with electric blue (#3A8DFF) and lime green (#C7FF4F) accents. Background: deep navy (#0B1024) studio backdrop with subtle lime green rim lighting accent. Sharp focus on the face, soft bokeh background. Professional sports portrait photography style, three-point lighting. Aspect ratio 1:1, image size 320 by 320 pixels. Fictional character, no real person likeness, no text overlay, no watermark, no real brand logos.
```

### `player-main.jpg` — 480×480, 25–50 KB · Hero-портрет «delta»
```
Premium hero portrait of a young fictional male esports football player nicknamed "delta", age 23, midfielder role. Cinematic magazine cover style, three-point lighting, intense direct eye contact with the camera. Curly dark-brown hair, focused confident expression. Wearing a dark navy team jersey with a clearly visible electric blue (#3A8DFF) number "10" printed on the chest. Background: gradient from deep navy (#0B1024) on the left to electric blue (#3A8DFF) on the right, with subtle football pitch line geometry visible behind the subject. Slight rim-light glow on the edges of the figure. High-end professional sports photography. Aspect ratio 1:1, image size 480 by 480 pixels. Fictional character, no real person likeness, no text overlay, no watermark, no real brand logos.
```

---

## Группа 4. Мерч-каталог (360×360, 12–25 KB каждая)

### `merch-1.jpg` — Игровая форма
```
Studio product photography of a folded or hanging football jersey for a fictional esports team. Color palette: deep navy (#0B1024) base with electric blue (#3A8DFF) sleeve trims and chest accent. Front view, slightly angled three-quarter perspective, clean composition. Subtle fabric weave texture visible. Background: deep navy seamless backdrop with soft natural shadows and lime green (#C7FF4F) accent rim light from one side. E-commerce style, sharp focus on product details, centered composition. Aspect ratio 1:1, image size 360 by 360 pixels. No text overlay, no watermark, no real brand logos.
```

### `merch-2.jpg` — Фан-шарф
```
Studio product photography of a folded lime green (#C7FF4F) knit football fan scarf with dark navy (#0B1024) horizontal stripes, for a fictional esports team. Top-down or slight angle view, neatly folded in half with visible knit texture and fringe ends. Background: deep navy seamless backdrop with soft natural shadows and electric blue (#3A8DFF) accent rim light from one side. E-commerce style, sharp focus on knit texture details, centered composition. Aspect ratio 1:1, image size 360 by 360 pixels. No text overlay, no watermark, no real brand logos.
```

### `merch-3.jpg` — Кепка
```
Studio product photography of a dark navy (#0B1024) snapback baseball cap for a fictional esports team. Three-quarter side view showing the brim and the front panel. Subtle embroidered geometric pattern on the front (abstract shapes, no letters or numbers). Electric blue (#3A8DFF) accent stitching along the brim edge. Background: deep navy seamless backdrop with soft natural shadows and lime green (#C7FF4F) accent rim light. E-commerce style, sharp focus on fabric weave and embroidery details, centered composition. Aspect ratio 1:1, image size 360 by 360 pixels. No text overlay, no watermark, no real brand logos.
```

### `merch-4.jpg` — Худи
```
Studio product photography of a dark navy (#0B1024) pullover hoodie for a fictional esports team, laid flat or worn by an invisible mannequin. Front view, electric blue (#3A8DFF) geometric chest print (abstract shapes only, no letters or numbers). Subtle cotton fleece texture, drawstrings visible at the neckline. Background: deep navy seamless backdrop with soft natural shadows and lime green (#C7FF4F) accent rim light from one side. E-commerce style, sharp focus on fabric texture and print details, centered composition. Aspect ratio 1:1, image size 360 by 360 pixels. No text overlay, no watermark, no real brand logos.
```

### `merch-5.jpg` — Кружка
```
Studio product photography of a white ceramic mug for a fictional esports team, side view. A dark navy (#0B1024) geometric print on the body of the mug (abstract shapes only, no letters or numbers). Glossy ceramic surface with subtle light reflections, gentle drop shadow on the surface below. Background: deep navy seamless backdrop with soft natural shadows and lime green (#C7FF4F) accent rim light from one side. E-commerce style, sharp focus on the print and ceramic texture, centered composition. Aspect ratio 1:1, image size 360 by 360 pixels. No text overlay, no watermark, no real brand logos.
```

### `merch-6.jpg` — Набор пинов
```
Studio product photography flat-lay of three to four enamel collectible pins for a fictional esports football championship, arranged on a flat surface. Pin motifs: a stylized football, a gaming controller silhouette, a lightning bolt, and a small abstract circular crest. Metallic enamel finish in electric blue (#3A8DFF), lime green (#C7FF4F), and dark navy (#0B1024) colors. Top-down camera angle. Background: deep navy (#0B1024) flat surface with soft natural shadows. E-commerce style, sharp focus on metallic texture and enamel details. Aspect ratio 1:1, image size 360 by 360 pixels. No text overlay, no watermark, no real brand logos.
```

---

## Группа 5. Превью новостей (720×420, 25–50 KB каждая)

### `news-1.jpg` — Восемь команд в группу A
```
Wide cinematic editorial illustration depicting eight stylized circular team emblems arranged in a tournament bracket grid layout (four by two or symmetrical bracket tree). Thin glowing electric blue (#3A8DFF) connector lines between the emblems suggest a knockout bracket. Atmospheric depth, soft volumetric haze, deep navy (#0B1024) background. Color palette: deep navy with electric blue and lime green (#C7FF4F) accents. Glassmorphism inspired, premium sports media editorial aesthetic. Aspect ratio 12:7, image size 720 by 420 pixels. No text overlay, no watermark, no real brand logos.
```

### `news-2.jpg` — Арена снаружи
```
Wide cinematic exterior nighttime photograph of a futuristic indoor sports arena building. Electric blue (#3A8DFF) and lime green (#C7FF4F) LED accent lighting on the modern glass-and-steel facade. Light snow on the ground in the foreground. Silhouette of a Siberian Russian city skyline visible in the distance. Atmospheric mist, glowing windows, prestigious venue ambiance. Deep navy (#0B1024) night sky. Cinematic wide-angle composition. Aspect ratio 12:7, image size 720 by 420 pixels. No text overlay, no watermark, no real brand logos.
```

### `news-3.jpg` — Игрок недели
```
Wide cinematic behind-the-scenes photograph of a young fictional male esports football player at a gaming station. Multiple monitors with an abstract football-game-like interface visible (no recognizable game UI), a gaming chair, RGB-lit peripherals. Lime green (#C7FF4F) and electric blue (#3A8DFF) ambient lighting coming from the monitors and LED strips. Player shown in profile view with a focused concentrated expression. Deep navy (#0B1024) studio background with atmospheric haze. Cinematic side-angle composition, shallow depth of field. Aspect ratio 12:7, image size 720 by 420 pixels. Fictional character, no real person likeness, no text overlay, no watermark, no real brand logos.
```

### `news-4.jpg` — Fan Zone
```
Wide cinematic interior photograph of a stylish sports fan zone venue. A long bar counter with snacks, drinks, and tasting glasses in the foreground. Neon LED signage on the back wall with abstract glowing letterforms (not forming real words). Blurred silhouettes of fans in the background. Lime green (#C7FF4F) and electric blue (#3A8DFF) accent lighting, deep navy (#0B1024) ambient mood. Atmospheric depth, shallow depth of field, premium venue ambiance. Aspect ratio 12:7, image size 720 by 420 pixels. No readable text, no watermark, no real brand logos.
```

---

## Группа 6. Постеры матчей (720×420, 25–50 KB каждая)

Симметричная композиция «команда А слева / пустое место в центре под наложение текста / команда Б справа». Текст не рисовать в самой картинке — он накладывается через CSS поверх.

### `match-1.jpg` — NSK Phantoms vs MSK United
```
Wide cinematic championship match poster background. Symmetric composition: a glowing translucent ghost-like silhouette in soft coral pink (#FF5A7A) wreathed in mist occupies the left third of the frame; a stylized geometric urban skyline silhouette in electric blue (#3A8DFF) occupies the right third; an empty negative-space gap in the center is reserved for overlay text. Atmospheric deep navy (#0B1024) background connecting both sides. Volumetric haze, cinematic rim lighting, premium sports media aesthetic. Aspect ratio 12:7, image size 720 by 420 pixels. No text in the image itself, no watermark, no real brand logos.
```

### `match-2.jpg` — SPB Storm vs EKB Wolves
```
Wide cinematic championship match poster background. Symmetric composition: a dramatic lightning bolt slashing through the left third of the frame with a lime green (#C7FF4F) glow; glowing purple (#B478FF) wolf eyes peering out of the darkness in the right third; an empty negative-space gap in the center is reserved for overlay text. Atmospheric deep navy (#0B1024) background connecting both sides. Volumetric haze, cinematic rim lighting, premium sports media aesthetic. Aspect ratio 12:7, image size 720 by 420 pixels. No text in the image itself, no watermark, no real brand logos.
```

### `match-3.jpg` — KZN Eagles vs KRD Sharks
```
Wide cinematic championship match poster background. Symmetric composition: an outstretched eagle wing rendered in amber-gold (#FFC850) light occupies the left third of the frame; a sharp shark fin cutting through teal (#50DCC8) wave patterns occupies the right third; an empty negative-space gap in the center is reserved for overlay text. Atmospheric deep navy (#0B1024) background connecting both sides. Volumetric haze, cinematic rim lighting, premium sports media aesthetic. Aspect ratio 12:7, image size 720 by 420 pixels. No text in the image itself, no watermark, no real brand logos.
```

---

## Сводная таблица 27 файлов

| # | Файл | WxH | Вес (KB) | Назначение в HTML |
|---:|---|---|---:|---|
|  1 | `hero-stadium.jpg` | 1440×600 | 60–120 | home: Hero-фон |
|  2 | `team-cover.jpg`   | 1440×400 | 50–90  | team: обложка |
|  3 | `team-1.jpg`       | 320×320  | 8–20   | эмблема MSK United |
|  4 | `team-2.jpg`       | 320×320  | 8–20   | эмблема SPB Storm |
|  5 | `team-3.jpg`       | 320×320  | 8–20   | эмблема NSK Phantoms |
|  6 | `team-4.jpg`       | 320×320  | 8–20   | эмблема KZN Eagles |
|  7 | `team-5.jpg`       | 320×320  | 8–20   | эмблема EKB Wolves |
|  8 | `team-6.jpg`       | 320×320  | 8–20   | эмблема KRD Sharks |
|  9 | `player-1.jpg`     | 320×320  | 10–25  | team: вратарь #01 |
| 10 | `player-2.jpg`     | 320×320  | 10–25  | team: защитник #07 |
| 11 | `player-3.jpg`     | 320×320  | 10–25  | team: ПЗ #10 |
| 12 | `player-4.jpg`     | 320×320  | 10–25  | team: ПЗ #17 |
| 13 | `player-5.jpg`     | 320×320  | 10–25  | team: нападающий #23 |
| 14 | `player-main.jpg`  | 480×480  | 25–50  | player: hero-портрет |
| 15 | `merch-1.jpg`      | 360×360  | 12–25  | shop: форма |
| 16 | `merch-2.jpg`      | 360×360  | 12–25  | shop: шарф |
| 17 | `merch-3.jpg`      | 360×360  | 12–25  | shop: кепка |
| 18 | `merch-4.jpg`      | 360×360  | 12–25  | shop: худи |
| 19 | `merch-5.jpg`      | 360×360  | 12–25  | shop: кружка |
| 20 | `merch-6.jpg`      | 360×360  | 12–25  | shop: пины |
| 21 | `news-1.jpg`       | 720×420  | 25–50  | home: новость про команды |
| 22 | `news-2.jpg`       | 720×420  | 25–50  | home: новость про арену |
| 23 | `news-3.jpg`       | 720×420  | 25–50  | home: новость «игрок недели» |
| 24 | `news-4.jpg`       | 720×420  | 25–50  | home: новость про Fan Zone |
| 25 | `match-1.jpg`      | 720×420  | 25–50  | shop: постер NSK vs MSK |
| 26 | `match-2.jpg`      | 720×420  | 25–50  | shop: постер SPB vs EKB |
| 27 | `match-3.jpg`      | 720×420  | 25–50  | shop: постер KZN vs KRD |

**Итоговый вес папки** после замены: ~700 KB–1.5 MB. Если файлы слишком тяжёлые — снизить JPG quality до 70.
