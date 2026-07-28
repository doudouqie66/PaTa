---@class ShowBuy_Colli_C:AActor
---@field Capsule UCapsuleComponent
---@field DefaultSceneRoot USceneComponent
---@field ProductID int32
-- Edit Below--
local ShowBuy_Colli = {}

function ShowBuy_Colli:ReceiveBeginPlay()
    ShowBuy_Colli.SuperClass.ReceiveBeginPlay(self)
    self.Capsule.OnComponentBeginOverlap:Add(self.Capsule_OnComponentBeginOverlap, self);

end

--[[
function ShowBuy_Colli:ReceiveTick(DeltaTime)
    ShowBuy_Colli.SuperClass.ReceiveTick(self, DeltaTime)
end
--]]

--[[
function ShowBuy_Colli:ReceiveEndPlay()
    ShowBuy_Colli.SuperClass.ReceiveEndPlay(self) 
end
--]]

--[[
function ShowBuy_Colli:GetReplicatedProperties()
    return
end
--]]

--[[
function ShowBuy_Colli:GetAvailableServerRPCs()
    return
end
--]]

-- [Editor Generated Lua] function define Begin:
function ShowBuy_Colli:LuaInit()
    if self.bInitDoOnce then
        return;
    end
    self.bInitDoOnce = true;
    -- [Editor Generated Lua] BindingProperty Begin:
    -- [Editor Generated Lua] BindingProperty End;

    -- [Editor Generated Lua] BindingEvent Begin:
    -- [Editor Generated Lua] BindingEvent End;
end

function ShowBuy_Colli:Capsule_OnComponentBeginOverlap(OverlappedComponent, OtherActor, OtherComp, OtherBodyIndex,
    bFromSweep, SweepResult)
    L_GloTools.BuyShopProduct(self.ProductID)

end

-- [Editor Generated Lua] function define End;

return ShowBuy_Colli
