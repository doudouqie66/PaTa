---@class UI_Head_C:UAEUserWidget
---@field Avatar Common_Avatar_BP_C
---@field HeadImage UImage
---@field ProfileFrameImage UImage
---@field SizeBox_0 USizeBox
---@field HeadImagePath FString
---@field HeadImageType TEnumAsByte<GetHeadImageTypeEnum>
---@field ProfileFrameAssetPath FString
--Edit Below--
---@class UI_Head:UUAEUserWidget
local UI_Head = {
	PlayerKey = nil,
	Character = nil,
	Size = 100,
}
function UI_Head:print(msg)
	print(string.format("[UI_Head]: %s", msg))
end

function UI_Head:Construct()
	self:print("Construct")
	self:ShowUI(nil)
end

function UI_Head:ShowUI(InCharacter)
	self:print("ShowUI")
	self:SetProfileFrameByAssetPath()
	self:SetWidthAndHeight(self.Size)
	if self.HeadImageType == 0 then --根据PlayerID设置头像
		self.HeadImage:SetVisibility(ESlateVisibility.Collapsed)
		self.Avatar:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
		local Character = nil
		if UE.IsValid(InCharacter) then
			Character = InCharacter
		else
			Character = GameplayStatics.GetPlayerController(self, 0):GetPlayerCharacterSafety()
		end
		self.Character = Character
		self:GetPlayerKeyByCharacter(Character)
		self:SetHeadImageByPlayerKey(self.PlayerKey)
	elseif self.HeadImageType == 1 then --根据Asset路径设置头像
		self:print("set head image by asset path")
		self:SetHeadImageByAssetPath()
		self.HeadImage:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
		self.Avatar:SetVisibility(ESlateVisibility.Collapsed)
	end
end
function UI_Head:GetPlayerKeyByCharacter(Character)
	local PC = Character:GetPlayerControllerSafety()
	if PC ~= nil then
		self.PlayerKey = PC.PlayerKey
	end
end
function UI_Head:SetHeadImageByPlayerKey(PlayerKey)
	self:print("SetHeadImageByPlayerKey --" .. PlayerKey)
	local PS = UGCGameSystem.GetPlayerStateByPlayerKey(PlayerKey):GetTeamMatePlayerStateFromPlayerKey(PlayerKey)
	local AccountInfo = UGCPlayerStateSystem.GetPlayerAccountInfo(PlayerKey)
	local UID = PS:GetInt64UID()
	local IconURL = PS.IconURL
	self:print(string.format("UID:%d,IconURL:%s,playerlevel:%d", UID, IconURL, AccountInfo.PlayerLevel))
	self.Avatar:InitView(1, UID, IconURL, nil, nil, AccountInfo.PlayerLevel, true)
end
function UI_Head:ResetHeadImagePath(NewPath)
	self.HeadImagePath = NewPath
end
function UI_Head:ResetProfileFrameAssetPath(NewPath)
	self.ProfileFrameAssetPath = NewPath
end
--Type=0为PlayerUD,Type=1为Asset路径
function UI_Head:ResetHeadImageType(Type)
	self.HeadImageType = Type
end
function UI_Head:SetHeadImageByAssetPath()
	FuncUtil.SetImageWithPathAsync(self.HeadImage, self.HeadImagePath)
end
function UI_Head:SetProfileFrameByAssetPath()
	FuncUtil.SetImageWithPathAsync(self.ProfileFrameImage, self.ProfileFrameAssetPath)
end
function UI_Head:SetWidthAndHeight(Size)
	self.SizeBox_0:SetWidthOverride(Size)
	self.SizeBox_0:SetHeightOverride(Size)
end
return UI_Head

