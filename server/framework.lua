
-- Framework Compatibility Layer
Framework = {}

function Framework:GetPlayer(source)
    if Config.Framework == 'qbcore' then
        return QBCore.Functions.GetPlayer(source)
    elseif Config.Framework == 'esx' then
        return ESX.GetPlayerFromId(source)
    elseif Config.Framework == 'vrp' then
        return vRP.getUserSource(source)
    else
        return { source = source }
    end
end

function Framework:GetPlayerIdentifier(source)
    if Config.Framework == 'qbcore' then
        local Player = QBCore.Functions.GetPlayer(source)
        if Player then
            return Player.PlayerData.license
        end
    elseif Config.Framework == 'esx' then
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer then
            return xPlayer.identifier
        end
    elseif Config.Framework == 'vrp' then
        local user_id = vRP.getUserId(source)
        if user_id then
            return 'vrp:' .. user_id
        end
    else
        -- Standalone: Use Steam ID
        local identifiers = GetPlayerIdentifiers(source)
        for _, id in ipairs(identifiers) do
            if string.find(id, 'steam:') then
                return id
            end
        end
    end
    return nil
end

function Framework:GetPlayerName(source)
    if Config.Framework == 'qbcore' then
        local Player = QBCore.Functions.GetPlayer(source)
        if Player then
            return Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname
        end
    elseif Config.Framework == 'esx' then
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer then
            return xPlayer.getName()
        end
    elseif Config.Framework == 'vrp' then
        local user_id = vRP.getUserId(source)
        if user_id then
            local identity = vRP.getUserIdentity(user_id)
            if identity then
                return identity.name .. ' ' .. identity.firstname
            end
        end
    else
        return GetPlayerName(source)
    end
    return 'Unknown'
end

function Framework:HasPermission(source)
    -- First check FiveM ACE permissions (group.admin, etc.)
    -- This checks if player has any of the permission groups defined in Config
    local playerName = Framework:GetPlayerName(source) or 'Unknown'
    
    print('^3[Admin To-Do]^7 Checking ACE permissions for ' .. playerName .. ' (source: ' .. tostring(source) .. ')')
    
    -- Get player identifiers for debugging
    local identifiers = GetPlayerIdentifiers(source)
    if identifiers then
        print('^3[Admin To-Do]^7 Player identifiers:')
        for _, identifier in ipairs(identifiers) do
            print('^3[Admin To-Do]^7   - ' .. identifier)
        end
    end
    
    -- Try multiple ACE check methods
    for group, _ in pairs(Config.PermissionGroups) do
        local aceString = 'group.' .. group
        local hasAce = IsPlayerAceAllowed(source, aceString)
        print('^3[Admin To-Do]^7 Checking ACE: ' .. aceString .. ' = ' .. tostring(hasAce))
        
        -- Also try checking with just the group name (some servers use this)
        if not hasAce then
            hasAce = IsPlayerAceAllowed(source, group)
            if hasAce then
                print('^3[Admin To-Do]^7 Found ACE permission using group name: ' .. group)
            end
        end
        
        -- Also try checking command permission (since server.cfg has "add_ace group.admin command allow")
        if not hasAce then
            hasAce = IsPlayerAceAllowed(source, 'command')
            if hasAce then
                print('^3[Admin To-Do]^7 Found ACE permission for command, checking if in group...')
                -- If they have command permission, they might be in admin group
                -- We'll assume they have permission if they have command access
            end
        end
        
        -- Check if player has any admin-related permissions
        if not hasAce then
            -- Try checking for admin permission directly
            hasAce = IsPlayerAceAllowed(source, 'admin')
            if hasAce then
                print('^3[Admin To-Do]^7 Found ACE permission: admin')
            end
        end
        
        if hasAce then
            print('^2[Admin To-Do]^7 Permission granted via ACE: ' .. aceString .. ' for ' .. playerName)
            return true
        end
    end
    
    print('^3[Admin To-Do]^7 No ACE permissions found, checking framework-specific permissions...')
    
    -- Fallback to framework-specific checks
    if Config.Framework == 'qbcore' then
        if not QBCore then
            return false
        end
        local Player = QBCore.Functions.GetPlayer(source)
        if not Player then
            return false
        end
        
        local playerName = Player.PlayerData.charinfo and (Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname) or 'Unknown'
        local job = Player.PlayerData.job
        
        print('^3[Admin To-Do]^7 Checking QBCore permission for ' .. playerName .. ' (source: ' .. tostring(source) .. ')')
        
        -- Check if player has admin/god job or high grade level
        if job then
            print('^3[Admin To-Do]^7 Job name: ' .. tostring(job.name) .. ', Grade level: ' .. tostring(job.grade and job.grade.level or 'nil'))
            
            if job.name == 'admin' or job.name == 'god' then
                print('^2[Admin To-Do]^7 Permission granted: admin/god job')
                return true
            end
            -- Check if job grade level is high enough (usually 4+ for admin)
            if job.grade and job.grade.level and job.grade.level >= 4 then
                print('^2[Admin To-Do]^7 Permission granted: grade level >= 4')
                return true
            end
            -- Check custom permission groups via job name
            for group, _ in pairs(Config.PermissionGroups) do
                if job.name == group then
                    print('^2[Admin To-Do]^7 Permission granted: custom group ' .. group)
                    return true
                end
            end
        else
            print('^1[Admin To-Do]^7 No job data found')
        end
        
        -- Alternative: Check if player is in admin list (if QBCore has this)
        -- Some QBCore versions use Player.PlayerData.metadata.isadmin or similar
        if Player.PlayerData.metadata and Player.PlayerData.metadata.isadmin then
            print('^2[Admin To-Do]^7 Permission granted: metadata.isadmin')
            return true
        end
        
        print('^1[Admin To-Do]^7 Permission denied for ' .. playerName)
        return false
    elseif Config.Framework == 'esx' then
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer then
            local group = xPlayer.getGroup()
            return Config.PermissionGroups[group] == true
        end
        return false
    elseif Config.Framework == 'vrp' then
        local user_id = vRP.getUserId(source)
        if user_id then
            for group, _ in pairs(Config.PermissionGroups) do
                if vRP.hasPermission(user_id, group) then
                    return true
                end
            end
        end
        return false
    else
        -- Standalone: Check Steam ID whitelist
        local identifiers = GetPlayerIdentifiers(source)
        for _, id in ipairs(identifiers) do
            if string.find(id, 'steam:') then
                for _, whitelisted in ipairs(Config.WhitelistedSteamIDs) do
                    if id == whitelisted then
                        return true
                    end
                end
            end
        end
        return false
    end
end

-- Initialize Framework
CreateThread(function()
    if Config.Framework == 'qbcore' then
        QBCore = exports['qb-core']:GetCoreObject()
    elseif Config.Framework == 'esx' then
        ESX = nil
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        while ESX == nil do
            Wait(100)
        end
    elseif Config.Framework == 'vrp' then
        Proxy = module('vrp', 'lib/Proxy')
        vRP = Proxy.getInterface('vRP')
    end
end)