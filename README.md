# King_AbramUI

Кастомный Roblox-executor скрипт с GUI для автоматизации слайм-игры.

## Файлы

- **`SliemAbram.lua`** — основной скрипт с современным dark-UI, мобильной адаптацией и набором автоматов (Auto Roll / Farm / Kill / Best Zone / Upgrade / Rebirth / Feed / Equip Best, Discord webhook).
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
- **FPS Boost** — отключает глобальные тени, туман, декорации/волны террейна; у всех `BasePart` ставит материал `Plastic`, `Reflectance = 0`, `CastShadow = false`; глушит частицы, огонь, дым, искры, трейлы и beam'ы. Применяется к существующим объектам и автоматически к новым (`workspace.DescendantAdded`). При выключении восстанавливает оригинальное освещение/террейн.
- **Ultra Low-End** — всё что FPS Boost + удаляет все `Decal` / `Texture` / `SurfaceAppearance`, отключает все PostFX (`Bloom`, `Blur`, `DepthOfField`, `SunRays`, `ColorCorrection`) и понижает `Rendering.QualityLevel` до минимума через `sethiddenproperty` (если executor поддерживает). **Внимание:** удалённые декали/текстуры восстанавливаются только перезаходом в игру.

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

## Версия

`1.0.0` — см. константу `VERSION` в `SliemAbram.lua:3`.

## Дисклеймер

Скрипт нарушает [Roblox Terms of Use](https://en.help.roblox.com/hc/en-us/articles/115004647846). Используется на свой риск. Авторы не несут ответственности за бан аккаунтов.

## Лицензия

[MIT](./LICENSE)
