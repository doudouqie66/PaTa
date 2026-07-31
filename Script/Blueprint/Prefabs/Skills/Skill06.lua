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
--[[----------------------检查炸弹是否允许放置------------------------]]
function Skill06:CanActivateSkill_BP()
    local Player_Pawn = self:GetOwnerComponent():GetNetOwnerActor() -- 使用技能的玩家
    if #UGCPersistEffectSystem.GetBuffsByClass(Player_Pawn, L_Enum.Name_BuffPath.Buff07_2) > 0 then
        if not UGCGameSystem.IsServer() then
            L_TipsTool.ShowTips_01("安全区内不能放置道具", nil, SoundMgr.SoundName.UI_Error)
        end
        return false
    end
    return Skill06.SuperClass.CanActivateSkill_BP(self)
end

return Skill06
