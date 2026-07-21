---@class Skill02_C:PESkillTemplate_Base_C
--Edit Below--
local Skill02 = {}
 
function Skill02:OnEnableSkill_BP()
    Skill02.SuperClass.OnEnableSkill_BP(self)
end

function Skill02:OnDisableSkill_BP()
    Skill02.SuperClass.OnDisableSkill_BP(self)
end

function Skill02:OnActivateSkill_BP()
    Skill02.SuperClass.OnActivateSkill_BP(self)
end

function Skill02:OnDeActivateSkill_BP()
    Skill02.SuperClass.OnDeActivateSkill_BP(self)
end

function Skill02:CanActivateSkill_BP()
    return Skill02.SuperClass.CanActivateSkill_BP(self)
end

return Skill02