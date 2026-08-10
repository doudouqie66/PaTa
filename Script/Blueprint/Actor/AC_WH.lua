---@class AC_WH_C:AActor
---@field Widget1 UWidgetComponent
---@field Widget UWidgetComponent
---@field StaticMesh UStaticMeshComponent
---@field DefaultSceneRoot USceneComponent
--Edit Below--
local AC_WH = {}
 
--[[
function AC_WH:ReceiveBeginPlay()
    AC_WH.SuperClass.ReceiveBeginPlay(self)
end
--]]

--[[
function AC_WH:ReceiveTick(DeltaTime)
    AC_WH.SuperClass.ReceiveTick(self, DeltaTime)
end
--]]

--[[
function AC_WH:ReceiveEndPlay()
    AC_WH.SuperClass.ReceiveEndPlay(self) 
end
--]]

--[[
function AC_WH:GetReplicatedProperties()
    return
end
--]]

--[[
function AC_WH:GetAvailableServerRPCs()
    return
end
--]]

return AC_WH