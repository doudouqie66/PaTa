---@class MiMa_Colli_C:AActor
---@field StaticMesh UStaticMeshComponent
---@field Box UBoxComponent
---@field DefaultSceneRoot USceneComponent
--Edit Below--
---@class MiMa_Colli_C:AActor
---@field StaticMesh UStaticMeshComponent
---@field Box UBoxComponent
---@field DefaultSceneRoot USceneComponent
-- Edit Below--
---@class MiMa_Colli_C:AActor
---@field StaticMesh UStaticMeshComponent
---@field Box UBoxComponent
---@field DefaultSceneRoot USceneComponent
-- Edit Below--
local MiMa_Colli = {}
--[[----------------------处理鼠标点击物品------------------------]]
function MiMa_Colli:ReceiveActorOnClicked(Button_Pressed)
    L_GloTools.UIMgr(L_Enum.Name_ClassPath.UI07, true)

end

--[[----------------------处理手机触摸物品------------------------]]
function MiMa_Colli:ReceiveActorOnInputTouchBegin(Finger_Index)

    L_GloTools.UIMgr(L_Enum.Name_ClassPath.UI07, true)

end
--[[
function MiMa_Colli:ReceiveBeginPlay()
    MiMa_Colli.SuperClass.ReceiveBeginPlay(self)
end
--]]

--[[
function MiMa_Colli:ReceiveTick(DeltaTime)
    MiMa_Colli.SuperClass.ReceiveTick(self, DeltaTime)
end
--]]

--[[
function MiMa_Colli:ReceiveEndPlay()
    MiMa_Colli.SuperClass.ReceiveEndPlay(self) 
end
--]]

--[[
function MiMa_Colli:GetReplicatedProperties()
    return
end
--]]

--[[
function MiMa_Colli:GetAvailableServerRPCs()
    return
end
--]]

return MiMa_Colli
