
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local function gotoGame()
	composer.gotoScene( "game" )	
end

local backGroup = display.newGroup()
local mainGroup = display.newGroup()
local uiGroup = display.newGroup()

local physics = require( "physics" )
physics.setGravity(0,0)
physics.start()

local vidas = 2
local tempo = 0
local contVidas = nil

local peixeTable = {}

local collisionFilter = { groupIndex = -1 }

local died = false -- Variavel para marcar vida ou morte do mergulhador



local background = display.newImageRect(backGroup, "oceano.png", 800, 1400 )
background.x = display.contentCenterX
background.y = display.contentCenterY

-- SPRITE Boneco
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
player.y = 50--distância do cavalo ao chão
physics.addBody( player, "static", { radius = 25 })
player:scale(0.8, 0.8)
player:rotate(90)
player:play()
player.myName = "boneco"

--local boxPhysics = { halfWidth=33, halfHeight=18, x=10, y=12, angle=0 }
--physics.addBody( player, { box=boxPhysics, friction = 1, density=1, isSensor = true } )


-- Peixes
-- local peixe = display.newImageRect("peixe.jpg",80, 50)
-- peixe.x = display.contentCenterX -100
-- peixe.y = display.contentCenterY +400
-- physics.addBody( peixe, {radius=10, filter = collisionFilter})
-- peixe: setLinearVelocity ( 0, -1000)
-- peixe: rotate(-90)
-- peixe.myName = "peixe"




local setaesquerda = display.newImageRect(mainGroup, "seta-1.png",60, 60)
setaesquerda.x = display.contentCenterX - 90
setaesquerda.y = display.contentCenterY+ 220
setaesquerda.myName="esquerda"

local setadireita = display.newImageRect(mainGroup, "seta-2.png",60, 60)
setadireita.x = display.contentCenterX + 90
setadireita.y = display.contentCenterY+ 220
setadireita.myName="direita"

moverx = 0 -- variavel usada para mover o boneco ao longo do eixo x
velocidade = 6 -- Set Walking velocidade

-- Meove o mergulhador para a esquerda e direita
local function movePlayer(event)
    local posicao = player.x + moverx
    if (posicao > 20 and posicao < display.contentWidth) then
        player.x = posicao
    end
end


local function playerVelocity(event)
    if(event.phase == "began")then
        if (event.x > display.contentCenterX) then
            moverx = velocidade
        elseif (event.x < display.contentCenterX) then
            moverx = -velocidade
        end
    elseif (event.phase == "ended") then
        moverx = 0
    end
end
setaesquerda:addEventListener("touch",playerVelocity)
setadireita:addEventListener("touch",playerVelocity)


-- Gerando varios peixes
local function gerarPeixe(event)
    local whereFrom = math.random(4)
    local peixe = display.newImageRect(mainGroup, "peixe.png",80, 50)
    table.insert( peixeTable, peixe)
    peixe.y = 400 
    --physics.addBody( peixe, { radius=20, filter = collisionFilter } )
    physics.addBody(peixe, { radius =  25, isSensor=true} )
    peixe:rotate(-90)
    peixe.myName = "peixe"

    
    if ( whereFrom == 1 ) then
        peixe.x = display.contentCenterX + 125
        peixe:setLinearVelocity ( 0, -800)
    elseif ( whereFrom == 2) then
        peixe.x = display.contentCenterX - 125
        peixe:setLinearVelocity ( 0, -800)
    elseif ( whereFrom == 3) then
        peixe.x = display.contentCenterX - 41
        peixe:setLinearVelocity ( 0, -800)
    elseif ( whereFrom == 4) then
        peixe.x = display.contentCenterX + 41
        peixe:setLinearVelocity ( 0, -800)
    end
end

-- loopGame

local function gameLoop()
    gerarPeixe()

    for i = #peixeTable, 1, -1 do
        local essePeixe = peixeTable[i]

        if ( essePeixe.x < -100 or
            essePeixe.x > display.contentWidth + 100 or
            essePeixe.y < -100 or
            essePeixe.y > display.contentHeight + 100 )
        then
            display.remove( essePeixe )
            table.remove( peixeTable, i )
        end

    end
end

local function atualizaVidas()
    print("shshs")
    if(vidas > 0) then
        vidas = vidas - 1
        contVidas.text = "Vidas: " .. vidas 
    end
end


-- Colisão

local function colizao( self, event )
    local obj1 = event.target
    local obj2 = event.other
    print("bateu")
    print(obj1.myName)
    print(obj2.myName)

    if(obj2.myName == "peixe" and obj1.myName == "boneco" )
    then
        display.remove(obj2)
        atualizaVidas()
        for i = #peixeTable, 1, -1 do
            if ( peixeTable[i] == obj2) then
                table.remove( peixeTable, i)
                break
            end
        end

    end
end

player.collision = colizao
player:addEventListener("collision")

-- Adicionando tempo
local countText = display.newText( uiGroup, tempo, 250, -25, native.systemFont, 25 )
countText:setFillColor( 0, 0, 0 )

contVidas = display.newText( uiGroup, vidas, 80, -25, native.systemFont, 20 )
contVidas:setFillColor( 0, 0, 0 )

local function contagem()
    --print( event.count )
    tempo = tempo + 1
    countText.text = "Tempo: " .. tempo
end

timer.performWithDelay( 100, contagem, 0 )

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
	
	-- local physics = require( "physics" )
    -- physics.pause()
    -- physics.setGravity(0,0)

    sceneGroup:insert(backGroup);
    sceneGroup:insert(mainGroup);
    sceneGroup:insert(uiGroup);

    -- Mostra a fisica
    --physics.setDrawMode("hybrid")
    contagem();
    
end  
-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        --physics.start()
        contVidas.text = "Vidas: " .. vidas
        Runtime:addEventListener("enterFrame", movePlayer)
        geradorDePeixe = timer.performWithDelay( 500, gameLoop, 0 )
        --Runtime:addEventListener( "collision", onCollision )
	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)
        timer.cancel(geradorDePeixe);
	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
        Runtime:removeEventListner("enterFrame", movePlayer)
        Runtime:removeEventListner("touch",playerVelocity)
        --Runtime:removeEventListner("collision", onCollision)
        physics.pause()
        composer.removeScene("game");
	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
