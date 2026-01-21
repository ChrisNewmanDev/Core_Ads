local QBCore = exports['qb-core']:GetCoreObject()

RegisterCommand('ad', function(source, args, rawCommand)
    if #args < 1 then
        QBCore.Functions.Notify("Usage: /ad [message]", "error")
        return
    end

    local message = table.concat(args, " ")
    TriggerServerEvent('core-ads:server:sendAd', message)
end, false)

RegisterNetEvent('core-ads:client:displayAd', function(data)
    SendNUIMessage({
        action = "showAd",
        logo = data.logo,
        label = data.label,
        message = data.message,
        duration = Config.DisplayTime
    })
end)
