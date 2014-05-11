class "FedoraMeActiveImage"

function FedoraMeActiveImage:__init(image)
	self.image = image
	self.leftImage = Image.Create(AssetLocation.Base64, image.image)
	self.imageSize = self.leftImage:GetPixelSize() * image.size
	self.leftImage:SetSize(self.imageSize)
	self.lastSide = FedoraSides.left
	self.flipOffset = Vector2(0, 0)
end

class "FedoraMe"

function FedoraMe:__init()
	self.activeImage = FedoraMeActiveImage(FedoraMeImages[1])
	
	Events:Subscribe("Render", self, self.Render)
end

function FedoraMe:Render(e)
	if self.activeImage == nil then return end
	

	local headPosition = Render:WorldToScreen(LocalPlayer:GetBonePosition("ragdoll_head"))
	local angleDiff = Angle(LocalPlayer:GetAngle().yaw - Camera:GetAngle().yaw, 0, 0).yaw * (180 / math.pi)
	local sideToUse = (angleDiff > 90 or angleDiff < -90) and FedoraSides.right or FedoraSides.left
	
	if self.activeImage.lastSide ~= sideToUse then
		self.activeImage.lastSide = sideToUse
		self.activeImage.leftImage:SetSize(Vector2(sideToUse == FedoraSides.left and self.activeImage.imageSize.x or -self.activeImage.imageSize.x, self.activeImage.imageSize.y))
		self.activeImage.flipOffset = Vector2(sideToUse == FedoraSides.left and 0 or self.activeImage.imageSize.x, 0)
	end
	
	headPosition.x = headPosition.x - self.activeImage.imageSize.x / 2 + self.activeImage.image.offset.x
	headPosition.y = headPosition.y - self.activeImage.imageSize.y / 2 + self.activeImage.image.offset.y
	self.activeImage.leftImage:SetPosition(headPosition + self.activeImage.flipOffset)
	--self.activeImage.leftImage:SetSize(Vector2(-self.activeImage.imageSize.x, self.activeImage.imageSize.y))
	self.activeImage.leftImage:Draw()
end