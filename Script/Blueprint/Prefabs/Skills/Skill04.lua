---@class Skill04_C:PESkillTemplate_Base_C
--Edit Below--
local Skill04 = {}

function Skill04:DestroyMyself()
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

--[[----------------------检查香蕉皮是否允许放置------------------------]]
function Skill04:CanActivateSkill_BP()
    local Player_Pawn = self:GetOwnerComponent():GetNetOwnerActor() -- 使用技能的玩家
    if #UGCPersistEffectSystem.GetBuffsByClass(Player_Pawn, L_Enum.Name_BuffPath.Buff07_2) > 0 then
        if not UGCGameSystem.IsServer() then
            L_TipsTool.ShowTips_01("安全区内不能放置道具", nil, SoundMgr.SoundName.UI_Error)
        end
        return false
    end
    return Skill04.SuperClass.CanActivateSkill_BP(self)
end

return Skill04
