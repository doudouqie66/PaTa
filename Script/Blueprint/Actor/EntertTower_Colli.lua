---@class EntertTower_Colli_C:AActor
---@field Box UBoxComponent
---@field DefaultSceneRoot USceneComponent
--Edit Below--
local EntertTower_Colli = {}

--[[----------------------初始化塔内计时碰撞------------------------]]
function EntertTower_Colli:ReceiveBeginPlay()
    EntertTower_Colli.SuperClass.ReceiveBeginPlay(self)
    if not self:HasAuthority() then
        return
    end

    self.Box.OnComponentBeginOverlap:Add(self.Box_OnComponentBeginOverlap, self)
    self.Box.OnComponentEndOverlap:Add(self.Box_OnComponentEndOverlap, self)
end

--[[----------------------解绑塔内计时碰撞------------------------]]
function EntertTower_Colli:ReceiveEndPlay()
    if self:HasAuthority() then
        self.Box.OnComponentBeginOverlap:Remove(self.Box_OnComponentBeginOverlap, self)
        self.Box.OnComponentEndOverlap:Remove(self.Box_OnComponentEndOverlap, self)
    end

    EntertTower_Colli.SuperClass.ReceiveEndPlay(self)
end

--[[----------------------玩家进入区域后开始计时------------------------]]
function EntertTower_Colli:Box_OnComponentBeginOverlap(Overlapped_Component, Other_Actor, Other_Comp,
    Other_Body_Index, b_From_Sweep, Sweep_Result)
    local Player_Controller = UGCGameSystem.GetPlayerControllerByPlayerPawn(Other_Actor) -- 进入区域的玩家控制器
    if not Player_Controller then
        return
    end

    Player_Controller:StartTowerRewardTimer()
end

--[[----------------------玩家离开区域后暂停计时------------------------]]
function EntertTower_Colli:Box_OnComponentEndOverlap(Overlapped_Component, Other_Actor, Other_Comp,
    Other_Body_Index)
    local Player_Controller = UGCGameSystem.GetPlayerControllerByPlayerPawn(Other_Actor) -- 离开区域的玩家控制器
    if not Player_Controller then
        return
    end

    Player_Controller:PauseTowerRewardTimer()
end

return EntertTower_Colli
