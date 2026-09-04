---@class MY_CLS_SKill02_C:PESkillTemplate_Base_C
--Edit Below--
local MY_CLS_SKill02 = {}
 
function MY_CLS_SKill02:OnEnableSkill_BP()
    MY_CLS_SKill02.SuperClass.OnEnableSkill_BP(self)
end

function MY_CLS_SKill02:OnDisableSkill_BP()
    MY_CLS_SKill02.SuperClass.OnDisableSkill_BP(self)
end

function MY_CLS_SKill02:OnActivateSkill_BP()
    MY_CLS_SKill02.SuperClass.OnActivateSkill_BP(self)
end

function MY_CLS_SKill02:OnDeActivateSkill_BP()
    MY_CLS_SKill02.SuperClass.OnDeActivateSkill_BP(self)
end

function MY_CLS_SKill02:CanActivateSkill_BP()
    return MY_CLS_SKill02.SuperClass.CanActivateSkill_BP(self)
end

return MY_CLS_SKill02