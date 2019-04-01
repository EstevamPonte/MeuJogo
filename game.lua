
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local tempo = 0


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen

	local peixeTable = {}
	
	local physics = require( "physics" )
    physics.start()


    -- Mostra a fisica
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
    player: scale(0.8, 0.8)
    player: rotate(90)
    player:play()
    player.myName = "boneco"

    local boxPhysics = { halfWidth=33, halfHeight=18, x=10, y=12, angle=0 }
    physics.addBody( player, "dynamic",  { box=boxPhysics, friction = 1, density=1})

    -- Peixes
    -- local peixe = display.newImageRect("peixe.jpg",80, 50)
    -- peixe.x = display.contentCenterX -100
    -- peixe.y = display.contentCenterY +400
    -- physics.addBody( peixe, {radius=10, filter = collisionFilter})
    -- peixe: setLinearVelocity ( 0, -1000)
    -- peixe: rotate(-90)
    -- peixe.myName = "peixe"




    local setaesquerda = display.newImageRect("seta-1.png",60, 60)
    setaesquerda.x = display.contentCenterX - 90
    setaesquerda.y = display.contentCenterY+ 220

    local setadireita = display.newImageRect("seta-2.png",60, 60)
    setadireita.x = display.contentCenterX + 90
    setadireita.y = display.contentCenterY+ 220

    moverx = 0 -- variavel usada para mover o boneco ao longo do eixo x
    velocidade = 6 -- Set Walking velocidade

    -- Meove o mergulhador para a esquerda e direita
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



    -- Gerando varios peixes
    function gerarPeixe(event)
        local whereFrom = math.random(4)
        local peixe = display.newImageRect("peixe.jpg",80, 50)
        physics.addBody( peixe, {radius=10, filter = collisionFilter})
        table.insert( peixeTable, peixe)
        peixe.y = 400 
        peixe: rotate(-90)
        peixe.name = "peixe"

        
        if ( whereFrom == 1 ) then
            peixe.x = display.contentCenterX + 125
            peixe: setLinearVelocity ( 0, -1000)
        elseif ( whereFrom == 2) then
            peixe.x = display.contentCenterX - 125
            peixe: setLinearVelocity ( 0, -1000)
        elseif ( whereFrom == 3) then
            peixe.x = display.contentCenterX - 41
            peixe: setLinearVelocity ( 0, -1000)
        elseif ( whereFrom == 4) then
            peixe.x = display.contentCenterX + 41
            peixe: setLinearVelocity ( 0, -1000)
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

    geradorDePeixe = timer.performWithDelay( 500, gameLoop, 0 )

    -- Colisão
    local function onCollision( event ) 
        
        if ( event.phase == "began" ) then
            
            local obj1 = event.object1
            local obj2 = event.object2
            
            if ( ( obj1.myName == "boneco" and obj2.myName == "peixe" ) or ( obj1.myName == "peixe" and obj2.myName == "boneco" ) )
            then
                if ( died == false ) then
                    died = true
                    display.remove( player )
                end
            end
        end 
    end

    Runtime:addEventListener( "collision", onCollision )

    -- Adicionando tempo
    local countText = display.newText( tempo, 250, -25, native.systemFont, 25 )
    countText:setFillColor( 0, 0, 0 )

    local function contagem( event )
        print( event.count )
        tempo = tempo + 1
        countText.text = "Tempo: " ..tempo
    end

    timer.performWithDelay( 100, contagem, -1 )

end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen

	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen

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
