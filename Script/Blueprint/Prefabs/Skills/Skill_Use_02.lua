---@class Skill_Use_02_C:PESkillTemplate_Base_C
--Edit Below--
local Skill_Use_02 = {}

--[[----------------------启用技能并关闭系统失败提示------------------------]]
function Skill_Use_02:OnEnableSkill_BP()
    Skill_Use_02.SuperClass.OnEnableSkill_BP(self)
    self:SetShowTipsEnable(false)
end

--[[----------------------禁用冲天炮技能------------------------]]
function Skill_Use_02:OnDisableSkill_BP()
    Skill_Use_02.SuperClass.OnDisableSkill_BP(self)
end

--[[----------------------启动冲天炮飞行------------------------]]
function Skill_Use_02:OnActivateSkill_BP()
    Skill_Use_02.SuperClass.OnActivateSkill_BP(self)
    if self:HasAuthority() then
        local Player_Controller = self:GetOwnerActor():GetController() -- 技能所属玩家控制器
        Player_Controller:Set_Jetpack_Skill_Flying(true)
    end
end

--[[----------------------停止冲天炮飞行------------------------]]
function Skill_Use_02:OnDeActivateSkill_BP(Reason)
    if self:HasAuthority() then
        local Player_Controller = self:GetOwnerActor():GetController() -- 技能所属玩家控制器
        Player_Controller:Set_Jetpack_Skill_Flying(false)
    end
    Skill_Use_02.SuperClass.OnDeActivateSkill_BP(self, Reason)
end

return Skill_Use_02
