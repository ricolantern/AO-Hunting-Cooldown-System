--[[
    Created by Partcline for use by Vetex
    2023/10/29

    THIS IS AN EXAMPLE FILE.

    This file gives you an idea of what the player should be aware of when it comes to their applied cooldowns.
    The idea is that the server is always in control of the truth regarding a cooldown,
    and that the player does nothing but listen to the server for updates on their cooldowns.

    Not included in this example is successfully hunting someone and applying a new cooldown,
    thought to be a very easy concept to grasp, so it has been left out.
    (It's literally just firing a remote with a target user id in the desired circumstances).

    https://github.com/ricolantern/AO-Hunting-Cooldown-System
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Inspect = require(ReplicatedStorage.Shared.Inspect)

local RE_SetAllHuntCooldowns = ReplicatedStorage.Remotes.RE_SetAllHuntCooldowns
local RE_SetHuntCooldown = ReplicatedStorage.Remotes.RE_SetHuntCooldown

local cooldowns = {}

--[[
    Set all cooldowns initially, all at once.
    To be used the first time a player loads in.
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