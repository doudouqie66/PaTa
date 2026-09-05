---@class WP_02_C:BP_UGC_Pistol_DesertEagle_C
--Edit Below--
local WP_02 = {}

local Pistol_Ammo_Item_ID = 8310046 -- 手枪子弹物品ID
 
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
    if #UGCPersistEffectSystem.GetBuffsByClass(self:GetOwner(), L_Enum.Name_BuffPath.Buff07_2) > 0 then
        return false
    end
    if not WP_02.SuperClass.StartFireFilter(self) then
        if UGCGameSystem.IsServer() then
            return false
        end
        local Player_Pawn = self:GetOwner()
        local Player_Controller = UGCGameSystem.GetPlayerControllerByPlayerPawn(Player_Pawn)
        if UGCBackpackSystemV2.GetItemCountV2(Player_Controller, Pistol_Ammo_Item_ID) < 1 then
            L_TipsTool.ShowTips_01("手枪子弹每60秒自动发放", Player_Controller)
        end
        return false
    end
    return true
end

return WP_02
