--[[
module = {
	x=emitterPositionX, y=emitterPositionY,
	[1] = {
		system=particleSystem1,
		kickStartSteps=steps1, kickStartDt=dt1, emitAtStart=count1,
		blendMode=blendMode1, shader=shader1,
		texturePreset=preset1, texturePath=path1,
		shaderPath=path1, shaderFilename=filename1,
		x=emitterOffsetX, y=emitterOffsetY
	},
	[2] = {
		system=particleSystem2,
		...
	},
	...
}
]]
local LG        = love.graphics
local particles = {x=0, y=0}

local image1 = LG.newImage("assets/new/smoke.png")
image1:setFilter("linear", "linear")

local ps = LG.newParticleSystem(image1, 25)
ps:setColors(1, 0.9609375, 0, 0.5, 0.83203125, 0.47116613388062, 0.15275573730469, 0.78515625, 0.7265625, 0.7265625, 0.7265625, 0.56640625, 0.43359375, 0.43359375, 0.43359375, 0.03515625)
ps:setDirection(1.5707963705063)
ps:setEmissionArea("none", 0, 0, 0, false)
ps:setEmissionRate(14.131490707397)
ps:setEmitterLifetime(1.6259033679962)
ps:setInsertMode("top")
ps:setLinearAcceleration(-14.749563217163, 0, 11.4832239151, 0)
ps:setLinearDamping(0, 0.00020414621394593)
ps:setOffset(40, 40)
ps:setParticleLifetime(1.5684961080551, 2.7177577018738)
ps:setRadialAcceleration(36.848392486572, 0)
ps:setRelativeRotation(false)
ps:setRotation(0, 0)
ps:setSizes(0.76904326677322)
ps:setSizeVariation(0)
ps:setSpeed(90, 100)
ps:setSpin(6.7854218482971, -0.62851732969284)
ps:setSpinVariation(0)
ps:setSpread(1.3763167858124)
ps:setTangentialAcceleration(0, 0)
table.insert(particles, {system=ps, kickStartSteps=0, kickStartDt=0, emitAtStart=0, blendMode="alpha", shader=nil, texturePath="smoke.png", texturePreset="", shaderPath="", shaderFilename="", x=0, y=0})

return particles
