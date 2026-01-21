local QBCore = exports['qb-core']:GetCoreObject()

local CURRENT_VERSION = "1.0.0"
local RESOURCE_NAME = "Core_Ads"
local VERSION_CHECK_URL = "https://raw.githubusercontent.com/ChrisNewmanDev/Core_Ads/main/version.json"

local function ParseVersion(version)
    local major, minor, patch = version:match('(%d+)%.(%d+)%.(%d+)')
    return {
        major = tonumber(major) or 0,
        minor = tonumber(minor) or 0,
        patch = tonumber(patch) or 0
    }
end

local function CompareVersions(current, latest)
    local currentVer = ParseVersion(current)
    local latestVer = ParseVersion(latest)
    
    if latestVer.major > currentVer.major then return 'outdated'
    elseif latestVer.major < currentVer.major then return 'ahead' end
    
    if latestVer.minor > currentVer.minor then return 'outdated'
    elseif latestVer.minor < currentVer.minor then return 'ahead' end
    
    if latestVer.patch > currentVer.patch then return 'outdated'
    elseif latestVer.patch < currentVer.patch then return 'ahead' end
    
    return 'current'
end

local function CheckVersion()
    PerformHttpRequest(VERSION_CHECK_URL, function(statusCode, response, headers)
        if statusCode ~= 200 then
            print('^3[' .. RESOURCE_NAME .. '] ^1Failed to check for updates (HTTP ' .. statusCode .. ')^7')
            print('^3[' .. RESOURCE_NAME .. '] ^3Please verify the version.json URL is correct^7')
            return
        end
        
        local success, versionData = pcall(function() return json.decode(response) end)
        
        if not success or not versionData or not versionData.version then
            print('^3[' .. RESOURCE_NAME .. '] ^1Failed to parse version data^7')
            return
        end
        
        local latestVersion = versionData.version
        local versionStatus = CompareVersions(CURRENT_VERSION, latestVersion)
        
        print('^3========================================^7')
        print('^5[' .. RESOURCE_NAME .. '] Version Checker^7')
        print('^3========================================^7')
        print('^2Current Version: ^7' .. CURRENT_VERSION)
        print('^2Latest Version:  ^7' .. latestVersion)
        print('')
        
        if versionStatus == 'current' then
            print('^2✓ You are running the latest version!^7')
        elseif versionStatus == 'ahead' then
            print('^3⚠ You are running a NEWER version than released!^7')
            print('^3This may be a development version.^7')
        elseif versionStatus == 'outdated' then
            print('^1⚠ UPDATE AVAILABLE!^7')
            print('')
            
            if versionData.changelog and versionData.changelog[latestVersion] then
                local changelog = versionData.changelog[latestVersion]
                
                if changelog.date then
                    print('^6Release Date: ^7' .. changelog.date)
                    print('')
                end
                
                if changelog.changes and #changelog.changes > 0 then
                    print('^5Changes:^7')
                    for _, change in ipairs(changelog.changes) do
                        print('  ^2✓^7 ' .. change)
                    end
                    print('')
                end
                
                if changelog.files_to_update and #changelog.files_to_update > 0 then
                    print('^1Files that need to be updated:^7')
                    for _, file in ipairs(changelog.files_to_update) do
                        print('  ^3➤^7 ' .. file)
                    end
                    print('')
                end
            end
            
            print('^2Download: ^7https://github.com/ChrisNewmanDev/Core_Ads/releases/latest')
        end
        
        print('^3========================================^7')
    end, 'GET')
end

CreateThread(function()
    Wait(2000)
    CheckVersion()
end)

print('^2[' .. RESOURCE_NAME .. '] ^7Server initialized - v' .. CURRENT_VERSION)

local function SendWebhookLog(playerName, identifier, job, message)
    if Config.WebhookURL == "webhook_here" or Config.WebhookURL == "" then
        return
    end

    local embed = {
        {
            ["title"] = "Advertisement Sent",
            ["color"] = 3447003,
            ["fields"] = {
                {
                    ["name"] = "Player",
                    ["value"] = playerName,
                    ["inline"] = true
                },
                {
                    ["name"] = "Identifier",
                    ["value"] = identifier,
                    ["inline"] = true
                },
                {
                    ["name"] = "Job",
                    ["value"] = job,
                    ["inline"] = true
                },
                {
                    ["name"] = "Message",
                    ["value"] = message,
                    ["inline"] = false
                }
            },
            ["footer"] = {
                ["text"] = os.date("%Y-%m-%d %H:%M:%S")
            }
        }
    }

    PerformHttpRequest(Config.WebhookURL, function(err, text, headers) end, 'POST', json.encode({
        username = 'Core Ads',
        embeds = embed
    }), {
        ['Content-Type'] = 'application/json'
    })
end

-- Server event to handle ad requests
RegisterNetEvent('core-ads:server:sendAd', function(message)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if not Player then
        return
    end

    local playerJob = Player.PlayerData.job.name
    local playerGrade = Player.PlayerData.job.grade.level
    local jobConfig = Config.AllowedAds[playerJob]

    -- Check if player's job is allowed to send ads
    if not jobConfig then
        TriggerClientEvent('QBCore:Notify', src, "Your job is not authorized to send advertisements", "error")
        return
    end

    -- Check if player meets minimum grade requirement
    if playerGrade < jobConfig.minGrade then
        TriggerClientEvent('QBCore:Notify', src, "You need to be at least grade " .. jobConfig.minGrade .. " to send advertisements", "error")
        return
    end

    -- Prepare ad data
    local adData = {
        logo = jobConfig.logo,
        label = jobConfig.label,
        message = message
    }

    -- Send ad to all players
    TriggerClientEvent('core-ads:client:displayAd', -1, adData)

    -- Notify sender
    TriggerClientEvent('QBCore:Notify', src, "Advertisement sent successfully!", "success")

    -- Log to webhook
    local playerName = GetPlayerName(src)
    local identifier = Player.PlayerData.citizenid or "Unknown"
    SendWebhookLog(playerName, identifier, jobConfig.label, message)
end)
