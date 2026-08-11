---@class Skill_Use_01_C:PESkillTemplate_Base_C
--Edit Below--
local Skill_Use_01 = {}

--[[----------------------启用技能并关闭系统失败提示------------------------]]
function Skill_Use_01:OnEnableSkill_BP()
    Skill_Use_01.SuperClass.OnEnableSkill_BP(self)
    self:SetShowTipsEnable(false)
end

--[[----------------------禁用喷射钩爪技能------------------------]]
function Skill_Use_01:OnDisableSkill_BP()
    Skill_Use_01.SuperClass.OnDisableSkill_BP(self)
end

--[[----------------------激活喷射钩爪技能------------------------]]
function Skill_Use_01:OnActivateSkill_BP()
    Skill_Use_01.SuperClass.OnActivateSkill_BP(self)
end

--[[----------------------结束喷射钩爪技能------------------------]]
function Skill_Use_01:OnDeActivateSkill_BP()
    Skill_Use_01.SuperClass.OnDeActivateSkill_BP(self)
end

return Skill_Use_01
