---@class MY_CLS_Skill01_C:PESkillTemplate_Base_C
--Edit Below--
local MY_CLS_Skill01 = {}
 
function MY_CLS_Skill01:OnEnableSkill_BP()
    MY_CLS_Skill01.SuperClass.OnEnableSkill_BP(self)
end

function MY_CLS_Skill01:OnDisableSkill_BP()
    MY_CLS_Skill01.SuperClass.OnDisableSkill_BP(self)
end

function MY_CLS_Skill01:OnActivateSkill_BP()
    MY_CLS_Skill01.SuperClass.OnActivateSkill_BP(self)
end

function MY_CLS_Skill01:OnDeActivateSkill_BP()
    MY_CLS_Skill01.SuperClass.OnDeActivateSkill_BP(self)
end

function MY_CLS_Skill01:CanActivateSkill_BP()
    return MY_CLS_Skill01.SuperClass.CanActivateSkill_BP(self)
end

return MY_CLS_Skill01