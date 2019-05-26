
local composer = require( "composer" )

local scene = composer.newScene()


-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------


local backGroup = display.newGroup()
local mainGroup = display.newGroup()
local uiGroup = display.newGroup()
local bolhaTable = {}

local background = display.newImageRect( backGroup, "src/imagem/oceano.png", 500, 900)
background.x = display.contentCenterX
background.y = display.contentCenterY

local texto = display.newImageRect( backGroup, "src/imagem/Texto2.png", 900, 1400)
texto.x = display.contentCenterX
texto.y = display.contentCenterY -25
texto.width=300
texto.height=550

local menu = display.newImageRect( backGroup, "src/imagem/menu.png", 161, 66)
menu.x = display.contentCenterX
menu.y = display.contentCenterY + 225

local function gotoMenu()
	composer.gotoScene( "Cenas.menu", {time=800, effect="crossFade"} )	
end

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
	sceneGroup:insert(backGroup)
	sceneGroup:insert(mainGroup)
	sceneGroup:insert(uiGroup);
	
	
	-- physics.setDrawMode("hybrid")
	

end

-- show()
function scene:show( event )

	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		menu:addEventListener( "tap", gotoMenu )
		
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
		composer.removeScene("Cenas.about");

	end
end


-- destroy()
function scene:destroy( event )
	package.loaded["Cenas.about"] = nil
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
