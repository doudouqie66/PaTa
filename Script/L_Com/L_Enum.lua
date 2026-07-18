L_Enum = L_Enum or {}

--[[--------------------PlayerState的名字--------------------------]] --
L_Enum.Name_PlayerState = {
    Level = "Level"
}

--[[-----------------------资源路径-----------------------]] --
local RootPath = UGCMapInfoLib.GetRootLongPackagePath()

L_Enum.Name_ClassPath = {
    MainUI = RootPath .. "Asset/Blueprint/UI/MainUI.MainUI_C",
    Tips_01 = RootPath .. "Asset/Blueprint/L_Com/Tips/Tips_01.Tips_01_C"
}

--[[------------------CTRl那里的RPC方法名字----------------------------]] --
L_Enum.Name_RPC = {
    AddLevel = "AddLevel",
    UseRedemptionCode = "UseRedemptionCode"
    -- Client_RefUI_Level = "Client_RefUI_Level"
}

--[[-----------------------属性名字-----------------------]] --
L_Enum.Name_RepPts = {
    PlayerGameLevel = "PlayerGameLevel",
    PlayerAttack = "PlayerAttack",
    PlayerMaxHP = "PlayerMaxHP"

}
return L_Enum
