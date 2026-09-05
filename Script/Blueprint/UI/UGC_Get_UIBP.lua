---@class UGC_Get_UIBP_C:UAEUserWidget
---@field DX_Parachute UWidgetAnimation
---@field DX_GXHD UWidgetAnimation
---@field ConfirmButton UNewButton
---@field ItemList ReuseList2_C
--Edit Below--
local Base_UI = require("ugc.UITemplate.Get.UGC_Get_UIBP") -- 官方获得物品界面逻辑
local UGC_Get_UIBP = {} -- 项目奖励界面逻辑
for Key, Value in pairs(Base_UI) do -- 复制官方逻辑，避免修改共享模块
    UGC_Get_UIBP[Key] = Value
end

--[[----------------------刷新商城样式的奖励物品------------------------]]
function UGC_Get_UIBP:RefreshItem(Widget, Index)
    local Item = self.Items[Index + 1] -- 当前奖励的物品编号和数量
    local Item_Data = ShopV2Manager:GetItemConfigData(Item.ItemID) -- 虚拟物品显示配置
    Widget.ItemNameText:SetText(Item_Data.ItemName)
    Widget.NumText:SetText(tostring(Item.Num))
    Widget.ItemIcon:SetBrushImageReference(KismetSystemLibrary.MakeSoftObjectPath(Item_Data.ItemIcon))
    Widget.QualityBackground:SetBrushImageReference(
        KismetSystemLibrary.MakeSoftObjectPath(ShopV2Manager:GetQualityTexturePath(Item.ItemID, false)))
    Widget.QualityBar:SetBrushImageReference(
        KismetSystemLibrary.MakeSoftObjectPath(ShopV2Manager:GetQualityBarTexturePath(Item.ItemID)))
end

return UGC_Get_UIBP
