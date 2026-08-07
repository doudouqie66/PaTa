---@class UI12_C:UUserWidget
---@field Button_69 UButton
---@field Button_112 UButton
---@field Button_147 UButton
---@field Button_177 UButton
---@field Button_186 UButton
---@field Button_194 UButton
---@field Button_195 UButton
---@field Button_196 UButton
---@field Button_197 UButton
---@field Button_198 UButton
---@field Button_200 UButton
---@field CanvasPanel_152 UCanvasPanel
---@field CanvasPanel_160 UCanvasPanel
---@field CanvasPanel_161 UCanvasPanel
---@field CanvasPanel_162 UCanvasPanel
---@field CanvasPanel_163 UCanvasPanel
---@field CanvasPanel_164 UCanvasPanel
---@field CanvasPanel_165 UCanvasPanel
---@field CanvasPanel_166 UCanvasPanel
---@field Image_0 UImage
---@field Image_1 UImage
---@field Image_69 UImage
---@field Image_70 UImage
---@field Image_95 UImage
---@field Image_100 UImage
---@field Image_145 UImage
---@field Image_170 UImage
---@field Image_257 UImage
---@field Image_265 UImage
---@field Image_266 UImage
---@field Image_267 UImage
---@field Image_268 UImage
---@field Image_269 UImage
---@field Image_270 UImage
---@field Image_271 UImage
---@field UIParticleEmitter_32 UUIParticleEmitter
--Edit Below--
local UIMgr = UGCGameSystem.UGCRequire("Script.L_Com.UIMgr") -- 抽奖动画管理

local Lottery_Hide_X = 0 -- 抽奖完成后的隐藏横坐标
local Lottery_Hide_Y = -690 -- 抽奖完成后的隐藏纵坐标
local Lottery_Drop_ID = 4 -- 抽奖使用的掉落表编号
local Lottery_Count_Order = {66, 166, 888, 6, 188, 666, 0, 8} -- 抽奖格子数量顺序（左上到右下）

local UI12 = {
    bInitDoOnce = false
}

function UI12:Construct()
    self:LuaInit();

end

-- function UI12:Tick(MyGeometry, InDeltaTime)

-- end

--[[----------------------销毁界面并停止抽奖动画------------------------]]
function UI12:Destruct()
    UIMgr.StopLotteryEffect()
end

-- [Editor Generated Lua] function define Begin:
function UI12:LuaInit()
    if self.bInitDoOnce then
        return;
    end
    self.bInitDoOnce = true;
    math.randomseed(os.time()) -- 使用系统时间初始化随机种子
    -- [Editor Generated Lua] BindingProperty Begin:
    -- [Editor Generated Lua] BindingProperty End;

    -- [Editor Generated Lua] BindingEvent Begin:
    self.Button_147.OnClicked:Add(self.Button_147_OnClicked, self);
    self.Button_177.OnClicked:Add(self.Button_177_OnClicked, self);
    self.Button_69.OnClicked:Add(self.Button_69_OnClicked, self);
    -- [Editor Generated Lua] BindingEvent End;

    self.Lottery_Panels = {
        self.CanvasPanel_160,
        self.CanvasPanel_152,
        self.CanvasPanel_161,
        self.CanvasPanel_162,
        self.CanvasPanel_163,
        self.CanvasPanel_164,
        self.CanvasPanel_165,
        self.CanvasPanel_166
    } -- 抽奖奖品格子面板（左上、中上、右上、中左、中右、左下、中下、右下）

    self.Lottery_Images = {
        self.Image_265,
        self.Image_257,
        self.Image_266,
        self.Image_267,
        self.Image_268,
        self.Image_269,
        self.Image_270,
        self.Image_271
    } -- 抽奖奖品格子图标（与格子顺序一致）

    self.Lottery_Drop_Items = {} -- 掉落表ID4的奖励配置
    local Drop_Table = UGCGameSystem.GetTableData("Data/Table/UGCDrop") -- 掉落表配置
    if Drop_Table then
        for Drop_ID, Drop_Info in pairs(Drop_Table) do
            if tonumber(Drop_ID) == Lottery_Drop_ID then
                local Item_Infos = Drop_Info.DropItemInfo -- 掉落表ID4的物品信息
                if Item_Infos then
                    local Item_Count = type(Item_Infos) == "table" and #Item_Infos or Item_Infos:Num() -- 奖励物品数量
                    for Item_Index = 1, Item_Count do
                        local Item_Info = Item_Infos[Item_Index] -- 单个奖励物品配置
                        local Slot_Index = nil -- 当前奖励对应的格子索引
                        for Order_Index, Order_Count in ipairs(Lottery_Count_Order) do
                            if Item_Info.ItemNumMin == Order_Count then
                                Slot_Index = Order_Index
                                break
                            end
                        end
                        if Slot_Index then
                            table.insert(self.Lottery_Drop_Items, {
                                ItemID = Item_Info.ItemID,
                                Item_Count = Item_Info.ItemNumMin,
                                Item_Weight = Item_Info.Parameter,
                                Slot_Index = Slot_Index
                            })
                        end
                    end
                end
                break
            end
        end
    end

    for Reward_Index, Reward_Info in ipairs(self.Lottery_Drop_Items) do
        ugcprint(string.format("[UI12] 掉落配置 %d item=%d count=%d weight=%d weighttype=%s slot=%d", Reward_Index,
            Reward_Info.ItemID, Reward_Info.Item_Count, Reward_Info.Item_Weight or 0, type(Reward_Info.Item_Weight),
            Reward_Info.Slot_Index or 0))
    end

    for Reward_Index, Reward_Info in ipairs(self.Lottery_Drop_Items) do
        local Reward_Image = self.Lottery_Images[Reward_Index] -- 当前格子的图标控件
        local Reward_Icon_Path = UGCItemSystemV2.GetItemIconTextureV2(Reward_Info.ItemID) -- 当前格子的图标路径
        if Reward_Icon_Path then
            UGCObjectUtility.AsyncLoadObjectBySoftPath(Reward_Icon_Path, function(Loaded_Texture)
                if Loaded_Texture and UE.IsValid(Reward_Image) then
                    Reward_Image:SetBrushFromTexture(Loaded_Texture, true)
                end
            end)
        end
    end
end

function UI12:Button_147_OnClicked()
    UIMgr.StopLotteryEffect()
    self.Is_Lottery_Drawing = false
    self.Button_69:SetIsEnabled(true)
    L_GloTools.UIMgr(L_Enum.Name_ClassPath.UI12, false)
end

function UI12:Button_177_OnClicked()
    local bOK = UGCWidgetManagerSystem.Share(function()
        L_TipsTool.ShowTips_01("分享成功")
    end)
    if not bOK then
        PopUpNoticeUI.ShowFastNoticeQueue("当前无法分享")
        L_TipsTool.ShowTips_01("当前无法分享")
    end
end

--[[----------------------计算本次抽奖结果------------------------]]
function UI12:GetLotteryResult()
    local Total_Weight = 0 -- 所有奖励的总权重
    for _, Reward_Info in ipairs(self.Lottery_Drop_Items) do
        Total_Weight = Total_Weight + (Reward_Info.Item_Weight or 0)
    end

    if Total_Weight <= 0 then
        self.Last_Reward_Item_ID = 0 -- 兜底奖励物品ID
        self.Last_Reward_Count = 0 -- 兜底奖励数量
        return 1
    end

    local Roll_Value = math.random(Total_Weight) -- 本次随机权重
    local Random_Weight = Roll_Value
    for Reward_Index, Reward_Info in ipairs(self.Lottery_Drop_Items) do
        Random_Weight = Random_Weight - (Reward_Info.Item_Weight or 0)
        if Random_Weight <= 0 then
            self.Last_Reward_Item_ID = Reward_Info.ItemID -- 记录本次奖励物品ID
            self.Last_Reward_Count = Reward_Info.Item_Count -- 记录本次奖励数量
            ugcprint(string.format("[UI12] 抽奖 total=%d random=%d rawindex=%d index=%d item=%d count=%d", Total_Weight,
                Roll_Value, Reward_Index, Reward_Info.Slot_Index or Reward_Index, Reward_Info.ItemID,
                Reward_Info.Item_Count))
            return Reward_Info.Slot_Index or Reward_Index
        end
    end

    self.Last_Reward_Item_ID = 0 -- 兜底奖励物品ID
    self.Last_Reward_Count = 0 -- 兜底奖励数量
    return 1
end

function UI12:Button_69_OnClicked()
    if self.Is_Lottery_Drawing then
        return
    end

    self.Is_Lottery_Drawing = true -- 抽奖动画进行中
    self.Button_69:SetIsEnabled(false)
    local Target_Index = self:GetLotteryResult() -- 本次抽奖结果
    UIMgr.PlayLotteryEffect(self.Lottery_Panels, self.Image_1, Target_Index, function(Stop_Index)
        local Image_Slot = UGCWidgetManagerSystem.SlotAsCanvasSlot(self.Image_1)
        if Image_Slot then
            Image_Slot:SetPosition(UGCMathUtility.MakeVector2D(Lottery_Hide_X, Lottery_Hide_Y))
        end
        self.Is_Lottery_Drawing = false
        self.Button_69:SetIsEnabled(true)
        local Reward_Count = self.Last_Reward_Count or 0 -- 本次奖励数量
        ugcprint(string.format("[UI12] 动画结束 stop=%s count=%d", tostring(Stop_Index), Reward_Count))
        if Reward_Count > 0 then
            local Player_Controller = UGCGameSystem.GetLocalPlayerController() -- 本地玩家控制器
            if Player_Controller then
                UnrealNetwork.CallUnrealRPC(Player_Controller, Player_Controller, L_Enum.Name_RPC.Grant_Lottery_Reward,
                    self.Last_Reward_Item_ID, Reward_Count)
            end
            L_TipsTool.ShowTips_01("获得奖励" .. tostring(Reward_Count) .. "个")
        else
            L_TipsTool.ShowTips_01("谢谢参与")
        end
    end)
end

-- [Editor Generated Lua] function define End;

return UI12
