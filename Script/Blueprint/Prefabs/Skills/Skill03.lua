---@class Skill03_C:PESkillTemplate_Base_C
--Edit Below--
local Skill03 = {}
 
function Skill03:OnEnableSkill_BP()
    Skill03.SuperClass.OnEnableSkill_BP(self)
end

function Skill03:OnDisableSkill_BP()
    Skill03.SuperClass.OnDisableSkill_BP(self)
end

function Skill03:OnActivateSkill_BP()
    Skill03.SuperClass.OnActivateSkill_BP(self)
end

function Skill03:OnDeActivateSkill_BP()
    Skill03.SuperClass.OnDeActivateSkill_BP(self)
end

function Skill03:CanActivateSkill_BP()
    return Skill03.SuperClass.CanActivateSkill_BP(self)
end

return Skill03