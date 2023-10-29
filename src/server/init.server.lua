--[[
    Created by Partcline
    29/10/2023

    THIS IS AN EXAMPLE FILE.

    This file shows you how the system can be used to track, remove, and retrieve cooldown data on a per-player basis.
    The idea is that the server is always in control of the truth regarding a cooldown,
    and that the player does nothing but listen to the server for updates on their cooldowns.
]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local HuntCooldownService = require(script.Service.HuntCooldownService)
local HuntCooldown = require(script.Object.HuntCooldown)
local Inspect = require(ReplicatedStorage.Shared.Inspect)

local RE_SetAllHuntCooldowns = ReplicatedStorage.Remotes.RE_SetAllHuntCooldowns
local RE_SetHuntCooldown = ReplicatedStorage.Remotes.RE_SetHuntCooldown

local cooldowns = {
    [666453434] = tick() - 10,  -- 10 seconds have passed.
    [3453432] = tick() - 29,    -- 29 seconds have passed.
    [232545646] = tick() - 500, -- 5 minutes have passed.
    [3464646] = tick() - 20,    -- 20 seconds have passed.
    [1212345] = tick()          -- No time has passed, new cooldown.
}

Players.PlayerAdded:Connect(function (player)
    --[[
        After retrieving the player's save, deserialize the huntCooldowns field in their data,
        then pass it on to the service as such.
    ]]
    HuntCooldownService.addAllKv(player.UserId, cooldowns, 30)

    -- Inform the player of their active cooldowns.
    local activeCooldowns = {}

    for targetId, _ in pairs(cooldowns) do
        table.insert(activeCooldowns, targetId)
    end

    RE_SetAllHuntCooldowns:FireClient(player, activeCooldowns, true)

    print("Player joined!", Inspect.inspect(HuntCooldownService.cooldowns))
end)

Players.PlayerRemoving:Connect(function (player)
    local cooldowns = HuntCooldownService.getAllKv(player.UserId)

    -- ...Serialize cooldowns...
    -- ...Add to player save for datastore send...

    HuntCooldownService.removeAll(player.UserId) -- Stop tracking cooldown data for this player.
    print("Player left!", Inspect.inspect(HuntCooldownService.cooldowns))
end)

HuntCooldownService.BE_COOLDOWN_ENDED.Event:Connect(function (hunterId, targetId)
    --[[
        This event will allow you to do *more* with the timeout of a cooldown.
        It is possible to fire a remote to the player that corresponds to hunterId
        to update them of their cooldown status.
        The player needs to know nothing but a table of targetIds,
        since the server handles everything for them.
    ]]
    RE_SetHuntCooldown:FireClient(Players:GetPlayerByUserId(hunterId), targetId, false)

    local cooldownsRemaining = HuntCooldownService.getHunterCooldownSize(hunterId)

    print(string.format("Hunt cooldown ended for hunter id %d and target id %d", hunterId, targetId))
    print(string.format("...%d cooldowns remain for hunter id %d...", cooldownsRemaining, hunterId))
end)
