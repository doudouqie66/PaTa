---@class UI04_C:UUserWidget
---@field Button_0 UButton
---@field Button_1 UButton
---@field Button_2 UButton
---@field Button_4 UButton
---@field Button_5 UButton
---@field Button_6 UButton
---@field Button_7 UButton
---@field Button_8 UButton
---@field Button_9 UButton
---@field Button_10 UButton
---@field Button_11 UButton
---@field Button_54 UButton
---@field Button_203 UButton
---@field Button_330 UButton
---@field Image_0 UImage
---@field Image_1 UImage
---@field Image_2 UImage
---@field Image_3 UImage
---@field Image_4 UImage
---@field Image_5 UImage
---@field Image_8 UImage
---@field Image_9 UImage
---@field Image_10 UImage
---@field Image_11 UImage
---@field Image_12 UImage
---@field Image_13 UImage
---@field Image_14 UImage
---@field Image_15 UImage
---@field Image_16 UImage
---@field Image_17 UImage
---@field Image_18 UImage
---@field Image_19 UImage
---@field Image_20 UImage
---@field Image_21 UImage
---@field Image_22 UImage
---@field Image_23 UImage
---@field Image_55 UImage
---@field Image_116 UImage
---@field Image_122 UImage
---@field Image_216 UImage
---@field Image_360 UImage
---@field Image_481 UImage
-- Edit Below--
---@class UI04_C:UUserWidget
---@field Button_0 UButton
---@field Button_1 UButton
---@field Button_2 UButton
---@field Button_4 UButton
---@field Button_5 UButton
---@field Button_6 UButton
---@field Button_7 UButton
---@field Button_8 UButton
---@field Button_9 UButton
---@field Button_10 UButton
---@field Button_11 UButton
---@field Button_54 UButton
---@field Button_203 UButton
---@field Button_330 UButton
---@field Image_0 UImage
---@field Image_1 UImage
---@field Image_2 UImage
---@field Image_3 UImage
---@field Image_4 UImage
---@field Image_5 UImage
---@field Image_8 UImage
---@field Image_9 UImage
---@field Image_10 UImage
---@field Image_11 UImage
---@field Image_12 UImage
---@field Image_13 UImage
---@field Image_14 UImage
---@field Image_15 UImage
---@field Image_16 UImage
---@field Image_17 UImage
---@field Image_18 UImage
---@field Image_19 UImage
---@field Image_20 UImage
---@field Image_21 UImage
---@field Image_22 UImage
---@field Image_23 UImage
---@field Image_55 UImage
---@field Image_116 UImage
---@field Image_122 UImage
---@field Image_216 UImage
---@field Image_360 UImage
---@field Image_481 UImage
-- Edit Below--
---@class UI04_C:UUserWidget
---@field Button_0 UButton
---@field Button_1 UButton
---@field Button_2 UButton
---@field Button_4 UButton
---@field Button_5 UButton
---@field Button_6 UButton
---@field Button_7 UButton
---@field Button_8 UButton
---@field Button_9 UButton
---@field Button_10 UButton
---@field Button_11 UButton
---@field Button_54 UButton
---@field Button_203 UButton
---@field Button_330 UButton
---@field Image_0 UImage
---@field Image_1 UImage
---@field Image_2 UImage
---@field Image_3 UImage
---@field Image_4 UImage
---@field Image_5 UImage
---@field Image_8 UImage
---@field Image_9 UImage
---@field Image_10 UImage
---@field Image_11 UImage
---@field Image_12 UImage
---@field Image_13 UImage
---@field Image_14 UImage
---@field Image_15 UImage
---@field Image_16 UImage
---@field Image_17 UImage
---@field Image_18 UImage
---@field Image_19 UImage
---@field Image_20 UImage
---@field Image_21 UImage
---@field Image_22 UImage
---@field Image_23 UImage
---@field Image_55 UImage
---@field Image_116 UImage
---@field Image_122 UImage
---@field Image_216 UImage
---@field Image_360 UImage
---@field Image_481 UImage
-- Edit Below--
local Item_Price_Config = L_Enum.Gold_Shop.Item_Price_Config -- 金币购买价格配置

local UI04 = {
    bInitDoOnce = false
}

--[[----------------------构造金币商店界面------------------------]]
function UI04:Construct()
    self:LuaInit();

end

-- function UI04:Tick(MyGeometry, InDeltaTime)

-- end

-- function UI04:Destruct()

-- end

-- [Editor Generated Lua] function define Begin:
--[[----------------------初始化金币商店界面------------------------]]
function UI04:LuaInit()
    if self.bInitDoOnce then
        return;
    end
    self.bInitDoOnce = true;
    -- [Editor Generated Lua] BindingProperty Begin:
    -- [Editor Generated Lua] BindingProperty End;

    -- [Editor Generated Lua] BindingEvent Begin:
    self.Button_330.OnClicked:Add(self.Button_330_OnClicked, self);
    self.Button_203.OnClicked:Add(self.Button_203_OnClicked, self);
    self.Button_0.OnClicked:Add(self.Button_0_OnClicked, self);
    self.Button_1.OnClicked:Add(self.Button_1_OnClicked, self);
    self.Button_2.OnClicked:Add(self.Button_2_OnClicked, self);
    self.Button_4.OnClicked:Add(self.Button_4_OnClicked, self);
    self.Button_5.OnClicked:Add(self.Button_5_OnClicked, self);
    self.Button_6.OnClicked:Add(self.Button_6_OnClicked, self);
    self.Button_7.OnClicked:Add(self.Button_7_OnClicked, self);
    self.Button_8.OnClicked:Add(self.Button_8_OnClicked, self);
    self.Button_9.OnClicked:Add(self.Button_9_OnClicked, self);
    self.Button_10.OnClicked:Add(self.Button_10_OnClicked, self);
    self.Button_11.OnClicked:Add(self.Button_11_OnClicked, self);
    self.Button_54.OnClicked:Add(self.Button_54_OnClicked, self);
    -- [Editor Generated Lua] BindingEvent End;
end

--[[----------------------关闭金币商店界面------------------------]]
function UI04:Button_330_OnClicked()
    L_GloTools.UIMgr(L_Enum.Name_ClassPath.UI04, false)
    SoundMgr.PlaySound2D(SoundMgr.SoundName.Event_Notice)
end

--[[----------------------申请使用金币购买道具------------------------]]
function UI04:Request_Gold_Purchase(Item_ID)
    local Player_Controller = UGCGameSystem.GetLocalPlayerController() -- 本地玩家控制器
    local Gold_Price = Item_Price_Config[Item_ID] -- 购买所需金币数量

    if UGCBackpackSystemV2.GetItemCountV2(Player_Controller, L_Enum.Gold_Shop.Gold_Item_ID) < Gold_Price then
        L_TipsTool.ShowTips_01("数量不足", nil, SoundMgr.SoundName.UI_Error)
        return
    end

    UnrealNetwork.CallUnrealRPC(Player_Controller, Player_Controller, L_Enum.Name_RPC.Buy_Gold_Item, Item_ID)
    SoundMgr.PlaySound2D(SoundMgr.SoundName.UI_Click)
end

--[[----------------------购买香蕉皮------------------------]]
function UI04:Button_203_OnClicked()
    self:Request_Gold_Purchase(1023)
end

--[[----------------------购买粑粑------------------------]]
function UI04:Button_0_OnClicked()
    self:Request_Gold_Purchase(1009)
end

--[[----------------------购买炸弹------------------------]]
function UI04:Button_1_OnClicked()
    self:Request_Gold_Purchase(1028)
end

--[[----------------------购买无敌药水------------------------]]
function UI04:Button_2_OnClicked()
    self:Request_Gold_Purchase(1022)
end

--[[----------------------购买加速药水------------------------]]
function UI04:Button_4_OnClicked()
    self:Request_Gold_Purchase(1016)
end

--[[----------------------购买跳高药水------------------------]]
function UI04:Button_5_OnClicked()
    self:Request_Gold_Purchase(1020)
end

--[[----------------------购买护盾药水------------------------]]
function UI04:Button_6_OnClicked()
    self:Request_Gold_Purchase(1012)
end

--[[----------------------购买隐身药水------------------------]]
function UI04:Button_7_OnClicked()
    self:Request_Gold_Purchase(1025)
end

--[[----------------------购买喷射钩爪------------------------]]
function UI04:Button_8_OnClicked()
    self:Request_Gold_Purchase(1013)
end

--[[----------------------购买冲天炮------------------------]]
function UI04:Button_9_OnClicked()
    self:Request_Gold_Purchase(1011)
end

--[[----------------------购买冰冻锤------------------------]]
function UI04:Button_10_OnClicked()
    self:Request_Gold_Purchase(1010)
end

--[[----------------------购买大力拳套------------------------]]
function UI04:Button_11_OnClicked()
    self:Request_Gold_Purchase(1006)
end

--[[---------------------购买金币宝箱-------------------------]] --
function UI04:Button_54_OnClicked()
    self:Request_Gold_Purchase(1026)

end

-- [Editor Generated Lua] function define End;

return UI04
