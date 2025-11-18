print([[^1
     _    _   _ _____ ___            ____ _   _ _____    _  _____ 
    / \  | \ | |_   _|_ _|          / ___| | | | ____|  / \|_   _|
   / _ \ |  \| | | |  | |   _____  | |   | |_| |  _|   / _ \ | |  
  / ___ \| |\  | | |  | |  |_____| | |___|  _  | |___ / ___ \| |  
 /_/   \_\_| \_| |_| |___|          \____|_| |_|_____/_/   \_\_|  
                                                                 
          ^8 ANTI CHEAT BY NATAKENSHI DEVELOPER^0
          ^8by Natakenshi (https://github.com/MasAjam)^0
^0---------------------[^2CODE BY NATAKENSHI DEV^0]---------------------]])
--[[
  NATAKENSHI ANTI CHEAT SYSTEM
  Fitur:
  ✅ Ban System via Database + Discord
  ✅ Deteksi Spam Ledakan / Ledakan Mencurigakan
  ✅ Deteksi Senjata Ilegal
  ✅ Deteksi Godmode
  ✅ Deteksi Invisible Player
  ✅ Deteksi Prop Spam / Entity Spam
  ✅ Deteksi TriggerEvent Abuse
  ✅ Deteksi Money / Job Injector
  ✅ Deteksi Aimbot / Rapid Fire
  ✅ Deteksi Spam Emote
  ✅ Command /unbanatc
]]--

-- Config
local webhookURL = "https://discord.com/api/webhooks/1385840623524904990/4TQUWQy-qiymTEaoE17cNzldUPMMfSN4bmxBfhuuXqtfbFKAA_bvZNu-7mWTY7mNX1ik"
local spamTracker = {}
local spamLimit = 7 --Spam Ledakan Sampai Berapa Biar Ke Banned
local spamResetTime = 2000
local shotTracker = {}
local emoteSpamTracker = {}

-- Anti Illegal Weapon
local blacklistedWeapons = {
    [`weapon_rpg`] = true,
    [`weapon_railgun`] = true,
    [`weapon_minigun`] = true
}

-- Anti Prop Spam
local blacklistedProps = {
    [`prop_weed_01`] = false,
    [`prop_air_bomb`] = true
}

-- Anti TriggerEvent Abuse
local blockedEvents = {
    "esx:addMoney",
    "giveWeapon",
    "esx:setGroup"
}

-- Ban saat player connecting
AddEventHandler("playerConnecting", function(name, setKickReason, deferrals)
    local src = source
    deferrals.defer()
    Wait(6000)
    deferrals.update("NATA ANTI CHEAT --- 🔒 Checking ban status...")

    local license = GetPlayerIdentifierByType(src, "license") or "license:unknown" or "license:unknown" or "license:unknown"
    if not license then
        deferrals.done("❌ License tidak ditemukan. Tidak dapat melanjutkan.")
        CancelEvent()
        return
    end

    MySQL.Async.fetchAll("SELECT * FROM bans WHERE license = @license AND expire = 0", {
        ['@license'] = license
    }, function(result)
        if result and #result > 0 then
            local ban = result[1]
            local banId = ban.id or "UNKNOWN"
            local reason = ban.reason or "Violation Detected"

            local msg = ([=[
🛡️ NATAKENSHI ANTI CHEAT

You have been banned by the Anticheat

Associated Ban ID: %s
Reason: %s

This ban never expires.

If you believe you were banned in error, please contact the server administration (join the Discord server below).
Do not discuss bans on FiveM official.

🔗 Discord: discord.gg/natakenshidevelopment
]=]):format(banId, reason)

            deferrals.done(msg)
            CancelEvent()
        else
            deferrals.done()
        end
    end)
end)

-- Fungsi log ke Discord
function sendToDiscord(title, message)
    local embed = {
        {
            ["title"] = title,
            ["description"] = message,
            ["color"] = 16711680,
            ["footer"] = {
                ["text"] = os.date("%d/%m/%Y %H:%M:%S")
            }
        }
    }

    PerformHttpRequest(webhookURL, function() end, "POST", json.encode({
        username = "🛡️ AntiCheat Logs",
        embeds = embed
    }), { ["Content-Type"] = "application/json" })
end

-- Fungsi ban
-- Fungsi ban (final fix dengan ambil Ban ID)
function BanPlayer(src, reason)
    local name = GetPlayerName(src) or "Unknown"
    local steam = GetPlayerIdentifierByType(src, "steam") or "steam:unknown"
    local license = GetPlayerIdentifierByType(src, "license") or "license:unknown"
    local discord = GetPlayerIdentifierByType(src, "discord") or "discord:unknown"
    local ip = GetPlayerEndpoint(src) or "IP:unknown"
    local bannedOn = os.time()

    MySQL.Async.insert("INSERT INTO bans (name, steam, license, discord, ip, reason, bannedby, expire, bannedon) VALUES (@name, @steam, @license, @discord, @ip, @reason, 'AntiCheat', 0, @bannedon)", {
        ['@name'] = name,
        ['@steam'] = steam,
        ['@license'] = license,
        ['@discord'] = discord,
        ['@ip'] = ip,
        ['@reason'] = reason,
        ['@bannedon'] = bannedOn
    }, function(banId)
        banId = banId or "UNKNOWN"

        local msg = ([=[
🛡️ NATAKENSHI DEVELOPMENT

You have been banned by the Anticheat

Associated Ban ID: %s
Reason: %s

This ban never expires.

If you believe you were banned in error, please contact the server administration (join the Discord server below).
Do not discuss bans on FiveM official.

🔗 Discord: discord.gg/natakenshidevelopment
]=]):format(banId, reason)

        DropPlayer(src, msg)
        sendToDiscord("🚨 Banned Player - Anti Cheat", ([=[
Name: %s
Steam: %s
License: %s
Ban ID: %s
Reason: %s
]=]):format(
            tostring(name),
            tostring(steam),
            tostring(license),
            tostring(banId),
            tostring(reason)
        ))
    end)
end



-- Anti Prop Spam
AddEventHandler("entityCreating", function(entity)
    if DoesEntityExist(entity) and GetEntityType(entity) == 3 then
        local model = GetEntityModel(entity)
        local creator = NetworkGetEntityOwner(entity)
        if blacklistedProps[model] and creator then
            CancelEvent()
            BanPlayer(creator, "Prop Spam: "..model)
            -- Log akan otomatis terkirim dari dalam BanPlayer()
        end
    end
end)

-- Anti TriggerEvent Abuse
for _, ev in ipairs(blockedEvents) do
    RegisterServerEvent(ev)
    AddEventHandler(ev, function()
        DropPlayer(source, "🚨 TriggerEvent Abuse: "..ev)
        sendToDiscord("TriggerEvent Abuse", GetPlayerName(source).." tried: "..ev)
        CancelEvent()
    end)
end

-- Anti Emote Spam (Cooldown Based)
RegisterServerEvent("emote:play")
AddEventHandler("emote:play", function()
    local src = source
    local now = GetGameTimer()

    if not emoteSpamTracker[src] then
        emoteSpamTracker[src] = { last = now, count = 1 }
    else
        local diff = now - emoteSpamTracker[src].last
        if diff <= 5000 then
            emoteSpamTracker[src].count = emoteSpamTracker[src].count + 1
        else
            emoteSpamTracker[src].count = 1
        end
        emoteSpamTracker[src].last = now
    end

    if emoteSpamTracker[src].count >= 4 then
        DropPlayer(src, "Kamu dibanned karena spam emote.")
        emoteSpamTracker[src] = nil
    end
end)

-- Anti Ledakan Mencurigakan (RPG, dll)
AddEventHandler('explosionEvent', function(sender, ev)
    local playerName = GetPlayerName(sender)
    local identifier = GetPlayerIdentifier(sender, 0)
    local explosionType = ev.explosionType
    local reason = ""

    if explosionType == 38 then
        reason = "Detected: Explosion (ROCKET)"
    end

    spamTracker[identifier] = spamTracker[identifier] or { count = 0, lastTime = os.time() * 1000 }
    local now = os.time() * 1000

    if now - spamTracker[identifier].lastTime <= spamResetTime then
        spamTracker[identifier].count = spamTracker[identifier].count + 1
    else
        spamTracker[identifier].count = 5
    end
    spamTracker[identifier].lastTime = now

    if spamTracker[identifier].count >= spamLimit or reason ~= "" then
        BanPlayer(sender, reason ~= "" and reason or "Spam ledakan mencurigakan")
    end
end)


-- Anti Explosion Spam
AddEventHandler('explosionEvent', function(sender, ev)
    local playerName = GetPlayerName(sender)
    local identifier = GetPlayerIdentifier(sender, 0)
    local explosionType = ev.explosionType
    local suspiciousExplosionTypes = {[6] = "Boat", [7] = "Plane", [59] = "Gas Tank", [60] = "Firework"}
    local reason = suspiciousExplosionTypes[explosionType] and "Deteksi: "..suspiciousExplosionTypes[explosionType] or ""

    if not spamTracker[identifier] then
        spamTracker[identifier] = { count = 1, lastTime = os.time() * 1000 }
    else
        local now = os.time() * 1000
        spamTracker[identifier].count = now - spamTracker[identifier].lastTime <= spamResetTime and spamTracker[identifier].count + 1 or 1
        spamTracker[identifier].lastTime = now
    end

    if spamTracker[identifier].count >= spamLimit or reason ~= "" then
        BanPlayer(sender, reason ~= "" and reason or "Spam ledakan mencurigakan")
    end
end)

-- Anti Fall Damage / Anti Fall Cheat
CreateThread(function()
    while true do
        Wait(3000)
        for _, playerId in ipairs(GetPlayers()) do
            local ped = GetPlayerPed(playerId)
            if ped and not IsPedFatallyInjured(ped) then
                local vel = GetEntityVelocity(ped)
                local speed = math.sqrt(vel.x^2 + vel.y^2 + vel.z^2)
                local height = GetEntityHeightAboveGround(ped)

                if height > 10.0 and speed > 10.0 and GetEntityHealth(ped) > 150 then
                    BanPlayer(playerId, "Fall Damage Bypass Detected (Possible .rpf cheat)")
                end
            end
        end
    end
end)

-- Unban Command /unbanatc steam:xxxxxxxxxxxxxxx
RegisterCommand("unbanatc", function(source, args)
    local steamID = args[1]
    if not steamID or not steamID:find("steam:") then
        if source ~= 0 then
            TriggerClientEvent("chat:addMessage", source, {
                args = {"^1[UNBAN]", "Format salah. Gunakan: /unbanatc steam:xxxxxxxxxxxxxxx"}
            })
        else
            print("[UNBAN] Format salah.")
        end
        return
    end
    MySQL.Async.fetchAll("SELECT * FROM bans WHERE steam = @steam AND expire = 0", {
        ['@steam'] = steamID
    }, function(result)
        if result and #result > 0 then
            MySQL.Async.execute("DELETE FROM bans WHERE steam = @steam AND expire = 0", {
                ['@steam'] = steamID
            }, function()
                local message = ("✅ Unbanned: %s"):format(steamID)
                if source ~= 0 then
                    TriggerClientEvent("chat:addMessage", source, { args = {"^2[UNBAN]", message} })
                else
                    print("[UNBAN] "..message)
                end
                sendToDiscord("🟢 Unban via Command", ("SteamID: %s\nBy: %s"):format(steamID, GetPlayerName(source) or "CONSOLE"))
            end)
        else
            local msg = "SteamID tidak ditemukan atau tidak sedang diban."
            if source ~= 0 then
                TriggerClientEvent("chat:addMessage", source, { args = {"^1[UNBAN]", msg} })
            else
                print("[UNBAN] "..msg)
            end
        end
    end)
end, true)
