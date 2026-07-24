L_GloTools = L_GloTools or {}
L_GloTools.UI_Map = L_GloTools.UI_Map or {} -- 缓存已创建的UI
L_GloTools.UI_Visibility_Map = L_GloTools.UI_Visibility_Map or {} -- 缓存UI原始显示状态

--[[----------------------管理UI显示隐藏------------------------]]
function L_GloTools.UIMgr(str, bVisible)
    local UI_BP = L_GloTools.UI_Map[str]

    if UI_BP == nil then
        if bVisible == false then
            return
        end

        local UI_Class = UE.LoadClass(str);
        local PlayerController = UGCGameSystem.GetLocalPlayerController()
        UI_BP = UserWidget.NewWidgetObjectBP(PlayerController, UI_Class);
        if str == L_Enum.Name_ClassPath.UI01 then
            UI_BP:AddToViewport(9999999);
        else
            UI_BP:AddToViewport(1);
        end
        L_GloTools.UI_Map[str] = UI_BP
        L_GloTools.UI_Visibility_Map[str] = UI_BP:GetVisibility()
        return
    end

    if bVisible == true then
        UI_BP:SetVisibility(L_GloTools.UI_Visibility_Map[str])
        return
    end

    if bVisible == false then
        UI_BP:SetVisibility(ESlateVisibility.Collapsed)
        return
    end

    if UI_BP:IsVisible() then
        UI_BP:SetVisibility(ESlateVisibility.Collapsed)
    else
        UI_BP:SetVisibility(L_GloTools.UI_Visibility_Map[str])
    end
end

--[[----------------------购买商城商品------------------------]]
function L_GloTools.BuyShopProduct(Product_ID, Buy_Count)
    Buy_Count = Buy_Count or 1 -- 购买数量
    local Product_Data = ShopV2Manager:GetProductConfigData(Product_ID) -- 商品信息
    local Object_Data = ShopV2Manager:GetItemConfigData(Product_Data.ItemID) -- 物品信息

    UGCCommoditySystem.BuyUGCCommodity2(Product_ID, Object_Data.ItemIcon, Object_Data.ItemDesc, Buy_Count)
end

return L_GloTools
