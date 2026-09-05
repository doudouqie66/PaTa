---@class Skill02_C:PESkillTemplate_Base_C
--Edit Below--
local Skill02 = {}

--[[----------------------启用技能并关闭系统失败提示------------------------]]
function Skill02:OnEnableSkill_BP()
    Skill02.SuperClass.OnEnableSkill_BP(self)
    self:SetShowTipsEnable(false)
end

--[[----------------------禁用技能------------------------]]
function Skill02:OnDisableSkill_BP()
    Skill02.SuperClass.OnDisableSkill_BP(self)
end

--[[----------------------激活技能------------------------]]
function Skill02:OnActivateSkill_BP()
    Skill02.SuperClass.OnActivateSkill_BP(self)
end

--[[----------------------结束技能------------------------]]
function Skill02:OnDeActivateSkill_BP()
    Skill02.SuperClass.OnDeActivateSkill_BP(self)
end

--[[----------------------检查技能激活条件并提示剩余冷却------------------------]]
function Skill02:CanActivateSkill_BP()
    if not self:CheckCDReady() then
        if not UGCGameSystem.IsServer() then
            local Remaining_CD = math.ceil(self:GetRemainingCDTime()) -- 技能剩余冷却秒数
            L_TipsTool.ShowTips_01("技能冷却还有" .. Remaining_CD .. "秒")
        end
        return false
    end

    return Skill02.SuperClass.CanActivateSkill_BP(self)
end

return Skill02
