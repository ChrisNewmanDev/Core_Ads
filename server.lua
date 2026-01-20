local QBCore = exports['qb-core']:GetCoreObject()

-- Function to send webhook log
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
