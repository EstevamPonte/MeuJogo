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

local paredeDireita = display.newRect( 316, display.contentCenterY, 10, 500 )
physics.addBody( paredeDireita, "static", { friction = 1} )

local paredeEsquerda = display.newRect( 1, display.contentCenterY, 10, 500 )
physics.addBody( paredeEsquerda, "static", {friction = 1} )

local plataforma = display.newRect( display.contentCenterX, 80, display.contentWidth, 10 )
physics.addBody( plataforma, "static",{ friction = 1, })

local background = display.newImageRect("oceano.png", 800, 1400 )
background.x = display.contentCenterX
background.y = display.contentCenterY

local boneco = display.newImageRect("bonequinho.png",80, 80)
boneco.x = display.contentCenterX
boneco.y = display.contentCenterY-200
physics.addBody( boneco, "dynamic",  {  friction = 1, filter = collisionFilter})



local collisionFilter = { groupIndex = 2}



local setaesquerda = display.newImageRect("seta-1.png",60, 60)
setaesquerda.x = display.contentCenterX - 90
setaesquerda.y = display.contentCenterY+ 220

local setadireita = display.newImageRect("seta-2.png",60, 60)
setadireita.x = display.contentCenterX + 90
setadireita.y = display.contentCenterY+ 220

moverx = 0 -- variavel usada para mover o boneco ao longo do eixo x
velocidade = 6 -- Set Walking velocidade

local function movePlayer(event)
    boneco.x = boneco.x + moverx
end
Runtime:addEventListener("enterFrame", movePlayer)
 
function playerVelocity(event)
    if (event.phase == "began") then
        if event.x  >= display.contentCenterX then
            moverx = velocidade
            boneco.xScale = 1
    elseif event.x <= display.contentCenterX then
        moverx = -velocidade
        boneco.xScale = -1
end
elseif (event.phase == "ended") then
moverx = 0
end
end
background:addEventListener("touch", playerVelocity)