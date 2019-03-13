-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
local physics = require( "physics" )
physics.start()


--mostra a fisica
physics.setDrawMode("hybrid")

local collisionFilter = { groupIndex = -1 }

local paredeDireita = display.newRect( 316, display.contentCenterY, 10, 500 )
physics.addBody( paredeDireita, "static", { friction = 1} )


local paredeEsquerda = display.newRect( 1, display.contentCenterY, 10, 500 )
physics.addBody( paredeEsquerda, "static", {friction = 1} )


local plataforma = display.newRect( display.contentCenterX, 80, display.contentWidth, 10 )
physics.addBody( plataforma, "static",{ friction = 1, filter = collisionFilter})


local background = display.newImageRect("oceano.png", 800, 1400 )
background.x = display.contentCenterX
background.y = display.contentCenterY

--SPRITE Boneco
local sheetOptions = { width = 150, height = 75, numFrames = 10 }

local boneco = graphics.newImageSheet( "cezinha-dos-mergulhos.png", sheetOptions )

local sequences = {
    {
        name = "normalRun",
        start = 1,
        count = 10,
        time = 1000,
        loopCount = 0,
        loopDirection = "forward"
    }
}
local player = display.newSprite( boneco, sequences )

player.x = display.contentCenterX
player.y = --distância do cavalo ao chão
player: rotate(90)

player:play()

local boxPhysics = { halfWidth=50, halfHeight=20, x=10, y=12, angle=0 }
physics.addBody( player, "dynamic",  { box=boxPhysics, friction = 1})

--Peixes
local peixe = display.newImageRect("peixe.jpg",80, 50)
peixe.x = display.contentCenterX -100
peixe.y = display.contentCenterY +400
physics.addBody( peixe, {radius=10, filter = collisionFilter})
peixe: setLinearVelocity ( 0, -1000)
peixe: rotate(-90)





local setaesquerda = display.newImageRect("seta-1.png",60, 60)
setaesquerda.x = display.contentCenterX - 90
setaesquerda.y = display.contentCenterY+ 220

local setadireita = display.newImageRect("seta-2.png",60, 60)
setadireita.x = display.contentCenterX + 90
setadireita.y = display.contentCenterY+ 220

moverx = 0 -- variavel usada para mover o boneco ao longo do eixo x
velocidade = 6 -- Set Walking velocidade

local function movePlayer(event)
    player.x = player.x + moverx
end
Runtime:addEventListener("enterFrame", movePlayer)
 
function playerVelocity(event)
    if (event.phase == "began") then
        if event.x  >= display.contentCenterX then
            moverx = velocidade
            
    elseif event.x <= display.contentCenterX then
        moverx = -velocidade
    

end
    elseif (event.phase == "ended") then
        moverx = 0
    end
end
Runtime:addEventListener("touch", playerVelocity)