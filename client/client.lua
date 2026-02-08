-- Client-side Logic for Admin To-Do System

local isUIOpen = false
local tasks = {}

-- Notification System
function ShowNotification(type, message)
    if Config.ShowNotifications then
        if Config.Framework == 'qbcore' then
            QBCore.Functions.Notify(message, type, Config.NotificationDuration)
        elseif Config.Framework == 'esx' then
            ESX.ShowNotification(message)
        elseif Config.Framework == 'vrp' then
            vRP.notify({ message, type })
        else
            -- Standalone notification
            SetNotificationTextEntry('STRING')
            AddTextComponentString(message)
            DrawNotification(false, false)
        end
    end
end

-- Open UI (server has already verified permissions)
RegisterNetEvent('sensless_devtool:openUI', function()
    isUIOpen = true
    -- Ensure NUI focus is set to keep UI in-game (not external browser)
    SetNuiFocus(true, true)
    SetNuiFocusKeepInput(false) -- Don't keep input, allow mouse/keyboard for UI only
    
    SendNUIMessage({
        action = 'openUI',
        theme = Config.UITheme,
        resourceName = GetCurrentResourceName(),
        locale = Config.Locale or 'en',
        locales = Locales and Locales[Config.Locale or 'en'] or {}
    })
    
    -- Request tasks
    TriggerServerEvent('sensless_devtool:getTasks')
end)

RegisterNetEvent('sensless_devtool:permissionDenied', function()
    ShowNotification('error', 'You do not have permission to use this system')
end)

-- Receive tasks from server
RegisterNetEvent('sensless_devtool:receiveTasks', function(receivedTasks)
    tasks = receivedTasks
    SendNUIMessage({
        action = 'updateTasks',
        tasks = tasks
    })
end)

-- Refresh tasks
RegisterNetEvent('sensless_devtool:refreshTasks', function()
    if isUIOpen then
        TriggerServerEvent('sensless_devtool:getTasks')
    end
end)

-- Notification event
RegisterNetEvent('sensless_devtool:notification', function(type, message)
    ShowNotification(type, message)
end)

-- Function to close UI properly
local function CloseUI()
    if isUIOpen then
        isUIOpen = false
        -- Release NUI focus to return control to game
        SetNuiFocus(false, false)
        SetNuiFocusKeepInput(false)
    end
end

-- NUI Callbacks
RegisterNUICallback('closeUI', function(data, cb)
    CloseUI()
    cb('ok')
end)

RegisterNUICallback('addTask', function(data, cb)
    -- Capture player position (vector4: x, y, z, heading)
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)
    
    local position = {
        x = coords.x,
        y = coords.y,
        z = coords.z,
        heading = heading
    }
    
    -- Handle resource - convert empty string or "none" to nil
    local resource = data.resource
    if resource == nil or resource == '' or (type(resource) == 'string' and resource:lower() == 'none') then
        resource = nil
    end
    
    TriggerServerEvent('sensless_devtool:addTask', data.title, data.description, data.assignedTo, data.priority, resource, position)
    cb('ok')
end)

RegisterNUICallback('getResources', function(data, cb)
    TriggerServerEvent('sensless_devtool:getResources')
    cb('ok')
end)

RegisterNUICallback('getResourcesList', function(data, cb)
    TriggerServerEvent('sensless_devtool:getResourcesList')
    cb('ok')
end)

RegisterNUICallback('deleteTask', function(data, cb)
    if data and data.taskId and data.deleteReason then
        print('^2[SenslessBugToolClient]^7 DeleteTask: taskId=' .. tostring(data.taskId) .. ', reason=' .. tostring(data.deleteReason))
        TriggerServerEvent('sensless_devtool:deleteTask', tonumber(data.taskId), tostring(data.deleteReason))
    else
        print('^1[SenslessBugToolClient]^7 DeleteTask: Missing data - taskId=' .. tostring(data and data.taskId) .. ', reason=' .. tostring(data and data.deleteReason))
    end
    cb('ok')
end)

RegisterNUICallback('completeTask', function(data, cb)
    if data and data.taskId and data.completeReason then
        print('^2[SenslessBugToolClient]^7 CompleteTask: taskId=' .. tostring(data.taskId) .. ', reason=' .. tostring(data.completeReason))
        TriggerServerEvent('sensless_devtool:completeTask', tonumber(data.taskId), tostring(data.completeReason))
    else
        print('^1[SenslessBugToolClient]^7 CompleteTask: Missing data - taskId=' .. tostring(data and data.taskId) .. ', reason=' .. tostring(data and data.completeReason))
    end
    cb('ok')
end)

RegisterNUICallback('reopenTask', function(data, cb)
    if data and data.taskId and data.reopenReason then
        print('^2[SenslessBugToolClient]^7 ReopenTask: taskId=' .. tostring(data.taskId) .. ', reason=' .. tostring(data.reopenReason))
        TriggerServerEvent('sensless_devtool:reopenTask', tonumber(data.taskId), tostring(data.reopenReason))
    else
        print('^1[SenslessBugToolClient]^7 ReopenTask: Missing data - taskId=' .. tostring(data and data.taskId) .. ', reason=' .. tostring(data and data.reopenReason))
    end
    cb('ok')
end)

RegisterNUICallback('refreshTasks', function(data, cb)
    TriggerServerEvent('sensless_devtool:getTasks')
    cb('ok')
end)

RegisterNUICallback('showNotification', function(data, cb)
    if data and data.type and data.message then
        ShowNotification(data.type, data.message)
    end
    cb('ok')
end)

RegisterNUICallback('updatePriority', function(data, cb)
    if data and data.taskId and data.priority then
        TriggerServerEvent('sensless_devtool:updatePriority', data.taskId, data.priority)
    end
    cb('ok')
end)

RegisterNUICallback('sendChatMessage', function(data, cb)
    if data and data.message then
        print('^2[SenslessBugToolClient]^7 Sending chat message via NUI callback: ' .. tostring(data.message))
        TriggerServerEvent('sensless_devtool:sendChatMessage', tostring(data.message))
    else
        print('^1[SenslessBugToolClient]^7 sendChatMessage: Missing message data')
    end
    cb('ok')
end)

RegisterNUICallback('getChatMessages', function(data, cb)
    print('^2[SenslessBugToolClient]^7 Requesting chat messages')
    TriggerServerEvent('sensless_devtool:getChatMessages')
    cb('ok')
end)

-- Auto-refresh tasks
CreateThread(function()
    while true do
        Wait(Config.AutoRefreshInterval)
        if isUIOpen then
            TriggerServerEvent('sensless_devtool:getTasks')
        end
    end
end)

-- Ensure UI closes when resource stops
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        CloseUI()
        SendNUIMessage({
            action = 'forceClose'
        })
    end
end)

-- Chat Events
RegisterNetEvent('sensless_devtool:updateChat', function(messages)
    SendNUIMessage({
        action = 'updateChat',
        messages = messages
    })
end)

RegisterNetEvent('sensless_devtool:newChatMessage', function(message)
    print('^2[SenslessBugToolClient]^7 Received chat message event')
    if message then
        print('^2[SenslessBugToolClient]^7 Message author: ' .. tostring(message.authorName))
        print('^2[SenslessBugToolClient]^7 Message text: ' .. tostring(message.message))
        SendNUIMessage({
            action = 'newChatMessage',
            message = message
        })
    else
        print('^1[SenslessBugToolClient]^7 Error: message is nil')
    end
end)

RegisterNetEvent('sensless_devtool:receiveResources', function(resources)
    SendNUIMessage({
        action = 'receiveResources',
        resources = resources
    })
end)

RegisterNetEvent('sensless_devtool:receiveResourcesList', function(resources)
    SendNUIMessage({
        action = 'receiveResourcesList',
        resources = resources
    })
end)

RegisterNUICallback('getResourceFiles', function(data, cb)
    if data and data.resourceName then
        TriggerServerEvent('sensless_devtool:getResourceFiles', data.resourceName)
    end
    cb('ok')
end)

RegisterNetEvent('sensless_devtool:receiveResourceFiles', function(resourceName, files)
    SendNUIMessage({
        action = 'receiveResourceFiles',
        resourceName = resourceName,
        files = files
    })
end)

RegisterNUICallback('getResourceTasks', function(data, cb)
    if data and data.resourceName then
        TriggerServerEvent('sensless_devtool:getResourceTasks', data.resourceName)
    end
    cb('ok')
end)

RegisterNetEvent('sensless_devtool:receiveResourceTasks', function(resourceName, tasks)
    SendNUIMessage({
        action = 'receiveResourceTasks',
        resourceName = resourceName,
        tasks = tasks
    })
end)

-- Teleport to position callback
RegisterNUICallback('teleportToPosition', function(data, cb)
    if data and data.x and data.y and data.z then
        local ped = PlayerPedId()
        local x = tonumber(data.x)
        local y = tonumber(data.y)
        local z = tonumber(data.z)
        local heading = tonumber(data.heading) or 0.0
        
        -- Teleport player
        SetEntityCoords(ped, x, y, z, false, false, false, true)
        if heading then
            SetEntityHeading(ped, heading)
        end
        
        ShowNotification('success', 'Teleported to task location')
    else
        ShowNotification('error', 'Invalid coordinates')
    end
    cb('ok')
end)

-- Commands
RegisterCommand('std', function()
    -- Request permission check from server before opening UI
    TriggerServerEvent('sensless_devtool:checkPermission')
end, false)

RegisterCommand('addtask', function(source, args)
    if not args[1] then
        ShowNotification('error', 'Usage: /addtask <description>')
        return
    end
    
    local description = table.concat(args, ' ')
    TriggerServerEvent('sensless_devtool:addTask', description, nil)
end, false)

RegisterCommand('deltask', function(source, args)
    if not args[1] then
        ShowNotification('error', 'Usage: /deltask <taskID>')
        return
    end
    
    local taskId = tonumber(args[1])
    if not taskId then
        ShowNotification('error', 'Invalid task ID')
        return
    end
    
    TriggerServerEvent('sensless_devtool:deleteTask', taskId)
end, false)

RegisterCommand('completetask', function(source, args)
    if not args[1] then
        ShowNotification('error', 'Usage: /completetask <taskID>')
        return
    end
    
    local taskId = tonumber(args[1])
    if not taskId then
        ShowNotification('error', 'Invalid task ID')
        return
    end
    
    TriggerServerEvent('sensless_devtool:completeTask', taskId)
end, false)

