---@class UI_TestBtn_C:UUserWidget
---@field Button_0 UButton
---@field Image_67 UImage
--Edit Below--
local UI_TestBtn = {
    bInitDoOnce = false
}

function UI_TestBtn:Construct()
    self:LuaInit();

end
function UI_TestBtn:LuaInit()
    if self.bInitDoOnce then
        return;
    end
    self.bInitDoOnce = true;
    self.Button_0.OnClicked:Add(self.Button_0_OnClicked, self);
end
--[[----------------------点击按钮添加反向移动Buff------------------------]]
function UI_TestBtn:Button_0_OnClicked()
    local PC = UGCGameSystem.GetLocalPlayerController() -- 本地玩家控制器
    UnrealNetwork.CallUnrealRPC(PC, PC, L_Enum.Name_RPC.Add_Player_Buff,
        L_Enum.Name_BuffPath.Debuff04)
end

return UI_TestBtn
