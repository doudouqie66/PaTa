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
---@field TextBlock_0 UTextBlock
---@field NewVar_011 UImage
--Edit Below--
local Jet_Grapple_Item_ID = 8310000 -- 喷射钩爪物品ID
local Jet_Grapple_Product_ID = 9000012 -- 喷射钩爪商品ID
local Btn_Skill_01 = {
	ReadyForActivateTimer = nil,
	PreCDState = false,
	PreEnableState = false,
	PreTagDisableState = false,
}

--[[----------------------构造技能按钮并监听喷射钩爪数量------------------------]]
function Btn_Skill_01:Construct()
	Btn_Skill_01.SuperClass.InitButton(self, self.Image_Icon, self.Text_Name, self.Button_Skill)
	self.Button_Skill.OnPressed:RemoveAll()
	self.Button_Skill.OnPressed:Add(self.OnSkillButtonPressed, self)
	Btn_Skill_01.SuperClass.InitCDProgress(self, self.Text_Time, self.Image_CDTime, self.CanvasPanel_CDtime)
	Btn_Skill_01.SuperClass.InitEnergyProgress(self, self.Image_ChargingCD, self.CanvasPanel_Charging)
	Btn_Skill_01.SuperClass.InitLayer(self, self.Text_Num, self.CanvasPanel_Number)
	Btn_Skill_01.SuperClass.InitEnableState(self, self.CanvasPanel_Lock)
	Btn_Skill_01.SuperClass.InitTagDisableState(self, self.CanvasPanel_Disable)
	Btn_Skill_01.SuperClass.InitVirtualJoystick(self, self.Border_VirtualJoystick, self.PESkillVirtualJoystick_0)
	self.CanvasPanel_OneAvailable:SetVisibility(ESlateVisibility.Collapsed)
	local Player_Controller = UGCGameSystem.GetLocalPlayerController() -- 本地玩家控制器
	self.Backpack_Component = Player_Controller and UGCBackpackSystemV2.GetBackpackComponentV2(Player_Controller) -- 本地玩家背包组件
	if self.Backpack_Component then
		self.Backpack_Component.ItemChangeDelegateV2:Add(self.OnJetGrappleItemChanged, self)
	end
	self:RefreshJetGrappleCount()
end

--[[----------------------销毁技能按钮并取消物品监听------------------------]]
function Btn_Skill_01:Destruct()
	if self.Backpack_Component then
		self.Backpack_Component.ItemChangeDelegateV2:Remove(self.OnJetGrappleItemChanged, self)
	end
end

--[[----------------------按下技能按钮时检查喷射钩爪数量------------------------]]
function Btn_Skill_01:OnSkillButtonPressed()
	local Player_Controller = UGCGameSystem.GetLocalPlayerController() -- 本地玩家控制器
	if Player_Controller and UGCBackpackSystemV2.GetItemCountV2(Player_Controller, Jet_Grapple_Item_ID) < 1 then
		print("[Btn_Skill_01] 喷射钩爪数量不足，打开商品9000012购买窗口")
		L_GloTools.BuyShopProduct(Jet_Grapple_Product_ID)
		return
	end
	Btn_Skill_01.SuperClass.OnIconBtnDownEvent(self)
end

--[[----------------------绑定技能时记录初始状态------------------------]]
function Btn_Skill_01:OnSkillBound_BP(InOwnerSkill)
	Btn_Skill_01.SuperClass.OnSkillBound_BP(self, InOwnerSkill)

    if UE.IsValid(InOwnerSkill) then
        self.PreCDState = InOwnerSkill.SkillCD.MaxLayer ~= InOwnerSkill.SkillCD.CurLayer
        self.PreEnableState = InOwnerSkill:IsSkillEnable()
    end
end

--[[----------------------刷新喷射钩爪数量显示------------------------]]
function Btn_Skill_01:RefreshJetGrappleCount()
	local Player_Controller = UGCGameSystem.GetLocalPlayerController() -- 本地玩家控制器
	if Player_Controller then
		self.TextBlock_0:SetText(tostring(UGCBackpackSystemV2.GetItemCountV2(Player_Controller, Jet_Grapple_Item_ID)))
	end
end

--[[----------------------喷射钩爪数量变化时刷新显示------------------------]]
function Btn_Skill_01:OnJetGrappleItemChanged(Change_Type, Define_ID)
	if Define_ID.TypeSpecificID == Jet_Grapple_Item_ID then
		self:RefreshJetGrappleCount()
	end
end

--[[----------------------处理技能冷却状态变化------------------------]]
function Btn_Skill_01:OnCDStateChange_BP(IsCD)
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
	Btn_Skill_01.SuperClass.OnCDStateChange_BP(self, IsCD)
end 

--[[----------------------处理技能启用状态变化------------------------]]
function Btn_Skill_01:OnEnableChange_BP(IsEnable)
	Btn_Skill_01.SuperClass.OnEnableChange_BP(self, IsEnable)
	if IsEnable and self.PreEnableState ~= IsEnable then
		self:PlayAnimation(self.DX_UpgradeSkills, 0, 1, EUMGSequencePlayMode.Forward, 1)
	end
	self.PreEnableState = IsEnable
end

--[[----------------------处理技能标签禁用状态变化------------------------]]
function Btn_Skill_01:OnTagDisableChange_BP(IsDisable)
	Btn_Skill_01.SuperClass.OnTagDisableChange_BP(self, IsDisable)
	if not IsDisable and self.PreTagDisableState ~= IsDisable then
		self:PlayAnimation(self.DX_UpgradeSkills_old, 0, 1, EUMGSequencePlayMode.Forward, 1)
	end
	self.PreTagDisableState = IsDisable
end


return Btn_Skill_01
