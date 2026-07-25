---@class BP_Action_GrapplePull_C:ProjectileActionEffectBase
local BP_Action_GrapplePull = {}

local Pull_Interval = 0.02 -- 拉拽更新间隔
local Pull_Speed = 2200 -- 每秒拉拽速度
local Stop_Distance = 80 -- 玩家与安全目标点的停止距离
local Slow_Down_Distance = 500 -- 接近目标时开始减速的距离
local Min_Pull_Speed = 500 -- 接近目标时的最低拉拽速度
local Max_Pull_Time = 2.5 -- 单次拉拽最长时间
local Surface_Offset_Distance = 80 -- 目标点远离命中表面的距离
local Min_Move_Distance = 2 -- 判定玩家发生有效移动的最小距离
local Max_Blocked_Count = 3 -- 连续移动受阻的最大次数
local Active_Grapple_Actions = {} -- 各玩家当前正在执行的钩爪动作

--[[----------------------初始化钩爪拉拽动作------------------------]]
function BP_Action_GrapplePull:InitBP(InOwnerActor)
    self.ActionTriggerType = 2 -- 服务端与客户端都执行
    self.Projectile_Actor = InOwnerActor
end

--[[----------------------开始持续拉拽玩家------------------------]]
function BP_Action_GrapplePull:ApplyActionEffect(TargetData)
    if self.Pull_Timer_Delegate then
        return
    end

    self.Player_Pawn = self.Projectile_Actor:GetInstigator()
    if not self.Player_Pawn then
        ugcprint("[钩爪] 当前执行端未取得发射者")
        return
    end

    local Active_Grapple_Action = Active_Grapple_Actions[self.Player_Pawn] -- 玩家当前正在执行的钩爪动作
    if Active_Grapple_Action and Active_Grapple_Action ~= self then
        Active_Grapple_Action:StopPull("[钩爪] 旧拉拽被新钩爪替换")
    end
    Active_Grapple_Actions[self.Player_Pawn] = self

    local Impact_Point = TargetData.HitResult.ImpactPoint -- 钩爪实际接触位置
    local Impact_Normal = TargetData.HitResult.ImpactNormal -- 命中表面朝外法线
    self.Hit_Location = { -- 避免玩家胶囊体贴入表面的安全目标点
        X = Impact_Point.X + Impact_Normal.X * Surface_Offset_Distance,
        Y = Impact_Point.Y + Impact_Normal.Y * Surface_Offset_Distance,
        Z = Impact_Point.Z + Impact_Normal.Z * Surface_Offset_Distance
    }
    self.Pull_Elapsed_Time = 0
    self.Blocked_Count = 0
    self.Pull_Timer_Delegate = ObjectExtend.CreateDelegate(self, self.PullPlayer, self)

    self.Pull_Timer_Handle = KismetSystemLibrary.K2_SetTimerDelegateForLua(
        self.Pull_Timer_Delegate,
        self,
        Pull_Interval,
        true
    )

    ugcprint("[钩爪] 开始持续拉拽")
end

--[[----------------------持续将玩家拉向钩爪位置------------------------]]
function BP_Action_GrapplePull:PullPlayer()
    self.Pull_Elapsed_Time = self.Pull_Elapsed_Time + Pull_Interval

    local Player_Location = self.Player_Pawn:K2_GetActorLocation() -- 玩家当前位置
    local Offset_X = self.Hit_Location.X - Player_Location.X -- X轴位置差
    local Offset_Y = self.Hit_Location.Y - Player_Location.Y -- Y轴位置差
    local Offset_Z = self.Hit_Location.Z - Player_Location.Z -- Z轴位置差
    local Distance = math.sqrt(Offset_X * Offset_X + Offset_Y * Offset_Y + Offset_Z * Offset_Z) -- 玩家与钩爪的距离

    if Distance <= Stop_Distance then
        self:StopPull("[钩爪] 到达目标位置")
        return
    end

    if self.Pull_Elapsed_Time >= Max_Pull_Time then
        self:StopPull("[钩爪] 达到最长拉拽时间")
        return
    end

    local Current_Pull_Speed = Pull_Speed -- 本次拉拽速度
    if Distance < Slow_Down_Distance then
        local Speed_Ratio = (Distance - Stop_Distance) / (Slow_Down_Distance - Stop_Distance) -- 末段速度比例
        Current_Pull_Speed = math.max(Min_Pull_Speed, Pull_Speed * Speed_Ratio)
    end

    local Move_Distance = math.min(Current_Pull_Speed * Pull_Interval, Distance - Stop_Distance) -- 本次移动距离
    local New_Location = { -- 玩家本次移动的目标位置
        X = Player_Location.X + Offset_X / Distance * Move_Distance,
        Y = Player_Location.Y + Offset_Y / Distance * Move_Distance,
        Z = Player_Location.Z + Offset_Z / Distance * Move_Distance
    }

    self.Player_Pawn:K2_SetActorLocation(New_Location, true, nil, false)

    local Actual_Location = self.Player_Pawn:K2_GetActorLocation() -- 碰撞处理后的玩家实际位置
    local Actual_Offset_X = Actual_Location.X - Player_Location.X -- 本次实际移动的X轴距离
    local Actual_Offset_Y = Actual_Location.Y - Player_Location.Y -- 本次实际移动的Y轴距离
    local Actual_Offset_Z = Actual_Location.Z - Player_Location.Z -- 本次实际移动的Z轴距离
    local Actual_Move_Distance = math.sqrt(
        Actual_Offset_X * Actual_Offset_X +
        Actual_Offset_Y * Actual_Offset_Y +
        Actual_Offset_Z * Actual_Offset_Z
    ) -- 本次实际移动距离

    if Actual_Move_Distance < Min_Move_Distance then
        self.Blocked_Count = self.Blocked_Count + 1
    else
        self.Blocked_Count = 0
    end

    if self.Blocked_Count >= Max_Blocked_Count then
        self:StopPull("[钩爪] 拉拽被障碍阻挡")
    end
end

--[[----------------------停止钩爪拉拽并销毁钩爪------------------------]]
function BP_Action_GrapplePull:StopPull(Stop_Reason)
    KismetSystemLibrary.K2_ClearTimerHandle(self, self.Pull_Timer_Handle)
    ObjectExtend.DestroyDelegate(self.Pull_Timer_Delegate)
    self.Pull_Timer_Delegate = nil
    self.Pull_Timer_Handle = nil

    if self.Player_Pawn and Active_Grapple_Actions[self.Player_Pawn] == self then
        Active_Grapple_Actions[self.Player_Pawn] = nil
    end

    ugcprint(Stop_Reason)
    if self.Projectile_Actor:HasAuthority() then
        self.Projectile_Actor:K2_DestroyActor()
    end
end

return BP_Action_GrapplePull
