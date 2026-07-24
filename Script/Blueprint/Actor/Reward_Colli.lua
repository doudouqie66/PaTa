---@class Reward_Colli_C:AActor
---@field Box UBoxComponent
---@field DefaultSceneRoot USceneComponent
--Edit Below--
---@class Reward_Colli_C:AActor
---@field Box UBoxComponent
---@field DefaultSceneRoot USceneComponent
local Reward_Colli = {
    Reward_Wait_Time = 5, -- 礼包每次领取后的等待时间
    Reward_Drop_ID = 3 -- 礼包使用的掉落表编号
}

--[[----------------------初始化礼包碰撞与计时------------------------]]
function Reward_Colli:ReceiveBeginPlay()
    Reward_Colli.SuperClass.ReceiveBeginPlay(self)
    if not self:HasAuthority() then
        return
    end

    self.Box.OnComponentBeginOverlap:Add(self.Box_OnComponentBeginOverlap, self)
    self:StartRewardTimer()
end

--[[----------------------清理礼包计时器------------------------]]
function Reward_Colli:ReceiveEndPlay()
    if self:HasAuthority() and self.Reward_Timer then
        UGCTimerUtility.RemoveLuaTimer(self.Reward_Timer)
        self.Reward_Timer = nil
    end
    Reward_Colli.SuperClass.ReceiveEndPlay(self)
end

--[[----------------------初始化编辑器生成属性------------------------]]
function Reward_Colli:LuaInit()
    if self.bInitDoOnce then
        return
    end
    self.bInitDoOnce = true
end

--[[----------------------开始礼包等待计时------------------------]]
function Reward_Colli:StartRewardTimer()
    self.Reward_Is_Available = false
    self.Reward_Timer = UGCTimerUtility.CreateLuaTimer(self.Reward_Wait_Time, function()
        self.Reward_Timer = nil
        self.Reward_Is_Available = true
    end, false)
end

--[[----------------------处理玩家碰撞领取礼包------------------------]]
function Reward_Colli:Box_OnComponentBeginOverlap(OverlappedComponent, OtherActor, OtherComp, OtherBodyIndex,
    bFromSweep, SweepResult)
    if not self.Reward_Is_Available then
        return
    end

    local Player_Controller = UGCGameSystem.GetPlayerControllerByPlayerPawn(OtherActor) -- 碰撞玩家的控制器
    if not Player_Controller then
        return
    end

    self.Reward_Is_Available = false
    local Reward_Items = UGCDropSystem.DropItems(self.Reward_Drop_ID) -- 本次礼包的随机掉落结果
    local Virtual_Item_Manager = UGCGamePartSystem.GetGamePartGlobalActor("VirtualItemManager") -- 虚拟物品管理器
    if not Virtual_Item_Manager:AddVirtualItems(Player_Controller, Reward_Items) then
        self.Reward_Is_Available = true
        return
    end

    L_TipsTool.ShowTips_01("领取礼包成功", Player_Controller)
    self:StartRewardTimer()
end

return Reward_Colli
