
local composer = require( "composer" )

local scene = composer.newScene()


-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------


local backGroup = display.newGroup()
local mainGroup = display.newGroup()
local uiGroup = display.newGroup()


local function gotoGame()
	composer.gotoScene( "Cenas.game", {time=800, effect="crossFade"} )	
end

local function gotoMenu()
	composer.gotoScene( "Cenas.menu", {time=800, effect="crossFade"} )	
end


local background = display.newImageRect( backGroup, "src/imagem/oceano.png", 500, 900)
background.x = display.contentCenterX
background.y = display.contentCenterY

local title = display.newImageRect( mainGroup ,"src/imagem/LOGO.png", 800, 700 )
title.x = display.contentCenterX
title.y = display.contentCenterY -150
title.width=300
title.height=200

local restartButton = display.newImageRect( mainGroup ,"src/imagem/restart.png", 500, 500 )
restartButton.x = display.contentCenterX
restartButton.y = display.contentCenterY + 30
restartButton.width=165
restartButton.height=95

local telaMenu = display.newImageRect( mainGroup ,"src/imagem/menu.png", 500, 500 )
telaMenu.x = display.contentCenterX
telaMenu.y = display.contentCenterY + 130
telaMenu.width=165
telaMenu.height=95

local musica = audio.loadStream( "src/audio/telaMenuAudio.mp3")
audio.play(musica, {channel = 2, loops = -1})


local pontuacao = composer.getVariable( "finalTime" )
print(pontuacao)
local countText = display.newText( uiGroup, "Final Time: "..pontuacao, display.contentCenterX, 190, "src/font/AmaticSC-Bold.ttf",50 )
countText:setFillColor( 0, 0, 0 )

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )
	
	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen

	print("--ENTROU---")
	sceneGroup:insert(backGroup);
	sceneGroup:insert(mainGroup);
	sceneGroup:insert(uiGroup);

	print(backGroup)
	print(mainGroup)
	print(uiGroup)
end


-- show()
function scene:show( event )

	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		restartButton:addEventListener( "tap", gotoGame )
		telaMenu:addEventListener( "tap", gotoMenu )
	end
end


-- hide()
function scene:hide( event )

	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)
		audio.stop(2)
	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
		composer.removeScene("Cenas.restart");

	end
end


-- destroy()
function scene:destroy( event )
	package.loaded["Cenas.restart"] = nil
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
