local SpringObject = {
	SpringLength       = 0,
	LastSpringLength   = 0,

	SpringForce        = 0,
	SpringDisplacement = 0,
	SpringVelocity     = 0,

	Compression = 0,
	StiffnessForce     = 0,
	DamperForce        = 0,
	ForceVector        = Vector3.new(),

	Raycast            = nil,
	RaycastPosition    = Vector3.new(),
	RaycastDirection   = Vector3.new(),
	RaycastDistance    = 0,

	CFrame             = CFrame.new(),
	Attachment         = nil,
	RaycastParams      = RaycastParams.new(),
	

	MaxSpringLength    = 1.5,
	TargetSpringLength = 1.3,
	WheelRadius        = 2.669/2,
	Damper             = 1000,
	Stiffness          = 30000,
	UseGlobalUpVector = true
}

SpringObject.__index = SpringObject

function SpringObject:Frame(DeltaTime)
	DeltaTime = DeltaTime or 1
	if not self.Attachment or not self.RaycastParams then return end

	self.RaycastPosition = self.Attachment.WorldCFrame.Position
	self.RaycastDirection = -self.Attachment.WorldCFrame.UpVector
	self.RaycastDistance = self.MaxSpringLength + self.WheelRadius

	self.Raycast = workspace:Raycast(
		self.RaycastPosition,
		self.RaycastDirection * self.RaycastDistance,
		self.RaycastParams
	)

	self.SpringLength = if self.Raycast then self.Raycast.Distance - self.WheelRadius else self.MaxSpringLength

	self.SpringDisplacement = self.TargetSpringLength - self.SpringLength

	self.SpringVelocity = (self.SpringLength - self.LastSpringLength) / DeltaTime
	self.LastSpringLength = self.SpringLength

	self.StiffnessForce = self.Stiffness * self.SpringDisplacement
	self.DamperForce    = self.Damper * -self.SpringVelocity

	local Force = self.StiffnessForce + self.DamperForce

	self.CFrame = self.Attachment.WorldCFrame:ToWorldSpace(CFrame.new(0, -self.SpringLength, 0))

	self.Compression = math.clamp(1 - (self.SpringLength / self.TargetSpringLength), 0,1)
	self.SpringForce = if self.Raycast then Force else 0
	self.ForceVector = if self.UseGlobalUpVector then self.SpringForce * Vector3.yAxis else self.SpringForce * self.Attachment.CFrame.UpVector
end

function SpringObject.New(attachment)
	local self = setmetatable({}, SpringObject)
	self.Attachment = attachment
	self.RaycastParams.FilterType = Enum.RaycastFilterType.Exclude
	return self
end

return SpringObject
