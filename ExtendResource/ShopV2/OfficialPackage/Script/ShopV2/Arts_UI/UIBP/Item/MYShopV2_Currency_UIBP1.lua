---@class MYShopV2_Currency_UIBP1_C:UUserWidget
---@field AmountText UTextBlock
---@field CurrencyIcon UImage
---@field ItemID int32
---@field CurrencyIconTexture UTexture2D
--Edit Below--
local MYShopV2_Currency_UIBP1 = 
{ 
    bInitDoOnce = false;
    bBindBackpackDelegate = false;
} 

function MYShopV2_Currency_UIBP1:Construct()
	
    self.CurrencyIcon:SetBrushFromTexture(self.CurrencyIconTexture);
    self.AmountText:SetText("0");

    --ItemID为0视为无效，不显示货币
    if self.ItemID == 0 then
        self:SetVisibility(ESlateVisibility.Collapsed)
        return
    end

    ShopV2Manager.OnItemNumChangeDelegate:Add(self.Refresh, self);
end

function MYShopV2_Currency_UIBP1:Destruct()

    ShopV2Manager.OnItemNumChangeDelegate:Remove(self.Refresh, self);
end

function MYShopV2_Currency_UIBP1:Refresh()

    local PlayerController = STExtraGameplayStatics.GetFirstPlayerController(self);
    local CoinNum = ShopV2Manager:GetVirtualItemManager():GetItemNum(self.ItemID);
    self.AmountText:SetText(tostring(CoinNum));
end

return MYShopV2_Currency_UIBP1