local webhooks = {
    all = "DISCORD_WEBHOOK_HERE",
    chat = "DISCORD_WEBHOOK_HERE",
    joins = "DISCORD_WEBHOOK_HERE",
    leaving = "DISCORD_WEBHOOK_HERE",
    deaths = "DISCORD_WEBHOOK_HERE",
    shooting = "DISCORD_WEBHOOK_HERE",
    resources = "DISCORD_WEBHOOK_HERE",
    WEBHOOK_CHANNEL = "DISCORD_WEBHOOK_HERE"
}

-- Send log to specific category and all/general
function sendLog(type, title, description, color)
    local data = {
        username = "Server Logs",
        embeds = {{
            title = title,
            description = description,
            color = color or 16777215,
            footer = { text = os.date("Logged on %Y-%m-%d at %H:%M:%S") }
        }}
    }

    local function send(webhook)
        PerformHttpRequest(webhook, function() end, 'POST', json.encode(data), { ['Content-Type'] = 'application/json' })
    end

    if webhooks[type] then send(webhooks[type]) end
    if webhooks.all then send(webhooks.all) end
end

-- Join logs
AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
    sendLog("joins", "🟢 Player Connecting", string.format("**%s** is joining the server.", name), 3066993)
end)

-- Leave logs
AddEventHandler('playerDropped', function(reason)
    local src = source
    local name = GetPlayerName(src)
    sendLog("leaving", "🔴 Player Left", string.format("**%s** left the server. Reason: %s", name, reason or "No reason"), 15158332)
end)

-- Chat logs
RegisterServerEvent('chatMessage')
AddEventHandler('chatMessage', function(source, name, message)
    sendLog("chat", "💬 Chat Message", string.format("**%s**: %s", name, message), 3447003)
end)

-- Resource logs
AddEventHandler("onResourceStart", function(resourceName)
    sendLog("resources", "📥 Resource Started", string.format("`%s` has started.", resourceName), 1752220)
end)

AddEventHandler("onResourceStop", function(resourceName)
    sendLog("resources", "📤 Resource Stopped", string.format("`%s` has stopped.", resourceName), 15105570)
end)

-- (Optional) Death logs (if using a death event system)
RegisterServerEvent("playerDied") -- You'd trigger this manually or with a combat logger
AddEventHandler("playerDied", function(killer, victim, weapon)
    sendLog("deaths", "☠️ Player Death", string.format("**%s** killed **%s** with `%s`.", killer, victim, weapon), 10038562)
end)

-- (Optional) Shooting logs (requires client detection and server trigger)
RegisterServerEvent("playerShooting")
AddEventHandler("playerShooting", function(player)
    local name = GetPlayerName(player)
    sendLog("shooting", "🔫 Shooting Detected", string.format("**%s** fired a weapon.", name), 15844367)
end)



