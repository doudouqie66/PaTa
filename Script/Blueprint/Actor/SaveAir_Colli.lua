---@class SaveAir_Colli_C:AActor
---@field Box UBoxComponent
---@field DefaultSceneRoot USceneComponent
--Edit Below--
---@class SaveAir_Colli_C:AActor
---@field Capsule UCapsuleComponent
---@field DefaultSceneRoot USceneComponent
--Edit Below--
local SaveAir_Colli = {}

--[[----------------------初始化并绑定怪物安全区碰撞事件------------------------]]
function SaveAir_Colli:ReceiveBeginPlay()
    SaveAir_Colli.SuperClass.ReceiveBeginPlay(self)
    if not self:HasAuthority() then
        return
    end
    self.Box.OnComponentBeginOverlap:Add(self.Box_OnComponentBeginOverlap, self);
    self.Box.OnComponentEndOverlap:Add(self.Box_OnComponentEndOverlap, self);
end

--[[
function SaveAir_Colli:ReceiveTick(DeltaTime)
    SaveAir_Colli.SuperClass.ReceiveTick(self, DeltaTime)
end
--]]

--[[
function SaveAir_Colli:ReceiveEndPlay()
    SaveAir_Colli.SuperClass.ReceiveEndPlay(self) 
end
--]]

--[[
function SaveAir_Colli:GetReplicatedProperties()
    return
end
--]]

--[[
function SaveAir_Colli:GetAvailableServerRPCs()
    return
end
--]]

-- [Editor Generated Lua] function define Begin:
--[[----------------------初始化Lua绑定------------------------]]
function SaveAir_Colli:LuaInit()
    if self.bInitDoOnce then
        return;
    end
    self.bInitDoOnce = true;
    -- [Editor Generated Lua] BindingProperty Begin:
    -- [Editor Generated Lua] BindingProperty End;

    -- [Editor Generated Lua] BindingEvent Begin:

    -- [Editor Generated Lua] BindingEvent End;
end

--[[----------------------玩家进入区域时开启怪物碰撞保护------------------------]]

function SaveAir_Colli:Box_OnComponentBeginOverlap(OverlappedComponent, OtherActor, OtherComp, OtherBodyIndex,
    bFromSweep, SweepResult)
    local Player_Controller = UGCGameSystem.GetPlayerControllerByPlayerPawn(OtherActor) -- 进入区域的玩家控制器
    if Player_Controller == nil then
        return
    end
    OtherActor.Is_In_Monster_Safe_Area = true -- 标记玩家处于怪物安全区

    local Safe_Area_Buff_Class = UGCObjectUtility.LoadClass(L_Enum.Name_BuffPath.Buff07_2) -- 安全区Buff类
    UGCPersistEffectSystem.AddBuffByClass(OtherActor, Safe_Area_Buff_Class)
end
--[[----------------------玩家离开区域时关闭怪物碰撞保护------------------------]]

function SaveAir_Colli:Box_OnComponentEndOverlap(OverlappedComponent, OtherActor, OtherComp, OtherBodyIndex)
    local Player_Controller = UGCGameSystem.GetPlayerControllerByPlayerPawn(OtherActor) -- 离开区域的玩家控制器
    if Player_Controller == nil then
        return
    end
    local Safe_Area_Buff_Class = UGCObjectUtility.LoadClass(L_Enum.Name_BuffPath.Buff07_2) -- 安全区Buff类

    OtherActor.Is_In_Monster_Safe_Area = false -- 标记玩家离开怪物安全区
    UGCPersistEffectSystem.RemoveBuffByClass(OtherActor, Safe_Area_Buff_Class)

end

-- [Editor Generated Lua] function define End;

return SaveAir_Colli
