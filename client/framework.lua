-- Client-side Framework Compatibility Layer
ClientFramework = {}

function ClientFramework:GetPlayer()
    if Config.Framework == 'qbcore' then
        return QBCore.Functions.GetPlayerData()
    elseif Config.Framework == 'esx' then
        return ESX.GetPlayerData()
    elseif Config.Framework == 'vrp' then
        return vRP.getUserData()
    else
        return {}
    end
end

function ClientFramework:HasPermission()
    -- Check FiveM ACE permissions first (if available client-side)
    -- Note: IsPlayerAceAllowed might not work client-side, so we'll verify with server
    -- For now, we'll check framework-specific permissions and let server verify
    
    if Config.Framework == 'qbcore' then
        if QBCore then
            local Player = QBCore.Functions.GetPlayerData()
            if Player then
                local job = Player.job
                if job then
                    -- Check if player has admin/god job
                    if job.name == 'admin' or job.name == 'god' then
                        return true
                    end
                    -- Check if job grade level is high enough (usually 4+ for admin)
                    if job.grade and job.grade.level and job.grade.level >= 4 then
                        return true
                    end
                    -- Check custom permission groups via job name
                    for group, _ in pairs(Config.PermissionGroups) do
                        if job.name == group then
                            return true
                        end
                    end
                end
            end
        end
        -- If no permission found, deny access - server will also verify
        return false
    elseif Config.Framework == 'esx' then
        if ESX then
            local xPlayer = ESX.GetPlayerData()
            if xPlayer then
                local group = xPlayer.group
                return Config.PermissionGroups[group] == true
            end
        end
        return false
    elseif Config.Framework == 'vrp' then
        if vRP then
            local user_id = vRP.getUserId()
            if user_id then
                for group, _ in pairs(Config.PermissionGroups) do
                    if vRP.hasPermission(user_id, group) then
                        return true
                    end
                end
            end
        end
        return false
    else
        -- Standalone: Always return true if they can use commands
        return true
    end
end

-- Initialize Framework
CreateThread(function()
    if Config.Framework == 'qbcore' then
        while not exports['qb-core'] do
            Wait(100)
        end
        QBCore = exports['qb-core']:GetCoreObject()
    elseif Config.Framework == 'esx' then
        while not exports['es_extended'] do
            Wait(100)
        end
        ESX = exports['es_extended']:getSharedObject()
    elseif Config.Framework == 'vrp' then
        Proxy = module('vrp', 'lib/Proxy')
        vRP = Proxy.getInterface('vRP')
    end
end)

