---@class UI10_C:UUserWidget
---@field Button_61 UButton
---@field Button_62 UButton
---@field Button_63 UButton
---@field Button_244 UButton
---@field Button_245 UButton
---@field CanvasPanel_93 UCanvasPanel
---@field CanvasPanel_94 UCanvasPanel
---@field CanvasPanel_95 UCanvasPanel
---@field Image_126 UImage
---@field Image_211 UImage
---@field Image_212 UImage
---@field Image_213 UImage
---@field Image_214 UImage
---@field Image_215 UImage
---@field TextBlock_88 UTextBlock
---@field TextBlock_89 UTextBlock
---@field TextBlock_90 UTextBlock
--Edit Below--
---@class UI10_C:UUserWidget
---@field Button_61 UButton
---@field Button_62 UButton
---@field Button_63 UButton
---@field Button_244 UButton
---@field Button_245 UButton
---@field CanvasPanel_93 UCanvasPanel
---@field CanvasPanel_94 UCanvasPanel
---@field CanvasPanel_95 UCanvasPanel
---@field Image_126 UImage
---@field Image_211 UImage
---@field Image_212 UImage
---@field Image_213 UImage
---@field Image_214 UImage
---@field Image_215 UImage
---@field TextBlock_88 UTextBlock
---@field TextBlock_89 UTextBlock
---@field TextBlock_90 UTextBlock
-- Edit Below--
local UIFoldMgr = UGCGameSystem.UGCRequire("Script.L_Com.UIFoldMgr") -- 通用UI折叠管理器

local UI10 = {
    bInitDoOnce = false
}

--[[----------------------初始化折叠面板------------------------]]
function UI10:Construct()
    self:LuaInit()
    self.Fold_Manager = UIFoldMgr.New({ -- 当前界面的折叠管理器
        Expand_Button = self.Button_244,
        Collapse_Button = self.Button_245,
        Panels = {self.CanvasPanel_93, self.CanvasPanel_94, self.CanvasPanel_95},
        Default_Expanded = true
    })
end

--[[----------------------销毁折叠面板------------------------]]
function UI10:Destruct()
    self.Fold_Manager:Destroy()
end

--[[----------------------绑定折叠面板按钮事件------------------------]]
function UI10:LuaInit()
    if self.bInitDoOnce then
        return
    end
    self.bInitDoOnce = true
    self.Button_244.OnClicked:Add(self.Button_244_OnClicked, self)
    self.Button_245.OnClicked:Add(self.Button_245_OnClicked, self)
end

--[[----------------------点击展开折叠面板------------------------]]
function UI10:Button_244_OnClicked()
    self.Fold_Manager:Expand()
end

--[[----------------------点击收起折叠面板------------------------]]
function UI10:Button_245_OnClicked()
    self.Fold_Manager:Collapse()
end

return UI10
