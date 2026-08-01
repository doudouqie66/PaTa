---@class Colli_StartTime_C:AActor
---@field Box UBoxComponent
---@field DefaultSceneRoot USceneComponent
--Edit Below--
local Colli_StartTime = {}

--[[----------------------初始化排行榜计时碰撞------------------------]]
function Colli_StartTime:ReceiveBeginPlay()
    Colli_StartTime.SuperClass.ReceiveBeginPlay(self)
    if not self:HasAuthority() then
        return
    end

    self.Box.OnComponentBeginOverlap:Add(self.Box_OnComponentBeginOverlap, self)
end

--[[
function Colli_StartTime:ReceiveTick(DeltaTime)
    Colli_StartTime.SuperClass.ReceiveTick(self, DeltaTime)
end
--]]

--[[----------------------解绑排行榜计时碰撞------------------------]]
function Colli_StartTime:ReceiveEndPlay()
    if self:HasAuthority() then
        self.Box.OnComponentBeginOverlap:Remove(self.Box_OnComponentBeginOverlap, self)
    end

    Colli_StartTime.SuperClass.ReceiveEndPlay(self)
end

--[[
function Colli_StartTime:GetReplicatedProperties()
    return
end
--]]

--[[
function Colli_StartTime:GetAvailableServerRPCs()
    return
end
--]]

-- [Editor Generated Lua] function define Begin:
--[[----------------------初始化编辑器生成逻辑------------------------]]
function Colli_StartTime:LuaInit()
    if self.bInitDoOnce then
        return;
    end
    self.bInitDoOnce = true;
    -- [Editor Generated Lua] BindingProperty Begin:
    -- [Editor Generated Lua] BindingProperty End;

    -- [Editor Generated Lua] BindingEvent Begin:
    -- [Editor Generated Lua] BindingEvent End;
end

--[[----------------------玩家触碰起点后开始排行榜计时------------------------]]
function Colli_StartTime:Box_OnComponentBeginOverlap(OverlappedComponent, OtherActor, OtherComp, OtherBodyIndex,
    bFromSweep, SweepResult)
    local Player_Controller = UGCGameSystem.GetPlayerControllerByPlayerPawn(OtherActor) -- 触碰起点的玩家控制器
    if not Player_Controller then
        return
    end

    Player_Controller:StartTowerClimbTimer()
end

-- [Editor Generated Lua] function define End;

return Colli_StartTime
