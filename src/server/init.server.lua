local ReplicatedStorage = game:GetService("ReplicatedStorage")

local HuntCooldownService = require(script.Service.HuntCooldownService)
local HuntCooldown = require(script.Object.HuntCooldown)
local Inspect = require(ReplicatedStorage.Shared.Inspect)

-- [userId] = timestamp.
local cooldowns = {
    [666453434] = tick() - 10,  -- 10 seconds have passed.
    [3453432] = tick() - 29,    -- 29 seconds have passed.
    [232545646] = tick() - 500, -- 5 minutes have passed.
    [3464646] = tick() - 20,    -- 20 seconds have passed.
    [1212345] = tick()          -- No time has passed, new cooldown.
}

-- TODO: Cooldown for each player.

HuntCooldownService.BE_COOLDOWN_ENDED.Event:Connect(function (userId)
    print(string.format("Hunt cooldown ended for user id %d", userId))
    print(string.format("...%d cooldowns remain...", HuntCooldownService.length))
    
    -- Start it over!
    if (HuntCooldownService.length == 0) then
        HuntCooldownService.addAllKv({
            [666453434] = tick() - 10,  -- 10 seconds have passed.
            [3453432] = tick() - 29,    -- 29 seconds have passed.
            [232545646] = tick() - 500, -- 5 minutes have passed.
            [3464646] = tick() - 20,    -- 20 seconds have passed.
            [1212345] = tick()          -- No time has passed, new cooldown.
        }, 30)
        -- This is how you can add cooldowns individually.
        HuntCooldownService.add(HuntCooldown.new(
            666666,
            tick(),
            HuntCooldownService.timer
        ))
        print(Inspect.inspect(HuntCooldownService.getAllKv()))
    end
end)

task.wait(5)
HuntCooldownService.addAllKv(cooldowns, 30)