---@class Aire04_C:BP_MagicFieldActorBase_C
---@field Box UBoxComponent
---@field StaticMesh UStaticMeshComponent
-- Edit Below--
---@class Aire03_C:BP_MagicFieldActorBase_C
---@field Box UBoxComponent
---@field StaticMesh UStaticMeshComponent
-- Edit Below--
---@class Aire03_C:BP_MagicFieldActorBase_C
---@field Box UBoxComponent
---@field StaticMesh UStaticMeshComponent
-- Edit Below--
local Aire04 = {}

--[[
function Aire04:ReceiveTick(DeltaTime)
    Aire04.SuperClass.ReceiveTick(self, DeltaTime)
end
--]]

--[[
function Aire04:ReceiveEndPlay()
    Aire04.SuperClass.ReceiveEndPlay(self) 
end
--]]

--[[
function Aire04:GetReplicatedProperties()
    return
end
--]]

--[[
function Aire04:GetAvailableServerRPCs()
    return
end
--]]

-- [Editor Generated Lua] function define Begin:
function Aire04:LuaInit()
    if self.bInitDoOnce then
        return;
    end
    self.bInitDoOnce = true;
    -- [Editor Generated Lua] BindingProperty Begin:
    -- [Editor Generated Lua] BindingProperty End;

    -- [Editor Generated Lua] BindingEvent Begin:
    -- [Editor Generated Lua] BindingEvent End;
end

-- [Editor Generated Lua] function define End;

--[[----------------------绑定盒体重叠事件------------------------]]
function Aire04:ReceiveBeginPlay()
    Aire04.SuperClass.ReceiveBeginPlay(self)
    if UGCGameSystem.IsServer() then
        self.Box.OnComponentBeginOverlap:Add(self.Box_OnComponentBeginOverlap, self)
    end
end

--[[----------------------玩家进入盒体时传送回去------------------------]]
function Aire04:Box_OnComponentBeginOverlap(OverlappedComponent, OtherActor, OtherComp, OtherBodyIndex, bFromSweep,
    SweepResult)
    self:K2_DestroyActor()

    local PC = UGCGameSystem.GetPlayerControllerByPlayerPawn(OtherActor)
    if PC == nil then
        return
    end
    UGCPlayerPawnSystem.SetIsDirectlyDie(OtherActor, true)

end

return Aire04
