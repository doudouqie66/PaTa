---@class Colli_ShowBack_C:AActor
---@field Box UBoxComponent
---@field DefaultSceneRoot USceneComponent
--Edit Below--
local Colli_ShowBack = {}

--[[----------------------绑定回城按钮区域碰撞事件------------------------]]
function Colli_ShowBack:ReceiveBeginPlay()
    Colli_ShowBack.SuperClass.ReceiveBeginPlay(self)
    if self:HasAuthority() then
        return
    end

    self.Box.OnComponentBeginOverlap:Add(self.Box_OnComponentBeginOverlap, self);
    self.Box.OnComponentEndOverlap:Add(self.Box_OnComponentEndOverlap, self);
end

--[[----------------------解绑回城按钮区域碰撞事件------------------------]]
function Colli_ShowBack:ReceiveEndPlay()
    if not self:HasAuthority() then
        self.Box.OnComponentBeginOverlap:Remove(self.Box_OnComponentBeginOverlap, self)
        self.Box.OnComponentEndOverlap:Remove(self.Box_OnComponentEndOverlap, self)
    end

    Colli_ShowBack.SuperClass.ReceiveEndPlay(self)
end

--[[----------------------初始化Lua事件绑定------------------------]]
function Colli_ShowBack:LuaInit()
    if self.bInitDoOnce then
        return;
    end
    self.bInitDoOnce = true;

end

--[[----------------------本地玩家进入区域时显示回城按钮------------------------]]
function Colli_ShowBack:Box_OnComponentBeginOverlap(OverlappedComponent, OtherActor, OtherComp, OtherBodyIndex,
    bFromSweep, SweepResult)
    local Player_Controller = UGCGameSystem.GetPlayerControllerByPlayerPawn(OtherActor) -- 进入区域的玩家控制器
    if Player_Controller == nil or Player_Controller ~= UGCGameSystem.GetLocalPlayerController() then
        return
    end

    L_GloTools.UI_Map[L_Enum.Name_ClassPath.UI02].Button_181:SetVisibility(ESlateVisibility.Visible)
end

--[[----------------------本地玩家离开区域时隐藏回城按钮------------------------]]
function Colli_ShowBack:Box_OnComponentEndOverlap(OverlappedComponent, OtherActor, OtherComp, OtherBodyIndex)
    local Player_Controller = UGCGameSystem.GetPlayerControllerByPlayerPawn(OtherActor) -- 离开区域的玩家控制器
    if Player_Controller == nil or Player_Controller ~= UGCGameSystem.GetLocalPlayerController() then
        return
    end

    L_GloTools.UI_Map[L_Enum.Name_ClassPath.UI02].Button_181:SetVisibility(ESlateVisibility.Collapsed)
end
return Colli_ShowBack
