---@class AC_WH_C:AActor
---@field ParticleSystem UParticleSystemComponent
---@field Box1 UBoxComponent
---@field Box UBoxComponent
---@field Widget1 UWidgetComponent
---@field Widget UWidgetComponent
---@field StaticMesh UStaticMeshComponent
---@field DefaultSceneRoot USceneComponent
--Edit Below--
local AC_WH = {}

--[[----------------------初始化点击范围检测------------------------]]
function AC_WH:ReceiveBeginPlay()
    AC_WH.SuperClass.ReceiveBeginPlay(self)
    self.Can_Click = false -- 是否允许点击
    self.Box.OnComponentBeginOverlap:Add(self.Box_OnComponentBeginOverlap, self);
    self.Box.OnComponentEndOverlap:Add(self.Box_OnComponentEndOverlap, self);
end

--[[----------------------初始化Lua脚本------------------------]]
function AC_WH:LuaInit()
    if self.bInitDoOnce then
        return;
    end
    self.bInitDoOnce = true;

end
--[[----------------------处理鼠标点击物品------------------------]]
function AC_WH:ReceiveActorOnClicked(Button_Pressed)
    if not self.Can_Click then
        return
    end
    SoundMgr.PlaySound2D(SoundMgr.SoundName.UI_Switch)
    self:ProcessCreate()

end

--[[----------------------处理手机触摸物品------------------------]]
function AC_WH:ReceiveActorOnInputTouchBegin(Finger_Index)
    if not self.Can_Click then
        return
    end
    SoundMgr.PlaySound2D(SoundMgr.SoundName.UI_Switch)
    self:ProcessCreate()
end
--[[---------------------开启显示动画-------------------------]] --
function AC_WH:Box_OnComponentBeginOverlap(OverlappedComponent, OtherActor, OtherComp, OtherBodyIndex, bFromSweep,
    SweepResult)
    if OtherActor ~= UGCGameSystem.GetLocalPlayerPawn() then
        return
    end

    self.Can_Click = true -- 允许点击
    self.Widget:SetHiddenInGame(false, false) -- 显示
    self.Widget1:SetHiddenInGame(false, false) -- 显示

end
--[[---------------------关闭显示动画-------------------------]] --
function AC_WH:Box_OnComponentEndOverlap(OverlappedComponent, OtherActor, OtherComp, OtherBodyIndex)
    if OtherActor ~= UGCGameSystem.GetLocalPlayerPawn() then
        return
    end

    self.Can_Click = false -- 禁止点击
    self.Widget:SetHiddenInGame(true, false) -- 隐藏
    self.Widget1:SetHiddenInGame(true, false) -- 隐藏
end

--[[----------------------请求开启随机奖励方块------------------------]]
function AC_WH:ProcessCreate()
    local Player_Controller = UGCGameSystem.GetLocalPlayerController() -- 本地玩家控制器
    UnrealNetwork.CallUnrealRPC(Player_Controller, Player_Controller, L_Enum.Name_RPC.Open_Random_Block, self)
end

return AC_WH
