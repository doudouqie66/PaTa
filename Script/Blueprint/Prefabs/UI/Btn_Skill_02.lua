---@class Btn_Skill_02_C:PESkillWidget
---@field DX_UpgradeSkills UWidgetAnimation
---@field DX_UpgradeSkills_old UWidgetAnimation
---@field DX_RefreshSkill UWidgetAnimation
---@field Border_SkillSlot UBorder
---@field Border_VirtualJoystick UBorder
---@field Button_Skill UButton
---@field CanvasPanel_CDtime UCanvasPanel
---@field CanvasPanel_Charging UCanvasPanel
---@field CanvasPanel_Disable UCanvasPanel
---@field CanvasPanel_Lock UCanvasPanel
---@field CanvasPanel_Number UCanvasPanel
---@field CanvasPanel_OneAvailable UCanvasPanel
---@field CanvasPanel_tips UCanvasPanel
---@field Image_BG UImage
---@field Image_CDTime UImage
---@field Image_ChargingCD UImage
---@field Image_Icon UImage
---@field PESkillVirtualJoystick_0 UPESkillVirtualJoystick
---@field Text_LockGrade UTextBlock
---@field Text_Name UTextBlock
---@field Text_Num UTextBlock
---@field Text_Time UTextBlock
---@field TextBlock_0 UTextBlock
---@field NewVar_011 UImage
--Edit Below--
local Jetpack_Item_ID = 8310037 -- 冲天炮物品ID
local Jetpack_Product_ID = 9000010 -- 冲天炮商品ID
local Jetpack_Max_Durability = 10 -- 单个冲天炮最大耐久秒数
local Jetpack_Vertical_Input_Scale = 0.7 -- 冲天炮上升输入比例
local Btn_Skill_02 = {
	ReadyForActivateTimer = nil,
	PreCDState = false,
	PreEnableState = false,
	PreTagDisableState = false,
	Jetpack_Is_Pressed = false,
}

--[[----------------------构造冲天炮技能按钮------------------------]]
function Btn_Skill_02:Construct()
	Btn_Skill_02.SuperClass.InitButton(self, self.Image_Icon, self.Text_Name, self.Button_Skill)
	self.Button_Skill.OnPressed:RemoveAll()
	self.Button_Skill.OnPressed:Add(self.OnSkillButtonPressed, self)
	self.Button_Skill.OnReleased:RemoveAll()
	self.Button_Skill.OnReleased:Add(self.OnSkillButtonReleased, self)
	Btn_Skill_02.SuperClass.InitCDProgress(self, self.Text_Time, self.Image_CDTime, self.CanvasPanel_CDtime)
	Btn_Skill_02.SuperClass.InitEnergyProgress(self, self.Image_ChargingCD, self.CanvasPanel_Charging)
	Btn_Skill_02.SuperClass.InitLayer(self, self.Text_Num, self.CanvasPanel_Number)
	Btn_Skill_02.SuperClass.InitEnableState(self, self.CanvasPanel_Lock)
	Btn_Skill_02.SuperClass.InitTagDisableState(self, self.CanvasPanel_Disable)
	Btn_Skill_02.SuperClass.InitVirtualJoystick(self, self.Border_VirtualJoystick, self.PESkillVirtualJoystick_0)
	self.CanvasPanel_OneAvailable:SetVisibility(ESlateVisibility.Collapsed)
	self.CanvasPanel_Number:SetVisibility(ESlateVisibility.Collapsed)
	self.TextBlock_0:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
	local UI_Path = L_Enum.Name_ClassPath.UI_Fly -- 冲天炮进度条界面路径
	L_GloTools.UIMgr(UI_Path, true, false)
	L_GloTools.UI_Map[UI_Path]:SetSkillJetpackProgressVisible(false)
	local Player_Controller = UGCGameSystem.GetLocalPlayerController() -- 本地玩家控制器
	self.Backpack_Component = Player_Controller and UGCBackpackSystemV2.GetBackpackComponentV2(Player_Controller) -- 本地玩家背包组件
	if self.Backpack_Component then
		self.Backpack_Component.ItemChangeDelegateV2:Add(self.OnJetpackItemChanged, self)
	end
	self:RefreshJetpackCount()
end

--[[----------------------销毁冲天炮技能按钮------------------------]]
function Btn_Skill_02:Destruct()
	self.Jetpack_Is_Pressed = false
	if self.Backpack_Component then
		self.Backpack_Component.ItemChangeDelegateV2:Remove(self.OnJetpackItemChanged, self)
	end
	local Fly_UI = L_GloTools.UI_Map[L_Enum.Name_ClassPath.UI_Fly] -- 已创建的冲天炮进度条界面
	if Fly_UI then
		Fly_UI:SetSkillJetpackProgressVisible(false)
	end
	local Skill = self:GetCurrentSkill() -- 当前冲天炮技能
	if Skill and Skill:IsActivating() then
		Skill:DeActivateSkill(EPESkillDeActivateReason.E_PESKILL_DeActivateReason_Cancel)
	end
end

--[[----------------------按下按钮时启动冲天炮技能------------------------]]
function Btn_Skill_02:OnSkillButtonPressed()
	local Player_Controller = UGCGameSystem.GetLocalPlayerController() -- 本地玩家控制器
	if Player_Controller and UGCBackpackSystemV2.GetItemCountV2(Player_Controller, Jetpack_Item_ID) < 1 then
		L_GloTools.BuyShopProduct(Jetpack_Product_ID)
		return
	end
	local Skill = self:GetCurrentSkill() -- 当前冲天炮技能
	if self.Jetpack_Is_Pressed or not Skill or not Skill:CanActivateSkill() then
		return
	end
	self.Jetpack_Is_Pressed = true
	local Fly_UI = L_GloTools.UI_Map[L_Enum.Name_ClassPath.UI_Fly] -- 冲天炮耐久界面
	if Fly_UI then
		Fly_UI:SetSkillJetpackProgressVisible(true)
	end
	Skill:ActivateSkill()
end

--[[----------------------刷新冲天炮数量和耐久显示------------------------]]
function Btn_Skill_02:RefreshJetpackCount()
	local Player_Controller = UGCGameSystem.GetLocalPlayerController() -- 本地玩家控制器
	if not Player_Controller then
		return
	end

	local Item_Count = UGCBackpackSystemV2.GetItemCountV2(Player_Controller, Jetpack_Item_ID) -- 当前冲天炮数量
	self.TextBlock_0:SetText(tostring(Item_Count))
	local Durability = Player_Controller.Jetpack_Durability or 0 -- 当前冲天炮耐久秒数
	if Item_Count > 0 and Durability <= 0 then
		local Item_Define_IDs = UGCBackpackSystemV2.GetItemDefineIDsByIDV2(Player_Controller, Jetpack_Item_ID) -- 冲天炮实例列表
		local Custom_Data = Item_Define_IDs[1] and UGCItemSystemV2.LoadItemCustomData(Item_Define_IDs[1]) or {} -- 当前冲天炮实例数据
		Durability = Custom_Data.Jetpack_Durability or Jetpack_Max_Durability
	end
	local Fly_UI = L_GloTools.UI_Map[L_Enum.Name_ClassPath.UI_Fly] -- 冲天炮耐久界面
	if Fly_UI then
		Fly_UI:SetJetpackDurability(Item_Count > 0 and Durability / Jetpack_Max_Durability or 0)
	end
end

--[[----------------------冲天炮物品变化时刷新技能状态------------------------]]
function Btn_Skill_02:OnJetpackItemChanged(Change_Type, Define_ID)
	if Define_ID.TypeSpecificID ~= Jetpack_Item_ID then
		return
	end
	if self.Jetpack_Is_Pressed then
		self:OnSkillButtonReleased()
	end
	self:RefreshJetpackCount()
end

--[[----------------------松开按钮时停止冲天炮技能------------------------]]
function Btn_Skill_02:OnSkillButtonReleased()
	self.Jetpack_Is_Pressed = false
	local Fly_UI = L_GloTools.UI_Map[L_Enum.Name_ClassPath.UI_Fly] -- 冲天炮耐久界面
	if Fly_UI then
		Fly_UI:SetSkillJetpackProgressVisible(false)
	end
	local Skill = self:GetCurrentSkill() -- 当前冲天炮技能
	if Skill and Skill:IsActivating() then
		Skill:DeActivateSkill(EPESkillDeActivateReason.E_PESKILL_DeActivateReason_Cancel)
	end
end

--[[----------------------按住按钮时持续输入上升方向------------------------]]
function Btn_Skill_02:Tick(MyGeometry, InDeltaTime)
	if self.Jetpack_Is_Pressed then
		UGCGameSystem.GetLocalPlayerPawn():AddMovementInput(Vector.New(0, 0, 1), Jetpack_Vertical_Input_Scale, false)
	end
end

--[[----------------------绑定技能时记录初始状态------------------------]]
function Btn_Skill_02:OnSkillBound_BP(InOwnerSkill)
	Btn_Skill_02.SuperClass.OnSkillBound_BP(self, InOwnerSkill)

    if UE.IsValid(InOwnerSkill) then
        self.PreCDState = InOwnerSkill.SkillCD.MaxLayer ~= InOwnerSkill.SkillCD.CurLayer
        self.PreEnableState = InOwnerSkill:IsSkillEnable()
    end
end

--[[----------------------处理技能冷却状态变化------------------------]]
function Btn_Skill_02:OnCDStateChange_BP(IsCD)
	local Skill = self:GetCurrentSkill()
	if not Skill then
		return
	end

	-- 播放技能就绪特效
	if not IsCD and self.PreCDState ~= IsCD then
		self.CanvasPanel_OneAvailable:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
		self:PlayAnimation(self.DX_RefreshSkill, 0, 1, EUMGSequencePlayMode.Forward, 1)
		if self.ReadyForActivateTimer then
			Timer.RemoveTimer(self.ReadyForActivateTimer)
		end
		self.ReadyForActivateTimer = Timer.InsertTimer(1, function()
			if self and UE.IsValid(self) then
				self.CanvasPanel_OneAvailable:SetVisibility(ESlateVisibility.Collapsed)
				self.ReadyForActivateTimer = nil
			end
		end, false)
	end

	self.PreCDState = IsCD
	Btn_Skill_02.SuperClass.OnCDStateChange_BP(self, IsCD)
end 

--[[----------------------处理技能启用状态变化------------------------]]
function Btn_Skill_02:OnEnableChange_BP(IsEnable)
	Btn_Skill_02.SuperClass.OnEnableChange_BP(self, IsEnable)
	if IsEnable and self.PreEnableState ~= IsEnable then
		self:PlayAnimation(self.DX_UpgradeSkills, 0, 1, EUMGSequencePlayMode.Forward, 1)
	end
	self.PreEnableState = IsEnable
end

--[[----------------------处理技能标签禁用状态变化------------------------]]
function Btn_Skill_02:OnTagDisableChange_BP(IsDisable)
	Btn_Skill_02.SuperClass.OnTagDisableChange_BP(self, IsDisable)
	if not IsDisable and self.PreTagDisableState ~= IsDisable then
		self:PlayAnimation(self.DX_UpgradeSkills_old, 0, 1, EUMGSequencePlayMode.Forward, 1)
	end
	self.PreTagDisableState = IsDisable
end


return Btn_Skill_02
