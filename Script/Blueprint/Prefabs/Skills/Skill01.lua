---@class Skill01_C:PESkillTemplate_Base_C
--Edit Below--
local Skill01 = {}
 
function Skill01:OnEnableSkill_BP()
    Skill01.SuperClass.OnEnableSkill_BP(self)
end

function Skill01:OnDisableSkill_BP()
    Skill01.SuperClass.OnDisableSkill_BP(self)
end

function Skill01:OnActivateSkill_BP()
    Skill01.SuperClass.OnActivateSkill_BP(self)
end

function Skill01:OnDeActivateSkill_BP()
    Skill01.SuperClass.OnDeActivateSkill_BP(self)
end

function Skill01:CanActivateSkill_BP()
    return Skill01.SuperClass.CanActivateSkill_BP(self)
end

return Skill01