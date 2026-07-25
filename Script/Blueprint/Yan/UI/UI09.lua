---@class UI09_C:UUserWidget
---@field Button_98 UButton
---@field Button_99 UButton
---@field Image_91 UImage
---@field Image_180 UImage
---@field Image_181 UImage
---@field TextBlock_132 UTextBlock
--Edit Below--
---@class UI09_C:UUserWidget
---@field Button_98 UButton
---@field Button_99 UButton
---@field Image_91 UImage
---@field Image_180 UImage
---@field Image_181 UImage
---@field TextBlock_132 UTextBlock
-- Edit Below--
local UI09 = {
    bInitDoOnce = false
}

local Return_Scroll_Item_ID = 8310002 -- 返回卷背包物品ID
local Return_Scroll_Product_ID = 9000003 -- 返回卷商品ID

--[[----------------------初始化复活界面------------------------]]
function UI09:Construct()
    self:LuaInit();
    self:RefreshReturnScrollCount()
end

-- function UI09:Tick(MyGeometry, InDeltaTime)

-- end

--[[----------------------销毁复活界面------------------------]]
function UI09:Destruct()
    self.Virtual_Item_Manager.OnItemNumUpdatedDelegate:Remove(self.RefreshReturnScrollCount, self)
end

-- [Editor Generated Lua] function define Begin:
--[[----------------------绑定复活界面事件------------------------]]
function UI09:LuaInit()
    if self.bInitDoOnce then
        return;
    end
    self.bInitDoOnce = true;
    -- [Editor Generated Lua] BindingProperty Begin:
    -- [Editor Generated Lua] BindingProperty End;

    -- [Editor Generated Lua] BindingEvent Begin:
    self.Button_98.OnClicked:Add(self.Button_98_OnClicked, self);
    self.Button_99.OnClicked:Add(self.Button_99_OnClicked, self);
    self.Virtual_Item_Manager = UGCGamePartSystem.GetGamePartGlobalActor("VirtualItemManager") -- 虚拟物品管理器
    self.Virtual_Item_Manager.OnItemNumUpdatedDelegate:Add(self.RefreshReturnScrollCount, self)
    -- [Editor Generated Lua] BindingEvent End;
end

--[[----------------------刷新返回卷数量------------------------]]
function UI09:RefreshReturnScrollCount()
    local Player_Controller = UGCGameSystem.GetLocalPlayerController() -- 本地玩家控制器
    local Return_Scroll_Count = UGCBackpackSystemV2.GetItemCountV2(Player_Controller, Return_Scroll_Item_ID) -- 返回卷数量
    self.TextBlock_132:SetText(tostring(Return_Scroll_Count))
end

--[[-----------------------不了按钮-----------------------]] --
function UI09:Button_98_OnClicked()
    local PlayerController = UGCGameSystem.GetLocalPlayerController()
    UnrealNetwork.CallUnrealRPC(PlayerController, PlayerController, L_Enum.Name_RPC.Request_Respawn, false)
    L_GloTools.UIMgr(L_Enum.Name_ClassPath.UI09, false)
end
--[[-----------------------返回按钮-----------------------]] --
function UI09:Button_99_OnClicked()
    local PlayerController = UGCGameSystem.GetLocalPlayerController()
    if UGCBackpackSystemV2.GetItemCountV2(PlayerController, Return_Scroll_Item_ID) < 1 then
        L_GloTools.BuyShopProduct(Return_Scroll_Product_ID)
        return
    end

    UnrealNetwork.CallUnrealRPC(PlayerController, PlayerController, L_Enum.Name_RPC.Request_Respawn, true)
    L_GloTools.UIMgr(L_Enum.Name_ClassPath.UI09, false)

end

-- [Editor Generated Lua] function define End;

return UI09
