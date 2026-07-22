---@class Aire03_C:BP_MagicFieldActorBase_C
---@field Box UBoxComponent
---@field StaticMesh UStaticMeshComponent
-- Edit Below--
---@class Aire03_C:BP_MagicFieldActorBase_C
---@field Box UBoxComponent
---@field StaticMesh UStaticMeshComponent
-- Edit Below--
local Aire03 = {}

--[[
function Aire03:ReceiveTick(DeltaTime)
    Aire03.SuperClass.ReceiveTick(self, DeltaTime)
end
--]]

--[[
function Aire03:ReceiveEndPlay()
    Aire03.SuperClass.ReceiveEndPlay(self) 
end
--]]

--[[
function Aire03:GetReplicatedProperties()
    return
end
--]]

--[[
function Aire03:GetAvailableServerRPCs()
    return
end
--]]

-- [Editor Generated Lua] function define Begin:
function Aire03:LuaInit()
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
function Aire03:ReceiveBeginPlay()
    Aire03.SuperClass.ReceiveBeginPlay(self)
    if UGCGameSystem.IsServer() then
        self.Box.OnComponentBeginOverlap:Add(self.Box_OnComponentBeginOverlap, self)
    end
end

--[[----------------------玩家进入盒体时添加减益------------------------]]
function Aire03:Box_OnComponentBeginOverlap(OverlappedComponent, OtherActor, OtherComp, OtherBodyIndex, bFromSweep,
    SweepResult)
    local Buff_Class = UGCObjectUtility.LoadClass(L_Enum.Name_BuffPath.Debuff01) -- Buff类
    local Buff_Instance = UGCPersistEffectSystem.AddBuffByClass(OtherActor, Buff_Class) -- 添加的Buff实例
    self:K2_DestroyActor()
end

return Aire03
