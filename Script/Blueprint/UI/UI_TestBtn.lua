---@class UI_TestBtn_C:UUserWidget
---@field Button_0 UButton
---@field Image_67 UImage
--Edit Below--
local UI_TestBtn = {
    bInitDoOnce = false
}

function UI_TestBtn:Construct()
    self:LuaInit();

end
function UI_TestBtn:LuaInit()
    if self.bInitDoOnce then
        return;
    end
    self.bInitDoOnce = true;
    self.Button_0.OnClicked:Add(self.Button_0_OnClicked, self);
end
function UI_TestBtn:Button_0_OnClicked()
    self:OpenLotteryTicketPurchasePopup(UGCGameSystem.GetLocalPlayerController(), 9000003)
end

function UI_TestBtn:OpenLotteryTicketPurchasePopup(PlayerController, ProductID)
    local PurchaseUIClass = UE.LoadClass(UGCGameSystem.GetUGCResourcesFullPath(
        "ExtendResource/ShopV2/OfficialPackage/Asset/ShopV2/Arts_UI/UIBP/ShopV2_PurchasePopups_UIBP.ShopV2_PurchasePopups_UIBP_C"))

    local PurchaseUI = UserWidget.NewWidgetObjectBP(PlayerController, PurchaseUIClass)

    -- ShopV2Manager.bBlockRepeatPurchase = true
    PurchaseUI:AddToViewport(15000)
    local Success, Err = pcall(PurchaseUI.Refresh, PurchaseUI, ProductID)
    if not Success then
        -- ShopV2Manager.bBlockRepeatPurchase = false
        PurchaseUI:SetVisibility(ESlateVisibility.Collapsed)
        return false
    end

    return true
end

return UI_TestBtn
