---@class Skill04_2_C:PESkillTemplate_Base_C
--Edit Below--
local Skill04_2 = {}
 
function Skill04_2:OnEnableSkill_BP()
    Skill04_2.SuperClass.OnEnableSkill_BP(self)
end

function Skill04_2:OnDisableSkill_BP()
    Skill04_2.SuperClass.OnDisableSkill_BP(self)
end

function Skill04_2:OnActivateSkill_BP()
    Skill04_2.SuperClass.OnActivateSkill_BP(self)
end

function Skill04_2:OnDeActivateSkill_BP()
    Skill04_2.SuperClass.OnDeActivateSkill_BP(self)
end

function Skill04_2:CanActivateSkill_BP()
    return Skill04_2.SuperClass.CanActivateSkill_BP(self)
end

return Skill04_2