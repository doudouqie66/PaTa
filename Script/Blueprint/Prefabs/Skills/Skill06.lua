---@class Skill06_C:PESkillTemplate_Base_C
--Edit Below--
local Skill06 = {}

function Skill06:DestroyMyself()
    local peskill_component = self:GetOwnerComponent()
    if not peskill_component then
        return
    end

    local owner_actor = peskill_component:GetNetOwnerActor()
    if not UE.IsValid(owner_actor) then
        return
    end
    owner_actor:K2_DestroyActor()
end

return Skill06