local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local HuntCooldownService = require(script.Service.HuntCooldownService)
local HuntCooldown = require(script.Object.HuntCooldown)
local Inspect = require(ReplicatedStorage.Shared.Inspect)

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
    local cooldownsRemaining = HuntCooldownService.getHunterCooldownSize(hunterId)

    print(string.format("Hunt cooldown ended for hunter id %d and target id %d", hunterId, targetId))
    print(string.format("...%d cooldowns remain for hunter id %d...", cooldownsRemaining, hunterId))
    
    -- Start it over!
    -- if (cooldownsRemaining == 0) then
    --     HuntCooldownService.addAllKv(hunterId, {
    --         [666453434] = tick() - 10,  -- 10 seconds have passed.
    --         [3453432] = tick() - 29,    -- 29 seconds have passed.
    --         [232545646] = tick() - 500, -- 5 minutes have passed.
    --         [3464646] = tick() - 20,    -- 20 seconds have passed.
    --         [1212345] = tick()          -- No time has passed, new cooldown.
    --     }, 30)
    --     -- This is how you can add cooldowns individually.
    --     HuntCooldownService.add(HuntCooldown.new(
    --         2342342,
    --         666666,
    --         nil,
    --         HuntCooldownService.timer
    --     ))
    --     print(Inspect.inspect(HuntCooldownService.getAllKv(hunterId)))
    -- end
end)
