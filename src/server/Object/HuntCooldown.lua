local HuntCooldown = {}

local RunService = game:GetService("RunService")


--[[ Creates a new instance of this object. ]]
function HuntCooldown.new(userId, timestamp, timer)
    local self = setmetatable({}, {__index = HuntCooldown}) -- Inherit the functions declared on HuntCooldown.
    
    self.userId = userId or error("userId cannot be nil!")
    self.timestamp = timestamp or tick() -- In seconds, defaulting to "now".
    self.timer = timer or error("timer cannot be nil!")

    -- Private properties, for internal reference and use only.
    self._heartbeat = nil

    -- Events.
    self.BE_COOLDOWN_ENDED = Instance.new("BindableEvent")

    -- Initializers.
    self:Start()
    
    return self
end

--[[ Called every heartbeat, evaluating whether the cooldown has ended. ]]
function HuntCooldown:_Evaluate()
    if tick() > self.timestamp + self.timer then
        self:End()
    end
end

function HuntCooldown:Start()
    if self._heartbeat then
        self._heartbeat:Disconnect()

        self._heartbeat = nil
    end

    self._heartbeat = RunService.Heartbeat:Connect(function () self:_Evaluate() end)
end

function HuntCooldown:End()
    if self._heartbeat then
        self._heartbeat:Disconnect()

        self._heartbeat = nil
    end

    self.BE_COOLDOWN_ENDED:Fire(self.userId)
end

function HuntCooldown:Destroy()
    if self._heartbeat then
        self._heartbeat:Disconnect()

        self._heartbeat = nil
    end

    self.BE_COOLDOWN_ENDED:Destroy()
end

return HuntCooldown