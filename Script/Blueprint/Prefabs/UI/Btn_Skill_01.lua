---@class Btn_Skill_01_C:PESkillWidget
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
---@field NewVar_011 UImage
--Edit Below--
local Btn_Skill_01 = {
	ReadyForActivateTimer = nil,
	PreCDState = false,
	PreEnableState = false,
	PreTagDisableState = false,
}

function Btn_Skill_01:Construct()
	Btn_Skill_01.SuperClass.InitButton(self, self.Image_Icon, self.Text_Name, self.Button_Skill)
	Btn_Skill_01.SuperClass.InitCDProgress(self, self.Text_Time, self.Image_CDTime, self.CanvasPanel_CDtime)
	Btn_Skill_01.SuperClass.InitEnergyProgress(self, self.Image_ChargingCD, self.CanvasPanel_Charging)
	Btn_Skill_01.SuperClass.InitLayer(self, self.Text_Num, self.CanvasPanel_Number)
	Btn_Skill_01.SuperClass.InitEnableState(self, self.CanvasPanel_Lock)
	Btn_Skill_01.SuperClass.InitTagDisableState(self, self.CanvasPanel_Disable)
	Btn_Skill_01.SuperClass.InitVirtualJoystick(self, self.Border_VirtualJoystick, self.PESkillVirtualJoystick_0)
	self.CanvasPanel_OneAvailable:SetVisibility(ESlateVisibility.Collapsed)
end


function Btn_Skill_01:OnSkillBound_BP(InOwnerSkill)
	Btn_Skill_01.SuperClass.OnSkillBound_BP(self, InOwnerSkill)

    if UE.IsValid(InOwnerSkill) then
        self.PreCDState = InOwnerSkill.SkillCD.MaxLayer ~= InOwnerSkill.SkillCD.CurLayer
        self.PreEnableState = InOwnerSkill:IsSkillEnable()
    end
end

function Btn_Skill_01:OnCDStateChange_BP(IsCD)
	local Skill = self:GetCurrentSkill()
	if not Skill then
		return
	end

	-- play effect
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
	Btn_Skill_01.SuperClass.OnCDStateChange_BP(self, IsCD)
end 

function Btn_Skill_01:OnEnableChange_BP(IsEnable)
	Btn_Skill_01.SuperClass.OnEnableChange_BP(self, IsEnable)
	if IsEnable and self.PreEnableState ~= IsEnable then
		self:PlayAnimation(self.DX_UpgradeSkills, 0, 1, EUMGSequencePlayMode.Forward, 1)
	end
	self.PreEnableState = IsEnable
end

function Btn_Skill_01:OnTagDisableChange_BP(IsDisable)
	Btn_Skill_01.SuperClass.OnTagDisableChange_BP(self, IsDisable)
	if not IsDisable and self.PreTagDisableState ~= IsDisable then
		self:PlayAnimation(self.DX_UpgradeSkills_old, 0, 1, EUMGSequencePlayMode.Forward, 1)
	end
	self.PreTagDisableState = IsDisable
end


return Btn_Skill_01