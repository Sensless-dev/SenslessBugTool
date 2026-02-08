-- Discord Webhook Configuration
-- This file contains the Discord webhook URL for the Admin To-Do system

-- Make sure this is global
DiscordWebhook = DiscordWebhook or {}
DiscordWebhook.URL = 'https://discord.com/api/webhooks/YOUR_WEBHOOK_URL'

print('^2[Admin To-Do]^7 Discord webhook file loaded. URL: ' .. tostring(DiscordWebhook.URL:sub(1, 50)) .. '...')

