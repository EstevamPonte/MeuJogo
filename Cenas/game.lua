
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------


local sheetOptions2 =
{
    frames =
    {
        {   -- Inimigo peixe --
        x = 0,
        y = 0,
        width = 129,
        height = 142
        },
        {   -- Inimigo tubarão --
         x = 0,
        y = 150,
        width = 129,
        height = 142
        },
        {   -- Inimigo aguá viva --
         x = 0,
        y = 300,
        width = 129,
        height = 132
        },
    }
}

local musica = audio.loadStream( "src/audio/gameAudio.mp3")
audio.play(musica, {channel = 2, loops = -1})
audio.setVolume(0.3)


local objectSheet2 = graphics.newImageSheet( "src/imagem/peixesanimados.png", sheetOptions2 )



local function gotoGame()
	composer.gotoScene( "game" )	
end

local backGroup = display.newGroup()
local mainGroup = display.newGroup()
local uiGroup = display.newGroup()

local physics = require( "physics" )
physics.start()
physics.setGravity(0,0)

local vidas = 340
local vidasPadrao = 340
local tempo = 0
local bolhaTable = {}
local peixeTable = {}
local tanqueTable = {}
local peixe
local velocidadePeixe = 4000
local scrollSpeed = 1
local _H = display.contentHeight
local velocidadeDeGeracao = 1000


local collisionFilter = { groupIndex = -1 }

local died = false -- Variavel para marcar vida ou morte do mergulhador

local myRoundedRect = display.newRoundedRect( mainGroup, 310 , display.contentCenterY, 9, 350, 12 )
myRoundedRect.strokeWidth = 3
myRoundedRect:setFillColor( 0, 0, 0 )
myRoundedRect:setStrokeColor( 0, 0, 0 )

local myRoundedRect2 = display.newRoundedRect( mainGroup, 310 , display.contentHeight -70, 9, 340, 12 )
myRoundedRect2.strokeWidth = 0
myRoundedRect2:setFillColor( 1, 1, 0)
myRoundedRect2:setStrokeColor( 0, 0, 0 )
myRoundedRect2.anchorY = 1


local background = display.newImageRect(backGroup, "src/imagem/oceano1.png", 800, 1400 )
background.x = display.contentCenterX
background.y = display.contentCenterY

-- local background2 = display.newImageRect(backGroup, "oceano.png", 800, 1400 )
-- background2.x = display.contentCenterX
-- background2.y = display.contentCenterY - display.actualContentHeight



-- SPRITE Boneco-------------------------------------------------------------------
local sheetOptions = { width = 150 , height = 75, numFrames = 10 }

local boneco = graphics.newImageSheet( "src/imagem/mergulhador.png", sheetOptions )

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
local boxPhysics = { halfWidth=33, halfHeight=18, x=10, y=12, angle=0 }
physics.addBody( player, { box=boxPhysics, friction = 1, density=1, isSensor = true } )
player:scale(0.8, 0.8)
player:rotate(90)
player:play()
player.myName = "boneco"

---------------------------------------------------------------------------------


local setaesquerda = display.newImageRect(mainGroup, "src/imagem/seta-1.png",60, 60)
setaesquerda.x = display.contentCenterX - 90
setaesquerda.y = display.contentCenterY+ 220
setaesquerda.myName="esquerda"

local setadireita = display.newImageRect(mainGroup, "src/imagem/seta-2.png",60, 60)
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
        if (event.x >= display.contentCenterX) then
            moverx = velocidade
        elseif (event.x <= display.contentCenterX) then
            moverx = -velocidade
        end
    elseif (event.phase == "ended") then
        moverx = 0
    end
end
background:addEventListener("touch", playerVelocity)

-- Gerando varios peixes------------------------------------------------------------------------------

local function aumentarVelocidade()
    velocidadePeixe = velocidadePeixe -100
    
end

local function velocidadeGerador()
   
end


local function gerarPeixe(event)
    local whereFrom = math.random(4)
    local tipo = math.random(3)
    peixe = display.newImageRect(mainGroup, objectSheet2, tipo, 50, 80)
    -- local peixe = display.newImageRect(mainGroup, "peixe.png",80, 50)
    table.insert( peixeTable, peixe)
    peixe.y = 500
    --physics.addBody( peixe, { radius=20, filter = collisionFilter } )
    physics.addBody(peixe, { radius = 15, isSensor=true} )
    peixe.myName = "peixe"
    
    if ( whereFrom == 1 ) then
        peixe.x = display.contentCenterX + 125
        transition.to(peixe,{y = -200, time = velocidadePeixe})
        -- peixe:setLinearVelocity ( 0, -500)
    elseif ( whereFrom == 2) then
        peixe.x = display.contentCenterX - 125
        transition.to(peixe,{y = -200, time = velocidadePeixe})

        -- peixe:setLinearVelocity ( 0, -500)
    elseif ( whereFrom == 3) then
        peixe.x = display.contentCenterX - 41
        transition.to(peixe,{y = -200, time = velocidadePeixe})

        -- peixe:setLinearVelocity ( 0, -500)
    elseif ( whereFrom == 4) then
        peixe.x = display.contentCenterX + 41
        transition.to(peixe,{y = -200, time = velocidadePeixe})

        -- peixe:setLinearVelocity ( 0, -500)
    end
    if (tipo == 2) then
        peixe.xScale = 2
        peixe.yScale = 2
    end
end



local function gerarBolha(event)
    local whereFrom = math.random(1)
    local bolha = display.newImageRect(mainGroup, "src/imagem/bubble.png", 35, 35 )
    table.insert( bolhaTable, bolha)
    physics.addBody(bolha, "dynamic")
    bolha.myName = "bolha"
    bolha.y = 500
    
    
     if ( whereFrom == 1 ) then
        -- From the left
        bolha.x = math.random(300)
        bolha:setLinearVelocity( 0, math.random( -100, -50 ) )
     end
end


local function gerarTanque(event)
    local whereFrom = math.random(2)
    local tanque = display.newImageRect(mainGroup, "src/imagem/tanque.png", 50, 50 )
    table.insert( tanqueTable, tanque)
    tanque.y = 500
    physics.addBody(tanque, "dynamic", {radius = 25, isSensor = true})
    tanque.myName = "tanque"

    
    if ( whereFrom == 1 ) then
        tanque.x = display.contentCenterX + 50
        tanque:setLinearVelocity ( 0, -100)
    elseif ( whereFrom == 2) then
        tanque.x = display.contentCenterX - 50
        tanque:setLinearVelocity ( 0, -100)
    end
    tanque:applyTorque( 0.5 )
end



-- loopGame------------------------------------------------------------------------------------

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


local function gameLoop2()
    gerarBolha()

    for i = #bolhaTable, 1, -1 do
        local esseBolha = bolhaTable[i]

        if ( esseBolha.x < -100 or
            esseBolha.x > display.contentWidth + 100 or
            esseBolha.y < -100 or
            esseBolha.y > display.contentHeight + 100 )
        then
            display.remove( esseBolha )
            table.remove( bolhaTable, i )
        end

    end
end

local function gameLoop3()
    gerarTanque()

    for i = #tanqueTable, 1, -1 do
        local esseTanque = tanqueTable[i]

        if ( esseTanque.x < -100 or
            esseTanque.x > display.contentWidth + 100 or
            esseTanque.y < -100 or
            esseTanque.y > display.contentHeight + 100 )
        then
            display.remove( esseTanque )
            table.remove( tanqueTable, i )
        end

    end
end
-------Leva para a tela de menu----------------------------------------------------------
local function endGame()
    composer.setVariable('finalTime', tempo)
    composer.gotoScene( "Cenas.restart", { time=800, effect="crossFade" } )
end

local function sumirSetas()
    display.remove(setadireita, { time=800, effect="crossFade" })
    display.remove(setaesquerda, { time=800, effect="crossFade" })
end


-- Funçoes que fazem a vida ser alteradas------------------------------------------------


local function diminuirVidas()
    
    if(vidas > 0) then
        vidas = vidas - 40
        transition.to(myRoundedRect2, {time = 300,height = vidas})
    end
end

local function aumentarVidas()

    if(vidas < 340) then

        local aux = vidas + 40

        if ( aux >= vidasPadrao) then
            transition.to(myRoundedRect2, {time = 300,height = vidasPadrao})
            
        else
            vidas = vidas + 40
            transition.to(myRoundedRect2, {time = 300,height = vidas})
        end
    end
end

local function descer()
    vidas = vidas - 10
    transition.to(myRoundedRect2, {time = 300,height = vidas})
   

    if (vidas <= 0) then
        display.remove( player )
        Runtime:removeEventListener("enterFrame", movePlayer)
        timer.performWithDelay( 300, endGame )
    end
end


-- Colisão------------------------------------------------------------------------

local function colizao( self, event )
    local obj1 = event.target
    local obj2 = event.other


    if(obj2.myName == "peixe" and obj1.myName == "boneco" )
    then
        display.remove(obj2)
        diminuirVidas()
        if (vidas <= 0) then
            display.remove( player )
            Runtime:removeEventListener("enterFrame", movePlayer)
            timer.performWithDelay( 300, endGame )
        end

        for i = #peixeTable, 1, -1 do
            if ( peixeTable[i] == obj2) then
                table.remove( peixeTable, i)
                break
            end
        end

    end
    
    if(obj2.myName == "tanque" and obj1.myName == "boneco" )
    then
        local coletandoTanque = audio.loadStream( "src/audio/vidaAudio.ogg")
		audio.play(coletandoTanque, {channel = 5})
		audio.setVolume( 1.0 , {channel = 5} )
        display.remove(obj2)
        aumentarVidas()
        for i = #tanqueTable, 1, -1 do
            if ( tanqueTable[i] == obj2) then
                table.remove( tanqueTable, i)
                break
            end
        end
    end
end

player.collision = colizao
player:addEventListener("collision")

-- Adicionando tempo--------------------------------------------------------------
local countText = display.newText( uiGroup, tempo, display.contentCenterX, -25, "src/font/AmaticSC-Bold.ttf", 30 )
countText:setFillColor( 0, 0, 0 )


local function contagem()
    tempo = tempo + 1
    countText.text = tempo
end

timer.performWithDelay( 100, contagem, 0 )


-- local function move( event )

   
--         background.y = background.y - scrollSpeed
--         background2.y = background2.y - scrollSpeed
--         if ( background.y + _H / 2 < 0 ) then 
--             background:translate( 0, background.contentHeight * 2 )
--         end
--         if ( background2.y + _H / 2 < 0 ) then
--             background2:translate( 0, background2.contentHeight * 2 )
--         end
-- end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
	

    sceneGroup:insert(backGroup);
    sceneGroup:insert(mainGroup);
    sceneGroup:insert(uiGroup);

    

    -- Mostra a fisica
    -- physics.setDrawMode("hybrid")
    contagem();
    
end  
-- show()



function scene:show( event )

	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        Runtime:addEventListener("enterFrame", movePlayer)
        -- timer.performWithDelay(16000, velocidadeGerador, 3)
        velocidadeGerada = timer.performWithDelay(1000, aumentarVelocidade, 30)
        timer.performWithDelay(3000, sumirSetas, 1)
        descendoVidas = timer.performWithDelay( 3000, descer, 0)
        -- Runtime:addEventListener("enterFrame", move)
        geradorDePeixe = timer.performWithDelay( 600, gameLoop, 0 )
        geradorDeBolha = timer.performWithDelay( 2000, gameLoop2, 0 )
        geradorDeTanque = timer.performWithDelay( 5000, gameLoop3, 0 )
        --Runtime:addEventListener( "collision", onCollision )
	end
end


-- hide()
function scene:hide( event )

	local phase = event.phase

	if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
        timer.cancel(velocidadeGerada)
        timer.cancel(geradorDePeixe);
        timer.cancel(geradorDeBolha)
        timer.cancel(geradorDeTanque)
        timer.cancel(descendoVidas)
        audio.stop(2)
	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
        Runtime:removeEventListener("enterFrame", movePlayer)
        Runtime:removeEventListener("touch",playerVelocity)
        -- Runtime:removeEventListener("enterFrame", move)
        physics.pause()
        composer.removeScene("Cenas.game");
	end
end


-- destroy()
function scene:destroy( event )

	-- Code here runs prior to the removal of scene's view
    package.loaded["Cenas.restart"] = nil
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
