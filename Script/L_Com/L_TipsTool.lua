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
    if NowTime - LastToastTime >= 1 then
        LastToastTime = NowTime
        TipsMgr.ShowTips_01(text)
    end
    if Sound_Name then
        SoundMgr.PlaySound2D(Sound_Name)
    end
end

--[[----------------------向所有玩家显示小提示------------------------]]
function L_TipsTool.ShowTips_Broadcast(text, Sound_Name)
    if not UGCGameSystem.IsServer() then
        return
    end

    if Sound_Name then
        UnrealNetwork.CallUnrealRPC_Multicast(UGCGameSystem.GameState, L_Enum.Name_RPC.Broadcast_Tips, text,
            Sound_Name)
    else
        UnrealNetwork.CallUnrealRPC_Multicast(UGCGameSystem.GameState, L_Enum.Name_RPC.Broadcast_Tips, text)
    end
end

--[[---------------------官方Api-------------------------]] --
function L_TipsTool.ShowOfficialTips(str)
    UGCWidgetManagerSystem.ShowTipsUI(str)
end

return L_TipsTool
