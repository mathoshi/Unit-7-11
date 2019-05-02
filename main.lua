-----------------------------------------------------------------------------------------
--
-- Created by: Matsuru Hoshi
-- Created on: Apr 30, 2019
--
-- This file plays with animation
-----------------------------------------------------------------------------------------

local physics = require( "physics")

physics.start()
physics.setGravity( 0, 1)
physics.setDrawMode("hybrid")

local ground = display.newRect( 160, 510, 450, 20)
physics.addBody( ground, "static", {
    friction = 0.3,
    bounce = 0.3
    })

local sheetOptionsIdle =
{
    width = 232,
    height = 439,
    numFrames = 12
}
local sheetIdleNinja = graphics.newImageSheet( "assets/NinjaIdle.png", sheetOptionsIdle )

local sheetOptionsWalk =
{
    width = 363,
    height = 458,
    numFrames = 10
}
local sheetWalkingNinja = graphics.newImageSheet( "assets/NinjaRunning.png", sheetOptionsWalk )

local sheetOptionsAttack =
{
    width = 536,
    height = 495,
    numFrames = 10 
}
local sheetAttackingNinja = graphics.newImageSheet( "assets/NinjaAttack.png", sheetOptionsAttack )

-- sequences table
local sequence_data = {
    -- consecutive frames sequence
    {
        name = "idle",
        start = 1,
        count = 10,
        time = 800,
        loopCount = 0,
        sheet = sheetIdleNinja
    },
    {
        name = "walk",
        start = 1,
        count = 10,
        time = 800,
        loopCount = 0,
        sheet = sheetWalkingNinja
    }
}

local sequenceData = {
	{	
    	name = "attack",
        start = 1,
        count = 10,
        time = 800,
        loopCount = 0,
        sheet = sheetAttackingNinja
	}
}

local AttackNinja = display.newSprite( sheetAttackingNinja, sequenceData )
AttackNinja.x = 50
AttackNinja.y = 400
AttackNinja.xScale = 100/536
AttackNinja.yScale = 92/495
AttackNinja.width = 100
AttackNinja.height = 73
physics.addBody( AttackNinja, "dynamic" ,{
    friction = 0.3,
    bounce = 0
    })

AttackNinja:play()

local ninja = display.newSprite( sheetIdleNinja, sequence_data )
ninja.x = display.contentWidth / 2
ninja.y = 300
ninja.xScale = 58/363
ninja.yScale = 77/458

ninja:play()

-- After a short time, swap the sequence to 'seq2' which uses the second image sheet
local function swapSheet()
    ninja:setSequence( "walk" )
    ninja:play()
    print("walk")
end

timer.performWithDelay( 2000, swapSheet )


