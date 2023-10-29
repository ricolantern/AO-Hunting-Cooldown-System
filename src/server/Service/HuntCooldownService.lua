--[[
    Created by Partcline for use by Vetex
    2023/10/29

    This service is in charge of keeping track of all cooldowns for every player in the server.
    A parent module/script can make use of this service to add, remove, or listen to cooldown changes.
    The parent module/script can then notify the player of these changes through the use of remotes,
    and also easily grab all of their active cooldowns for saving to datastore.

    https://github.com/ricolantern/AO-Hunting-Cooldown-System
]]

local HuntCooldownService = {}

local ServerScriptService = game:GetService("ServerScriptService")

local HuntCooldown = require(ServerScriptService.Server.Object.HuntCooldown)

HuntCooldownService.BE_COOLDOWN_ENDED = Instance.new("BindableEvent")
HuntCooldownService.timer = 900 -- 15 seconds.
--[[
    {
        [<HUNTER ID>] = {
            [<TARGET ID>] = <OBJECT#HuntCooldown>,
            ...
        },
        ...
    }
]]
HuntCooldownService.cooldowns = {}

local function onCooldownEnded(hunterId, targetId)
    if not hunterId then error("hunterId is required!") end
    if not targetId then error("targetId is required!") end

    HuntCooldownService.remove(hunterId, targetId)

    if HuntCooldownService.getHunterCooldownSize(hunterId) == 0 then
        HuntCooldownService.cooldowns[hunterId] = nil
    end

    HuntCooldownService.BE_COOLDOWN_ENDED:Fire(hunterId, targetId)
end

--[[ Adds the given HuntCooldown instance to the cooldowns and keeps track of it. ]]
function HuntCooldownService.add(huntCooldown)
    if not huntCooldown then error("huntCooldown is required!") end

    if not HuntCooldownService.cooldowns[huntCooldown.hunterId] then
        HuntCooldownService.cooldowns[huntCooldown.hunterId] = {}
    end

    if HuntCooldownService.get(huntCooldown.hunterId, huntCooldown.targetId) then
        HuntCooldownService.cooldowns[huntCooldown.hunterId][huntCooldown.targetId]:Destroy()
    end

    HuntCooldownService.cooldowns[huntCooldown.hunterId][huntCooldown.targetId] = huntCooldown
    huntCooldown.BE_COOLDOWN_ENDED.Event:Connect(onCooldownEnded) -- No need to store the connection; HuntCooldown object already clears it on destroy.
end

--[[ Utility function that iteratively instances HuntCooldown objects for each targetId => timestamp.]]
function HuntCooldownService.addAllKv(hunterId, cooldownsKv, timer)
    if not hunterId then error("hunterId is required!") end
    if not cooldownsKv then error("cooldownsKv is required!") end

    for targetId, timestamp in pairs(cooldownsKv) do
        HuntCooldownService.add(HuntCooldown.new(
            hunterId,
            targetId,
            timestamp,
            timer or HuntCooldownService.timer
        ))
    end
end

--[[ Returns the HuntCooldown instance for the given hunter id. ]]
function HuntCooldownService.get(hunterId, targetId)
    if not hunterId then error("hunterId is required!") end
    if not targetId then error("targetId is required!") end

    if not HuntCooldownService.cooldowns[hunterId] then return nil end

    return HuntCooldownService.cooldowns[hunterId][targetId]
end

--[[
    Returns all of the cooldown info for the hunter in a key => value format that's ready for serialization.
    To be used when saving cooldowns to datastore.
]]
function HuntCooldownService.getAllKv(hunterId)
    if not hunterId then error("hunterId is required!") end

    local cooldowns = {}

    if not HuntCooldownService.cooldowns[hunterId] then return cooldowns end

    for targetId, huntCooldown in pairs(HuntCooldownService.cooldowns[hunterId]) do
        cooldowns[targetId] = huntCooldown.timestamp
    end

    return cooldowns
end

--[[
    Returns the length of the cooldown table for a hunter.
]]
function HuntCooldownService.getHunterCooldownSize(hunterId)
    if not hunterId then error("hunterId is required!") end

    if not HuntCooldownService.cooldowns[hunterId] then return 0 end

    local length = 0

    for _, huntCooldown in pairs(HuntCooldownService.cooldowns[hunterId]) do
        if not huntCooldown then continue end
        
        length = length + 1
    end

    return length
end

function HuntCooldownService.remove(hunterId, targetId)
    if not hunterId then error("hunterId is required!") end
    if not targetId then error("targetId is required!") end

    local huntCooldown = HuntCooldownService.get(hunterId, targetId)

    assert(huntCooldown, "Expected huntCooldown to be true")

    if huntCooldown then
        huntCooldown:Destroy()

        HuntCooldownService.cooldowns[hunterId][targetId] = nil
    end
end

function HuntCooldownService.removeAll(hunterId)
    if not hunterId then error("hunterId is required!") end

    if not HuntCooldownService.cooldowns[hunterId] then return end

    for targetId, _ in pairs(HuntCooldownService.cooldowns[hunterId]) do
        HuntCooldownService.remove(hunterId, targetId)
    end

    HuntCooldownService.cooldowns[hunterId] = nil
end

return HuntCooldownService