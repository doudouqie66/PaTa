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
local UI03 = {
    bInitDoOnce = false
}

function UI03:Construct()
    self:LuaInit();

end

-- function UI03:Tick(MyGeometry, InDeltaTime)

-- end

-- function UI03:Destruct()

-- end

-- [Editor Generated Lua] function define Begin:
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
    -- [Editor Generated Lua] BindingEvent End;
end

function UI03:Button_330_OnClicked()
    L_GloTools.UIMgr(L_Enum.Name_ClassPath.UI03, false)

end
--[[----------------------购买按键------------------------]] --
function UI03:Button_108_OnClicked()

    local Product_ID = 9000029 -- 商品表中的商品ID
    local Buy_Count = 1 -- 购买数量
    local Product_Data = ShopV2Manager:GetProductConfigData(Product_ID) -- 商品信息
    local Object_Data = ShopV2Manager:GetItemConfigData(Product_Data.ItemID) -- 物品信息

    local Purchase_Future = UGCCommoditySystem.BuyUGCCommodity2(Product_ID, Object_Data.ItemIcon, Object_Data.ItemDesc,
        Buy_Count)
    -- UGCCommoditySystem.BuyUGCCommodity2(9000029, nil, nil, 1)

end

-- [Editor Generated Lua] function define End;

return UI03
