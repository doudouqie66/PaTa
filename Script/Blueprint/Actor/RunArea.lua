---@class RunArea_C:AActor
---@field Box UBoxComponent
---@field DefaultSceneRoot USceneComponent
--Edit Below--
---@class RunArea_C:AActor
---@field Box UBoxComponent
---@field DefaultSceneRoot USceneComponent
-- Edit Below--
local RunArea = {}

--[[----------------------初始化并绑定区域碰撞事件------------------------]]
function RunArea:ReceiveBeginPlay()
    RunArea.SuperClass.ReceiveBeginPlay(self)
    if UGCGameSystem.IsServer() then
        self.Box.OnComponentBeginOverlap:Add(self.Box_OnComponentBeginOverlap, self)
        self.Box.OnComponentEndOverlap:Add(self.Box_OnComponentEndOverlap, self)
    end
end

--[[
function RunArea:ReceiveTick(DeltaTime)
    RunArea.SuperClass.ReceiveTick(self, DeltaTime)
end
--]]

--[[
function RunArea:ReceiveEndPlay()
    RunArea.SuperClass.ReceiveEndPlay(self) 
end
--]]

--[[
function RunArea:GetReplicatedProperties()
    return
end
--]]

--[[
function RunArea:GetAvailableServerRPCs()
    return
end
--]]

-- [Editor Generated Lua] function define Begin:
function RunArea:LuaInit()
    if self.bInitDoOnce then
        return;
    end
    self.bInitDoOnce = true;
    -- [Editor Generated Lua] BindingProperty Begin:
    -- [Editor Generated Lua] BindingProperty End;

    -- [Editor Generated Lua] BindingEvent Begin:

    -- [Editor Generated Lua] BindingEvent End;
end

--[[----------------------玩家进入区域时添加金币Buff------------------------]]
function RunArea:Box_OnComponentBeginOverlap(OverlappedComponent, OtherActor, OtherComp, OtherBodyIndex, bFromSweep,
    SweepResult)
    local Player_Controller = UGCGameSystem.GetPlayerControllerByPlayerPawn(OtherActor) -- 触碰玩家控制器
    if Player_Controller == nil then
        return
    end

    L_TipsTool.ShowTips_01("进入区域")
    EventScheduler:_AddBuffToOnePlayers(OtherActor, L_Enum.Name_BuffPath.Buff10)
end

--[[----------------------玩家离开区域时移除金币Buff------------------------]]
function RunArea:Box_OnComponentEndOverlap(OverlappedComponent, OtherActor, OtherComp, OtherBodyIndex)
    L_TipsTool.ShowTips_01("离开区域")
    EventScheduler:_RemoveBuffFromOnePlayers(OtherActor, L_Enum.Name_BuffPath.Buff10)
end

-- [Editor Generated Lua] function define End;

return RunArea
