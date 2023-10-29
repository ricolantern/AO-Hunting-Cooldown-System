local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Inspect = require(ReplicatedStorage.Shared.Inspect)

local RE_SetAllHuntCooldowns = ReplicatedStorage.Remotes.RE_SetAllHuntCooldowns
local RE_SetHuntCooldown = ReplicatedStorage.Remotes.RE_SetHuntCooldown

local cooldowns = {}

--[[
    Set all cooldowns initially, all at once.
]]
RE_SetAllHuntCooldowns.OnClientEvent:Connect(function (targetIds, onCooldown)
    cooldowns = onCooldown and table.clone(targetIds) or {}
    
    print("I received a set of cooldowns!", Inspect.inspect(cooldowns))
end)

--[[
    There's multiple ways to do this,
    but essentially the player only needs to know who they have a cooldown for locally.
]]
RE_SetHuntCooldown.OnClientEvent:Connect(function (targetId, onCooldown)
    if onCooldown then
        table.insert(cooldowns, targetId)
    else
        for i, cooldownTargetId in cooldowns do
            if cooldownTargetId == targetId then
                cooldowns[i] = nil

                break
            end
        end
    end
    print("I received a cooldown update!", Inspect.inspect(cooldowns))
end)