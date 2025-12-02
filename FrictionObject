local FrictionObject = {
	LastCFrame        = CFrame.new(),
	CFrame            = CFrame.new(),
	FrictionCFrame	  = CFrame.new(),

	GlobalVelocity    = Vector3.new(),
	LocalVelocity     = Vector3.new(),
	Force             = Vector3.new(),

	XVelocity         = 0,
	YVelocity         = 0,
	ZVelocity         = 0,

	XFriction         = 50,
	ZFriction         = 10,

	Pitch             = 0,
	Yaw               = 0,

	MaxForce          = 2000,
}

FrictionObject.__index = FrictionObject

function FrictionObject:Frame(deltaTime)
	if not self.Attachment then return end
	deltaTime = deltaTime or 1

	self.CFrame =  self.Attachment.WorldCFrame
	self.GlobalVelocity = (self.CFrame.Position - self.LastCFrame.Position) / deltaTime
	self.LastCFrame = self.CFrame

	self.FrictionCFrame = self.CFrame * CFrame.Angles(0, math.rad(self.Yaw), 0)

	local right = self.FrictionCFrame.RightVector
	local up    = self.FrictionCFrame.UpVector
	local look  = self.FrictionCFrame.LookVector

	self.XVelocity = self.GlobalVelocity:Dot(right)
	self.YVelocity = self.GlobalVelocity:Dot(up)
	self.ZVelocity = self.GlobalVelocity:Dot(look)

	self.LocalVelocity = Vector3.new(self.XVelocity, self.YVelocity, self.ZVelocity)

	local force = (-(right * self.XVelocity) * self.XFriction) + (-(look * self.ZVelocity) * self.ZFriction)
	if force.Magnitude > self.MaxForce then force = force.Unit * self.MaxForce end
	
	self.Pitch -= self.ZVelocity / 1.3
	self.Force = force
end

function FrictionObject.New(attachment)
	local self = setmetatable({}, FrictionObject)
	self.Attachment = attachment
	self.CFrame = attachment.WorldCFrame
	self.LastCFrame = attachment.WorldCFrame
	return self
end

return FrictionObject
