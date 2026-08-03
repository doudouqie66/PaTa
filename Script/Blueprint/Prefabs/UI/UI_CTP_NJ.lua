---@class UI_CTP_NJ_C:UAEUserWidget
---@field background UImage
---@field Dark_Image UImage
---@field Light_Image UImage
---@field TextBlock_0 UTextBlock
---@field Material_Instance UMaterialInstanceDynamic
---@field Percent float
---@field Start_Point FUGC_GradualColorPoint__pf2209879471
---@field End_Point FUGC_GradualColorPoint__pf2209879471
--Edit Below--
---@class UI_CTP_NJ:UUAEUserWidget
---@field Percent float
---@field Light_Image UImage
---@field Material_Instance UMaterialInstanceDynamic

local UI_CTP_NJ = {
	OldPercent = 0.0,
}
function UI_CTP_NJ:Construct()
	--print("UI_CTP_NJ:Construct")

	self.Material_Instance = self.Light_Image:GetDynamicMaterial()
	self.Material_Instance:SetScalarParameterValue("Start_Percent", self.Start_Point.percent)

	self.Material_Instance:SetScalarParameterValue("End_Percent", self.End_Point.percent)
end

function UI_CTP_NJ:Destruct()
	if UGCTimerUtility.IsLuaTimerExistByName("Duration_Timer") then
		UGCTimerUtility.RemoveLuaTimerByName("Duration_Timer")
	end
end

function UI_CTP_NJ:SetPercent(InPercent)
	log("UI_CTP_NJ:SetPercent" .. tostring(InPercent))
	self.Percent = KismetMathLibrary.FClamp(InPercent, 0.0, 1.0)
	self.Material_Instance:SetScalarParameterValue("Percent", self.Percent)
	self.TextBlock_0:SetText(string.format("%.0f", self.Percent * 100))
end

-------------------------------PETaskProgressInterface------------------------------------

function UI_CTP_NJ:SetDuration(duration)
	self.duration = duration
	self.along_duration = 0.0
	self.frequence = 0.05
	self:SetPercent(self.along_duration)

	UGCTimerUtility.CreateLuaTimer(self.frequence, function()
		self.along_duration = self.along_duration + self.frequence
		if self.along_duration > self.duration then
			UGCTimerUtility.RemoveLuaTimerByName("Duration_Timer")
		end
		self:SetPercent(self.along_duration / self.duration)
		self:OnPercentChanged(self.OldPercent, self.along_duration / self.duration)
		self.OldPercent = self.along_duration / self.duration
	end, true, "Duration_Timer")
end

function UI_CTP_NJ:OnPercentChanged(OldPercent, NewPercent)
	
end


function UI_CTP_NJ:SetText(text)
	self.TextBlock_0:SetText(text)
end

function UI_CTP_NJ:SetSkill(text) end

function UI_CTP_NJ:SetColor(LineColor) end

-------------------------------PETaskProgressInterface------------------------------------

return UI_CTP_NJ
