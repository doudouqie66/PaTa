local UIFoldMgr = {}
UIFoldMgr.__index = UIFoldMgr -- 折叠管理器实例索引

local Default_Animation_Duration = 0.22 -- 默认完整动画时长
local Default_Minimum_Scale_X = 0.96 -- 默认收起时横向缩放

--[[----------------------创建通用UI折叠管理器------------------------]]
function UIFoldMgr.New(Config)
    local Controller = setmetatable({}, UIFoldMgr) -- 新折叠管理器
    Controller.Expand_Button = Config.Expand_Button -- 展开按钮
    Controller.Collapse_Button = Config.Collapse_Button -- 收起按钮
    Controller.Panels = Config.Panels -- 需要展开和收起的控件
    Controller.Animation_Duration = Config.Duration or Default_Animation_Duration -- 完整动画时长
    Controller.Minimum_Scale_X = Config.Minimum_Scale_X or Default_Minimum_Scale_X -- 收起时横向缩放
    Controller.Pivot_X = Config.Pivot_X or 0.5 -- 动画中心横坐标
    Controller.Pivot_Y = Config.Pivot_Y or 0.0 -- 动画中心纵坐标
    Controller.Expand_Easing = Config.Expand_Easing or EEasingType.BackOut -- 展开缓动类型
    Controller.Collapse_Easing = Config.Collapse_Easing or EEasingType.QuadIn -- 收起缓动类型
    Controller.Animation_Progress = 0.0 -- 当前展开进度
    Controller.Animation_Serial = 0 -- 当前动画序号
    Controller.Expanded_State = Config.Default_Expanded == true -- 当前目标展开状态
    Controller:SetExpanded(Controller.Expanded_State, true)
    return Controller
end

--[[----------------------更新展开和收起按钮状态------------------------]]
function UIFoldMgr:UpdateButtons()
    if self.Expand_Button then
        self.Expand_Button:SetVisibility(self.Expanded_State and ESlateVisibility.Collapsed or ESlateVisibility.Visible)
    end
    if self.Collapse_Button then
        self.Collapse_Button:SetVisibility(self.Expanded_State and ESlateVisibility.Visible or ESlateVisibility.Collapsed)
    end
end

--[[----------------------应用折叠动画进度------------------------]]
function UIFoldMgr:ApplyProgress(Progress)
    local Opacity_Progress = math.max(0.0, math.min(1.0, Progress)) -- 限制后的透明度进度
    self.Animation_Progress = Progress
    for _, Panel in ipairs(self.Panels) do
        Panel:SetRenderTransformPivot(UGCMathUtility.MakeVector2D(self.Pivot_X, self.Pivot_Y))
        Panel:SetRenderScale(UGCMathUtility.MakeVector2D(
            self.Minimum_Scale_X + Progress * (1.0 - self.Minimum_Scale_X),
            Progress
        ))
        Panel:SetRenderOpacity(Opacity_Progress)
    end
end

--[[----------------------立即完成当前折叠状态------------------------]]
function UIFoldMgr:FinishState()
    self:ApplyProgress(self.Expanded_State and 1.0 or 0.0)
    for _, Panel in ipairs(self.Panels) do
        Panel:SetVisibility(self.Expanded_State and ESlateVisibility.Visible or ESlateVisibility.Collapsed)
    end
    self:UpdateButtons()
end

--[[----------------------设置面板展开状态------------------------]]
function UIFoldMgr:SetExpanded(Is_Expanded, Is_Immediate)
    local Target_Progress = Is_Expanded and 1.0 or 0.0 -- 本次动画目标进度
    local Start_Progress = self.Animation_Progress -- 本次动画起始进度

    self.Animation_Serial = self.Animation_Serial + 1
    local Animation_Serial = self.Animation_Serial -- 本次动画序号
    if self.Tween_Handler and UGCTweenSystem.IsTweenValid(self.Tween_Handler) then
        UGCTweenSystem.KillTween(self.Tween_Handler)
        self:ApplyProgress(Start_Progress)
    end

    self.Expanded_State = Is_Expanded
    if Is_Immediate or math.abs(Target_Progress - Start_Progress) < 0.001 then
        self:FinishState()
        return
    end

    for _, Panel in ipairs(self.Panels) do
        Panel:SetVisibility(ESlateVisibility.Visible)
    end
    self:UpdateButtons()

    local Animation_Time = self.Animation_Duration * math.abs(Target_Progress - Start_Progress) -- 本次动画时长
    local Tween_Config = UGCTweenSystem.MakeConfig(0, 0, false, 0) -- 单次补间配置
    self.Tween_Handler = UGCTweenSystem.TweenFloatValue(
        Start_Progress,
        Target_Progress,
        Animation_Time,
        Is_Expanded and self.Expand_Easing or self.Collapse_Easing,
        function(_, Progress)
            self:ApplyProgress(Progress)
        end,
        Tween_Config
    )
    UGCTweenSystem.BindCompletedDelegate(self.Tween_Handler, function()
        if Animation_Serial ~= self.Animation_Serial then
            return
        end
        self:FinishState()
    end)
end

--[[----------------------展开面板------------------------]]
function UIFoldMgr:Expand()
    self:SetExpanded(true)
end

--[[----------------------收起面板------------------------]]
function UIFoldMgr:Collapse()
    self:SetExpanded(false)
end

--[[----------------------切换面板展开状态------------------------]]
function UIFoldMgr:Toggle()
    self:SetExpanded(not self.Expanded_State)
end

--[[----------------------获取面板展开状态------------------------]]
function UIFoldMgr:IsExpanded()
    return self.Expanded_State
end

--[[----------------------销毁通用UI折叠管理器------------------------]]
function UIFoldMgr:Destroy()
    self.Animation_Serial = self.Animation_Serial + 1
    if self.Tween_Handler and UGCTweenSystem.IsTweenValid(self.Tween_Handler) then
        UGCTweenSystem.KillTween(self.Tween_Handler)
    end
    self.Tween_Handler = nil
end

return UIFoldMgr
