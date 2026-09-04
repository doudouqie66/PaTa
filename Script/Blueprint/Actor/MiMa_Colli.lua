---@class MiMa_Colli_C:AActor
---@field Widget UWidgetComponent
---@field Box1 UBoxComponent
---@field StaticMesh UStaticMeshComponent
---@field Box UBoxComponent
---@field DefaultSceneRoot USceneComponent
--Edit Below--
local MiMa_Colli = {}
--[[----------------------处理鼠标点击物品------------------------]]
function MiMa_Colli:ReceiveActorOnClicked(Button_Pressed)
    if not self.Can_Touch then
        return
    end
    L_GloTools.UIMgr(L_Enum.Name_ClassPath.UI07, true)
    SoundMgr.PlaySound2D(SoundMgr.SoundName.UI_Switch)
end

--[[----------------------处理手机触摸物品------------------------]]
function MiMa_Colli:ReceiveActorOnInputTouchBegin(Finger_Index)
    if not self.Can_Touch then
        return
    end
    L_GloTools.UIMgr(L_Enum.Name_ClassPath.UI07, true)
    SoundMgr.PlaySound2D(SoundMgr.SoundName.UI_Switch)
end

--[[----------------------初始化触摸区域检测------------------------]]
function MiMa_Colli:ReceiveBeginPlay()
    MiMa_Colli.SuperClass.ReceiveBeginPlay(self)
    self.Can_Touch = false -- 是否允许触摸
    local Tips_Widget = self.Widget:GetUserWidgetObject() -- 密码提示控件实例
    Tips_Widget:StopAnimation(Tips_Widget.Move)
    self.Widget:SetVisibility(false, false, false) -- 默认隐藏交互提示
    self.Box1.OnComponentBeginOverlap:Add(self.Box1_OnComponentBeginOverlap, self);
    self.Box1.OnComponentEndOverlap:Add(self.Box1_OnComponentEndOverlap, self);
end

-- [Editor Generated Lua] function define Begin:
function MiMa_Colli:LuaInit()
    if self.bInitDoOnce then
        return;
    end
    self.bInitDoOnce = true;
    -- [Editor Generated Lua] BindingProperty Begin:
    -- [Editor Generated Lua] BindingProperty End;

    -- [Editor Generated Lua] BindingEvent Begin:

    -- [Editor Generated Lua] BindingEvent End;
end

--[[----------------------本地玩家进入区域时允许触摸------------------------]]
function MiMa_Colli:Box1_OnComponentBeginOverlap(OverlappedComponent, OtherActor, OtherComp, OtherBodyIndex, bFromSweep,
    SweepResult)
    if OtherActor ~= UGCGameSystem.GetLocalPlayerPawn() then
        return
    end

    self.Can_Touch = true -- 允许触摸
    self.Widget:SetVisibility(true, false, false) -- 显示交互提示
    local Tips_Widget = self.Widget:GetUserWidgetObject() -- 密码提示控件实例
    Tips_Widget:PlayAnimation(Tips_Widget.Move, 0, 0, EUMGSequencePlayMode.Forward, 1)
end

--[[----------------------本地玩家离开区域时禁止触摸------------------------]]
function MiMa_Colli:Box1_OnComponentEndOverlap(OverlappedComponent, OtherActor, OtherComp, OtherBodyIndex)
    if OtherActor ~= UGCGameSystem.GetLocalPlayerPawn() then
        return
    end

    self.Can_Touch = false -- 禁止触摸
    local Tips_Widget = self.Widget:GetUserWidgetObject() -- 密码提示控件实例
    Tips_Widget:StopAnimation(Tips_Widget.Move)
    self.Widget:SetVisibility(false, false, false) -- 隐藏交互提示
end

-- [Editor Generated Lua] function define End;

return MiMa_Colli
