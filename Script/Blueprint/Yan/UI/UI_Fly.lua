---@class UI_Fly_C:UUserWidget
---@field Button_46 UButton
---@field Button_85 UButton
---@field Button_329 UButton
---@field UI_CTP_NJ UI_CTP_NJ_C
--Edit Below--
---@class UI_Fly_C:UUserWidget
---@field Button_46 UButton
---@field Button_85 UButton
---@field Button_329 UButton
--Edit Below--
---@class UI_Fly_C:UUserWidget
---@field Button_46 UButton
---@field Button_85 UButton
---@field Button_329 UButton
--Edit Below--
local UI_Fly = {}

local Jetpack_Item_ID = 8310037 -- 冲天炮物品ID
local Magic_Carpet_Item_ID = 8310038 -- 魔毯物品ID
local Jetpack_Vertical_Input_Scale = 1 -- 冲天炮上升输入比例
local Magic_Carpet_Vertical_Input_Scale = 2 -- 魔毯升降输入比例
local Magic_Carpet_Max_Fly_Speed = 250 -- 魔毯最高飞行速度
local Jetpack_Skill_Max_Fly_Speed = 500 -- 技能冲天炮最高飞行速度
-- local Magic_Carpet_Max_Fly_Speed = 2500 -- 魔毯最高飞行速度

local Magic_Carpet_Braking_Deceleration = 2048 -- 魔毯飞行制动力

--[[----------------------初始化飞行界面------------------------]]
function UI_Fly:Construct()
    self:LuaInit()
end

--[[----------------------按住飞行按钮时持续输入升降方向------------------------]]
function UI_Fly:Tick(MyGeometry, InDeltaTime)
    local Vertical_Input_Value = self.Magic_Carpet_Vertical_Input_Value -- 魔毯升降输入值
    if self.Jetpack_Is_Pressed then
        Vertical_Input_Value = Jetpack_Vertical_Input_Scale
    end
    if Vertical_Input_Value ~= 0 then
        UGCGameSystem.GetLocalPlayerPawn():AddMovementInput(Vector.New(0, 0, 1), Vertical_Input_Value, false)
    end
end

--[[----------------------销毁飞行界面并停止推进------------------------]]
function UI_Fly:Destruct()
    if self.Jetpack_Is_Pressed then
        self:SetJetpackFlying(false)
    end
    self:RestoreMagicCarpetMovement()
end

--[[----------------------绑定飞行按钮事件------------------------]]
function UI_Fly:LuaInit()
    if self.bInitDoOnce then
        return
    end
    self.bInitDoOnce = true
    self.Jetpack_Is_Pressed = false -- 飞行按钮按住状态
    self.Magic_Carpet_Vertical_Input_Value = 0 -- 魔毯升降输入值

    self.Button_46.OnPressed:Add(self.Button_46_OnPressed, self)
    self.Button_46.OnReleased:Add(self.Button_46_OnReleased, self)
    self.Button_85.OnPressed:Add(self.Button_85_OnPressed, self)
    self.Button_85.OnReleased:Add(self.Button_85_OnReleased, self)
    self.Button_329.OnPressed:Add(self.Button_329_OnPressed, self)
    self.Button_329.OnReleased:Add(self.Button_329_OnReleased, self)
end

--[[----------------------应用本地魔毯移动参数------------------------]]
function UI_Fly:ApplyMagicCarpetMovement(Max_Fly_Speed)
    if self.Magic_Carpet_Movement_Applied then
        return
    end

    Max_Fly_Speed = Max_Fly_Speed or Magic_Carpet_Max_Fly_Speed
    local Character_Movement = UGCGameSystem.GetLocalPlayerPawn().CharacterMovement -- 本地角色移动组件
    self.Original_Max_Fly_Speed = Character_Movement.MaxFlySpeed
    self.Original_Braking_Deceleration_Flying = Character_Movement.BrakingDecelerationFlying
    Character_Movement.MaxFlySpeed = Max_Fly_Speed
    Character_Movement.BrakingDecelerationFlying = Magic_Carpet_Braking_Deceleration
    self.Magic_Carpet_Movement_Applied = true
end

--[[----------------------恢复本地角色移动参数------------------------]]
function UI_Fly:RestoreMagicCarpetMovement()
    if not self.Magic_Carpet_Movement_Applied then
        return
    end

    local Player_Pawn = UGCGameSystem.GetLocalPlayerPawn() -- 本地玩家角色
    if not Player_Pawn then
        self.Magic_Carpet_Movement_Applied = false
        return
    end
    local Character_Movement = Player_Pawn.CharacterMovement -- 本地角色移动组件
    Character_Movement.MaxFlySpeed = self.Original_Max_Fly_Speed
    Character_Movement.BrakingDecelerationFlying = self.Original_Braking_Deceleration_Flying
    self.Magic_Carpet_Movement_Applied = false
end

--[[----------------------根据已装备飞行物刷新按钮------------------------]]
function UI_Fly:SetFlyingItem(Flying_Item_ID)
    if Flying_Item_ID ~= Jetpack_Item_ID and self.Jetpack_Is_Pressed then
        self.Jetpack_Is_Pressed = false
        self:SetJetpackFlying(false)
    end

    self.Magic_Carpet_Vertical_Input_Value = 0
    local Is_Jetpack = Flying_Item_ID == Jetpack_Item_ID -- 是否装备冲天炮
    local Is_Magic_Carpet = Flying_Item_ID == Magic_Carpet_Item_ID -- 是否装备魔毯
    if Is_Jetpack or Is_Magic_Carpet then
        self:ApplyMagicCarpetMovement()
    else
        self:RestoreMagicCarpetMovement()
    end
    local Jetpack_Button_Visibility = Is_Jetpack and ESlateVisibility.Visible or ESlateVisibility.Collapsed -- 冲天炮按钮状态
    local Magic_Carpet_Button_Visibility = Is_Magic_Carpet and ESlateVisibility.Visible or ESlateVisibility.Collapsed -- 魔毯按钮状态

    self.Button_46:SetIsEnabled(Is_Jetpack)
    self.Button_46:SetVisibility(Jetpack_Button_Visibility)
    self.Button_85:SetIsEnabled(Is_Magic_Carpet)
    self.Button_85:SetVisibility(Magic_Carpet_Button_Visibility)
    self.Button_329:SetIsEnabled(Is_Magic_Carpet)
    self.Button_329:SetVisibility(Magic_Carpet_Button_Visibility)
    self.UI_CTP_NJ:SetVisibility(Is_Jetpack and ESlateVisibility.SelfHitTestInvisible or ESlateVisibility.Collapsed)
    self:SetVisibility((Is_Jetpack or Is_Magic_Carpet) and ESlateVisibility.SelfHitTestInvisible or
                           ESlateVisibility.Collapsed)
    if self.Skill_Jetpack_Progress_Visible then
        self:SetSkillJetpackProgressVisible(true)
    end
end

--[[----------------------只显示技能冲天炮进度条------------------------]]
function UI_Fly:SetSkillJetpackProgressVisible(Is_Visible)
    self.Skill_Jetpack_Progress_Visible = Is_Visible
    if Is_Visible then
        self:ApplyMagicCarpetMovement(Jetpack_Skill_Max_Fly_Speed)
        self.Button_46:SetVisibility(ESlateVisibility.Collapsed)
        self.Button_85:SetVisibility(ESlateVisibility.Collapsed)
        self.Button_329:SetVisibility(ESlateVisibility.Collapsed)
        self.UI_CTP_NJ:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.UI_CTP_NJ:SetPercent(1)
        self:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        return
    end

    local Player_Controller = UGCGameSystem.GetLocalPlayerController() -- 本地玩家控制器
    self:SetFlyingItem(Player_Controller and Player_Controller.Flying_Item_ID or 0)
end

--[[----------------------根据冲天炮耐久刷新飞行按钮------------------------]]
function UI_Fly:SetJetpackDurability(Durability_Percent)
    self.UI_CTP_NJ:SetPercent(Durability_Percent)
    if Durability_Percent <= 0 and self.Jetpack_Is_Pressed then
        self.Jetpack_Is_Pressed = false
        self:SetJetpackFlying(false)
    end
    if UGCGameSystem.GetLocalPlayerController().Flying_Item_ID == Jetpack_Item_ID then
        self.Button_46:SetIsEnabled(Durability_Percent > 0)
    end
end

--[[----------------------请求服务器设置冲天炮飞行状态------------------------]]
function UI_Fly:SetJetpackFlying(Is_Flying)
    local Player_Controller = UGCGameSystem.GetLocalPlayerController() -- 本地玩家控制器
    if Player_Controller then
        UnrealNetwork.CallUnrealRPC(Player_Controller, Player_Controller, "Set_Jetpack_Flying", Is_Flying)
    end
end

--[[----------------------按下飞行按钮启动推进------------------------]]
function UI_Fly:Button_46_OnPressed()
    if self.Jetpack_Is_Pressed then
        return
    end

    self.Jetpack_Is_Pressed = true
    self:SetJetpackFlying(true)
end

--[[----------------------松开飞行按钮停止推进------------------------]]
function UI_Fly:Button_46_OnReleased()
    self.Jetpack_Is_Pressed = false
    self:SetJetpackFlying(false)
end

--[[----------------------按下魔毯上升按钮------------------------]]
function UI_Fly:Button_85_OnPressed()
    self.Magic_Carpet_Vertical_Input_Value = Magic_Carpet_Vertical_Input_Scale
end

--[[----------------------松开魔毯上升按钮------------------------]]
function UI_Fly:Button_85_OnReleased()
    if self.Magic_Carpet_Vertical_Input_Value > 0 then
        self.Magic_Carpet_Vertical_Input_Value = 0
    end
end

--[[----------------------按下魔毯下降按钮------------------------]]
function UI_Fly:Button_329_OnPressed()
    self.Magic_Carpet_Vertical_Input_Value = -Magic_Carpet_Vertical_Input_Scale
end

--[[----------------------松开魔毯下降按钮------------------------]]
function UI_Fly:Button_329_OnReleased()
    if self.Magic_Carpet_Vertical_Input_Value < 0 then
        self.Magic_Carpet_Vertical_Input_Value = 0
    end
end

return UI_Fly
