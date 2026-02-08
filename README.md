# Sensless BugTool — Admin To‑Do System for FiveM

Modern, in‑game admin task management and collaboration tool for FiveM servers. Provides a clean NUI, task lifecycle (create, complete, reopen, delete), chat for admins, resource-aware filtering, teleport-to-task locations, and framework‑agnostic notifications.

## Features
- Task board with create/assign/priority/complete/reopen/delete
- Admin chat with persistence via MySQL
- Auto-refresh when UI is open, manual refresh via NUI
- Teleport to task location (vector4 stored with each task)
- Resource list and resource-specific task views
- Permission gating via server-side framework integration
- Works with QBCore, ESX, vRP, or standalone notifications

## Requirements
- FiveM (fx_version cerulean, lua54 yes)
- oxmysql
- One of: QBCore / ESX / vRP (optional; falls back to standalone notifications)

## Installation
1. Place the `sensless_bugtool` resource in your server `resources` folder.
2. Ensure `oxmysql` is installed and configured.
3. Add to your `server.cfg`:
   ```
   ensure oxmysql
   ensure sensless_bugtool
   ```
4. Configure `config.lua`:
   - `Framework`: `'qbcore' | 'esx' | 'vrp' | 'standalone'`
   - `ShowNotifications`: `true | false`
   - `NotificationDuration`: milliseconds for notifications
   - `AutoRefreshInterval`: UI auto-refresh interval in ms
   - `UITheme`, `Locale`

## Commands
- `/std` — Open the admin UI (permission checked server-side)
- `/addtask <description>` — Quick-add a task
- `/deltask <taskID>` — Delete a task
- `/completetask <taskID>` — Complete a task

## Notable Events
- Client to Server:
  - `sensless_devtool:addTask`, `deleteTask`, `completeTask`, `reopenTask`, `getTasks`, `getResources`, `getResourcesList`, `getResourceFiles`, `getResourceTasks`, `sendChatMessage`, `getChatMessages`, `checkPermission`
- Server to Client:
  - `sensless_devtool:openUI`, `permissionDenied`, `receiveTasks`, `refreshTasks`, `notification`, `updateChat`, `newChatMessage`, `receiveResources`, `receiveResourcesList`, `receiveResourceFiles`, `receiveResourceTasks`

## Debug Tags
- Client debug prints use `[SenslessBugToolClient]`.

## UI Files
- `html/ui.html`, `html/ui.css`, `html/ui.js` are referenced by `fxmanifest.lua` via `ui_page` and `files`.

## Author
SenslessStudios

