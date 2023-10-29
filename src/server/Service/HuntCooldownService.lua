local HuntCooldownService = {}

local ServerScriptService = game:GetService("ServerScriptService")

local HuntCooldown = require(ServerScriptService.Server.Object.HuntCooldown)

HuntCooldownService.BE_COOLDOWN_ENDED = Instance.new("BindableEvent")
HuntCooldownService.timer = 900 -- 15 seconds.
HuntCooldownService.length = 0 -- Keep track of amount of cooldowns we have, since lua can't handle this.
HuntCooldownService.cooldowns = {}

local function onCooldownEnded(userId)
    local huntCooldown = HuntCooldownService.get(userId)

    if huntCooldown then huntCooldown:Destroy() end
    
    HuntCooldownService.cooldowns[userId] = nil
    HuntCooldownService.length = HuntCooldownService.length - 1

    HuntCooldownService.BE_COOLDOWN_ENDED:Fire(userId)
end

--[[ Adds the given HuntCooldown instance to the cooldowns and keeps track of it. ]]
function HuntCooldownService.add(huntCooldown)
    if HuntCooldownService.cooldowns[huntCooldown.userId] then
        HuntCooldownService.cooldowns[huntCooldown.userId]:Destroy()
    end

    HuntCooldownService.cooldowns[huntCooldown.userId] = huntCooldown
    HuntCooldownService.length = HuntCooldownService.length + 1

    huntCooldown.BE_COOLDOWN_ENDED.Event:Connect(onCooldownEnded) -- No need to store the connection; HuntCooldown object already clears it on destroy.
end

--[[ Utility function that iteratively instances HuntCooldown objects for each userId => timestamp.]]
function HuntCooldownService.addAllKv(cooldownsKv, timer)
    for userId, timestamp in pairs(cooldownsKv) do
        HuntCooldownService.add(HuntCooldown.new(
            userId,
            timestamp,
            timer
        ))
    end
end

--[[ Returns the HuntCooldown instance for the given user id. ]]
function HuntCooldownService.get(userId)
    return HuntCooldownService.cooldowns[userId]
end

--[[
    Returns all of the cooldown info in a key => value format that's ready for serialization.
    To be used when saving cooldowns to datastore.
]]
function HuntCooldownService.getAllKv()
    local cooldowns = {}

    for userId, huntCooldown in pairs(HuntCooldownService.cooldowns) do
        cooldowns[userId] = huntCooldown.timestamp
    end

    return cooldowns
end

return HuntCooldownService