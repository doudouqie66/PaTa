---@class UGCGameState_C:BP_UGCGameState_C
-- Edit Below--
--[[----------------------全局提前引用------------------------]] --
UGCGameSystem.UGCRequire('Script.Common.ue_enum_custom')
UGCGameSystem.UGCRequire('Script.L_Com.L_Enum')
UGCGameSystem.UGCRequire('Script.L_Com.L_TipsTool')
UGCGameSystem.UGCRequire('Script.L_Com.TipsMgr')

local UGCGameState = {};
--[[----------------------游戏状态开始时初始化------------------------]]
function UGCGameState:ReceiveBeginPlay()
    self.SuperClass.ReceiveBeginPlay(self);
    self:InitUI()
end

--[[----------------------初始化界面------------------------]]
function UGCGameState:InitUI()
    if self:HasAuthority() == true then
        -- 只有客户端加载UI
    else
        local MainUI = UE.LoadClass(L_Enum.Name_ClassPath.MainUI);
        local PlayerController = UGCGameSystem.GetLocalPlayerController()
        local MainUI_BP = UserWidget.NewWidgetObjectBP(PlayerController, MainUI);
        PlayerController.MainUI_BP = MainUI_BP;
        MainUI_BP:AddToViewport();
    end

end
return UGCGameState;
