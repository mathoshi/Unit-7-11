-----------------------------------------------------------------------------------------
--
-- Created by: Matsuru Hoshi
-- Created on: Apr 30, 2019
--
-- This file plays with animation
-----------------------------------------------------------------------------------------

local physics = require( "physics")

physics.start()
physics.setGravity( 0, 10)
physics.setDrawMode("hybrid")

local playerBullets = {} -- Table that holds the players Bullets

local ground = display.newRect( 160, 510, 450, 20)
physics.addBody( ground, "static", {
    friction = 0.3,
    bounce = 0.3
    })

local leftWall = display.newRect( -50, display.contentCenterY, 100, 560)
leftWall.id = "left wall"
physics.addBody( leftWall, "static", {
    friction = 0.5,
    bounce = 0.1
    })

local shootButton = display.newCircle( 270, 350, 40)
shootButton.alpha = 0.5

local sheetOptionsIdle =
{
    width = 232,
    height = 439,
    numFrames = 12
}
local sheetIdleNinja = graphics.newImageSheet( "assets/NinjaIdle.png", sheetOptionsIdle )

local sheetOptionsDead =
{
    width = 482,
    height = 498,
    numFrames = 10
}
local sheetDeadNinja = graphics.newImageSheet( "assets/NinjaDead.png", sheetOptionsDead )

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
        name = "dead",
        start = 1,
        count = 10,
        time = 800,
        loopCount = 0,
        sheet = sheetDeadNinja
    }
}

local sequenceData = {
	{	
    	name = "attack",
        start = 1,
        count = 10,
        time = 800,
        loopCount = 1,
        sheet = sheetAttackingNinja
	},
    {
        name = "idle",
        start = 1,
        count = 10,
        time = 800,
        loopCount = 0,
        sheet = sheetIdleNinja
    },
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

AttackNinja:setSequence( "idle")
AttackNinja:play()

local ninja = display.newSprite( sheetIdleNinja, sequence_data )
ninja.x = display.contentWidth / 2
ninja.y = 300
ninja.xScale = 58/363
ninja.yScale = 77/458
ninja.width = 58
ninja.height = 77
physics.addBody( ninja, "dynamic", {
    fricition = 0.5,
    bounce = 0.1
    })   

ninja:play()

-- After a short time, swap the sequence to 'seq2' which uses the second image sheet
--local function swapSheet()
--    ninja:setSequence( "dead" )
--    ninja:play()
--    print("dead")
--end
--
--timer.performWithDelay( 2000, swapSheet )

function shootButton:touch( event )
    if ( event.phase == "began" ) then
            AttackNinja:setSequence( "attack")
            AttackNinja:play()
            -- make a bullet appear
            local aSingleBullet = display.newCircle( 0, 0, 10 )
            aSingleBullet.x = AttackNinja.x +10
            aSingleBullet.y = AttackNinja.y
            physics.addBody( aSingleBullet, 'dynamic' )
            -- Make the object a "bullet" type object
            aSingleBullet.isBullet = true
            aSingleBullet.gravityScale = (10)
            aSingleBullet.id = "bullet"
            aSingleBullet:setLinearVelocity( 1000, 0 )

            table.insert(playerBullets,aSingleBullet)
            print("# of bullet: " .. tostring(#playerBullets))
    end
end

shootButton:addEventListener( "touch", shootButton)
