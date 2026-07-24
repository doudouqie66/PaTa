---@class UI07_C:UUserWidget
---@field Button_60 UButton
---@field Button_66 UButton
---@field Button_67 UButton
---@field Button_68 UButton
---@field Button_69 UButton
---@field Button_70 UButton
---@field Button_71 UButton
---@field Button_72 UButton
---@field Button_73 UButton
---@field Button_74 UButton
---@field Button_75 UButton
---@field Button_76 UButton
---@field Button_159 UButton
---@field Image_0 UImage
---@field Image_18 UImage
---@field Image_99 UImage
---@field TextBlock_191 UTextBlock
-- Edit Below--
---@class UI07_C:UUserWidget
---@field Button_60 UButton
---@field Button_66 UButton
---@field Button_67 UButton
---@field Button_68 UButton
---@field Button_69 UButton
---@field Button_70 UButton
---@field Button_71 UButton
---@field Button_72 UButton
---@field Button_73 UButton
---@field Button_74 UButton
---@field Button_75 UButton
---@field Button_76 UButton
---@field Button_159 UButton
---@field Image_0 UImage
---@field Image_18 UImage
---@field Image_99 UImage
-- Edit Below--
local UI07 = {
    bInitDoOnce = false,
    Input_Pass = "" -- 当前输入的密码
}

--[[----------------------初始化密码输入界面------------------------]]
function UI07:Construct()
    self.Input_Pass = ""
    self.TextBlock_191:SetText("")
    self:LuaInit()
end

--[[----------------------绑定密码界面按钮事件------------------------]]
function UI07:LuaInit()
    if self.bInitDoOnce then
        return
    end
    self.bInitDoOnce = true
    self.Button_159.OnClicked:Add(self.Button_159_OnClicked, self)
    self.Button_60.OnClicked:Add(self.Button_60_OnClicked, self)
    self.Button_66.OnClicked:Add(self.Button_66_OnClicked, self)
    self.Button_67.OnClicked:Add(self.Button_67_OnClicked, self)
    self.Button_68.OnClicked:Add(self.Button_68_OnClicked, self)
    self.Button_69.OnClicked:Add(self.Button_69_OnClicked, self)
    self.Button_70.OnClicked:Add(self.Button_70_OnClicked, self)
    self.Button_71.OnClicked:Add(self.Button_71_OnClicked, self)
    self.Button_72.OnClicked:Add(self.Button_72_OnClicked, self)
    self.Button_73.OnClicked:Add(self.Button_73_OnClicked, self)
    self.Button_75.OnClicked:Add(self.Button_75_OnClicked, self)
    self.Button_74.OnClicked:Add(self.Button_74_OnClicked, self)
    self.Button_76.OnClicked:Add(self.Button_76_OnClicked, self)
end

--[[----------------------关闭密码输入界面------------------------]]
function UI07:Button_159_OnClicked()
    L_GloTools.UIMgr(L_Enum.Name_ClassPath.UI07, false)
end

--[[----------------------追加密码数字------------------------]]
function UI07:AppendPassNumber(Number)
    if #self.Input_Pass >= 4 then
        L_TipsTool.ShowTips_01("请先清除")
        return
    end

    self.Input_Pass = self.Input_Pass .. tostring(Number)
    self.TextBlock_191:SetText(self.Input_Pass)
end

--[[----------------------数字1按键点击------------------------]]
function UI07:Button_60_OnClicked()
    self:AppendPassNumber(1)
end

--[[----------------------数字2按键点击------------------------]]
function UI07:Button_66_OnClicked()
    self:AppendPassNumber(2)
end

--[[----------------------数字3按键点击------------------------]]
function UI07:Button_67_OnClicked()
    self:AppendPassNumber(3)
end

--[[----------------------数字4按键点击------------------------]]
function UI07:Button_68_OnClicked()
    self:AppendPassNumber(4)
end

--[[----------------------数字5按键点击------------------------]]
function UI07:Button_69_OnClicked()
    self:AppendPassNumber(5)
end

--[[----------------------数字6按键点击------------------------]]
function UI07:Button_70_OnClicked()
    self:AppendPassNumber(6)
end

--[[----------------------数字7按键点击------------------------]]
function UI07:Button_71_OnClicked()
    self:AppendPassNumber(7)
end

--[[----------------------数字8按键点击------------------------]]
function UI07:Button_72_OnClicked()
    self:AppendPassNumber(8)
end

--[[----------------------数字9按键点击------------------------]]
function UI07:Button_73_OnClicked()
    self:AppendPassNumber(9)
end

--[[----------------------数字0按键点击------------------------]]
function UI07:Button_75_OnClicked()
    self:AppendPassNumber(0)
end

--[[----------------------清除按键点击------------------------]]
function UI07:Button_74_OnClicked()
    self.Input_Pass = ""
    self.TextBlock_191:SetText("")
end

--[[----------------------确认按键点击------------------------]]
function UI07:Button_76_OnClicked()
    if #self.Input_Pass ~= 4 then
        L_TipsTool.ShowTips_01("请输入四位密码")
        return
    end
    local PC = UGCGameSystem.GetLocalPlayerController()

    local Game_State = UGCGameSystem.GameState -- 当前房间状态
    if tonumber(self.Input_Pass) == Game_State.Room_Pass then
        L_TipsTool.ShowTips_01("密码正确")
        L_GloTools.UIMgr(L_Enum.Name_ClassPath.UI07, false)

        UnrealNetwork.CallUnrealRPC(PC, UGCGameSystem.GameState, L_Enum.Name_RPC.Men_State, true)

        -- 重新生成密码
        UnrealNetwork.CallUnrealRPC(PC, PC, L_Enum.Name_RPC.New_Pass)

    else
        L_TipsTool.ShowTips_01("密码错误")
        self.Input_Pass = ""
        self.TextBlock_191:SetText("")
    end
end

return UI07
