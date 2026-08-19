---@class Aire01_C:BP_MagicFieldActorBase_C
---@field ParticleSystem UParticleSystemComponent
---@field Box UBoxComponent
---@field StaticMesh UStaticMeshComponent
--Edit Below--
---@class Aire01_C:BP_MagicFieldActorBase_C
---@field Box UBoxComponent
---@field StaticMesh UStaticMeshComponent
-- Edit Below--
local Aire01 = {}

--[[----------------------绑定香蕉皮盒体重叠事件------------------------]]
function Aire01:ReceiveBeginPlay()
    Aire01.SuperClass.ReceiveBeginPlay(self)
    if UGCGameSystem.IsServer() then
        self.Box.OnComponentBeginOverlap:Add(self.Box_OnComponentBeginOverlap, self)
    end
end

--[[----------------------玩家踩中香蕉皮时播放音效------------------------]]
function Aire01:Box_OnComponentBeginOverlap(OverlappedComponent, OtherActor, OtherComp, OtherBodyIndex, bFromSweep,
    SweepResult)
    local Player_Controller = UGCGameSystem.GetPlayerControllerByPlayerPawn(OtherActor) -- 踩中香蕉皮的玩家控制器
    if Player_Controller then
        UnrealNetwork.CallUnrealRPC(Player_Controller, Player_Controller, L_Enum.Name_RPC.Play_Sound,
            SoundMgr.SoundName.Banana)
    end
end

--[[
function Aire01:ReceiveTick(DeltaTime)
    Aire01.SuperClass.ReceiveTick(self, DeltaTime)
end
--]]

--[[
function Aire01:ReceiveEndPlay()
    Aire01.SuperClass.ReceiveEndPlay(self) 
end
--]]

--[[
function Aire01:GetReplicatedProperties()
    return
end
--]]

--[[
function Aire01:GetAvailableServerRPCs()
    return
end
--]]

return Aire01
