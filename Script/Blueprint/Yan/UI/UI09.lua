---@class UI09_C:UUserWidget
---@field Button_98 UButton
---@field Button_99 UButton
---@field Image_91 UImage
---@field Image_180 UImage
---@field Image_181 UImage
---@field TextBlock_132 UTextBlock
-- Edit Below--
local UI09 = {
    bInitDoOnce = false
}

function UI09:Construct()
    self:LuaInit();

end

-- function UI09:Tick(MyGeometry, InDeltaTime)

-- end

-- function UI09:Destruct()

-- end

-- [Editor Generated Lua] function define Begin:
function UI09:LuaInit()
    if self.bInitDoOnce then
        return;
    end
    self.bInitDoOnce = true;
    -- [Editor Generated Lua] BindingProperty Begin:
    -- [Editor Generated Lua] BindingProperty End;

    -- [Editor Generated Lua] BindingEvent Begin:
    self.Button_98.OnClicked:Add(self.Button_98_OnClicked, self);
    self.Button_99.OnClicked:Add(self.Button_99_OnClicked, self);
    -- [Editor Generated Lua] BindingEvent End;
end

--[[-----------------------不了按钮-----------------------]] --
function UI09:Button_98_OnClicked()
    local PlayerController = UGCGameSystem.GetLocalPlayerController()
    UnrealNetwork.CallUnrealRPC(PlayerController, PlayerController, L_Enum.Name_RPC.Request_Respawn, false)
    L_GloTools.UIMgr(L_Enum.Name_ClassPath.UI09, false)
end
--[[-----------------------返回按钮-----------------------]] --
function UI09:Button_99_OnClicked()
    local PlayerController = UGCGameSystem.GetLocalPlayerController()
    UnrealNetwork.CallUnrealRPC(PlayerController, PlayerController, L_Enum.Name_RPC.Request_Respawn, true)
    L_GloTools.UIMgr(L_Enum.Name_ClassPath.UI09, false)

end

-- [Editor Generated Lua] function define End;

return UI09
