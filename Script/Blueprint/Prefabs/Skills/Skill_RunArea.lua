---@class Skill_RunArea_C:PESkillTemplate_Base_C
---@field SetterActors ULuaArrayHelper<AEmitter>
---@field SetterActors_1 ULuaArrayHelper<AEmitter>
--Edit Below--
local Skill_RunArea = {}
 
function Skill_RunArea:OnEnableSkill_BP()
    Skill_RunArea.SuperClass.OnEnableSkill_BP(self)
end

function Skill_RunArea:OnDisableSkill_BP()
    Skill_RunArea.SuperClass.OnDisableSkill_BP(self)
end

function Skill_RunArea:OnActivateSkill_BP()
    Skill_RunArea.SuperClass.OnActivateSkill_BP(self)
end

function Skill_RunArea:OnDeActivateSkill_BP()
    Skill_RunArea.SuperClass.OnDeActivateSkill_BP(self)
end

function Skill_RunArea:CanActivateSkill_BP()
    return Skill_RunArea.SuperClass.CanActivateSkill_BP(self)
end

return Skill_RunArea