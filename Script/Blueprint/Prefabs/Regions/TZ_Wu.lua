---@class TZ_Wu_C:BP_MagicFieldActorBase_C
---@field Box UBoxComponent
---@field ParticleSystem UParticleSystemComponent
--Edit Below--
local TZ_Wu = {}
 
--[[----------------------初始化雾区并绑定进入事件------------------------]]
function TZ_Wu:ReceiveBeginPlay()
    TZ_Wu.SuperClass.ReceiveBeginPlay(self)
    if UGCGameSystem.IsServer() then
        self.Box.OnComponentBeginOverlap:Add(self.Box_OnComponentBeginOverlap, self)
    end
end

--[[----------------------怪物进入雾区时清除仇恨------------------------]]
function TZ_Wu:Box_OnComponentBeginOverlap(OverlappedComponent, OtherActor, OtherComp, OtherBodyIndex, bFromSweep,
    SweepResult)
    if not self:HasAuthority() or not UGCGenericCharacterSystem.IsGenericCharacter(OtherActor) then
        return
    end

    OtherActor:RemoveForceHatredTarget()
    if OtherActor.Force_Hatred_Timer then
        UGCTimerUtility.RemoveLuaTimer(OtherActor.Force_Hatred_Timer)
        OtherActor.Force_Hatred_Timer = nil -- 清空旧的追击计时器
    end
    OtherActor.Last_Hit_Target = nil
    UGCGenericCharacterSystem.StopMove(OtherActor)
end

--[[
function TZ_Wu:ReceiveTick(DeltaTime)
    TZ_Wu.SuperClass.ReceiveTick(self, DeltaTime)
end
--]]

--[[
function TZ_Wu:ReceiveEndPlay()
    TZ_Wu.SuperClass.ReceiveEndPlay(self) 
end
--]]

--[[
function TZ_Wu:GetReplicatedProperties()
    return
end
--]]

--[[
function TZ_Wu:GetAvailableServerRPCs()
    return
end
--]]

return TZ_Wu
