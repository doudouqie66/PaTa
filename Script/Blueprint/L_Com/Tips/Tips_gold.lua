---@class Tips_gold_C:UUserWidget
---@field ToastBg UBorder
---@field ToastText UTextBlock
--Edit Below--
---@class Tips_01_C:UUserWidget
---@field TextBlock_78 UTextBlock
---@field ToastBg UBorder
---@field ToastText UTextBlock
-- Edit Below--
local Tips_gold = {}

--[[----------------------设置提示文本------------------------]]
function Tips_gold:SetTipText(text)
    self.ToastText:SetText(text)
end

return Tips_gold
