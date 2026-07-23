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

local Gift_Pack_Product_ID = 9000029 -- 礼包对应的商品ID
local Gift_Pack_ID = 1030 -- 礼包表中的礼包ID

local UI03 = {
    bInitDoOnce = false,
    Pending_Open_Gift_Pack = false
}

--[[----------------------构造商城界面------------------------]]
function UI03:Construct()
    self:LuaInit();

end

-- function UI03:Tick(MyGeometry, InDeltaTime)

-- end

--[[----------------------销毁商城界面并解绑委托------------------------]]
function UI03:Destruct()
    UGCCommoditySystem.BuyUGCCommodityResultDelegate:Remove(self.OnBuyUGCCommodityResult, self)
    self.Virtual_Item_Manager.OnItemNumUpdatedDelegate:Remove(self.OnItemNumUpdated, self)
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
    -- [Editor Generated Lua] BindingEvent End;
end

--[[----------------------关闭商城界面------------------------]]
function UI03:Button_330_OnClicked()
    L_GloTools.UIMgr(L_Enum.Name_ClassPath.UI03, false)

end

--[[----------------------购买礼包商品------------------------]]
function UI03:Button_108_OnClicked()

    local Buy_Count = 1 -- 购买数量
    local Product_Data = ShopV2Manager:GetProductConfigData(Gift_Pack_Product_ID) -- 商品信息
    local Object_Data = ShopV2Manager:GetItemConfigData(Product_Data.ItemID) -- 物品信息

    UGCCommoditySystem.BuyUGCCommodity2(Gift_Pack_Product_ID, Object_Data.ItemIcon, Object_Data.ItemDesc, Buy_Count)
end

--[[----------------------记录购买成功后待开启的礼包------------------------]]
function UI03:OnBuyUGCCommodityResult(bSuccess, PlayerKey, CommodityID, Count, UID, ProductID)
    if bSuccess and ProductID == Gift_Pack_Product_ID and CommodityID == Gift_Pack_ID then
        self.Pending_Open_Gift_Pack = true
    end
end

--[[----------------------礼包到账后自动开启------------------------]]
function UI03:OnItemNumUpdated()
    if self.Pending_Open_Gift_Pack and GiftPackManager:GetItemNum(Gift_Pack_ID) > 0 then
        self.Pending_Open_Gift_Pack = false
        GiftPackManager:OpenGiftPack(Gift_Pack_ID)
    end
end

-- [Editor Generated Lua] function define End;

return UI03
