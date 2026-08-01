---@class UI_Rank_02_C:UUserWidget
---@field TextBlock_0 UTextBlock
---@field Rank_1 UTextBlock
---@field Player_1 UTextBlock
---@field Time_1 UTextBlock
---@field Rank_2 UTextBlock
---@field Player_2 UTextBlock
---@field Time_2 UTextBlock
---@field Rank_3 UTextBlock
---@field Player_3 UTextBlock
---@field Time_3 UTextBlock
---@field Rank_4 UTextBlock
---@field Player_4 UTextBlock
---@field Time_4 UTextBlock
---@field Rank_5 UTextBlock
---@field Player_5 UTextBlock
---@field Time_5 UTextBlock
---@field Rank_6 UTextBlock
---@field Player_6 UTextBlock
---@field Time_6 UTextBlock
---@field Rank_7 UTextBlock
---@field Player_7 UTextBlock
---@field Time_7 UTextBlock
---@field Rank_8 UTextBlock
---@field Player_8 UTextBlock
---@field Time_8 UTextBlock
---@field Rank_9 UTextBlock
---@field Player_9 UTextBlock
---@field Time_9 UTextBlock
---@field Rank_10 UTextBlock
---@field Player_10 UTextBlock
---@field Time_10 UTextBlock
--Edit Below--
local UI_Rank_02 = { bInitDoOnce = false }

--[[----------------------刷新奖杯排行榜------------------------]]
function UI_Rank_02:RefreshRankingList(Rank_List_Data, Ranking_List_Manager, Rank_ID)
    local Rank_Texts = {self.Rank_1, self.Rank_2, self.Rank_3, self.Rank_4, self.Rank_5, self.Rank_6, self.Rank_7, self.Rank_8, self.Rank_9, self.Rank_10} -- 名次文本
    local Player_Texts = {self.Player_1, self.Player_2, self.Player_3, self.Player_4, self.Player_5, self.Player_6, self.Player_7, self.Player_8, self.Player_9, self.Player_10} -- 玩家文本
    local Trophy_Texts = {self.Time_1, self.Time_2, self.Time_3, self.Time_4, self.Time_5, self.Time_6, self.Time_7, self.Time_8, self.Time_9, self.Time_10} -- 奖杯数量文本

    for Index = 1, 10 do
        local Rank_Data = Rank_List_Data and Rank_List_Data[Index] -- 当前名次数据
        if Rank_Data then
            local Profile_Data = Ranking_List_Manager:GetProfileData(Rank_ID, Rank_Data.UID) -- 玩家资料
            local Player_Name = Profile_Data and (Profile_Data.ShowName or Profile_Data.PlayerName) or "匿名玩家" -- 玩家显示名
            local Trophy_Count = math.max(0, math.floor(Rank_Data.Score or 0)) -- 奖杯数量
            Rank_Texts[Index]:SetText(tostring(Rank_Data.Rank or Index))
            Player_Texts[Index]:SetText(Player_Name)
            Trophy_Texts[Index]:SetText(tostring(Trophy_Count))
        else
            Rank_Texts[Index]:SetText(tostring(Index))
            Player_Texts[Index]:SetText("--")
            Trophy_Texts[Index]:SetText("--")
        end
    end
end

-- function UI_Rank_02:Tick(MyGeometry, InDeltaTime)

-- end

-- function UI_Rank_02:Destruct()

-- end

return UI_Rank_02
