---@class UI11_C:UUserWidget
---@field Gold_Move_UP UWidgetAnimation
---@field Move_Down UWidgetAnimation
---@field Box_Before UWidgetAnimation
---@field Rotate_Anim UWidgetAnimation
---@field Button_72 UButton
---@field Button_147 UButton
---@field CanvasPanel_2 UCanvasPanel
---@field CanvasPanel_74 UCanvasPanel
---@field Image_0 UImage
---@field Image_96 UImage
---@field Image_285 UImage
---@field Image_286 UImage
---@field TextBlock_48 UTextBlock
---@field TextBlock_49 UTextBlock
---@field UIParticleEmitter_11 UUIParticleEmitter
---@field UIParticleEmitter_22 UUIParticleEmitter
--Edit Below--
local UI11 = {
    bInitDoOnce = false
}

function UI11:Construct()
    self:LuaInit();

end

-- function UI11:Tick(MyGeometry, InDeltaTime)

-- end

-- function UI11:Destruct()

-- end

-- [Editor Generated Lua] function define Begin:
function UI11:LuaInit()
    if self.bInitDoOnce then
        return;
    end
    self.bInitDoOnce = true;
    self:PlayAnimation(self.Rotate_Anim, 0, 0, EUMGSequencePlayMode.Forward, 0.1);
    self:PlayAnimation(self.Box_Before, 0, 0, EUMGSequencePlayMode.Forward, 0.1);

    -- [Editor Generated Lua] BindingProperty Begin:
    -- [Editor Generated Lua] BindingProperty End;

    -- [Editor Generated Lua] BindingEvent Begin:
    self.Button_147.OnClicked:Add(self.Button_147_OnClicked, self);
    self.Button_72.OnClicked:Add(self.Button_72_OnClicked, self);
    -- [Editor Generated Lua] BindingEvent End;
end
--[[-------------------关闭界面---------------------------]] --
function UI11:Button_147_OnClicked()
    L_GloTools.UIMgr(L_Enum.Name_ClassPath.UI11, false)
    L_GloTools.UIMgr(L_Enum.Name_ClassPath.UI02, true, false)
    L_GloTools.UIMgr(L_Enum.Name_ClassPath.UI10, true, false)

end
--[[----------------------开金币------------------------]] --
function UI11:Button_72_OnClicked()
    self.Button_72:SetIsEnabled(false)

    local Drop_Result = UGCDropSystem.DropItems(5)
    local Drop_Count = Drop_Result[1005]
    ---触发点击图片
    self.Image_0:SetVisibility(ESlateVisibility.Visible)

    ---先往下移动
    self:PlayAnimation(self.Move_Down, 0, 1, EUMGSequencePlayMode.Forward, 1);

    ---
    UGCTimerUtility.CreateLuaTimer(1, function()
        ---打开宝箱开启的UI
        self.CanvasPanel_74:SetVisibility(ESlateVisibility.Visible)
        self.CanvasPanel_2:SetVisibility(ESlateVisibility.Collapsed)

        ---播放金币向上的动画
        self:PlayAnimation(self.Gold_Move_UP, 0, 1, EUMGSequencePlayMode.Forward, 0.5);
        UGCTimerUtility.CreateLuaTimer(2, function()
            ---关闭点击图片

            self.Image_0:SetVisibility(ESlateVisibility.Collapsed)

            ---文本打开
            self.TextBlock_49:SetVisibility(ESlateVisibility.Visible)
            ---开启跳动的动画
            local Gold_Count_Tween = UGCTweenSystem.TweenFloatValue(0, Drop_Count, 3, EEasingType.QuadOut,
                function(_, Gold_Count)
                    self.TextBlock_49:SetText("+" .. tostring(math.floor(Gold_Count + 0.5)))
                end, UGCTweenSystem.MakeConfig(0, 0, false, 0))

            UGCTweenSystem.BindCompletedDelegate(Gold_Count_Tween, function()
                self.TextBlock_49:SetText("+" .. tostring(Drop_Count))
            end)

            ---获得奖励
            UGCTimerUtility.CreateLuaTimer(3, function()
                local PC = UGCGameSystem.GetLocalPlayerController()
                UnrealNetwork.CallUnrealRPC(PC, PC, L_Enum.Name_RPC.Grant_Virtual_Item, 1005, Drop_Count)

            end)
        end)
    end)
end

-- [Editor Generated Lua] function define End;

return UI11
