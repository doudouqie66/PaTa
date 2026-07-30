---@class Actor_ShopMan_C:AActor
---@field Box UBoxComponent
---@field DefaultSceneRoot USceneComponent
-- Edit Below--
local Actor_ShopMan = {}

--[[----------------------绑定商店区域碰撞事件------------------------]]
function Actor_ShopMan:ReceiveBeginPlay()
    Actor_ShopMan.SuperClass.ReceiveBeginPlay(self)
    if self:HasAuthority() then
        return
    end
    self.Box.OnComponentBeginOverlap:Add(self.Box_OnComponentBeginOverlap, self);
    self.Box.OnComponentEndOverlap:Add(self.Box_OnComponentEndOverlap, self);
end

--[[
function Actor_ShopMan:ReceiveTick(DeltaTime)
    Actor_ShopMan.SuperClass.ReceiveTick(self, DeltaTime)
end
--]]

--[[
function Actor_ShopMan:ReceiveEndPlay()
    Actor_ShopMan.SuperClass.ReceiveEndPlay(self) 
end
--]]

--[[
function Actor_ShopMan:GetReplicatedProperties()
    return
end
--]]

--[[
function Actor_ShopMan:GetAvailableServerRPCs()
    return
end
--]]

-- [Editor Generated Lua] function define Begin:
--[[----------------------初始化Lua事件绑定------------------------]]
function Actor_ShopMan:LuaInit()
    if self.bInitDoOnce then
        return;
    end
    self.bInitDoOnce = true;
    -- [Editor Generated Lua] BindingProperty Begin:
    -- [Editor Generated Lua] BindingProperty End;

    -- [Editor Generated Lua] BindingEvent Begin:

    -- [Editor Generated Lua] BindingEvent End;
end

--[[----------------------本地玩家进入区域时打开商店------------------------]]
function Actor_ShopMan:Box_OnComponentBeginOverlap(OverlappedComponent, OtherActor, OtherComp, OtherBodyIndex,
    bFromSweep, SweepResult)
    local Player_Controller = UGCGameSystem.GetPlayerControllerByPlayerPawn(OtherActor) -- 进入区域的玩家控制器
    if Player_Controller == nil or Player_Controller ~= UGCGameSystem.GetLocalPlayerController() then
        return
    end
    ShopV2Manager:OpenMainUI()
end

--[[----------------------本地玩家离开区域时关闭商店------------------------]]
function Actor_ShopMan:Box_OnComponentEndOverlap(OverlappedComponent, OtherActor, OtherComp, OtherBodyIndex)
    local Player_Controller = UGCGameSystem.GetPlayerControllerByPlayerPawn(OtherActor) -- 离开区域的玩家控制器
    if Player_Controller == nil or Player_Controller ~= UGCGameSystem.GetLocalPlayerController() then
        return
    end
    ShopV2Manager:CloseMainUI()
end

-- [Editor Generated Lua] function define End;

return Actor_ShopMan
