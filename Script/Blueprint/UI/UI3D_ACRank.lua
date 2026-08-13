---@class UI3D_ACRank_C:UUserWidget
---@field TextBlock_0 UTextBlock
---@field UI_Head UI_Head_C
--Edit Below--
local UI3D_ACRank = { bInitDoOnce = false } 

--[[----------------------刷新排行榜名字和头像------------------------]]
function UI3D_ACRank:RefreshRankDisplay(Rank_Data, Profile_Data)
    if not Rank_Data then
        local Null_Profile_Texture = UGCObjectUtility.LoadObject(L_Enum.Path_RankBP.Pic_Null) -- 暂无玩家头像

        self.TextBlock_0:SetText("暂无")
        self.UI_Head.HeadImage:SetBrushFromTexture(Null_Profile_Texture, true)
        self.UI_Head.HeadImage:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.UI_Head.Avatar:SetVisibility(ESlateVisibility.Collapsed)
        return
    end

    self.UI_Head.HeadImage:SetVisibility(ESlateVisibility.Collapsed)
    self.UI_Head.Avatar:SetVisibility(ESlateVisibility.SelfHitTestInvisible)

    if Profile_Data and next(Profile_Data) then
        self.TextBlock_0:SetText(Profile_Data.ShowName or Profile_Data.PlayerName or "匿名玩家")
        self.UI_Head.Avatar:InitView(2, Profile_Data.UID, Profile_Data.PicUrl, nil, nil, nil, true, false)
    else
        self.TextBlock_0:SetText("玩家 UID: " .. tostring(Rank_Data.UID))
        self.UI_Head.Avatar:InitView(2, Rank_Data.UID, "", nil, nil, nil, true, false)
    end
end

--[==[ Construct
function UI3D_ACRank:Construct()
	
end
-- Construct ]==]

-- function UI3D_ACRank:Tick(MyGeometry, InDeltaTime)

-- end

-- function UI3D_ACRank:Destruct()

-- end

return UI3D_ACRank
