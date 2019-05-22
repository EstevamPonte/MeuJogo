
local composer = require( "composer" )

local scene = composer.newScene()


-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------


local backGroup = display.newGroup()
local mainGroup = display.newGroup()
local bolhaTable = {}

local physics = require( "physics" )
physics.start()
physics.setGravity(0,0)

local function gotoGame()
	composer.gotoScene( "Cenas.game", {time=800, effect="crossFade"} )	
end

local function gotoAbout()
	composer.gotoScene( "Cenas.about", {time=800, effect="crossFade"} )	
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

local background = display.newImageRect( backGroup, "src/imagem/oceano.png", 500, 900)
background.x = display.contentCenterX
background.y = display.contentCenterY

local title = display.newImageRect( mainGroup ,"src/imagem/LOGO.png", 800, 700 )
title.x = display.contentCenterX
title.y = display.contentCenterY -150
title.width=300
title.height=200

local playButton = display.newImageRect( mainGroup ,"src/imagem/play2.png", 500, 500 )
playButton.x = display.contentCenterX
playButton.y = display.contentCenterY
playButton.width=160
playButton.height=100


local sobre = display.newImageRect( mainGroup ,"src/imagem/Sobre.png", 500, 500 )
sobre.x = display.contentCenterX
sobre.y = display.contentCenterY + 100
sobre.width=160
sobre.height=100


local musica = audio.loadStream( "src/audio/telaMenuAudio.mp3")
audio.play(musica, {channel = 2, loops = -1})
audio.setVolume(0.5)




-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )
	
	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
	sceneGroup:insert(backGroup);
	sceneGroup:insert(mainGroup);
	
	-- physics.setDrawMode("hybrid")
	

end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		playButton:addEventListener( "tap", gotoGame )
		sobre:addEventListener( "tap", gotoAbout )
		geradorDeBolha = timer.performWithDelay( 2000, gameLoop2, 0 )
	end
end


-- hide()
function scene:hide( event )

	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)
		timer.cancel(geradorDeBolha)
		audio.stop(2)
	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
		composer.removeScene("Cenas.menu");

	end
end


-- destroy()
function scene:destroy( event )
	package.loaded["Cenas.menu"] = nil
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
