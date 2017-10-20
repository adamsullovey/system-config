-- Auto-reload config
function reloadConfig(files)
    doReload = false
    for _,file in pairs(files) do
        if file:sub(-4) == ".lua" then
            doReload = true
        end
    end
    if doReload then
        hs.reload()
    end
end
hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()

--
-- Key defs
--

local cah = {"cmd", "alt", "ctrl"}
local cahs = {"cmd", "alt", "ctrl", "shift"}

--
-- Window manipulation
--

-- Window hints
hs.hotkey.bind(cah, "E", hs.hints.windowHints)

-- Grid setup

hs.grid.MARGINX = 0
hs.grid.MARGINY = 0
hs.grid.GRIDWIDTH = 6
hs.grid.GRIDHEIGHT = 6

-- a helper function that returns another function that resizes the current window
-- to a certain grid size.
local gridset = function(x, y, w, h)
    return function()
        local win = hs.window.focusedWindow()
        hs.grid.set(
            win,
            {x=x, y=y, w=w, h=h},
            win:screen()
        )
    end
end

-- Maximize window
hs.hotkey.bind(cah, "M", function()
  hs.grid.maximizeWindow(hs.window.focusedWindow())
end)




function cycle(amount, orientation)

	offsetX = 0
	offsetY = 0

	width = 0
	height = 0

	-- notes positions and dimensions grid to cycle through 
	-- 0,2 = start at 0th cell, be 2 cells wide 
	-- 0,2
	-- 0,3
	-- 0,4
	-- 0,6

	-- 2,2
	-- 2,4

	-- 3,3

	-- 4,2

	if (orientation == 'horizontal') then
		return function()

			width = width + amount

			if (width + offsetX > 6) then
				offsetX = offsetX + amount
				width = amount
			end

			if (offsetX >= 6) then
				offsetX = 0
			end

		  	hs.notify.new({title="Horizontal " .. amount, informativeText= offsetX .. " by " .. width}):send()

			gridset(offsetX, offsetY, width, height)()
		end
	else

		return function()

			height = height + amount

			if (height + offsetY > 6) then
				offsetY = offsetY + amount
				height = amount
			end

			if (offsetY >= 6) then
				offsetY = 0
			end

		  	hs.notify.new({title="Vertical " .. amount, informativeText= offsetY .. " by " .. height}):send()

			gridset(offsetX, offsetY, width, height)()
		end


	end


end

-- mashing control, alt/option, command and the numbers 2 or 3 or 4 or 5 resizes windows
hs.hotkey.bind(cah, "3", cycle(2, 'horizontal'))
hs.hotkey.bind(cah, "2", cycle(3, 'horizontal'))

hs.hotkey.bind(cah, "4", cycle(2, 'vertical'))
hs.hotkey.bind(cah, "5", cycle(3, 'vertical'))



-- someone else's grid system for reference

-- Left 1/2 of the screen
--hs.hotkey.bind(cah, "Left", gridset(0, 0, 5, 2))
-- Right 1/2 of the screen
--hs.hotkey.bind(cah, "Right", gridset(5, 0, 5, 2))

-- Left 7/10 of the screen
--hs.hotkey.bind(cah, "1", gridset(0, 0, 7, 2))
-- Top right corner 3/10 of the screen
--hs.hotkey.bind(cah, "2", gridset(7, 0, 3, 1))
-- Bottom right corner 3/10 of the screen
--hs.hotkey.bind(cah, "3", gridset(7, 1, 3, 1))
-- Bottom right corner 4/10 of the screen
--hs.hotkey.bind(cah, "4", gridset(6, 1, 4, 1))

-- Shift window on grid
-- hs.hotkey.bind(cah, "H", function()
--     hs.grid.pushWindowLeft(hs.window.focusedWindow())
-- end)
-- hs.hotkey.bind(cah, "J", function()
--     hs.grid.pushWindowDown(hs.window.focusedWindow())
-- end)
-- hs.hotkey.bind(cah, "K", function()
--     hs.grid.pushWindowUp(hs.window.focusedWindow())
-- end)
-- hs.hotkey.bind(cah, "L", function()
--     hs.grid.pushWindowRight(hs.window.focusedWindow())
-- end)

-- -- Resize window on grid
-- hs.hotkey.bind(cahs, "H", function()
--     hs.grid.resizeWindowThinner(hs.window.focusedWindow())
-- end)
-- hs.hotkey.bind(cahs, "J", function()
--     hs.grid.resizeWindowShorter(hs.window.focusedWindow())
-- end)
-- hs.hotkey.bind(cahs, "K", function()
--     hs.grid.resizeWindowTaller(hs.window.focusedWindow())
-- end)
-- hs.hotkey.bind(cahs, "L", function()
--     hs.grid.resizeWindowWider(hs.window.focusedWindow())
-- end)

-- End Window manipulation

-- Start screensaver...  This isn't needed because we do this with
-- an OS level key binding already
--hs.hotkey.bind({"cmd", "shift"}, "L", function()
--    hs.caffeinate.startScreensaver()
--end)


hs.alert.show("Hammerspoon loaded")
