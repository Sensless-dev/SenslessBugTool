Config = {}

-- Framework Selection: 'qbcore', 'esx', 'vrp', 'standalone'
Config.Framework = 'qbcore'

-- Permission Settings
Config.PermissionGroups = {
    admin = true,
    superadmin = true,
    moderator = true
}

-- For QBCore: Checks player job (admin/god) or job grade level >= 4
--   - Players with job.name == 'admin' or 'god' have access
--   - Players with job.grade.level >= 4 have access
--   - Custom groups checked via job.name matching Config.PermissionGroups
-- For ESX: Use ESX group system (admin, superadmin, etc.)
-- For vRP: Use vRP permission system
-- For Standalone: Use Steam ID whitelist (see below)

-- Standalone Mode: Whitelist of Steam IDs (only works if Framework = 'standalone')
Config.WhitelistedSteamIDs = {
    'steam:110000xxxxxxxxx', -- Example Steam ID
    -- Add more Steam IDs here
}

-- UI Settings
Config.UITheme = 'dark' -- 'light' or 'dark'
Config.ShowNotifications = true
Config.NotificationDuration = 5000 -- milliseconds

-- Database Settings
Config.DatabaseTable = 'admin_tasks'

-- Log Settings
Config.LogDirectory = 'logs'
Config.ChangelogFile = 'changelog.txt'
Config.TranslogFile = 'logs/translog.txt'

-- Task Settings
Config.AutoRefreshInterval = 3000 -- milliseconds (3 seconds)
Config.MaxTasksPerPage = 50

-- Date Format
Config.DateFormat = '%Y-%m-%d %H:%M:%S'

-- Language Settings
Config.Locale = 'en'  -- Language code: 'en' (English), add more in locals/ folder

