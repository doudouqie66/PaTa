---@class WP_02_C:BP_UGC_Pistol_DesertEagle_C
--Edit Below--
local WP_02 = {}
 
--[[
function WP_02:ReceiveBeginPlay()
    WP_02.SuperClass.ReceiveBeginPlay(self)
end
--]]

--[[
function WP_02:ReceiveTick(DeltaTime)
    WP_02.SuperClass.ReceiveTick(self, DeltaTime)
end
--]]

--[[
function WP_02:ReceiveEndPlay()
    WP_02.SuperClass.ReceiveEndPlay(self) 
end
--]]

--[[
function WP_02:GetReplicatedProperties()
    return
end
--]]

--[[
function WP_02:GetAvailableServerRPCs()
    return
end
--]]

--[[----------------------检查手枪是否允许开火------------------------]]
function WP_02:StartFireFilter()
    if not WP_02.SuperClass.StartFireFilter(self) then
        return false
    end
    return #UGCPersistEffectSystem.GetBuffsByClass(self:GetOwner(), L_Enum.Name_BuffPath.Buff07_2) == 0
end

return WP_02
