---@class Actor_Touch_C:AActor
---@field StaticMesh UStaticMeshComponent
---@field Box UBoxComponent
---@field DefaultSceneRoot USceneComponent
---@field TargetPoint int32
--Edit Below--
---@class Actor_Touch_C:AActor
---@field StaticMesh UStaticMeshComponent
---@field Box UBoxComponent
---@field DefaultSceneRoot USceneComponent
---@field TargetPoint int32
-- Edit Below--
local Actor_Touch = {}
--[[----------------------处理鼠标点击物品------------------------]]
function Actor_Touch:ReceiveActorOnClicked(Button_Pressed)
    SoundMgr.PlaySound2D(SoundMgr.SoundName.UI_Switch)
    local Player_Controller = UGCGameSystem.GetLocalPlayerController() -- 本地玩家控制器
    UnrealNetwork.CallUnrealRPC(Player_Controller, Player_Controller, L_Enum.Name_RPC.Tele_To_Point, self.TargetPoint)
end

--[[----------------------处理手机触摸物品------------------------]]
function Actor_Touch:ReceiveActorOnInputTouchBegin(Finger_Index)
    SoundMgr.PlaySound2D(SoundMgr.SoundName.UI_Switch)
    local Player_Controller = UGCGameSystem.GetLocalPlayerController() -- 本地玩家控制器
    UnrealNetwork.CallUnrealRPC(Player_Controller, Player_Controller, L_Enum.Name_RPC.Tele_To_Point, self.TargetPoint)
end
--[[
function Actor_Touch:ReceiveBeginPlay()
    Actor_Touch.SuperClass.ReceiveBeginPlay(self)
end
--]]

--[[
function Actor_Touch:ReceiveTick(DeltaTime)
    Actor_Touch.SuperClass.ReceiveTick(self, DeltaTime)
end
--]]

--[[
function Actor_Touch:ReceiveEndPlay()
    Actor_Touch.SuperClass.ReceiveEndPlay(self) 
end
--]]

--[[
function Actor_Touch:GetReplicatedProperties()
    return
end
--]]

--[[
function Actor_Touch:GetAvailableServerRPCs()
    return
end
--]]

return Actor_Touch
