---@class UI11_C:UUserWidget
---@field Rotate_Anim UWidgetAnimation
---@field Button_72 UButton
---@field Button_147 UButton
---@field CanvasPanel_74 UCanvasPanel
---@field Image_96 UImage
---@field Image_285 UImage
---@field Image_286 UImage
---@field TextBlock_48 UTextBlock
---@field TextBlock_49 UTextBlock
---@field UIParticleEmitter_11 UUIParticleEmitter
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
    L_GloTools.UIMgr(L_Enum.Name_ClassPath.UI02, true)
    L_GloTools.UIMgr(L_Enum.Name_ClassPath.UI10, true)

end
--[[----------------------开金币------------------------]] --
function UI11:Button_72_OnClicked()

    local Drop_Result = UGCDropSystem.DropItems(4)

    local Drop_Count = Drop_Result[1005]
    self.CanvasPanel_74:SetVisibility(ESlateVisibility.Visible)
    self.TextBlock_49:SetText("金币+" .. tostring(Drop_Count))
    self.Button_72:SetVisibility(ESlateVisibility.Collapsed)
    self.TextBlock_48:SetVisibility(ESlateVisibility.Collapsed)
    self.Image_96:SetVisibility(ESlateVisibility.Collapsed)
    local PC = UGCGameSystem.GetLocalPlayerController()

    UGCTimerUtility.CreateLuaTimer(1, function()
        UnrealNetwork.CallUnrealRPC(PC, PC, L_Enum.Name_RPC.Grant_Virtual_Item, 1005, Drop_Count)
    end)

end

-- [Editor Generated Lua] function define End;

return UI11
