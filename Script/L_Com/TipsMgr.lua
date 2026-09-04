-- TipsMgr.lua
TipsMgr = TipsMgr or {}

local ToastItemClass = nil

local CONFIG = {
    ZOrder = 30000
}

--[[----------------------创建并显示提示控件------------------------]]
local function CreateAndShowToast(WidgetClass, text)
    if WidgetClass == nil then
        return
    end

    local ToastWidget = UGCWidgetManagerSystem.CreateWidget(WidgetClass)
    if ToastWidget == nil then
        return
    end

    ToastWidget:AddToViewport(CONFIG.ZOrder)

    if ToastWidget.SetTipText == nil then
        return
    end
    ToastWidget:SetTipText(text)
    ToastWidget:PlayMove()
end

--[[----------------------显示小提示------------------------]]
function TipsMgr.ShowTips_01(text)
    if not ToastItemClass then
        ToastItemClass = UE.LoadClass(L_Enum.Name_ClassPath.Tips_01)
    end
    CreateAndShowToast(ToastItemClass, text)
end

return TipsMgr
