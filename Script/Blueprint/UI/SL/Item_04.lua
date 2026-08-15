---@class Item_04_C:UUserWidget
---@field Button_5 UButton
---@field CanvasPanel_3 UCanvasPanel
---@field Image_5 UImage
---@field Image_6 UImage
--Edit Below--
local Item_04 = { bInitDoOnce = false } 

--[[----------------------初始化物品四控件------------------------]]
function Item_04:Construct()
    if self.bInitDoOnce then
        return
    end
    self.bInitDoOnce = true
    self.Button_5.OnClicked:Add(self.Button_5_OnClicked, self)
end

--[[----------------------点击后折叠物品四按钮------------------------]]
function Item_04:Button_5_OnClicked()
    self.Button_5:SetIsEnabled(false)
    self:PlayClickEffect()
end

--[[----------------------播放点击音效并隐藏按钮------------------------]]
function Item_04:PlayClickEffect()
    SoundMgr.PlaySound2D(SoundMgr.SoundName.UI_Click)

    --[[----------------------渐变隐藏按钮------------------------]]
    self:FadeOutButton()
end

--[[----------------------渐隐按钮------------------------]]
function Item_04:FadeOutButton()
    UGCTweenSystem.TweenFloatValue(1.0, 0.0, 2.0, EEasingType.Linear, function(_, Value)
        self.Button_5:SetRenderOpacity(Value)
    end, UGCTweenSystem.MakeConfig(0, 0, false, 0))
end

-- function Item_04:Tick(MyGeometry, InDeltaTime)

-- end

-- function Item_04:Destruct()

-- end

return Item_04
