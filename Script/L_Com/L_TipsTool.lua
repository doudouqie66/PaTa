L_TipsTool = L_TipsTool or {}
local LastToastTime = 0

--[[----------------------显示小提示------------------------]]
function L_TipsTool.ShowTips_01(text, PlayerController, Sound_Name)
    if UGCGameSystem.IsServer() then
        if Sound_Name then
            UnrealNetwork.CallUnrealRPC(PlayerController, PlayerController, L_Enum.Name_RPC.Tool_Msg_01, text,
                Sound_Name)
        else
            UnrealNetwork.CallUnrealRPC(PlayerController, PlayerController, L_Enum.Name_RPC.Tool_Msg_01, text)
        end
        return
    end

    local NowTime = os.time()
    if NowTime - LastToastTime < 1 then
        return
    end
    LastToastTime = NowTime
    TipsMgr.ShowTips_01(text)
    if Sound_Name then
        SoundMgr.PlaySound2D(Sound_Name)
    end
end

--[[---------------------官方Api-------------------------]] --
function L_TipsTool.ShowOfficialTips(str)
    UGCWidgetManagerSystem.ShowTipsUI(str)
end

return L_TipsTool
