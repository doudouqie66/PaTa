---@class Tips_01_C:UUserWidget
---@field Move UWidgetAnimation
---@field ToastBg UBorder
---@field ToastText UTextBlock
--Edit Below--

local Tips_01 = {}

--[[----------------------设置提示文本------------------------]]
function Tips_01:SetTipText(text)
    self.ToastText:SetText(text)
end

--[[----------------------播放提示动画------------------------]]
function Tips_01:PlayMove()
    self:PlayAnimation(self.Move, 0, 1, EUMGSequencePlayMode.Forward, 1)
end

--[[----------------------提示动画结束后移除控件------------------------]]
function Tips_01:OnAnimationFinished(Animation)
    if Animation == self.Move then
        self:RemoveFromViewport()
    end
end

return Tips_01
