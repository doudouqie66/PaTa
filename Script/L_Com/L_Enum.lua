L_Enum = L_Enum or {}

--[[-----------------------资源路径-----------------------]] --
local RootPath = UGCMapInfoLib.GetRootLongPackagePath()

L_Enum.Name_ClassPath = {
    MainUI = RootPath .. "Asset/Blueprint/UI/MainUI.MainUI_C",
    Tips_01 = RootPath .. "Asset/Blueprint/L_Com/Tips/Tips_01.Tips_01_C",
    UI_Attention = RootPath .. "Asset/Blueprint/Yan/UI/UI_Attention.UI_Attention_C",
    UI01 = RootPath .. "Asset/Blueprint/Yan/UI/UI01.UI01_C",
    UI02 = RootPath .. "Asset/Blueprint/Yan/UI/UI02.UI02_C",
    UI03 = RootPath .. "Asset/Blueprint/Yan/UI/UI03.UI03_C",
    UI04 = RootPath .. "Asset/Blueprint/Yan/UI/UI04.UI04_C",
    UI05 = RootPath .. "Asset/Blueprint/Yan/UI/UI05.UI05_C",
    UI06 = RootPath .. "Asset/Blueprint/Yan/UI/UI06.UI06_C",
    UI07 = RootPath .. "Asset/Blueprint/Yan/UI/UI07.UI07_C",
    UI08 = RootPath .. "Asset/Blueprint/Yan/UI/UI08.UI08_C",
    UI09 = RootPath .. "Asset/Blueprint/Yan/UI/UI09.UI09_C"

}
--[[----------------------Buff名字------------------------]] --

L_Enum.Name_BuffPath = {
    Debuff01 = RootPath .. "Asset/Blueprint/Prefabs/Buffs/DeBuff01.DeBuff01_C"

}

--[[------------------CTRl那里的RPC方法名字----------------------------]] --
L_Enum.Name_RPC = {
    AddLevel = "AddLevel",
    UseRedemptionCode = "UseRedemptionCode",
    Mgr_Atten = "Mgr_Atten",
    Tool_Msg_01 = "Tool_Msg_01",
    Request_Respawn = "RequestRespawn", -- 复活请求RPC名称
    Show_Respawn_UI = "ShowRespawnUI" -- 显示复活界面RPC名称
    -- Client_RefUI_Level = "Client_RefUI_Level"
}

--[[-----------------------属性名字-----------------------]] --
L_Enum.Name_RepPts = {
    PlayerGameLevel = "PlayerGameLevel",
    PlayerAttack = "PlayerAttack",
    PlayerMaxHP = "PlayerMaxHP"

}
return L_Enum
