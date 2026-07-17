-- TipsMgr.lua
TipsMgr = TipsMgr or {}

local ToastItemClass = nil
local ActiveToasts = {}

local CONFIG = {
    ZOrder = 30000,
    TopOffset = 200,
    FadeInDuration = 0.5,
    HoldDuration = 1.2,
    FadeOutDuration = 0.8,
    RiseDistance = 50,
    FadeOutRiseDistance = 40
}

--[[----------------------清理提示控件------------------------]]
local function CleanupToast(data)
    data.widget:RemoveFromViewport()
    data.widget = nil
    for i, d in ipairs(ActiveToasts) do
        if d == data then
            table.remove(ActiveToasts, i)
            break
        end
    end
end

--[[----------------------播放淡出动画------------------------]]
local function PlayFadeOut(data)
    local startY = data.baseY
    local endY = data.baseY - CONFIG.FadeOutRiseDistance

    local Callback = function(_, Progress)
        data.widget:SetRenderOpacity(1.0 - Progress)
        local currentY = startY + (endY - startY) * Progress
        data.widget:SetPositionInViewport(UGCMathUtility.MakeVector2D(data.baseX, currentY), false)
    end

    local Config = UGCTweenSystem.MakeConfig(0, 0, false, 0)
    local Handle =
        UGCTweenSystem.TweenFloatValue(0.0, 1.0, CONFIG.FadeOutDuration, EEasingType.QuadIn, Callback, Config)
    UGCTweenSystem.BindCompletedDelegate(Handle, function()
        CleanupToast(data)
    end)
    return Handle
end

--[[----------------------播放停留动画------------------------]]
local function PlayHold(data)
    local Config = UGCTweenSystem.MakeConfig(0, 0, false, 0)
    return UGCTweenSystem.TweenFloatValue(0.0, 0.0, CONFIG.HoldDuration, EEasingType.Linear, function()
    end, Config)
end

--[[----------------------播放淡入动画------------------------]]
local function PlayFadeIn(data)
    local startY = data.baseY + CONFIG.RiseDistance
    data.widget:SetRenderOpacity(0.0)
    data.widget:SetPositionInViewport(UGCMathUtility.MakeVector2D(data.baseX, startY), false)

    local Callback = function(_, Progress)
        data.widget:SetRenderOpacity(Progress)
        local currentY = startY + (data.baseY - startY) * Progress
        data.widget:SetPositionInViewport(UGCMathUtility.MakeVector2D(data.baseX, currentY), false)
    end

    local Config = UGCTweenSystem.MakeConfig(0, 0, false, 0)
    return UGCTweenSystem.TweenFloatValue(0.0, 1.0, CONFIG.FadeInDuration, EEasingType.QuadOut, Callback, Config)
end

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

    local ScreenSize = UGCWidgetManagerSystem.GetViewportSize()
    local baseX = (ScreenSize.X - 400) / 2
    local baseY = CONFIG.TopOffset

    local ToastData = {
        widget = ToastWidget,
        baseX = baseX,
        baseY = baseY
    }
    table.insert(ActiveToasts, ToastData)

    local FadeIn = PlayFadeIn(ToastData)
    local Hold = PlayHold(ToastData)
    local FadeOut = PlayFadeOut(ToastData)
    UGCTweenSystem.ChainTween(FadeIn, Hold)
    UGCTweenSystem.ChainTween(Hold, FadeOut)
end

--[[----------------------显示小提示------------------------]]
function TipsMgr.ShowTips_01(text)
    if not ToastItemClass then
        ToastItemClass = UE.LoadClass(L_Enum.Name_ClassPath.Tips_01)
    end
    CreateAndShowToast(ToastItemClass, text)
end

return TipsMgr
