---@class Buff10_C:PersistEffectBuff
-- Edit Below--
local Buff10 = {}

-- buff启动条件
--[[
function Buff10:CanApply_BP(OwnerActor)
-- return true
end
--]]

-- buff合并条件，A为当前身上已有buff，B为外来buff，当要挂载外来buff时会判断A.CanMerge(B)
--[[
function Buff10:CanMerge_BP(PersistEffect)
-- return true
end
--]]

-- buff合并，A为当前身上已有buff，B为外来buff，调用A.OnMerge(B)
--[[
function Buff10:OnMerge_BP(PersistEffect)

end
--]]

-- 开启Tick需要SetTickEnable(true)，或buff为间隔触发类型会自动开启
--[[
function Buff10:Tick_BP(OwnerActor, DeltaTime)

end
--]]

--[[
function Buff10:OnInterrupted_BP(OwnerActor)

end
--]]

-- buff总持续时长变化，如修改ApplyTime、修改StackNum
--[[
function Buff10:OnTotalDurationChange_BP(PreTime, CurTime)

end
--]]

-- buff堆叠层数变化
--[[
function Buff10:OnStackChange_BP(PreNum, CurNum)

end
--]]

-- buff触发前条件判断
--[[
function Buff10:CanTrigger_BP()
	return true
end
--]]

--[[----------------------根据周卡状态给玩家添加金币------------------------]]
function Buff10:GiveGold(Delta)
    if self:HasAuthority() then
        local Owner_Actor = self:GetOwnerActor() -- Buff所属玩家角色
        local Player_Controller = UGCGameSystem.GetPlayerControllerByPlayerPawn(Owner_Actor) -- 获取玩家控制器
        local Gold_Count = 4 -- 本次获得的金币数量
        local Current_Time = UGCGameSystem.DateTimeToTimeStamp(UGCGameSystem.GetCurrentDateTime()) -- 当前时间戳
        if Player_Controller.WeekEndTime and Current_Time < Player_Controller.WeekEndTime then
            Gold_Count = math.floor(Gold_Count * 1.5)
        end
        UGCBackpackSystemV2.AddItemV2(Owner_Actor, 8310003, Gold_Count)
        L_TipsTool.ShowTips_01("金币加" .. Gold_Count, Player_Controller)
    end
end

return Buff10
