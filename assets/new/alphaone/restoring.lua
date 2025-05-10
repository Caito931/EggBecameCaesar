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

local image1 = "assets/new/alphaone/restoring.png" -- Preset: light
image1:setFilter("linear", "linear")

local ps = LG.newParticleSystem(image1, 47)
ps:setColors(1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0.5, 1, 1, 1, 0)
ps:setDirection(3.1415927410126)
ps:setEmissionArea("uniform", 10.888468742371, 97.996215820313, 0, false)
ps:setEmissionRate(20)
ps:setEmitterLifetime(-1)
ps:setInsertMode("top")
ps:setLinearAcceleration(0, 0, 0, 0)
ps:setLinearDamping(0, 0)
ps:setOffset(75, 75)
ps:setParticleLifetime(1.7999999523163, 2.2000000476837)
ps:setRadialAcceleration(0, 0)
ps:setRelativeRotation(false)
ps:setRotation(0, 0)
ps:setSizes(0.40000000596046)
ps:setSizeVariation(0)
ps:setSpeed(90, 100)
ps:setSpin(0, 0)
ps:setSpinVariation(0)
ps:setSpread(0.31415927410126)
ps:setTangentialAcceleration(0, 0)
table.insert(particles, {system=ps, kickStartSteps=0, kickStartDt=0, emitAtStart=0, blendMode="add", shader=nil, texturePath="", texturePreset="light", shaderPath="", shaderFilename="", x=0, y=0})

return particles
