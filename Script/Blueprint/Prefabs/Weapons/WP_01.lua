---@class WP_01_C:BP_UGC_Other_RPG7_C
--Edit Below--
local WP_01 = {}

local RPG_Ammo_Item_ID = 8310044 -- 火箭弹物品ID
local RPG_Ammo_Product_ID = 9000034 -- 火箭弹商品ID
 
--[[
function WP_01:ReceiveBeginPlay()
    WP_01.SuperClass.ReceiveBeginPlay(self)
end
--]]

--[[
function WP_01:ReceiveTick(DeltaTime)
    WP_01.SuperClass.ReceiveTick(self, DeltaTime)
end
--]]

--[[
function WP_01:ReceiveEndPlay()
    WP_01.SuperClass.ReceiveEndPlay(self) 
end
--]]

--[[
function WP_01:GetReplicatedProperties()
    return
end
--]]

--[[
function WP_01:GetAvailableServerRPCs()
    return
end
--]]

--[[----------------------检查RPG是否允许开火------------------------]]
function WP_01:StartFireFilter()
    if not UGCGameSystem.IsServer() then
        local Player_Pawn = self:GetOwner()
        local Player_Controller = UGCGameSystem.GetPlayerControllerByPlayerPawn(Player_Pawn)
        if UGCBackpackSystemV2.GetItemCountV2(Player_Controller, RPG_Ammo_Item_ID) < 1 then
            L_GloTools.BuyShopProduct(RPG_Ammo_Product_ID)
            return false
        end
    end
    if not WP_01.SuperClass.StartFireFilter(self) then
        return false
    end
    return #UGCPersistEffectSystem.GetBuffsByClass(self:GetOwner(), L_Enum.Name_BuffPath.Buff07_2) == 0
end

return WP_01
