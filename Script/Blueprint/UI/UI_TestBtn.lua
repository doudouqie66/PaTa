---@class UI_TestBtn_C:UUserWidget
---@field Button_6 UButton
---@field Image_67 UImage
--Edit Below--
local UI_TestBtn = {
    bInitDoOnce = false
}

function UI_TestBtn:Construct()
    self:LuaInit();

end

-- function UI_TestBtn:Tick(MyGeometry, InDeltaTime)

-- end

-- function UI_TestBtn:Destruct()

-- end

-- [Editor Generated Lua] function define Begin:
function UI_TestBtn:LuaInit()
    if self.bInitDoOnce then
        return;
    end
    self.bInitDoOnce = true;
    -- [Editor Generated Lua] BindingProperty Begin:
    -- [Editor Generated Lua] BindingProperty End;

    -- [Editor Generated Lua] BindingEvent Begin:
    self.Button_6.OnClicked:Add(self.Button_6_OnClicked, self);
    -- [Editor Generated Lua] BindingEvent End;
end

--[[----------------------请求随机生成方块------------------------]]
function UI_TestBtn:Button_6_OnClicked()
    local Player_Controller = UGCGameSystem.GetLocalPlayerController() -- 本地玩家控制器
    UnrealNetwork.CallUnrealRPC(Player_Controller, Player_Controller, L_Enum.Name_RPC.Spawn_Random_Block)
end

function UI_TestBtn:Button_0_OnClicked()

end

-- [Editor Generated Lua] function define End;

return UI_TestBtn
