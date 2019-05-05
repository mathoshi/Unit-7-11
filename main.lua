-----------------------------------------------------------------------------------------
--
-- Created by: Matsuru Hoshi
-- Created on: Apr 30, 2019
--
-- This file plays with animation
-----------------------------------------------------------------------------------------

local physics = require( "physics")

physics.start()
physics.setGravity( 0, 20)
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
    numFrames = 12 
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
        loopCount = 1,
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
AttackNinja.x = 90
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
ninja.x = 250
ninja.y = 300
ninja.xScale = 58/363
ninja.yScale = 77/458
ninja.width = 58
ninja.height = 77
ninja.id = "normal ninja"
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

local function shootBullet()
    -- make a bullet appear
    local aSingleBullet = display.newCircle( 0, 0, 10 )
    aSingleBullet.x = AttackNinja.x +10
    aSingleBullet.y = AttackNinja.y
    physics.addBody( aSingleBullet, 'dynamic' )
    -- Make the object a "bullet" type object
    aSingleBullet.isBullet = true
    aSingleBullet.gravityScale = (10)
    aSingleBullet.id = "bullet"
    aSingleBullet:setLinearVelocity( 700, 0 )

    table.insert(playerBullets,aSingleBullet)
    print("# of bullet: " .. tostring(#playerBullets))
end

local function goIdle()
    AttackNinja:setSequence( "idle")
    AttackNinja:play()
end

function shootButton:touch( event )
    if ( event.phase == "began" ) then
        AttackNinja:setSequence( "attack")
        AttackNinja:play()
        timer.performWithDelay( 200, shootBullet )
        timer.performWithDelay( 700, goIdle)        
    end
end

local function onCollision( event )
 
   if ( event.phase == "began" ) then

       local obj1 = event.object1
       local obj2 = event.object2
       local whereCollisonOccurredX = obj1.x
       local whereCollisonOccurredY = obj1.y

       if ( ( obj1.id == "normal ninja" and obj2.id == "bullet" ) or
            ( obj1.id == "bullet" and obj2.id == "normal ninja" ) ) then
           -- Remove both the laser and asteroid
           --display.remove( obj1 )
           --display.remove( obj2 )
           
           -- remove the bullet
           local bulletCounter = nil
           
           for bulletCounter = #playerBullets, 1, -1 do
               if ( playerBullets[bulletCounter] == obj1 or playerBullets[bulletCounter] == obj2 ) then
                   playerBullets[bulletCounter]:removeSelf()
                   playerBullets[bulletCounter] = nil
                   table.remove( playerBullets, bulletCounter )
                   break
               end
           end

           --remove character
           display.remove(aSingleBullet)

           ninja:setSequence("dead")
           ninja:play()


       end
   end
end

        Runtime:addEventListener( "collision", onCollision )


shootButton:addEventListener( "touch", shootButton)
