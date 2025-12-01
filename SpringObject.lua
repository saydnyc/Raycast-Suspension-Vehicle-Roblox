local SpringObject = {
	MaxSpringLength    = 10,
	TargetSpringLength = 3,
	WheelRadius        = 1.9,

	SpringLength       = 0,
	LastSpringLength   = 0,

	SpringForce        = 0,
	SpringDisplacement = 0,
	SpringVelocity     = 0,

	StiffnessForce     = 0,
	DamperForce        = 0,

	Raycast            = nil,
	RaycastPosition    = Vector3.new(),
	RaycastDirection   = Vector3.new(),
	RaycastDistance    = 0,

	CFrame             = CFrame.new(),
	Attachment         = Instance.new("Attachment"),
	RaycastParams      = nil,

	Damper             = 3000,
	Stiffness          = 100000,
}


SpringObject.__index = SpringObject

function SpringObject:Frame(DeltaTime)
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

	self.CFrame = self.Attachment.WorldCFrame:ToWorldSpace(CFrame.new(0, -self.SpringLength, 0))

	self.SpringForce = if self.Raycast then self.StiffnessForce + self.DamperForce else 0
end


function SpringObject.New(attachment)
	local self = setmetatable({}, SpringObject)
	self.RaycastParams = RaycastParams.new()
	self.RaycastParams.FilterType = Enum.RaycastFilterType.Exclude
	self.Attachment = attachment
	
	return self
end


return SpringObject
