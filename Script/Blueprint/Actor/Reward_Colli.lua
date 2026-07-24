---@class Reward_Colli_C:AActor
---@field Box UBoxComponent
---@field DefaultSceneRoot USceneComponent
-- Edit Below--
local Reward_Colli = {}

function Reward_Colli:ReceiveBeginPlay()
    Reward_Colli.SuperClass.ReceiveBeginPlay(self)
    self.Box.OnComponentBeginOverlap:Add(self.Box_OnComponentBeginOverlap, self);

end

function Reward_Colli:LuaInit()
    if self.bInitDoOnce then
        return;
    end
    self.bInitDoOnce = true;
    -- [Editor Generated Lua] BindingProperty Begin:
    -- [Editor Generated Lua] BindingProperty End;

    -- [Editor Generated Lua] BindingEvent Begin:
    -- [Editor Generated Lua] BindingEvent End;
end

function Reward_Colli:Box_OnComponentBeginOverlap(OverlappedComponent, OtherActor, OtherComp, OtherBodyIndex,
    bFromSweep, SweepResult)
    L_TipsTool.ShowTips_01("碰到拉")
end

-- [Editor Generated Lua] function define End;

return Reward_Colli
