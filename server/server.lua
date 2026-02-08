-- Server-side Logic for Admin To-Do System

local function EnsureLogDirectory()
    local logDir = GetResourcePath(GetCurrentResourceName()) .. '/' .. Config.LogDirectory
    if not os.rename(logDir, logDir) then
        os.execute('mkdir "' .. logDir .. '"')
    end
end

local function WriteTranslog(action, taskId, adminIdentifier, adminName, notes)
    EnsureLogDirectory()
    local logFile = GetResourcePath(GetCurrentResourceName()) .. '/' .. Config.TranslogFile
    local file = io.open(logFile, 'a')
    if file then
        local timestamp = os.date(Config.DateFormat)
        local entry = string.format('[%s] ACTION: %s | TASK_ID: %s | ADMIN: %s (%s) | NOTES: %s\n',
            timestamp, action, tostring(taskId), adminName, adminIdentifier, notes or 'N/A')
        file:write(entry)
        file:close()
    end
end

-- Check Discord webhook on startup
CreateThread(function()
    Wait(2000) -- Wait a bit for all scripts to load
    print('^3[Admin To-Do]^7 Checking Discord webhook...')
    print('^3[Admin To-Do]^7 DiscordWebhook type: ' .. type(DiscordWebhook))
    if DiscordWebhook then
        print('^3[Admin To-Do]^7 DiscordWebhook.URL type: ' .. type(DiscordWebhook.URL))
        print('^3[Admin To-Do]^7 DiscordWebhook.URL value: ' .. tostring(DiscordWebhook.URL))
    end
    
    if DiscordWebhook and DiscordWebhook.URL and DiscordWebhook.URL ~= '' then
        print('^2[Admin To-Do]^7 Discord webhook loaded successfully: ' .. tostring(DiscordWebhook.URL:sub(1, 50)) .. '...')
    else
        print('^1[Admin To-Do]^7 Discord webhook NOT loaded!')
        if not DiscordWebhook then
            print('^1[Admin To-Do]^7 DiscordWebhook table is nil - check server/discord.lua')
        elseif not DiscordWebhook.URL then
            print('^1[Admin To-Do]^7 DiscordWebhook.URL is nil - check server/discord.lua')
        end
    end
end)

-- Get Discord webhook URL from server/discord.lua
local function GetDiscordWebhook()
    -- Read from DiscordWebhook table in server/discord.lua
    if DiscordWebhook and DiscordWebhook.URL and DiscordWebhook.URL ~= '' then
        return DiscordWebhook.URL
    else
        print('^1[Admin To-Do]^7 GetDiscordWebhook: Webhook not available')
        if not DiscordWebhook then
            print('^1[Admin To-Do]^7 DiscordWebhook table is nil')
        elseif not DiscordWebhook.URL then
            print('^1[Admin To-Do]^7 DiscordWebhook.URL is nil')
        end
    end
    return nil
end

-- Send Discord webhook for changelog entries
local function SendDiscordWebhook(changelogEntry)
    if not changelogEntry or changelogEntry == '' then
        print('^1[Admin To-Do]^7 SendDiscordWebhook: changelogEntry is empty')
        return
    end
    
    local webhookURL = GetDiscordWebhook()
    
    if not webhookURL or webhookURL == '' then
        print('^1[Admin To-Do]^7 SendDiscordWebhook: No webhook URL available')
        return
    end
    
    print('^2[Admin To-Do]^7 Sending Discord webhook...')
    
    -- Parse the changelog entry to extract information
    local actionType = nil
    local taskId = nil
    local taskDescription = nil
    local adminName = nil
    local adminIdentifier = nil
    local reason = nil
    local timestamp = nil
    local status = nil
    local priority = nil
    local created = nil
    local completed = nil
    local originalCompletionDate = nil
    
    -- Extract timestamp from the first line
    local timestampMatch = changelogEntry:match('%[(.-)%]')
    if timestampMatch then
        timestamp = timestampMatch
    end
    
    -- Determine action type
    print('^3[Admin To-Do]^7 Parsing changelog entry. First 100 chars: ' .. tostring(changelogEntry:sub(1, 100)))
    
    if changelogEntry:match('TASK CREATED') then
        actionType = 'created'
        print('^2[Admin To-Do]^7 Detected action type: CREATED')
        taskId = changelogEntry:match('TASK CREATED %- ID: (%d+)')
        local titleMatch = changelogEntry:match('Title: (.+)\n')
        taskDescription = changelogEntry:match('Task: (.+)\n')
        if titleMatch and taskDescription then
            taskDescription = titleMatch .. ': ' .. taskDescription
        elseif titleMatch then
            taskDescription = titleMatch
        end
        adminName = changelogEntry:match('Created by: (.+) %(')
        adminIdentifier = changelogEntry:match('Created by: .+ %((.+)\\)')
        priority = changelogEntry:match('Priority: (.+)\n')
        local assignedToMatch = changelogEntry:match('Assigned to: (.+)\n')
        if assignedToMatch then
            reason = 'Assigned to: ' .. assignedToMatch
        end
        local resourceMatch = changelogEntry:match('Resource: (.+)\n')
        if resourceMatch then
            if reason then
                reason = reason .. ' | Resource: ' .. resourceMatch
            else
                reason = 'Resource: ' .. resourceMatch
            end
        end
    elseif changelogEntry:match('TASK COMPLETED') then
        actionType = 'completed'
        print('^2[Admin To-Do]^7 Detected action type: COMPLETED')
        taskId = changelogEntry:match('TASK COMPLETED %- ID: (%d+)')
        taskDescription = changelogEntry:match('Task: (.+)\n')
        adminName = changelogEntry:match('Completed by: (.+) %(')
        adminIdentifier = changelogEntry:match('Completed by: .+ %((.+)\\)')
        reason = changelogEntry:match('Completion Description: (.+)\n')
    elseif changelogEntry:match('TASK DELETED') then
        actionType = 'deleted'
        print('^2[Admin To-Do]^7 Detected action type: DELETED')
        taskId = changelogEntry:match('TASK DELETED %- ID: (%d+)')
        taskDescription = changelogEntry:match('Task: (.+)\n')
        adminName = changelogEntry:match('Deleted by: (.+) %(')
        adminIdentifier = changelogEntry:match('Deleted by: .+ %((.+)\\)')
        reason = changelogEntry:match('Deletion Reason: (.+)\n')
        status = changelogEntry:match('Status: (.+)\n')
        priority = changelogEntry:match('Priority: (.+)\n')
        created = changelogEntry:match('Created: (.+)\n')
        completed = changelogEntry:match('Completed: (.+)\n')
    elseif changelogEntry:match('TASK REOPENED') then
        actionType = 'reopened'
        print('^2[Admin To-Do]^7 Detected action type: REOPENED')
        taskId = changelogEntry:match('TASK REOPENED %- ID: (%d+)')
        taskDescription = changelogEntry:match('Task: (.+)\n')
        adminName = changelogEntry:match('Reopened by: (.+) %(')
        adminIdentifier = changelogEntry:match('Reopened by: .+ %((.+)\\)')
        reason = changelogEntry:match('Reason: (.+)\n')
        originalCompletionDate = changelogEntry:match('Original completion date: (.+)\n')
    end
    
    -- Convert timestamp to ISO 8601 format for Discord
    local discordTimestamp = nil
    if timestamp then
        -- Parse timestamp format: YYYY-MM-DD HH:MM:SS
        local year, month, day, hour, minute, second = timestamp:match('(%d%d%d%d)%-(%d%d)%-(%d%d) (%d%d):(%d%d):(%d%d)')
        if year and month and day and hour and minute and second then
            -- Discord expects ISO 8601 format: YYYY-MM-DDTHH:MM:SS.000Z
            discordTimestamp = string.format('%s-%s-%sT%s:%s:%s.000Z', year, month, day, hour, minute, second)
        end
    end
    
    -- Build embed based on action type
    local embed = {
        title = nil,
        description = nil,
        color = nil,
        fields = {},
        footer = {
            text = 'Admin To-Do System'
        }
    }
    
    if discordTimestamp then
        embed.timestamp = discordTimestamp
    end
    
    -- Helper function to truncate strings to Discord's limits
    local function truncate(str, maxLen)
        if not str then return 'N/A' end
        if #str > maxLen then
            return str:sub(1, maxLen - 3) .. '...'
        end
        return str
    end
    
    if actionType == 'created' then
        embed.title = '📝 Task Created'
        embed.color = 3447003 -- Blue
        embed.description = string.format('**Task #%s** has been created', taskId or 'N/A')
        table.insert(embed.fields, { name = 'Task', value = truncate(taskDescription, 1024), inline = false })
        table.insert(embed.fields, { name = 'Created By', value = truncate(string.format('%s (%s)', adminName or 'N/A', adminIdentifier or 'N/A'), 1024), inline = true })
        if priority then
            table.insert(embed.fields, { name = 'Priority', value = truncate(priority, 1024), inline = true })
        end
        if reason then
            table.insert(embed.fields, { name = 'Details', value = truncate(reason, 1024), inline = false })
        end
    elseif actionType == 'completed' then
        embed.title = '✅ Task Completed'
        embed.color = 5763719 -- Green
        embed.description = string.format('**Task #%s** has been completed', taskId or 'N/A')
        table.insert(embed.fields, { name = 'Task', value = truncate(taskDescription, 1024), inline = false })
        table.insert(embed.fields, { name = 'Completed By', value = truncate(string.format('%s (%s)', adminName or 'N/A', adminIdentifier or 'N/A'), 1024), inline = true })
        table.insert(embed.fields, { name = 'Completion Description', value = truncate(reason, 1024), inline = false })
    elseif actionType == 'deleted' then
        embed.title = '🗑️ Task Deleted'
        embed.color = 15548997 -- Red
        embed.description = string.format('**Task #%s** has been deleted', taskId or 'N/A')
        table.insert(embed.fields, { name = 'Task', value = truncate(taskDescription, 1024), inline = false })
        table.insert(embed.fields, { name = 'Deleted By', value = truncate(string.format('%s (%s)', adminName or 'N/A', adminIdentifier or 'N/A'), 1024), inline = true })
        table.insert(embed.fields, { name = 'Deletion Reason', value = truncate(reason, 1024), inline = false })
        if status then
            table.insert(embed.fields, { name = 'Status', value = truncate(status, 1024), inline = true })
        end
        if priority then
            table.insert(embed.fields, { name = 'Priority', value = truncate(priority, 1024), inline = true })
        end
        if created then
            table.insert(embed.fields, { name = 'Created', value = truncate(created, 1024), inline = true })
        end
        if completed then
            table.insert(embed.fields, { name = 'Completed', value = truncate(completed, 1024), inline = true })
        end
    elseif actionType == 'reopened' then
        embed.title = '🔄 Task Reopened'
        embed.color = 16776960 -- Yellow
        embed.description = string.format('**Task #%s** has been reopened', taskId or 'N/A')
        table.insert(embed.fields, { name = 'Task', value = truncate(taskDescription, 1024), inline = false })
        table.insert(embed.fields, { name = 'Reopened By', value = truncate(string.format('%s (%s)', adminName or 'N/A', adminIdentifier or 'N/A'), 1024), inline = true })
        table.insert(embed.fields, { name = 'Reason', value = truncate(reason, 1024), inline = false })
        if originalCompletionDate then
            table.insert(embed.fields, { name = 'Original Completion Date', value = truncate(originalCompletionDate, 1024), inline = true })
        end
    else
        -- Unknown action type, send basic embed
        print('^3[Admin To-Do]^7 Unknown action type, sending generic embed')
        embed.title = '📝 Changelog Entry'
        embed.color = 9807270 -- Gray
        embed.description = 'A new changelog entry has been created'
        table.insert(embed.fields, { name = 'Details', value = truncate(changelogEntry, 1024), inline = false })
    end
    
    print('^3[Admin To-Do]^7 Embed prepared. Action type: ' .. tostring(actionType) .. ', Title: ' .. tostring(embed.title))
    
    -- Prepare webhook payload
    local payload = {
        embeds = { embed }
    }
    
    -- Send HTTP request to Discord webhook
    PerformHttpRequest(webhookURL, function(err, text, headers)
        if err == 200 or err == 204 then
            print('^2[Admin To-Do]^7 Discord webhook sent successfully')
        else
            print('^1[Admin To-Do]^7 Failed to send Discord webhook. Error code: ' .. tostring(err))
            if text then
                print('^1[Admin To-Do]^7 Response: ' .. tostring(text))
            end
        end
    end, 'POST', json.encode(payload), { ['Content-Type'] = 'application/json' })
end

local function WriteChangelog(taskDescription, completedBy, completedByName, timestamp)
    print('^3[Admin To-Do]^7 WriteChangelog called')
    local logFile = GetResourcePath(GetCurrentResourceName()) .. '/' .. Config.ChangelogFile
    local file = io.open(logFile, 'a')
    if file then
        -- If taskDescription is a full entry string (for reopen), write it directly
        -- Otherwise, format it as a completion entry
        if completedBy == nil and completedByName == nil and timestamp == nil then
            -- This is a full entry string (for reopen, delete, etc.)
            print('^3[Admin To-Do]^7 Writing full changelog entry and sending Discord webhook')
            file:write(taskDescription)
            -- Send Discord webhook
            SendDiscordWebhook(taskDescription)
        else
            -- This is a completion entry
            local entry = string.format('[%s] COMPLETED: %s | BY: %s (%s)\n',
                timestamp, taskDescription, completedByName, completedBy)
            file:write(entry)
            -- Send Discord webhook (format as full entry for parsing)
            local fullEntry = string.format('[%s] TASK COMPLETED - ID: N/A\nTask: %s\nCompleted by: %s (%s)\nCompletion Description: N/A\n---\n\n',
                timestamp, taskDescription, completedByName, completedBy)
            SendDiscordWebhook(fullEntry)
        end
        file:close()
    end
end

-- Admin Chat System Functions (defined before database initialization)
local chatMessages = {}

-- Load chat messages from database on server start
local function LoadChatMessages()
    MySQL.Async.fetchAll([[
        SELECT `author_name`, `message`, `timestamp` 
        FROM `admin_chat_messages` 
        ORDER BY `timestamp` ASC
    ]], {}, function(result)
        if result then
            chatMessages = {}
            for _, row in ipairs(result) do
                table.insert(chatMessages, {
                    authorName = row.author_name,
                    message = row.message,
                    timestamp = row.timestamp
                })
            end
            print('^2[Admin To-Do]^7 Loaded ' .. #chatMessages .. ' chat messages from database')
        else
            chatMessages = {}
            print('^2[Admin To-Do]^7 No chat messages found in database')
        end
    end)
end

-- Clean up messages older than 4 days
local function CleanupOldChatMessages()
    local fourDaysAgo = os.date('%Y-%m-%d %H:%M:%S', os.time() - (4 * 24 * 60 * 60))
    MySQL.Async.execute([[
        DELETE FROM `admin_chat_messages` 
        WHERE `timestamp` < ?
    ]], { fourDaysAgo }, function(affectedRows)
        if affectedRows and affectedRows > 0 then
            print('^2[Admin To-Do]^7 Cleaned up ' .. affectedRows .. ' chat messages older than 4 days')
            -- Reload messages after cleanup
            LoadChatMessages()
        end
    end)
end

-- Initialize Database
CreateThread(function()
    -- Create table if it doesn't exist
    MySQL.Async.execute([[
        CREATE TABLE IF NOT EXISTS `admin_tasks` (
            `id` INT(11) NOT NULL AUTO_INCREMENT,
            `title` VARCHAR(255) DEFAULT NULL,
            `description` TEXT NOT NULL,
            `created_by` VARCHAR(100) NOT NULL,
            `created_by_name` VARCHAR(100) DEFAULT NULL,
            `assigned_to` VARCHAR(100) DEFAULT NULL,
            `assigned_to_name` VARCHAR(100) DEFAULT NULL,
            `status` ENUM('pending', 'completed') DEFAULT 'pending',
            `priority` ENUM('low', 'normal', 'high', 'urgent', 'started') DEFAULT 'normal',
            `date_created` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
            `date_completed` DATETIME DEFAULT NULL,
            `completed_by` VARCHAR(100) DEFAULT NULL,
            `completed_by_name` VARCHAR(100) DEFAULT NULL,
            `reopen_reason` TEXT DEFAULT NULL,
            `resource` VARCHAR(100) DEFAULT NULL,
            `position_x` DECIMAL(10, 4) DEFAULT NULL,
            `position_y` DECIMAL(10, 4) DEFAULT NULL,
            `position_z` DECIMAL(10, 4) DEFAULT NULL,
            `position_heading` DECIMAL(10, 4) DEFAULT NULL,
            PRIMARY KEY (`id`),
            INDEX `idx_status` (`status`),
            INDEX `idx_priority` (`priority`),
            INDEX `idx_created_by` (`created_by`),
            INDEX `idx_assigned_to` (`assigned_to`),
            INDEX `idx_resource` (`resource`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
    ]], {}, function()
        -- Check if priority column exists, add it if not (for existing databases)
        -- Check and add priority column if needed
        MySQL.Async.fetchAll([[
            SELECT COUNT(*) as count 
            FROM INFORMATION_SCHEMA.COLUMNS 
            WHERE TABLE_SCHEMA = DATABASE() 
            AND TABLE_NAME = 'admin_tasks' 
            AND COLUMN_NAME = 'priority'
        ]], {}, function(result)
            if result and result[1] and result[1].count == 0 then
                MySQL.Async.execute([[
                    ALTER TABLE `admin_tasks` 
                    ADD COLUMN `priority` ENUM('low', 'normal', 'high', 'urgent', 'started') DEFAULT 'normal'
                ]], {}, function()
                    print('^2[Admin To-Do]^7 Added priority column to existing table')
                end)
            end
        end)
        
        -- Check and add reopen_reason column if needed
        MySQL.Async.fetchAll([[
            SELECT COUNT(*) as count 
            FROM INFORMATION_SCHEMA.COLUMNS 
            WHERE TABLE_SCHEMA = DATABASE() 
            AND TABLE_NAME = 'admin_tasks' 
            AND COLUMN_NAME = 'reopen_reason'
        ]], {}, function(result)
            if result and result[1] and result[1].count == 0 then
                MySQL.Async.execute([[
                    ALTER TABLE `admin_tasks` 
                    ADD COLUMN `reopen_reason` TEXT DEFAULT NULL
                ]], {}, function()
                    print('^2[Admin To-Do]^7 Added reopen_reason column to existing table')
                end)
            end
        end)
        
        -- Check and add resource column if needed
        MySQL.Async.fetchAll([[
            SELECT COUNT(*) as count 
            FROM INFORMATION_SCHEMA.COLUMNS 
            WHERE TABLE_SCHEMA = DATABASE() 
            AND TABLE_NAME = 'admin_tasks' 
            AND COLUMN_NAME = 'resource'
        ]], {}, function(result)
            if result and result[1] and result[1].count == 0 then
                MySQL.Async.execute([[
                    ALTER TABLE `admin_tasks` 
                    ADD COLUMN `resource` VARCHAR(100) DEFAULT NULL,
                    ADD INDEX `idx_resource` (`resource`)
                ]], {}, function()
                    print('^2[Admin To-Do]^7 Added resource column to existing table')
                end)
            end
        end)
        
        -- Check and add title column if needed
        MySQL.Async.fetchAll([[
            SELECT COUNT(*) as count 
            FROM INFORMATION_SCHEMA.COLUMNS 
            WHERE TABLE_SCHEMA = DATABASE() 
            AND TABLE_NAME = 'admin_tasks' 
            AND COLUMN_NAME = 'title'
        ]], {}, function(result)
            if result and result[1] and result[1].count == 0 then
                MySQL.Async.execute([[
                    ALTER TABLE `admin_tasks` 
                    ADD COLUMN `title` VARCHAR(255) DEFAULT NULL
                ]], {}, function()
                    print('^2[Admin To-Do]^7 Added title column to existing table')
                end)
            end
        end)
        
        -- Check and add position columns if needed
        MySQL.Async.fetchAll([[
            SELECT COUNT(*) as count 
            FROM INFORMATION_SCHEMA.COLUMNS 
            WHERE TABLE_SCHEMA = DATABASE() 
            AND TABLE_NAME = 'admin_tasks' 
            AND COLUMN_NAME = 'position_x'
        ]], {}, function(result)
            if result and result[1] and result[1].count == 0 then
                print('^2[Admin To-Do]^7 Adding position columns to existing table...')
                MySQL.Async.execute([[
                    ALTER TABLE `admin_tasks` 
                    ADD COLUMN `position_x` DECIMAL(10, 4) DEFAULT NULL,
                    ADD COLUMN `position_y` DECIMAL(10, 4) DEFAULT NULL,
                    ADD COLUMN `position_z` DECIMAL(10, 4) DEFAULT NULL,
                    ADD COLUMN `position_heading` DECIMAL(10, 4) DEFAULT NULL
                ]], {}, function()
                    print('^2[Admin To-Do]^7 Added position columns (position_x, position_y, position_z, position_heading) to existing table')
                end)
            else
                print('^2[Admin To-Do]^7 Position columns already exist')
            end
        end)
        
        -- Create admin_chat_messages table if it doesn't exist
        MySQL.Async.execute([[
            CREATE TABLE IF NOT EXISTS `admin_chat_messages` (
                `id` INT(11) NOT NULL AUTO_INCREMENT,
                `author_name` VARCHAR(100) NOT NULL,
                `message` TEXT NOT NULL,
                `timestamp` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                PRIMARY KEY (`id`),
                INDEX `idx_timestamp` (`timestamp`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
        ]], {}, function()
            print('^2[Admin To-Do]^7 Chat messages table ready')
            -- Load chat messages from database
            LoadChatMessages()
            -- Clean up old messages (older than 4 days)
            CleanupOldChatMessages()
        end)
    end)
    print('^2[Admin To-Do]^7 Database initialized successfully')
end)

-- Get all tasks
RegisterNetEvent('sensless_devtool:getTasks', function()
    local source = source
    if not Framework:HasPermission(source) then
        return
    end
    
    -- First check if priority column exists
    MySQL.Async.fetchAll([[
        SELECT COUNT(*) as count 
        FROM INFORMATION_SCHEMA.COLUMNS 
        WHERE TABLE_SCHEMA = DATABASE() 
        AND TABLE_NAME = 'admin_tasks' 
        AND COLUMN_NAME = 'priority'
    ]], {}, function(result)
        local hasPriority = result and result[1] and result[1].count > 0
        
        if hasPriority then
            -- Order by priority (urgent > high > started > normal > low), then by date
            MySQL.Async.fetchAll([[
                SELECT * FROM `admin_tasks` 
                ORDER BY 
                    CASE `priority`
                        WHEN 'urgent' THEN 1
                        WHEN 'high' THEN 2
                        WHEN 'started' THEN 3
                        WHEN 'normal' THEN 4
                        WHEN 'low' THEN 5
                        ELSE 4
                    END,
                    `date_created` DESC
            ]], {}, function(tasks)
                TriggerClientEvent('sensless_devtool:receiveTasks', source, tasks)
            end)
        else
            -- Fallback: order by date only if priority column doesn't exist
            MySQL.Async.fetchAll('SELECT * FROM `admin_tasks` ORDER BY `date_created` DESC', {}, function(tasks)
                -- Add default priority to tasks that don't have it
                for _, task in ipairs(tasks) do
                    if not task.priority then
                        task.priority = 'normal'
                    end
                end
                TriggerClientEvent('sensless_devtool:receiveTasks', source, tasks)
            end)
        end
    end)
end)

-- Get list of server resources
local function GetServerResources()
    local resources = {}
    local numResources = GetNumResources()
    
    for i = 0, numResources - 1 do
        local resourceName = GetResourceByFindIndex(i)
        -- Include all resources except internal ones
        if resourceName and resourceName ~= '_cfx_internal' and resourceName ~= 'monitor' then
            table.insert(resources, resourceName)
        end
    end
    
    -- Sort alphabetically
    table.sort(resources)
    return resources
end

-- Get resources list
local function GetResourcesWithLastEdited()
    local resources = GetServerResources()
    local resourcesList = {}
    
    for _, resourceName in ipairs(resources) do
        table.insert(resourcesList, {
            name = resourceName,
            state = GetResourceState(resourceName)
        })
    end
    
    -- Sort by name
    table.sort(resourcesList, function(a, b)
        return a.name < b.name
    end)
    
    return resourcesList
end

-- Get resources event (for dropdown)
RegisterNetEvent('sensless_devtool:getResources', function()
    local source = source
    if not Framework:HasPermission(source) then
        return
    end
    
    local resources = GetServerResources()
    TriggerClientEvent('sensless_devtool:receiveResources', source, resources)
end)

-- Get resources list (for resources tab)
RegisterNetEvent('sensless_devtool:getResourcesList', function()
    local source = source
    if not Framework:HasPermission(source) then
        return
    end
    
    local resources = GetResourcesWithLastEdited()
    TriggerClientEvent('sensless_devtool:receiveResourcesList', source, resources)
end)

-- Add new task function
local function AddTask(source, title, description, assignedTo, priority, resource, position)
    if not Framework:HasPermission(source) then
        print('^1[Admin To-Do]^7 AddTask: Permission denied for source ' .. tostring(source))
        TriggerClientEvent('sensless_devtool:notification', source, 'error', 'You do not have permission to add tasks')
        return
    end
    
    local adminIdentifier = Framework:GetPlayerIdentifier(source)
    local adminName = Framework:GetPlayerName(source)
    
    if not description or description == '' then
        TriggerClientEvent('sensless_devtool:notification', source, 'error', 'Task description cannot be empty')
        return
    end
    
    -- Title is optional, but if provided, validate length
    if title and #title > 255 then
        title = string.sub(title, 1, 255)
    end
    
    -- Validate priority
    local validPriorities = { 'low', 'normal', 'high', 'urgent', 'started' }
    priority = priority or 'normal'
    local isValidPriority = false
    for _, v in ipairs(validPriorities) do
        if v == priority then
            isValidPriority = true
            break
        end
    end
    if not isValidPriority then
        priority = 'normal'
    end
    
    local assignedToName = nil
    if assignedTo and assignedTo ~= '' then
        -- Try to get assigned player name
        local targetPlayer = Framework:GetPlayer(tonumber(assignedTo))
        if targetPlayer then
            assignedToName = Framework:GetPlayerName(tonumber(assignedTo))
        end
    end
    
    -- Extract position data
    local posX, posY, posZ, posHeading = nil, nil, nil, nil
    if position and type(position) == 'table' then
        posX = position.x
        posY = position.y
        posZ = position.z
        posHeading = position.heading
        print('^2[Admin To-Do]^7 Position captured: x=' .. tostring(posX) .. ', y=' .. tostring(posY) .. ', z=' .. tostring(posZ) .. ', heading=' .. tostring(posHeading))
    else
        print('^1[Admin To-Do]^7 No position data received or invalid format')
        if position then
            print('^1[Admin To-Do]^7 Position type: ' .. type(position))
        end
    end
    
    -- Check which columns exist, then insert accordingly
    MySQL.Async.fetchAll([[
        SELECT 
            (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'admin_tasks' AND COLUMN_NAME = 'title') as has_title,
            (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'admin_tasks' AND COLUMN_NAME = 'priority') as has_priority,
            (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'admin_tasks' AND COLUMN_NAME = 'resource') as has_resource,
            (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'admin_tasks' AND COLUMN_NAME = 'position_x') as has_position
    ]], {}, function(result)
        local hasTitle = result and result[1] and result[1].has_title > 0
        local hasPriority = result and result[1] and result[1].has_priority > 0
        local hasResource = result and result[1] and result[1].has_resource > 0
        local hasPosition = result and result[1] and result[1].has_position > 0
        
        print('^3[Admin To-Do]^7 Database columns check - hasPosition: ' .. tostring(hasPosition))
        
        local query = ''
        local params = {}
        
        -- Build query based on available columns
        local columns = {'description', 'created_by', 'created_by_name', 'assigned_to', 'assigned_to_name', 'status'}
        local values = {description, adminIdentifier, adminName, assignedTo or nil, assignedToName, 'pending'}
        
        if hasTitle then
            table.insert(columns, 'title')
            table.insert(values, title or nil)
        end
        if hasPriority then
            table.insert(columns, 'priority')
            table.insert(values, priority)
        end
        if hasResource then
            table.insert(columns, 'resource')
            table.insert(values, resource or nil)
        end
        if hasPosition then
            table.insert(columns, 'position_x')
            table.insert(columns, 'position_y')
            table.insert(columns, 'position_z')
            table.insert(columns, 'position_heading')
            table.insert(values, posX)
            table.insert(values, posY)
            table.insert(values, posZ)
            table.insert(values, posHeading)
        end
        
        local columnsStr = table.concat(columns, '`, `')
        local placeholders = string.rep('?,', #values):sub(1, -2)
        query = string.format('INSERT INTO `admin_tasks` (`%s`) VALUES (%s)', columnsStr, placeholders)
        params = values
        
        MySQL.Async.execute(query, params, function(affectedRows)
            if affectedRows and affectedRows > 0 then
                -- Get the last insert ID
                MySQL.Async.fetchAll('SELECT LAST_INSERT_ID() as id', {}, function(result)
                    local insertId = result and result[1] and result[1].id or nil
                    if insertId then
                        local timestamp = os.date(Config.DateFormat)
                        
                        -- Write to changelog
                        local changelogEntry = string.format(
                            '[%s] TASK CREATED - ID: %d\n',
                            timestamp,
                            insertId
                        )
                        if title then
                            changelogEntry = changelogEntry .. string.format(
                                'Title: %s\n',
                                title
                            )
                        end
                        changelogEntry = changelogEntry .. string.format(
                            'Task: %s\n',
                            description
                        )
                        changelogEntry = changelogEntry .. string.format(
                            'Created by: %s (%s)\n',
                            adminName,
                            adminIdentifier
                        )
                        if priority then
                            changelogEntry = changelogEntry .. string.format(
                                'Priority: %s\n',
                                priority
                            )
                        end
                        if assignedToName then
                            changelogEntry = changelogEntry .. string.format(
                                'Assigned to: %s\n',
                                assignedToName
                            )
                        end
                        if resource then
                            changelogEntry = changelogEntry .. string.format(
                                'Resource: %s\n',
                                resource
                            )
                        end
                        if posX and posY and posZ then
                            changelogEntry = changelogEntry .. string.format(
                                'Location: vector4(%.2f, %.2f, %.2f, %.2f)\n',
                                posX, posY, posZ, posHeading or 0.0
                            )
                        end
                        changelogEntry = changelogEntry .. '---\n\n'
                        
                        WriteChangelog(changelogEntry)
                        WriteTranslog('CREATE', insertId, adminIdentifier, adminName, 'Created task: ' .. (title or description))
                    end
                end)
                
                -- Notify all admins and refresh immediately
                TriggerClientEvent('sensless_devtool:notification', -1, 'success', 'New task created by ' .. adminName)
                TriggerClientEvent('sensless_devtool:refreshTasks', -1)
            else
                print('^1[Admin To-Do]^7 Error: Failed to insert task. Affected rows: ' .. tostring(affectedRows))
                TriggerClientEvent('sensless_devtool:notification', source, 'error', 'Failed to create task. Check server console.')
            end
        end)
    end)
end

RegisterNetEvent('sensless_devtool:addTask', function(title, description, assignedTo, priority, resource, position)
    AddTask(source, title, description, assignedTo, priority, resource, position)
end)

-- Delete task function
local function DeleteTask(source, taskId, deleteReason)
    if not Framework:HasPermission(source) then
        return
    end
    
    local adminIdentifier = Framework:GetPlayerIdentifier(source)
    local adminName = Framework:GetPlayerName(source)
    local timestamp = os.date('%Y-%m-%d %H:%M:%S')
    
    if not deleteReason or deleteReason == '' then
        TriggerClientEvent('sensless_devtool:notification', source, 'error', 'Please provide a reason for deleting this task')
        return
    end
    
    -- First fetch the task details before deleting
    MySQL.Async.fetchAll('SELECT * FROM `admin_tasks` WHERE `id` = ?', { taskId }, function(result)
        if result and #result > 0 then
            local task = result[1]
            
            -- Now delete the task
            MySQL.Async.execute('DELETE FROM `admin_tasks` WHERE `id` = ?', { taskId }, function(affectedRows)
                if affectedRows > 0 then
                    -- Write to changelog
                    local changelogEntry = string.format(
                        '[%s] TASK DELETED - ID: %d\n',
                        timestamp,
                        taskId
                    )
                    changelogEntry = changelogEntry .. string.format(
                        'Task: %s\n',
                        task.description
                    )
                    changelogEntry = changelogEntry .. string.format(
                        'Deleted by: %s (%s)\n',
                        adminName,
                        adminIdentifier
                    )
                    changelogEntry = changelogEntry .. string.format(
                        'Deletion Reason: %s\n',
                        deleteReason
                    )
                    changelogEntry = changelogEntry .. string.format(
                        'Status: %s\n',
                        task.status or 'N/A'
                    )
                    changelogEntry = changelogEntry .. string.format(
                        'Priority: %s\n',
                        task.priority or 'N/A'
                    )
                    if task.assigned_to_name then
                        changelogEntry = changelogEntry .. string.format(
                            'Assigned to: %s\n',
                            task.assigned_to_name
                        )
                    end
                    changelogEntry = changelogEntry .. string.format(
                        'Created: %s\n',
                        task.date_created or 'N/A'
                    )
                    if task.date_completed then
                        changelogEntry = changelogEntry .. string.format(
                            'Completed: %s\n',
                            task.date_completed
                        )
                    end
                    changelogEntry = changelogEntry .. '---\n\n'
                    
                    print('^2[Admin To-Do]^7 Calling WriteChangelog for deleted task #' .. tostring(taskId))
                    WriteChangelog(changelogEntry)
                    WriteTranslog('DELETE', taskId, adminIdentifier, adminName, 'Task deleted: ' .. task.description .. ' | Reason: ' .. deleteReason)
                    
                    TriggerClientEvent('sensless_devtool:notification', source, 'success', 'Task deleted successfully')
                    TriggerClientEvent('sensless_devtool:refreshTasks', -1)
                else
                    TriggerClientEvent('sensless_devtool:notification', source, 'error', 'Failed to delete task')
                end
            end)
        else
            TriggerClientEvent('sensless_devtool:notification', source, 'error', 'Task not found')
        end
    end)
end

RegisterNetEvent('sensless_devtool:deleteTask', function(taskId, deleteReason)
    DeleteTask(source, taskId, deleteReason)
end)

-- Complete task function
local function CompleteTask(source, taskId, completeReason)
    if not Framework:HasPermission(source) then
        return
    end
    
    local adminIdentifier = Framework:GetPlayerIdentifier(source)
    local adminName = Framework:GetPlayerName(source)
    local timestamp = os.date('%Y-%m-%d %H:%M:%S')
    
    if not completeReason or completeReason == '' then
        TriggerClientEvent('sensless_devtool:notification', source, 'error', 'Please provide a description of why this task is complete')
        return
    end
    
    MySQL.Async.fetchAll('SELECT * FROM `admin_tasks` WHERE `id` = ? AND `status` = ?', { taskId, 'pending' }, function(result)
        if result and #result > 0 then
            local task = result[1]
            
            MySQL.Async.execute(
                'UPDATE `admin_tasks` SET `status` = ?, `date_completed` = ?, `completed_by` = ?, `completed_by_name` = ? WHERE `id` = ?',
                { 'completed', timestamp, adminIdentifier, adminName, taskId },
                function(affectedRows)
                    if affectedRows > 0 then
                        -- Write to changelog with completion reason
                        local changelogEntry = string.format(
                            '[%s] TASK COMPLETED - ID: %d\n',
                            timestamp,
                            taskId
                        )
                        changelogEntry = changelogEntry .. string.format(
                            'Task: %s\n',
                            task.description
                        )
                        changelogEntry = changelogEntry .. string.format(
                            'Completed by: %s (%s)\n',
                            adminName,
                            adminIdentifier
                        )
                        changelogEntry = changelogEntry .. string.format(
                            'Completion Description: %s\n',
                            completeReason
                        )
                        changelogEntry = changelogEntry .. '---\n\n'
                        
                        print('^2[Admin To-Do]^7 Calling WriteChangelog for completed task #' .. tostring(taskId))
                        WriteChangelog(changelogEntry)
                        WriteTranslog('COMPLETE', taskId, adminIdentifier, adminName, 'Task completed: ' .. task.description .. ' | Reason: ' .. completeReason)
                        
                        TriggerClientEvent('sensless_devtool:notification', source, 'success', 'Task marked as completed')
                        TriggerClientEvent('sensless_devtool:refreshTasks', -1)
                    end
                end
            )
        else
            TriggerClientEvent('sensless_devtool:notification', source, 'error', 'Task not found or already completed')
        end
    end)
end

RegisterNetEvent('sensless_devtool:completeTask', function(taskId, completeReason)
    CompleteTask(source, taskId, completeReason)
end)

-- Reopen task function
local function ReopenTask(source, taskId, reopenReason)
    if not Framework:HasPermission(source) then
        print('^1[Admin To-Do]^7 ReopenTask: Permission denied for source ' .. tostring(source))
        return
    end
    
    local adminIdentifier = Framework:GetPlayerIdentifier(source)
    local adminName = Framework:GetPlayerName(source)
    local timestamp = os.date('%Y-%m-%d %H:%M:%S')
    
    print('^3[Admin To-Do]^7 ReopenTask called: taskId=' .. tostring(taskId) .. ', reason=' .. tostring(reopenReason))
    
    if not reopenReason or reopenReason == '' then
        TriggerClientEvent('sensless_devtool:notification', source, 'error', 'Please provide a reason for reopening the task')
        return
    end
    
    if not taskId then
        print('^1[Admin To-Do]^7 ReopenTask: Invalid taskId')
        TriggerClientEvent('sensless_devtool:notification', source, 'error', 'Invalid task ID')
        return
    end
    
    -- Check if reopen_reason column exists first
    MySQL.Async.fetchAll([[
        SELECT COUNT(*) as count 
        FROM INFORMATION_SCHEMA.COLUMNS 
        WHERE TABLE_SCHEMA = DATABASE() 
        AND TABLE_NAME = 'admin_tasks' 
        AND COLUMN_NAME = 'reopen_reason'
    ]], {}, function(columnResult)
        local hasReopenReasonColumn = columnResult and columnResult[1] and columnResult[1].count > 0
        
        print('^3[Admin To-Do]^7 Checking for task with id=' .. tostring(taskId) .. ' and status=completed')
        MySQL.Async.fetchAll('SELECT * FROM `admin_tasks` WHERE `id` = ? AND `status` = ?', { taskId, 'completed' }, function(result)
            if result and #result > 0 then
                local task = result[1]
                print('^2[Admin To-Do]^7 Task found, updating to pending status')
                
                local updateQuery
                local updateParams
                
                if hasReopenReasonColumn then
                    updateQuery = 'UPDATE `admin_tasks` SET `status` = ?, `date_completed` = NULL, `completed_by` = NULL, `completed_by_name` = NULL, `reopen_reason` = ? WHERE `id` = ?'
                    updateParams = { 'pending', reopenReason, taskId }
                else
                    updateQuery = 'UPDATE `admin_tasks` SET `status` = ?, `date_completed` = NULL, `completed_by` = NULL, `completed_by_name` = NULL WHERE `id` = ?'
                    updateParams = { 'pending', taskId }
                end
                
                MySQL.Async.execute(
                    updateQuery,
                    updateParams,
                    function(affectedRows)
                        if affectedRows and affectedRows > 0 then
                            -- Write to changelog
                            local changelogEntry = string.format(
                                '[%s] TASK REOPENED - ID: %d\n',
                                timestamp,
                                taskId
                            )
                            changelogEntry = changelogEntry .. string.format(
                                'Task: %s\n',
                                task.description
                            )
                            changelogEntry = changelogEntry .. string.format(
                                'Reopened by: %s (%s)\n',
                                adminName,
                                adminIdentifier
                            )
                            changelogEntry = changelogEntry .. string.format(
                                'Reason: %s\n',
                                reopenReason
                            )
                            changelogEntry = changelogEntry .. string.format(
                                'Original completion date: %s\n',
                                task.date_completed or 'N/A'
                            )
                            changelogEntry = changelogEntry .. '---\n\n'
                            
                            WriteChangelog(changelogEntry)
                            WriteTranslog('REOPEN', taskId, adminIdentifier, adminName, 'Task reopened: ' .. task.description .. ' | Reason: ' .. reopenReason)
                            
                            TriggerClientEvent('sensless_devtool:notification', source, 'success', 'Task reopened and moved to pending')
                            TriggerClientEvent('sensless_devtool:refreshTasks', -1)
                        else
                            print('^1[Admin To-Do]^7 Error: Failed to update task. Affected rows: ' .. tostring(affectedRows))
                            TriggerClientEvent('sensless_devtool:notification', source, 'error', 'Failed to reopen task. Check server console.')
                        end
                    end
                )
            else
                print('^1[Admin To-Do]^7 Error: Task not found or not completed. TaskId: ' .. tostring(taskId))
                TriggerClientEvent('sensless_devtool:notification', source, 'error', 'Task not found or not completed')
            end
        end)
    end)
end

RegisterNetEvent('sensless_devtool:reopenTask', function(taskId, reopenReason)
    print('^3[Admin To-Do]^7 Server event received: taskId=' .. tostring(taskId) .. ' (type: ' .. type(taskId) .. '), reason=' .. tostring(reopenReason))
    ReopenTask(source, tonumber(taskId), tostring(reopenReason))
end)

-- Update task priority
RegisterNetEvent('sensless_devtool:updatePriority', function(taskId, priority)
    local source = source
    if not Framework:HasPermission(source) then
        return
    end
    
    local validPriorities = { 'low', 'normal', 'high', 'urgent', 'started' }
    local isValidPriority = false
    for _, v in ipairs(validPriorities) do
        if v == priority then
            isValidPriority = true
            break
        end
    end
    
    if not isValidPriority then
        TriggerClientEvent('sensless_devtool:notification', source, 'error', 'Invalid priority level')
        return
    end
    
    local adminIdentifier = Framework:GetPlayerIdentifier(source)
    local adminName = Framework:GetPlayerName(source)
    
    MySQL.Async.execute(
        'UPDATE `admin_tasks` SET `priority` = ? WHERE `id` = ?',
        { priority, taskId },
        function(affectedRows)
            if affectedRows > 0 then
                WriteTranslog('UPDATE_PRIORITY', taskId, adminIdentifier, adminName, 'Priority changed to: ' .. priority)
                TriggerClientEvent('sensless_devtool:notification', source, 'success', 'Task priority updated')
                TriggerClientEvent('sensless_devtool:refreshTasks', -1)
            else
                TriggerClientEvent('sensless_devtool:notification', source, 'error', 'Task not found')
            end
        end
    )
end)

-- Permission check event (client requests permission before opening UI)
RegisterNetEvent('sensless_devtool:checkPermission', function()
    local source = source
    if Framework:HasPermission(source) then
        TriggerClientEvent('sensless_devtool:openUI', source)
    else
        TriggerClientEvent('sensless_devtool:permissionDenied', source)
    end
end)

-- Commands
RegisterCommand('std', function(source, args, rawCommand)
    if not Framework:HasPermission(source) then
        TriggerClientEvent('sensless_devtool:notification', source, 'error', 'You do not have permission to use this command')
        return
    end
    
    TriggerClientEvent('sensless_devtool:openUI', source)
end, false)

RegisterCommand('addtask', function(source, args, rawCommand)
    if not Framework:HasPermission(source) then
        TriggerClientEvent('sensless_devtool:notification', source, 'error', 'You do not have permission to use this command')
        return
    end
    
    if not args[1] then
        TriggerClientEvent('sensless_devtool:notification', source, 'error', 'Usage: /addtask <description>')
        return
    end
    
    local description = table.concat(args, ' ')
    AddTask(source, description, nil)
end, false)

RegisterCommand('deltask', function(source, args, rawCommand)
    if not Framework:HasPermission(source) then
        TriggerClientEvent('sensless_devtool:notification', source, 'error', 'You do not have permission to use this command')
        return
    end
    
    if not args[1] then
        TriggerClientEvent('sensless_devtool:notification', source, 'error', 'Usage: /deltask <taskID>')
        return
    end
    
    local taskId = tonumber(args[1])
    if not taskId then
        TriggerClientEvent('sensless_devtool:notification', source, 'error', 'Invalid task ID')
        return
    end
    
    DeleteTask(source, taskId)
end, false)

-- Periodic cleanup of old chat messages (every 6 hours)
CreateThread(function()
    while true do
        Wait(6 * 60 * 60 * 1000) -- 6 hours
        CleanupOldChatMessages()
    end
end)

-- Send chat message
RegisterNetEvent('sensless_devtool:sendChatMessage', function(message)
    local source = source
    if not Framework:HasPermission(source) then
        return
    end
    
    if not message or message == '' then
        return
    end
    
    if #message > 500 then
        TriggerClientEvent('sensless_devtool:notification', source, 'error', 'Message too long (max 500 characters)')
        return
    end
    
    local adminName = Framework:GetPlayerName(source)
    local timestamp = os.date('%Y-%m-%d %H:%M:%S')
    
    local chatEntry = {
        authorName = adminName,
        message = message,
        timestamp = timestamp
    }
    
    -- Save to database
    MySQL.Async.execute([[
        INSERT INTO `admin_chat_messages` (`author_name`, `message`, `timestamp`) 
        VALUES (?, ?, ?)
    ]], { adminName, message, timestamp }, function(insertId)
        if insertId then
            -- Add to in-memory cache
            table.insert(chatMessages, chatEntry)
            
            -- Limit in-memory cache to last 100 messages for performance
            if #chatMessages > 100 then
                table.remove(chatMessages, 1)
            end
            
            -- Broadcast to all admins
            print('^2[Admin To-Do]^7 Broadcasting chat message from ' .. adminName .. ': ' .. message)
            TriggerClientEvent('sensless_devtool:newChatMessage', -1, chatEntry)
        else
            print('^1[Admin To-Do]^7 Failed to save chat message to database')
            TriggerClientEvent('sensless_devtool:notification', source, 'error', 'Failed to send message')
        end
    end)
end)

-- Get chat messages (load from database to ensure we have all recent messages)
RegisterNetEvent('sensless_devtool:getChatMessages', function()
    local source = source
    if not Framework:HasPermission(source) then
        return
    end
    
    -- Reload from database to get all messages (in case cache is out of sync)
    MySQL.Async.fetchAll([[
        SELECT `author_name`, `message`, `timestamp` 
        FROM `admin_chat_messages` 
        ORDER BY `timestamp` ASC
    ]], {}, function(result)
        if result then
            local messages = {}
            for _, row in ipairs(result) do
                table.insert(messages, {
                    authorName = row.author_name,
                    message = row.message,
                    timestamp = row.timestamp
                })
            end
            -- Update cache
            chatMessages = messages
            -- Send to client
            TriggerClientEvent('sensless_devtool:updateChat', source, messages)
        else
            -- Send empty array if no messages
            TriggerClientEvent('sensless_devtool:updateChat', source, {})
        end
    end)
end)

RegisterCommand('completetask', function(source, args, rawCommand)
    if not Framework:HasPermission(source) then
        TriggerClientEvent('sensless_devtool:notification', source, 'error', 'You do not have permission to use this command')
        return
    end
    
    if not args[1] then
        TriggerClientEvent('sensless_devtool:notification', source, 'error', 'Usage: /completetask <taskID>')
        return
    end
    
    local taskId = tonumber(args[1])
    if not taskId then
        TriggerClientEvent('sensless_devtool:notification', source, 'error', 'Invalid task ID')
        return
    end
    
    CompleteTask(source, taskId)
end, false)
