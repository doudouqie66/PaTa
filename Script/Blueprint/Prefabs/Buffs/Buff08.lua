---@class Buff08_C:PersistEffectBuff
--Edit Below--
local Buff08 = {}

local Magic_Carpet_Item_ID = 8310038 -- 魔毯物品ID
 
-- buff启动条件
--[[
function Buff08:CanApply_BP(OwnerActor)
-- return true
end
--]]

--[[----------------------Buff挂载时启用魔毯飞行------------------------]]
function Buff08:OnApply_BP(OwnerActor)
    if self:HasAuthority() then
        local Player_Controller = OwnerActor:GetController() -- Buff所属玩家控制器
        self.Original_Flying_Item_ID = Player_Controller.Flying_Item_ID -- Buff前飞行物ID
        Player_Controller:Update_Flying_Item(Magic_Carpet_Item_ID, true)
    end
end

--[[----------------------Buff移除时关闭魔毯飞行------------------------]]
function Buff08:OnUnApply_BP(OwnerActor, Reason)
    if self:HasAuthority() then
        local Player_Controller = OwnerActor:GetController() -- Buff所属玩家控制器
        Player_Controller:Update_Flying_Item(Magic_Carpet_Item_ID, false)
        if self.Original_Flying_Item_ID ~= 0 then
            Player_Controller:Update_Flying_Item(self.Original_Flying_Item_ID, true)
        end
    end
end

-- buff合并条件，A为当前身上已有buff，B为外来buff，当要挂载外来buff时会判断A.CanMerge(B)
--[[
function Buff08:CanMerge_BP(PersistEffect)
-- return true
end
--]]

-- buff合并，A为当前身上已有buff，B为外来buff，调用A.OnMerge(B)
--[[
function Buff08:OnMerge_BP(PersistEffect)

end
--]]

--[[
function Buff08:OnInterrupted_BP(OwnerActor)

end
--]]

-- buff总持续时长变化，如修改ApplyTime、修改StackNum
--[[
function Buff08:OnTotalDurationChange_BP(PreTime, CurTime)

end
--]]

-- buff堆叠层数变化
--[[
function Buff08:OnStackChange_BP(PreNum, CurNum)

end
--]]

-- buff触发前条件判断
--[[
function Buff08:CanTrigger_BP()
	return true
end
--]]

-- buff触发效果
--[[
function Buff08:OnTrigger_BP(Delta)

end
--]]

return Buff08
