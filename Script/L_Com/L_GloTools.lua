L_GloTools = L_GloTools or {}
L_GloTools.UI_Map = L_GloTools.UI_Map or {}  -- 缓存已创建的UI
L_GloTools.UI_Visibility_Map = L_GloTools.UI_Visibility_Map or {}  -- 缓存UI原始显示状态

--[[----------------------管理UI显示隐藏------------------------]]
function L_GloTools.UIMgr(str, bVisible)
    local UI_BP = L_GloTools.UI_Map[str]

    if UI_BP == nil then
        if bVisible == false then
            return
        end

        local UI_Class = UE.LoadClass(str);
        local PlayerController = UGCGameSystem.GetLocalPlayerController()
        UI_BP = UserWidget.NewWidgetObjectBP(PlayerController, UI_Class);
        UI_BP:AddToViewport();
        L_GloTools.UI_Map[str] = UI_BP
        L_GloTools.UI_Visibility_Map[str] = UI_BP:GetVisibility()
        return
    end

    if bVisible == true then
        UI_BP:SetVisibility(L_GloTools.UI_Visibility_Map[str])
        return
    end

    if bVisible == false then
        UI_BP:SetVisibility(ESlateVisibility.Collapsed)
        return
    end

    if UI_BP:IsVisible() then
        UI_BP:SetVisibility(ESlateVisibility.Collapsed)
    else
        UI_BP:SetVisibility(L_GloTools.UI_Visibility_Map[str])
    end
end
return L_GloTools
