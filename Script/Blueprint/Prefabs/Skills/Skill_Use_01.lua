---@class Skill_Use_01_C:PESkillTemplate_Base_C
--Edit Below--
local Skill_Use_01 = {}
 
function Skill_Use_01:OnEnableSkill_BP()
    Skill_Use_01.SuperClass.OnEnableSkill_BP(self)
end

function Skill_Use_01:OnDisableSkill_BP()
    Skill_Use_01.SuperClass.OnDisableSkill_BP(self)
end

function Skill_Use_01:OnActivateSkill_BP()
    Skill_Use_01.SuperClass.OnActivateSkill_BP(self)
end

function Skill_Use_01:OnDeActivateSkill_BP()
    Skill_Use_01.SuperClass.OnDeActivateSkill_BP(self)
end

function Skill_Use_01:CanActivateSkill_BP()
    return Skill_Use_01.SuperClass.CanActivateSkill_BP(self)
end

return Skill_Use_01