---@class UI10_C:UUserWidget
---@field Button_61 UButton
---@field Button_62 UButton
---@field Button_63 UButton
---@field Button_244 UButton
---@field Button_245 UButton
---@field CanvasPanel_93 UCanvasPanel
---@field CanvasPanel_94 UCanvasPanel
---@field CanvasPanel_95 UCanvasPanel
---@field Image_126 UImage
---@field Image_211 UImage
---@field Image_212 UImage
---@field Image_213 UImage
---@field Image_214 UImage
---@field Image_215 UImage
---@field TextBlock_88 UTextBlock
---@field TextBlock_89 UTextBlock
---@field TextBlock_90 UTextBlock
--Edit Below--
---@class UI10_C:UUserWidget
---@field Button_61 UButton
---@field Button_62 UButton
---@field Button_63 UButton
---@field Button_244 UButton
---@field Button_245 UButton
---@field CanvasPanel_93 UCanvasPanel
---@field CanvasPanel_94 UCanvasPanel
---@field CanvasPanel_95 UCanvasPanel
---@field Image_126 UImage
---@field Image_211 UImage
---@field Image_212 UImage
---@field Image_213 UImage
---@field Image_214 UImage
---@field Image_215 UImage
---@field TextBlock_88 UTextBlock
---@field TextBlock_89 UTextBlock
---@field TextBlock_90 UTextBlock
-- Edit Below--
local UIFoldMgr = UGCGameSystem.UGCRequire("Script.L_Com.UIFoldMgr") -- 通用UI折叠管理器

local UI10 = {
    bInitDoOnce = false,
    Trap_Red_Dot_Read = {}, -- 道具红点已读状态
    Last_Item_Count = {}, -- 道具上次刷新数量
    Selected_Trap_Index = nil -- 当前技能槽对应的陷阽物品索引
}

--[[----------------------初始化折叠面板------------------------]]
function UI10:Construct()
    self.Fold_Manager = UIFoldMgr.New({ -- 当前界面的折叠管理器
        Expand_Button = self.Button_244,
        Collapse_Button = self.Button_245,
        Panels = {self.CanvasPanel_93, self.CanvasPanel_94, self.CanvasPanel_95},
        Default_Expanded = true
    })
    self:LuaInit()
end

--[[----------------------销毁折叠面板------------------------]]
function UI10:Destruct()
    if self.Virtual_Item_Manager_Timer then
        UGCTimerUtility.RemoveLuaTimer(self.Virtual_Item_Manager_Timer)
        self.Virtual_Item_Manager_Timer = nil
    end
    if self.Virtual_Item_Manager then
        self.Virtual_Item_Manager.OnItemNumUpdatedDelegate:Remove(self.RefreshTrapItems, self)
    end
    self.Fold_Manager:Destroy()
end

--[[----------------------绑定折叠面板按钮事件------------------------]]
function UI10:LuaInit()
    if self.bInitDoOnce then
        return
    end
    self.bInitDoOnce = true
    self.Button_61.OnClicked:Add(self.Button_61_OnClicked, self)
    self.Button_62.OnClicked:Add(self.Button_62_OnClicked, self)
    self.Button_63.OnClicked:Add(self.Button_63_OnClicked, self)
    self.Button_244.OnClicked:Add(self.Button_244_OnClicked, self)
    self.Button_245.OnClicked:Add(self.Button_245_OnClicked, self)
    if not self:BindVirtualItemManager() then
        self.Virtual_Item_Manager_Timer = UGCTimerUtility.CreateLuaTimer(0.2, function()
            if self:BindVirtualItemManager() then
                UGCTimerUtility.RemoveLuaTimer(self.Virtual_Item_Manager_Timer)
                self.Virtual_Item_Manager_Timer = nil
            end
        end, true)
    end
end

--[[----------------------等待并绑定虚拟物品管理器------------------------]]
function UI10:BindVirtualItemManager()
    self.Virtual_Item_Manager = UGCGamePartSystem.GetGamePartGlobalActor("VirtualItemManager") -- 虚拟物品管理器
    if not self.Virtual_Item_Manager then
        return false
    end

    self.Virtual_Item_Manager.OnItemNumUpdatedDelegate:Add(self.RefreshTrapItems, self)
    self:RefreshTrapItems()
    return true
end

--[[----------------------获取陷阱道具配置------------------------]]
function UI10:GetTrapItemConfig()
    return {
        {
            Item_ID = 8310021, -- 香蕉皮物品ID
            Product_ID = 9000022, -- 香蕉皮商品ID
            Panel = self.CanvasPanel_93, -- 香蕉皮面板
            Count_Text = self.TextBlock_88, -- 香蕉皮数量文本
            Red_Dot = self.Image_211 -- 香蕉皮红点
        },
        {
            Item_ID = 8310007, -- 粑粑物品ID
            Product_ID = 9000008, -- 粑粑商品ID
            Panel = self.CanvasPanel_94, -- 粑粑面板
            Count_Text = self.TextBlock_89, -- 粑粑数量文本
            Red_Dot = self.Image_213 -- 粑粑红点
        },
        {
            Item_ID = 8310026, -- 炸弹物品ID
            Product_ID = 9000027, -- 炸弹商品ID
            Panel = self.CanvasPanel_95, -- 炸弹面板
            Count_Text = self.TextBlock_90, -- 炸弹数量文本
            Red_Dot = self.Image_215 -- 炸弹红点
        }
    }
end

--[[----------------------刷新陷阱道具数量和显示状态------------------------]]
function UI10:RefreshTrapItems()
    local Player_Controller = UGCGameSystem.GetLocalPlayerController() -- 当前玩家控制器
    local Trap_Configs = self:GetTrapItemConfig() -- 陷阽物品配置

    for Trap_Index, Trap_Config in ipairs(Trap_Configs) do
        local Item_Count = UGCBackpackSystemV2.GetItemCountV2(Player_Controller, Trap_Config.Item_ID) -- 当前道具数量
        if self.Last_Item_Count[Trap_Index] and Item_Count > self.Last_Item_Count[Trap_Index] then
            self.Trap_Red_Dot_Read[Trap_Index] = false
        end

        self.Last_Item_Count[Trap_Index] = Item_Count
        Trap_Config.Count_Text:SetText(tostring(Item_Count))
        Trap_Config.Panel:SetRenderOpacity(Item_Count > 0 and 1 or 0.45)
        Trap_Config.Red_Dot:SetVisibility(Item_Count > 0 and not self.Trap_Red_Dot_Read[Trap_Index] and
                                              ESlateVisibility.Visible or ESlateVisibility.Collapsed)
    end

    if self.Selected_Trap_Index and self.Last_Item_Count[self.Selected_Trap_Index] <= 0 then
        local Previous_Trap_Index = self.Selected_Trap_Index -- 已经耗尽的陷阽物品索引
        local Next_Trap_Index = nil -- 下一个有库存的陷阽物品索引
        for Trap_Offset = 1, #Trap_Configs do
            local Trap_Index = (Previous_Trap_Index - 1 + Trap_Offset) % #Trap_Configs + 1 -- 循环检查的索引
            if self.Last_Item_Count[Trap_Index] > 0 then
                Next_Trap_Index = Trap_Index
                break
            end
        end

        if Next_Trap_Index then
            ugcprint(string.format("[TrapSkillDebug][客户端] 当前道具已耗尽，自动切换下一个技能：原索引=%s，新索引=%s",
                tostring(Previous_Trap_Index), tostring(Next_Trap_Index)))
            self:SelectTrapItem(Next_Trap_Index)
        else
            self.Selected_Trap_Index = nil
            ugcprint(string.format("[TrapSkillDebug][客户端] 当前道具已耗尽且没有剩余陷阽物品，清空技能槽：原索引=%s",
                tostring(Previous_Trap_Index)))
            UnrealNetwork.CallUnrealRPC(Player_Controller, Player_Controller,
                L_Enum.Name_RPC.Switch_Trap_Item_Skill, 0)
        end
    end
end

--[[----------------------处理陷阱道具按钮点击------------------------]]
function UI10:SelectTrapItem(Trap_Index)
    local Trap_Config = self:GetTrapItemConfig()[Trap_Index] -- 当前陷阱配置
    local Player_Controller = UGCGameSystem.GetLocalPlayerController() -- 当前玩家控制器
    local Item_Count = UGCBackpackSystemV2.GetItemCountV2(Player_Controller, Trap_Config.Item_ID) -- 当前道具数量
    ugcprint(string.format("[TrapSkillDebug][客户端] 点击按钮：索引=%s，物品ID=%s，商品ID=%s，数量=%s，控制器=%s",
        tostring(Trap_Index), tostring(Trap_Config.Item_ID), tostring(Trap_Config.Product_ID), tostring(Item_Count),
        tostring(Player_Controller)))

    if Item_Count <= 0 then
        ugcprint(string.format("[TrapSkillDebug][客户端] 数量不足，打开购买界面：商品ID=%s",
            tostring(Trap_Config.Product_ID)))
        L_GloTools.BuyShopProduct(Trap_Config.Product_ID)
        return false
    end

    self.Selected_Trap_Index = Trap_Index
    self.Trap_Red_Dot_Read[Trap_Index] = true
    Trap_Config.Red_Dot:SetVisibility(ESlateVisibility.Collapsed)
    ugcprint(string.format("[TrapSkillDebug][客户端] 数量充足，准备发送切换技能RPC：RPC=%s，物品ID=%s",
        tostring(L_Enum.Name_RPC.Switch_Trap_Item_Skill), tostring(Trap_Config.Item_ID)))
    UnrealNetwork.CallUnrealRPC(Player_Controller, Player_Controller, L_Enum.Name_RPC.Switch_Trap_Item_Skill,
        Trap_Config.Item_ID)
    ugcprint("[TrapSkillDebug][客户端] 切换技能RPC调用已执行")
    return true
end

--[[----------------------点击选择香蕉皮技能------------------------]]
function UI10:Button_61_OnClicked()
    local Is_Selected = self:SelectTrapItem(1) -- 是否成功选择陷阽物品
    SoundMgr.PlaySound2D(Is_Selected and SoundMgr.SoundName.UI_Click or SoundMgr.SoundName.UI_Switch)
end

--[[----------------------点击选择粑粑技能------------------------]]
function UI10:Button_62_OnClicked()
    local Is_Selected = self:SelectTrapItem(2) -- 是否成功选择陷阽物品
    SoundMgr.PlaySound2D(Is_Selected and SoundMgr.SoundName.UI_Click or SoundMgr.SoundName.UI_Switch)
end

--[[----------------------点击选择炸弹技能------------------------]]
function UI10:Button_63_OnClicked()
    local Is_Selected = self:SelectTrapItem(3) -- 是否成功选择陷阽物品
    SoundMgr.PlaySound2D(Is_Selected and SoundMgr.SoundName.UI_Click or SoundMgr.SoundName.UI_Switch)
end

--[[----------------------点击展开折叠面板------------------------]]
function UI10:Button_244_OnClicked()
    self.Fold_Manager:Expand()
    SoundMgr.PlaySound2D(SoundMgr.SoundName.UI_Switch)
end

--[[----------------------点击收起折叠面板------------------------]]
function UI10:Button_245_OnClicked()
    self.Fold_Manager:Collapse()
    SoundMgr.PlaySound2D(SoundMgr.SoundName.Event_Notice)
end

return UI10
