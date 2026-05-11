# King_AbramUI

Кастомный Roblox-executor скрипт с GUI для автоматизации слайм-игры.

## Файлы

- **`SliemAbram.lua`** — основной скрипт с современным dark-UI, мобильной адаптацией и набором автоматов (Auto Roll / Farm / Kill / Best Zone / Upgrade / Rebirth / Feed / Equip Best, Discord webhook).
- **`SkyWars.lua`** — полнофункциональный скрипт для SkyWars-подобных игр: Auto Farm руды, event-driven Noclip, Anti-Void, набор Movement-фич (Fly/Speed/HighJump/FastFall/NoRotate/Blink/TPaura), Combat (AutoClicker/AutoBow), Visual (FOV/Chams/ESP/Ore ESP/NoCameraClip/NoRender), anti-detect jitter, dark-UI с вкладками Main / Movement / Visual / Settings / Info, ALT для скрытия, мобильная кнопка `SW`.
- **`abramUI.lua`** — альтернативная сборка UI.

## Возможности `SliemAbram.lua`

### Automation (вкладка **Main**)
- **Auto Roll** — крутит ролл с интервалом из `RollSpeed`-стата.
- **Auto Index** — клеймит все награды индекса (`basic`, `big`, `huge`, `shiny`, `inverted`).
- **Auto Farm** — притягивает дроп к игроку. С `AntiDetectJitter` добавляет небольшой шум, чтобы паттерн выглядел менее механически.
- **Auto Potions** — пьёт `luck`, `ultraLuck`, `currency`, `rollSpeed` зелья каждые 3 с.
- **Auto Kill** — телепорт-фарм ближайшего врага с лёгким джиттером.
- **Auto Best Zone** — телепортирует в следующую (ещё не открытую) зону, чтобы быстрее её разблокировать.

### Performance (вкладка **Main**)
- **Zero Load** — единый «снять всю нагрузку» тоггл. При включении:
  - отключает `GlobalShadows`, туман и все PostFX в Lighting (`Bloom`, `Blur`, `DepthOfField`, `SunRays`, `ColorCorrection`);
  - у `Terrain` отключает декорацию, обнуляет волны/отражения воды и делает воду прозрачной;
  - у всех `BasePart` ставит материал `Plastic`, `Reflectance = 0`, `CastShadow = false`;
  - глушит `ParticleEmitter`, `Beam`, `Trail`, `Smoke`, `Fire`, `Sparkles`; у `Explosion` обнуляет радиус;
  - уничтожает все `Decal` / `Texture` / `SurfaceAppearance`;
  - понижает `settings().Rendering.QualityLevel` до минимума через `sethiddenproperty` (если executor поддерживает);
  - ставит FPS cap = 30 через `setfpscap` (если поддерживается);
  - выключает все чужие `ScreenGui` в `PlayerGui`, чтобы не тратить UI-render;
  - подписывается на `game.DescendantAdded` — те же правила применяются ко всем новым объектам.

  **Внимание:** удалённые текстуры/декали, понижение `QualityLevel` и FPS cap **не откатываются** автоматически — нужен перезаход в игру для полного восстановления.

### Progression (вкладка **Upgrades**)
- **MEGA Auto Upgrade** — закупает все апгрейды из захардкоженного списка. Купленные ID кэшируются и больше не дёргаются.
- **Auto Buy Zone** — `ZonesService.requestPurchaseZone`.
- **Auto Rebirth** — `RebirthService.requestRebirth`.
- **Auto Equip Best** — `InventoryService.requestEquipBest`.
- **Auto Feed Slimes** — кормит экипированных слаймов едой, поделив поровну. `Feed reserve` задаёт минимальный остаток каждого вида (например, оставить 100 яблок про запас).

### Webhook (вкладка **Webhook**)
- Discord webhook с периодической отправкой никнейма и числа роллов.
- Проверка URL регуляркой перед отправкой.
- Кнопка `Send test message`.

## Технические особенности

- **Один файл, никакой инсталляции** — копируется в executor, запускается loadstring-ом.
- **Динамический поиск Remotes** через `ReplicatedStorage.Packages._Index.*networker*._remotes` — устойчив к минорным апдейтам игры.
- **Кэш Remote-сервисов и RemoteFunction'ов** — без полного обхода `_Index` на каждый вызов.
- **Несколько фолбэков** для получения экипированных слаймов и количества еды: `DataService.client:get` → `getDataSource("equipped")` → `getValue` → парсинг UI.
- **Корректное управление ресурсами** — `task.cancel` для тредов, `:Disconnect()` для коннекшенов, выключение noclip при выключении AutoKill.
- **Неймспейс `_G.AbramSliem`** — никаких разрозненных глобалов.
- **Персистентный конфиг** через `writefile`/`readfile` (если executor поддерживает) в `AbramSliem_config.json`.
- **Defensive executor detection** — на старте проверяется наличие HTTP API и файловой системы; уведомления подсказывают, что недоступно.

## Управление

- **PC**: `ALT` — скрыть/показать меню.
- **Mobile**: кнопка `AS` в правом верхнем углу + перетаскиваемый pill-виджет.
- Перетаскивание главного окна — зажать в любом месте окна и тянуть.
- Перетаскивание pill / mobile-кнопки — зажать и тянуть.

## Конфиг

`AbramSliem_config.json` создаётся в корне executor'а:

```json
{
  "AutoBestZoneInterval": 15,
  "AutoUpgradeInterval": 30,
  "AutoFeedInterval": 5,
  "WebhookUrl": "",
  "WebhookInterval": 30,
  "FeedReserve": 0,
  "AntiDetectJitter": true
}
```

Поля валидируются по типу: некорректные значения игнорируются и заменяются дефолтами.

## Требования к executor'у

| API                              | Зачем                       | Что будет без него          |
|----------------------------------|-----------------------------|-----------------------------|
| `request` / `http_request` / `syn.request` | Discord webhook             | webhook отключён            |
| `writefile` / `readfile` / `isfile` | Сохранение конфига          | конфиг сбрасывается при запуске |
| `gethui`                         | Скрытие GUI от антипатча игры | UI грузится в `CoreGui`     |

## Возможности `SkyWars.lua`

### Automation (вкладка **Main**)
- **Auto Farm** — телепорт-tween к ближайшему `Block` в `workspace.*Map*.Map.Ores`, нависание над блоком (верхняя грань + offset), удержание позиции и добивание `RemoteEvent:FireServer(block)` раз в 100мс пока блок не уничтожен (таймаут `AutoFarmHoldMax`). HRP якорится на время AutoFarm — персонаж не падает между твинами и не дёргается при фарме колонны блоков. Tween'ы не накапливаются. Auto Farm автоматически включает `Noclip` и `Anti-Void`.
- **Noclip** — event-driven: подписка на `DescendantAdded` персонажа вместо per-frame обхода. При выключении коллизии восстанавливаются.
- **Anti-Void Platform** — невидимая платформа `2000x4x2000` под пивотом карты (`mapFolder:GetPivot()`), а не по жёстким координатам.

### Combat (вкладка **Main**)
- **Auto Clicker** — периодически вызывает `:Activate()` на текущем экипированном туле (Sword, Axe, Bow). CPS настраивается в Settings (1..30).
- **Auto Bow** — если в персонаже лежит `Bow`, стреляет раз в секунду через `Bow.ServerControl:InvokeServer(true/false)`.

### Movement (вкладка **Movement**)
- **Fly** — RenderStepped + WASD + Space/Shift. Направление с учётом взгляда камеры, скорость настраивается.
- **Speed** — редактирует `Humanoid.WalkSpeed`. Авто-переприменение после Respawn'а.
- **High Jump** — повышает `Humanoid.JumpPower` (вынуждает `UseJumpPower = true`).
- **Fast Fall** — во время состояния `Freefall` с велоцити < 0 добавляет вектор вниз (быстрее приземление).
- **No Rotate** — `Humanoid.AutoRotate = false` (персонаж не поворачивается по камере).
- **Blink** — якорит `HumanoidRootPart`, выводит неоновый маркер, WASD двигает маркер. При выключении телепортирует персонажа к маркеру.
- **TP Aura** — Heartbeat-loop, ищет ближайшего живого игрока в `TPauraRange` и телепортирует к нему.

### Visual (вкладка **Visual**)
- **FOV Override** — выставляет `Camera.FieldOfView` (из Settings, диапазон `30..120`). При выключении возвращает исходное значение.
- **No Camera Clip** — переключает `DevCameraOcclusionMode` на `Invisicam` (камера не упирается в блоки).
- **Player ESP** — BillboardGui над вражескими игроками с ником и расстоянием (опционально).
- **Chams** — `Highlight` на вражеских персонажах (красная заливка, белый обвод).
- **Ore ESP** — подсветка `Block`-ов в `oresFolder` ярко-жёлтым.
- **No Render** — периодически убивает `ShopGuiButtons` и `PromoFrame` в `PlayerGui.ScreenGui` (прячет баннеры магазина).

### Settings (вкладка **Settings**)
- **Farm radius (studs)** — радиус поиска руды (по умолчанию `105`, диапазон `10..2000`).
- **Tween speed (studs/s)** — скорость перемещения Auto Farm (`5..500`).
- **Hover above block (studs)** — на сколько высоты блока прижиматься сверху (по умолчанию `3`, диапазон `0..15`).
- **Block hold max (s)** — таймаут удержания над блоком, если он вдруг не разрушается (по умолчанию `2`, диапазон `0.3..10`).
- **Map rescan (s)** — период переоткрытия `mapFolder` (`1..60`).
- **Auto-equip Axe**, **Anti-Detect Jitter**, **Enable Anti-Void** — флаги поведения.
- **Movement tuning**: `Fly speed`, `Walk speed`, `Jump power`, `Fast Fall (studs)`, `Blink speed`, `TP Aura range` — все с клампами.
- **Combat tuning**: `Auto Clicker (CPS)` `1..30`.
- **Visual tuning**: `FOV value` `30..120`, `ESP shows distance` (вкл/выкл).

### Info (вкладка **Info**)
- Версия, ник, платформа (PC / Mobile), наличие FS API у executor'а.

## Технические особенности `SkyWars.lua`

- **Неймспейс `_G.AbramSky`** — без коллизий с другими скриптами. При повторном запуске старый экземпляр корректно потушит себя через `NS.cleanup`.
- **Корректное управление ресурсами** — `:Disconnect()` для коннекшенов, `task.cancel` для тредов, `Tween:Cancel()` для текущего tween-а, `Destroy()` для AntiVoid-платформы.
- **Defensive executor detection** — проверка `writefile`/`readfile`/`isfile` и `gethui`; уведомление, если FS недоступна.
- **Anti-AFK** через `localPlayer.Idled` + `VirtualUser:ClickButton2`.
- **Адаптивный UI** — `UIScale` под мобильный viewport, drag главного окна и pill-виджета, перерасчёт при смене ориентации экрана.
- **Персистентный конфиг** через `writefile`/`readfile` в `AbramSky_config.json` (опционально).
- **Авто-recovery после Respawn** — `CharacterAdded` переустанавливает noclip-подписку.

## Конфиг SkyWars

`AbramSky_config.json`:

```json
{
  "FarmRadius": 105,
  "TweenSpeed": 50,
  "RescanInterval": 5,
  "AutoEquipAxe": true,
  "AntiVoidEnabled": true,
  "AntiDetectJitter": true,
  "AutoFarmHover": 3,
  "AutoFarmHoldMax": 2,

  "FlySpeed": 60,
  "WalkSpeed": 32,
  "JumpPower": 100,
  "FastFallStrength": 4,
  "BlinkSpeed": 80,
  "TPauraRange": 18,

  "AutoClickCPS": 12,

  "FovValue": 90,
  "EspShowDistance": true
}
```

## Управление SkyWars

- **PC**: `ALT` — скрыть/показать меню, либо клик по плавающему `SW`-pill.
- **Mobile**: кнопка `SW` в правом верхнем углу + перетаскиваемый pill-виджет.
- Перетаскивание главного окна — зажать в любом месте окна и тянуть.

## Версия

- `SliemAbram.lua` — `1.0.0`, см. константу `VERSION` в `SliemAbram.lua:3`.
- `SkyWars.lua` — `2.1.1`, см. константу `VERSION` в `SkyWars.lua:8`.

## Дисклеймер

Скрипт нарушает [Roblox Terms of Use](https://en.help.roblox.com/hc/en-us/articles/115004647846). Используется на свой риск. Авторы не несут ответственности за бан аккаунтов.

## Лицензия

[MIT](./LICENSE)
