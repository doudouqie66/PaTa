---@class Cup_Colli_C:AActor
---@field Box UBoxComponent
---@field DefaultSceneRoot USceneComponent
-- Edit Below--
---@class Cup_Colli_C:AActor
---@field Box UBoxComponent
---@field DefaultSceneRoot USceneComponent
-- Edit Below--
---@class Cup_Colli_C:AActor
---@field Box UBoxComponent
---@field DefaultSceneRoot USceneComponent
-- Edit Below--
local Cup_Colli = {}

function Cup_Colli:ReceiveBeginPlay()
    Cup_Colli.SuperClass.ReceiveBeginPlay(self)
    self.Box.OnComponentBeginOverlap:Add(self.Box_OnComponentBeginOverlap, self);

end

--[[
function Cup_Colli:ReceiveTick(DeltaTime)
    Cup_Colli.SuperClass.ReceiveTick(self, DeltaTime)
end
--]]

--[[
function Cup_Colli:ReceiveEndPlay()
    Cup_Colli.SuperClass.ReceiveEndPlay(self) 
end
--]]

--[[
function Cup_Colli:GetReplicatedProperties()
    return
end
--]]

--[[
function Cup_Colli:GetAvailableServerRPCs()
    return
end
--]]

-- [Editor Generated Lua] function define Begin:
function Cup_Colli:LuaInit()
    if self.bInitDoOnce then
        return;
    end
    self.bInitDoOnce = true;
    -- [Editor Generated Lua] BindingProperty Begin:
    -- [Editor Generated Lua] BindingProperty End;

    -- [Editor Generated Lua] BindingEvent Begin:
    -- [Editor Generated Lua] BindingEvent End;
end
--[[-----------------------触碰奖杯-----------------------]] --

function Cup_Colli:Box_OnComponentBeginOverlap(OverlappedComponent, OtherActor, OtherComp, OtherBodyIndex, bFromSweep,
    SweepResult)
    local PC = UGCGameSystem.GetPlayerControllerByPlayerPawn(OtherActor) -- 触碰玩家控制器

    -- 通知房间玩家谁登顶

    -- 发放奖励
    PC:Add_WinCup(1)
    -- 传送回家

    PC:TeleToPoint(2)
end

-- [Editor Generated Lua] function define End;

return Cup_Colli
