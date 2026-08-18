---@class UI13_C:UUserWidget
---@field Button_0 UButton
---@field Image_6 UImage
---@field Image_145 UImage
---@field TextBlock_166 UTextBlock
---@field WrapBox_29 UWrapBox
---@field Pre_Item_01 UClass
---@field Pre_Item_02 UClass
---@field Pre_Item_03 UClass
---@field Pre_Item_04 UClass
---@field Pre_Item_05 UClass
--Edit Below--
local CFG_SL = UGCGameSystem.UGCRequire('Script.L_Com.Config_SL.CFG_SL')

local UI13 = {
    bInitDoOnce = false,
    Gold_Quantity = 20 -- 初始金币数量
}
function UI13:Construct()
    self.Button_0.OnClicked:Add(self.Button_0_OnClicked, self)
    self:LuaInit();
end

--[[----------------------添加测试物品控件------------------------]]
function UI13:Add_Test_Items()
    self.WrapBox_29:ClearChildren()

    local Item_Configs = {{
        Config = CFG_SL.All.Normal_Gold,
        Class = self.Pre_Item_01,
        OnClicked = self.Item_01_OnClicked
    }, {
        Config = CFG_SL.All.Add_Ten_Gold,
        Class = self.Pre_Item_02,
        OnClicked = self.Item_02_OnClicked
    }, {
        Config = CFG_SL.All.Double_Gold,
        Class = self.Pre_Item_03,
        OnClicked = self.Item_03_OnClicked
    }, {
        Config = CFG_SL.All.Banana_Peel,
        Class = self.Pre_Item_04,
        OnClicked = self.Item_04_OnClicked
    }, {
        Config = CFG_SL.All.Explosive,
        Class = self.Pre_Item_05,
        OnClicked = self.Item_05_OnClicked
    }}

    local All_Items = {}
    for _, Item_Data in ipairs(Item_Configs) do
        for _ = 1, Item_Data.Config.Grid_Count do
            table.insert(All_Items, Item_Data)
        end
    end

    for Index = #All_Items, 2, -1 do
        local Random_Index = math.random(Index)
        All_Items[Index], All_Items[Random_Index] = All_Items[Random_Index], All_Items[Index]
    end

    for _, Item_Data in ipairs(All_Items) do
        local Item_Widget = UGCWidgetManagerSystem.CreateWidget(Item_Data.Class)

        self.WrapBox_29:AddChildWrapBox(Item_Widget)
        Item_Widget.Button_5.OnClicked:Add(Item_Data.OnClicked, self)
    end
end

--[[----------------------刷新金币数量文本------------------------]]
function UI13:Refresh_Gold_Text()
    self.TextBlock_166:SetText(tostring(self.Gold_Quantity))
end

--[[----------------------处理普通金币并增加八金币------------------------]]
function UI13:Item_01_OnClicked()
    self.Gold_Quantity = self.Gold_Quantity + CFG_SL.All.Normal_Gold.Effect_Value
    self:Refresh_Gold_Text()
end

--[[----------------------处理金币加十并增加十金币------------------------]]
function UI13:Item_02_OnClicked()
    self.Gold_Quantity = self.Gold_Quantity + CFG_SL.All.Add_Ten_Gold.Effect_Value
    self:Refresh_Gold_Text()
end

--[[----------------------处理金币翻倍------------------------]]
function UI13:Item_03_OnClicked()
    self.Gold_Quantity = self.Gold_Quantity * CFG_SL.All.Double_Gold.Effect_Value
    self:Refresh_Gold_Text()
end

--[[----------------------处理香蕉皮并扣除十金币------------------------]]
function UI13:Item_04_OnClicked()
    self.Gold_Quantity = self.Gold_Quantity - CFG_SL.All.Banana_Peel.Effect_Value
    if self.Gold_Quantity < 0 then
        self.Gold_Quantity = 0
    end
    self:Refresh_Gold_Text()
end

--[[----------------------处理炸药并清空金币------------------------]]
function UI13:Item_05_OnClicked()
    self.Gold_Quantity = CFG_SL.All.Explosive.Effect_Value
    self:Refresh_Gold_Text()
    L_TipsTool.ShowTips_01("踩到炸弹啦，啥都没啦")
    self.Button_0:SetIsEnabled(false)

    UGCTimerUtility.CreateLuaTimer(5, function()
        self.Button_0:SetIsEnabled(true)
        self:Refresh()

        L_GloTools.UIMgr(L_Enum.Name_ClassPath.UI13, false, false)
        L_GloTools.UIMgr(L_Enum.Name_ClassPath.UI02, true, false)
    end, false)
end

function UI13:LuaInit()
    if self.bInitDoOnce then
        return;
    end
    self.bInitDoOnce = true;
    self:Refresh_Gold_Text()
    self:Add_Test_Items()
end

--[[----------------------刷新页面显示内容------------------------]]
function UI13:Refresh()
    self.Gold_Quantity = 20
    self:Refresh_Gold_Text()
    self:Add_Test_Items()
end

--[[----------------------见好就收------------------------]]
function UI13:Button_0_OnClicked()
    if self.Gold_Quantity > 0 then
        local Player_Controller = UGCGameSystem.GetLocalPlayerController()
        UnrealNetwork.CallUnrealRPC(Player_Controller, Player_Controller, L_Enum.Name_RPC.Grant_Virtual_Item, 1005,
            self.Gold_Quantity)
    end
    self:Refresh()
    L_GloTools.UIMgr(L_Enum.Name_ClassPath.UI13, false, false)
    L_GloTools.UIMgr(L_Enum.Name_ClassPath.UI02, true, false)

end
return UI13
