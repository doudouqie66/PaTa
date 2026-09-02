L_GloTools = L_GloTools or {}
L_GloTools.UI_Map = L_GloTools.UI_Map or {} -- 缓存已创建的UI
L_GloTools.UI_Visibility_Map = L_GloTools.UI_Visibility_Map or {} -- 缓存UI原始显示状态
local SoundMgr = UGCGameSystem.UGCRequire('Script.L_Com.SoundMgr') -- 音效管理

--[[----------------------管理UI显示隐藏------------------------]]
function L_GloTools.UIMgr(str, bVisible, Is_Change_SysUI) -- 是否修改系统UI
    local UI_BP = L_GloTools.UI_Map[str]

    if UI_BP == nil then
        if bVisible == false then
            return
        end

        local UI_Class = UE.LoadClass(str);
        local PlayerController = UGCGameSystem.GetLocalPlayerController()
        UI_BP = UserWidget.NewWidgetObjectBP(PlayerController, UI_Class);
        if str == L_Enum.Name_ClassPath.UI01 or str == L_Enum.Name_ClassPath.UI_Attention then
            UI_BP:AddToViewport(9999999);

        else
            UI_BP:AddToViewport(1);

        end
        L_GloTools.UI_Map[str] = UI_BP
        L_GloTools.UI_Visibility_Map[str] = UI_BP:GetVisibility()
    end

    if bVisible == true then
        UI_BP:SetVisibility(L_GloTools.UI_Visibility_Map[str])
        if str == L_Enum.Name_ClassPath.UI_Item_Show then
            UI_BP:PlayOnce()
        end
        if str == L_Enum.Name_ClassPath.UI_Attention then
            UI_BP:PlayAnimation(UI_BP.wh, 0, 0, EUMGSequencePlayMode.Forward, 4) -- 打开警示界面时加速循环播放动画
        end
        if Is_Change_SysUI ~= false and str ~= L_Enum.Name_ClassPath.UI01 and str ~= L_Enum.Name_ClassPath.UI02 and str ~=
            L_Enum.Name_ClassPath.UI_TestBtn then
            L_GloTools.Change_SysUI(false)
        end
    elseif bVisible == false then
        UI_BP:SetVisibility(ESlateVisibility.Collapsed)
        L_GloTools.Change_SysUI(true)
    end
    SoundMgr.PlaySound2D(SoundMgr.SoundName.UI_Switch)
end

--[[----------------------简单管理UI显示隐藏------------------------]]
function L_GloTools.SimpleUIMgr(UI_Path, Is_Visible)
    local UI_BP = L_GloTools.UI_Map[UI_Path] -- UI实例

    if UI_BP == nil then
        if Is_Visible == false then
            return
        end

        local UI_Class = UE.LoadClass(UI_Path) -- UI类
        local Player_Controller = UGCGameSystem.GetLocalPlayerController() -- 本地玩家控制器
        UI_BP = UserWidget.NewWidgetObjectBP(Player_Controller, UI_Class)
        UI_BP:AddToViewport(1)
        L_GloTools.UI_Map[UI_Path] = UI_BP
        L_GloTools.UI_Visibility_Map[UI_Path] = UI_BP:GetVisibility()
    end

    if Is_Visible then
        UI_BP:SetVisibility(L_GloTools.UI_Visibility_Map[UI_Path])
    else
        UI_BP:SetVisibility(ESlateVisibility.Collapsed)
    end

    return UI_BP
end

--[[----------------------改变系统UI------------------------]]
function L_GloTools.Change_SysUI(bool)
    local mainUI = L_GloTools.Main_UI or UGCWidgetManagerSystem.GetMainUI() or UGCWidgetManagerSystem.GetMainControlUI() -- 优先使用隐藏前缓存的主UI实例
    if bool == true then
        if mainUI then
            mainUI:SetVisibility(L_GloTools.Main_UI_Visibility or ESlateVisibility.SelfHitTestInvisible) -- 恢复根节点原始可见性，避免挡住下层按钮
            ugcprint("[Change_SysUI] 已恢复系统UI")
            L_GloTools.Main_UI = nil -- 清除缓存，下次隐藏时重新获取主UI实例
            L_GloTools.Main_UI_Visibility = nil -- 清除原始可见性缓存
        end
    else
        if L_GloTools.Main_UI == nil and mainUI then
            L_GloTools.Main_UI = mainUI -- 仅首次隐藏时缓存主UI实例
            L_GloTools.Main_UI_Visibility = mainUI:GetVisibility() -- 缓存主UI原始可见性
            mainUI:SetVisibility(ESlateVisibility.Collapsed) -- 直接收起根节点，确保系统UI不显示
            ugcprint("[Change_SysUI] 已隐藏系统UI")
        end
    end
end

--[[----------------------播放事件倒计时------------------------]]
function L_GloTools.StartEventCountdown(Countdown_Duration, Event_Name, Event_Duration)
    L_GloTools.UIMgr(L_Enum.Name_ClassPath.UI_CountDownAttnetion, true, false)
    local UI_BP = L_GloTools.UI_Map[L_Enum.Name_ClassPath.UI_CountDownAttnetion] -- 倒计时提示界面
    UI_BP:StartEventCountdown(Countdown_Duration, Event_Name, Event_Duration)
end

--[[----------------------购买商城商品------------------------]]
function L_GloTools.BuyShopProduct(Product_ID, Buy_Count)
    Buy_Count = Buy_Count or 1 -- 购买数量

    if ShopV2Manager.bBlockRepeatPurchase then
        return
    end

    ShopV2Manager.bBlockRepeatPurchase = true
    ShopV2Manager:OpenPurchaseUI(Product_ID, Buy_Count)
end

--[[----------------------客户端调用,给当前玩家添加背包物品------------------------]]
function L_GloTools.AddBackpackItem(Item_ID, Item_Count)
    local Player_Controller = UGCGameSystem.GetLocalPlayerController() -- 当前玩家控制器
    UnrealNetwork.CallUnrealRPC(Player_Controller, Player_Controller, L_Enum.Name_RPC.Add_Backpack_Item, Item_ID,
        Item_Count)
end

--[[----------------------在当前客户端播放或停止角色蒙太奇------------------------]]
function L_GloTools.SetPawnAnimMontage(Player_Pawn, Anim_Montage_Path, Is_Playing, Play_Rate, Start_Section_Name)
    Play_Rate = Play_Rate or 1.0
    Start_Section_Name = Start_Section_Name or "Default"

    local Anim_Montage = UE.LoadObject(Anim_Montage_Path) -- 蒙太奇资源
    if Is_Playing then
        Player_Pawn:PlayAnimMontage(Anim_Montage, Play_Rate, Start_Section_Name, true, true, true)
    else
        Player_Pawn:StopAnimMontage(Anim_Montage)
    end
end

--[[----------------------广播播放或停止指定玩家蒙太奇------------------------]]
function L_GloTools.SetAnimMontage(Player_Controller, Anim_Montage_Path, Is_Playing, Play_Rate, Start_Section_Name)
    Play_Rate = Play_Rate or 1.0
    Start_Section_Name = Start_Section_Name or "Default"

    if UGCGameSystem.IsServer() then
        local Game_State = UGCGameSystem.GetGameState() -- 当前游戏状态
        UnrealNetwork.CallUnrealRPC_Multicast(Game_State, L_Enum.Name_RPC.Set_Anim_Montage, Player_Controller.PlayerKey,
            Anim_Montage_Path, Is_Playing, Play_Rate, Start_Section_Name)
        return
    end

    local Player_Pawn = UGCGameSystem.GetPlayerPawnByPlayerController(Player_Controller) -- 当前玩家角色
    L_GloTools.SetPawnAnimMontage(Player_Pawn, Anim_Montage_Path, Is_Playing, Play_Rate, Start_Section_Name)
end

--[[----------------------在指定位置播放一次性粒子特效------------------------]]
function L_GloTools.PlayParticleAtLocation(World_Context, Particle_Path, Location, Rotation, Scale)
    local Particle_System = UE.LoadObject(Particle_Path) -- 粒子特效资源
    if not Particle_System then
        return
    end

    return UGCGameSystem.SpawnEmitterAtLocation(World_Context, Particle_System, Location, Rotation or {}, Scale or {
        X = 1,
        Y = 1,
        Z = 1
    }, true)
end

return L_GloTools
