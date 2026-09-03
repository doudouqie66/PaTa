---@class UI03_C:UUserWidget
---@field Button_107 UButton
---@field Button_108 UButton
---@field Button_203 UButton
---@field Button_204 UButton
---@field Button_205 UButton
---@field Button_206 UButton
---@field Button_207 UButton
---@field Button_208 UButton
---@field Button_209 UButton
---@field Button_210 UButton
---@field Button_330 UButton
---@field Image_55 UImage
---@field Image_56 UImage
---@field Image_57 UImage
---@field Image_216 UImage
---@field Image_217 UImage
---@field Image_218 UImage
---@field Image_219 UImage
---@field Image_220 UImage
---@field Image_221 UImage
---@field Image_222 UImage
---@field Image_223 UImage
---@field Image_360 UImage
---@field Image_481 UImage
---@field MoHu MoHu_C
---@field TextBlock_434 UTextBlock
---@field TextBlock_435 UTextBlock
---@field TextBlock_436 UTextBlock
--Edit Below--
---@class UI03_C:UUserWidget
---@field Button_107 UButton
---@field Button_108 UButton
---@field Button_203 UButton
---@field Button_204 UButton
---@field Button_205 UButton
---@field Button_206 UButton
---@field Button_207 UButton
---@field Button_208 UButton
---@field Button_209 UButton
---@field Button_210 UButton
---@field Button_330 UButton
---@field Image_55 UImage
---@field Image_56 UImage
---@field Image_57 UImage
---@field Image_216 UImage
---@field Image_217 UImage
---@field Image_218 UImage
---@field Image_219 UImage
---@field Image_220 UImage
---@field Image_221 UImage
---@field Image_222 UImage
---@field Image_223 UImage
---@field Image_360 UImage
---@field Image_481 UImage
---@field TextBlock_434 UTextBlock
---@field TextBlock_435 UTextBlock
---@field TextBlock_436 UTextBlock
-- Edit Below--
---@class UI03_C:UUserWidget
---@field Button_107 UButton
---@field Button_108 UButton
---@field Button_203 UButton
---@field Button_204 UButton
---@field Button_205 UButton
---@field Button_206 UButton
---@field Button_207 UButton
---@field Button_208 UButton
---@field Button_209 UButton
---@field Button_210 UButton
---@field Button_330 UButton
---@field Image_55 UImage
---@field Image_56 UImage
---@field Image_57 UImage
---@field Image_216 UImage
---@field Image_217 UImage
---@field Image_218 UImage
---@field Image_219 UImage
---@field Image_220 UImage
---@field Image_221 UImage
---@field Image_222 UImage
---@field Image_223 UImage
---@field Image_360 UImage
---@field Image_481 UImage
-- Edit Below--
---@class UI03_C:UUserWidget
---@field Button_107 UButton
---@field Button_108 UButton
---@field Button_203 UButton
---@field Button_204 UButton
---@field Button_205 UButton
---@field Button_206 UButton
---@field Button_207 UButton
---@field Button_208 UButton
---@field Button_209 UButton
---@field Button_210 UButton
---@field Button_330 UButton
---@field Image_55 UImage
---@field Image_56 UImage
---@field Image_57 UImage
---@field Image_216 UImage
---@field Image_217 UImage
---@field Image_218 UImage
---@field Image_219 UImage
---@field Image_220 UImage
---@field Image_221 UImage
---@field Image_222 UImage
---@field Image_223 UImage
---@field Image_360 UImage
---@field Image_481 UImage
-- Edit Below--
UGCGameSystem.UGCRequire("ExtendResource.GiftPack.OfficialPackage.Script.GiftPack.GiftPackManager")

local UI03 = {
    bInitDoOnce = false,
    Pending_Open_Gift_Pack = false,
    Week_Ref_Elapsed = 0 -- 周卡刷新累计秒数
}

--[[----------------------构造商城界面------------------------]]
function UI03:Construct()
    self:LuaInit();
    self.Week_Default_State_Text = self.TextBlock_435:GetText() -- 周卡默认状态文案
    self.Week_Default_End_Text = self.TextBlock_434:GetText() -- 周卡默认有效期文案
    self.Week_Default_Button_Text = self.TextBlock_436:GetText() -- 周卡默认购买按钮文案
    self.Week_Default_State_Color = self.TextBlock_435.ColorAndOpacity -- 周卡默认状态颜色
    self.Week_Ref_Elapsed = 0
    self:RefreshWeekGiftPurchased(UGCGameSystem.GetLocalPlayerController())

end

--[[----------------------定时刷新周卡状态------------------------]]
function UI03:Tick(MyGeometry, InDeltaTime)
    self.Week_Ref_Elapsed = self.Week_Ref_Elapsed + InDeltaTime
    if self.Week_Ref_Elapsed < 1 then
        return
    end
    self.Week_Ref_Elapsed = 0
    self:RefreshWeekGiftPurchased(UGCGameSystem.GetLocalPlayerController())
end

--[[----------------------销毁商城界面并解绑委托------------------------]]
function UI03:Destruct()
    UGCCommoditySystem.BuyUGCCommodityResultDelegate:Remove(self.OnBuyUGCCommodityResult, self)
    self.Virtual_Item_Manager.OnItemNumUpdatedDelegate:Remove(self.OnItemNumUpdated, self)
    GiftPackManager.OnOpenGiftPackageDelegate:Remove(self.OnOpenGiftPackage, self)
end

-- [Editor Generated Lua] function define Begin:
--[[----------------------初始化商城界面------------------------]]
function UI03:LuaInit()
    if self.bInitDoOnce then
        return;
    end
    self.bInitDoOnce = true;
    -- [Editor Generated Lua] BindingProperty Begin:
    -- [Editor Generated Lua] BindingProperty End;

    -- [Editor Generated Lua] BindingEvent Begin:
    self.Button_330.OnClicked:Add(self.Button_330_OnClicked, self);
    self.Button_108.OnClicked:Add(self.Button_108_OnClicked, self);
    UGCCommoditySystem.BuyUGCCommodityResultDelegate:Add(self.OnBuyUGCCommodityResult, self)
    self.Virtual_Item_Manager = GiftPackManager:GetVirtualItemManager() -- 获取虚拟物品管理器
    self.Virtual_Item_Manager.OnItemNumUpdatedDelegate:Add(self.OnItemNumUpdated, self)
    GiftPackManager.OnOpenGiftPackageDelegate:Add(self.OnOpenGiftPackage, self)
    -- [Editor Generated Lua] BindingEvent End;
end

--[[----------------------关闭商城界面------------------------]]
function UI03:Button_330_OnClicked()
    L_GloTools.UIMgr(L_Enum.Name_ClassPath.UI03, false)
    SoundMgr.PlaySound2D(SoundMgr.SoundName.Event_Notice)
end

--[[----------------------购买礼包商品------------------------]]
function UI03:Button_108_OnClicked()
    L_GloTools.BuyShopProduct(L_Enum.ID_ShopProduct.WeekdGift)
    SoundMgr.PlaySound2D(SoundMgr.SoundName.UI_Click)
end

--[[----------------------记录购买成功后待开启的礼包------------------------]]
function UI03:OnBuyUGCCommodityResult(bSuccess, PlayerKey, CommodityID, Count, UID, ProductID)
    if ProductID ~= L_Enum.ID_ShopProduct.WeekdGift then
        return
    end
    if not bSuccess or CommodityID ~= L_Enum.ID_Gift.WeekdGift then
        SoundMgr.PlaySound2D(SoundMgr.SoundName.UI_Error)
        return
    end
    SoundMgr.PlaySound2D(SoundMgr.SoundName.Reward_Gold)
    self.Pending_Open_Gift_Pack = true
end

--[[----------------------礼包到账后自动开启------------------------]]
function UI03:OnItemNumUpdated()
    if self.Pending_Open_Gift_Pack and GiftPackManager:GetItemNum(L_Enum.ID_Gift.WeekdGift) > 0 then
        self.Pending_Open_Gift_Pack = false
        UGCGameSystem.GetLocalPlayerController():OpenGiftPack(L_Enum.ID_Gift.WeekdGift)
    end
end

--[[----------------------礼包开启后检测周礼包状态------------------------]]
function UI03:OnOpenGiftPackage()
    self:RefreshWeekGiftPurchased(UGCGameSystem.GetLocalPlayerController())
end

--[[----------------------刷新周礼包已开通状态------------------------]]
function UI03:RefreshWeekGiftPurchased(ctrl)
    local Current_Time = UGCGameSystem.GetServerTimeSec() -- 当前服务器时间
    if not ctrl.WeekEndTime or Current_Time >= ctrl.WeekEndTime then
        self.TextBlock_435:SetText(self.Week_Default_State_Text)
        self.TextBlock_435:SetColorAndOpacity(self.Week_Default_State_Color)
        self.TextBlock_434:SetText(self.Week_Default_End_Text)
        self.TextBlock_436:SetText(self.Week_Default_Button_Text)
        return
    end

    self.TextBlock_435:SetText("已开通")
    self.TextBlock_435:SetColorAndOpacity({
        SpecifiedColor = {
            R = 0,
            G = 1,
            B = 0,
            A = 1
        },
        ColorUseRule = 0
    })
    self.TextBlock_434:SetText(os.date("%m月%d日 %H:%M", ctrl.WeekEndTime))
    self.TextBlock_436:SetText("再次购买")
end

-- [Editor Generated Lua] function define End;

return UI03
