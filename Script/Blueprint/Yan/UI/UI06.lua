---@class UI06_C:UUserWidget
---@field Button_88 UButton
---@field Button_159 UButton
---@field Image_16 UImage
---@field Image_18 UImage
---@field Image_97 UImage
---@field Image_209 UImage
---@field Image_210 UImage
---@field Image_211 UImage
---@field Image_212 UImage
---@field Image_213 UImage
---@field Image_214 UImage
---@field Image_215 UImage
---@field Image_216 UImage
---@field Image_217 UImage
---@field Image_218 UImage
---@field Image_219 UImage
---@field MoHu MoHu_C
--Edit Below--

local UI06 = {
    bInitDoOnce = false,
    Pending_Open_Gift_Pack = false,
    Opening_Starter_Gift_Pack = false -- 是否正在开启首充礼包

}
UGCGameSystem.UGCRequire("ExtendResource.GiftPack.OfficialPackage.Script.GiftPack.GiftPackManager")

function UI06:Construct()
    self:LuaInit();

end

--[[----------------------解绑委托------------------------]]
function UI06:Destruct()
    UGCCommoditySystem.BuyUGCCommodityResultDelegate:Remove(self.OnBuyUGCCommodityResult, self)
    self.Virtual_Item_Manager.OnItemNumUpdatedDelegate:Remove(self.OnItemNumUpdated, self)
    GiftPackManager.OnOpenGiftPackageDelegate:Remove(self.OnOpenGiftPackage, self)
end
-- function UI06:Tick(MyGeometry, InDeltaTime)

-- end

-- function UI06:Destruct()

-- end

-- [Editor Generated Lua] function define Begin:
function UI06:LuaInit()
    if self.bInitDoOnce then
        return;
    end
    self.bInitDoOnce = true;
    -- [Editor Generated Lua] BindingProperty Begin:
    -- [Editor Generated Lua] BindingProperty End;

    -- [Editor Generated Lua] BindingEvent Begin:
    self.Button_159.OnClicked:Add(self.Button_159_OnClicked, self);
    self.Button_88.OnClicked:Add(self.Button_88_OnClicked, self);

    UGCCommoditySystem.BuyUGCCommodityResultDelegate:Add(self.OnBuyUGCCommodityResult, self)
    self.Virtual_Item_Manager = GiftPackManager:GetVirtualItemManager() -- 获取虚拟物品管理器
    self.Virtual_Item_Manager.OnItemNumUpdatedDelegate:Add(self.OnItemNumUpdated, self)
    GiftPackManager.OnOpenGiftPackageDelegate:Add(self.OnOpenGiftPackage, self)
    -- [Editor Generated Lua] BindingEvent End;
end

function UI06:Button_159_OnClicked()

    L_GloTools.UIMgr(L_Enum.Name_ClassPath.UI06, false, false)
    SoundMgr.PlaySound2D(SoundMgr.SoundName.Event_Notice)
end

function UI06:Button_88_OnClicked()
    L_GloTools.BuyShopProduct(L_Enum.ID_ShopProduct.StarterGift)
    SoundMgr.PlaySound2D(SoundMgr.SoundName.UI_Click)
end

--[[----------------------记录购买成功后待开启的礼包------------------------]]
function UI06:OnBuyUGCCommodityResult(Result, PlayerKey, CommodityID, Count, UID, ProductID)
    if ProductID ~= L_Enum.ID_ShopProduct.StarterGift then
        return
    end
    if (Result ~= true and Result ~= 0) or CommodityID ~= L_Enum.ID_Gift.StarterGift then
        SoundMgr.PlaySound2D(SoundMgr.SoundName.UI_Error)
        return
    end
    SoundMgr.PlaySound2D(SoundMgr.SoundName.Reward_Gold)
    self.Pending_Open_Gift_Pack = true
end

--[[----------------------礼包到账后自动开启------------------------]]
function UI06:OnItemNumUpdated()
    if self.Pending_Open_Gift_Pack and GiftPackManager:GetItemNum(L_Enum.ID_Gift.StarterGift) > 0 then
        self.Pending_Open_Gift_Pack = false
        self.Opening_Starter_Gift_Pack = true
        UGCGameSystem.GetLocalPlayerController():OpenGiftPack(L_Enum.ID_Gift.StarterGift)
    end
end

--[[----------------------首充礼包开启后关闭首充界面------------------------]]
function UI06:OnOpenGiftPackage()
    if not self.Opening_Starter_Gift_Pack then
        return
    end

    self.Opening_Starter_Gift_Pack = false
    L_GloTools.UIMgr(L_Enum.Name_ClassPath.UI06, false)
end

--[[----------------------刷新新手礼包已开通状态------------------------]]
function UI06:RefreshWeekGiftPurchased(ctrl)
    -- local Current_Time = UGCGameSystem.DateTimeToTimeStamp(UGCGameSystem.GetCurrentDateTime()) -- 当前时间戳
    -- if not ctrl.WeekEndTime or Current_Time >= ctrl.WeekEndTime then
    --     return
    -- end

    -- self.TextBlock_435:SetText("已开通")
    -- self.TextBlock_435:SetColorAndOpacity({
    --     SpecifiedColor = {
    --         R = 0,
    --         G = 1,
    --         B = 0,
    --         A = 1
    --     },
    --     ColorUseRule = 0
    -- })
    -- self.TextBlock_434:SetText(os.date("%m月%d日 %H:%M", ctrl.WeekEndTime))
    -- self.TextBlock_436:SetText("再次购买")
end
-- [Editor Generated Lua] function define End;

return UI06
