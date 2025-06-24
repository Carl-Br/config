-- External Monitor Detection and App Launcher for Hammerspoon
-- Place this code in your ~/.hammerspoon/init.lua file

-- List of apps to launch when external monitor is detected
local apps = {
	"SaneSideButtons",
	"Scroll Reverser",
}

-- Function to check if an app is already running
local function isAppRunning(appName)
	local app = hs.application.get(appName)
	return app ~= nil and app:isRunning()
end

-- Function to launch apps
local function launchApps()
	print("External monitor detected! Launching apps...")

	for _, appName in ipairs(apps) do
		if not isAppRunning(appName) then
			print("Launching: " .. appName)
			hs.application.launchOrFocus(appName)
			-- Small delay between launches to avoid overwhelming the system
			hs.timer.usleep(500000) -- 0.5 seconds
		else
			print("Already running: " .. appName)
		end
	end

	-- Show notification
	hs.notify
		.new({
			title = "Monitor Connected",
			informativeText = "External monitor apps launched",
			withdrawAfter = 3,
		})
		:send()
end

-- Function to get current screen count
local function getCurrentScreenCount()
	return #hs.screen.allScreens()
end

-- Store initial screen count
local initialScreenCount = getCurrentScreenCount()

-- Screen watcher function
local function screenWatcher()
	local currentScreenCount = getCurrentScreenCount()

	-- Check if we've gained a screen (external monitor connected)
	if currentScreenCount > initialScreenCount then
		print("Screen count increased from " .. initialScreenCount .. " to " .. currentScreenCount)
		launchApps()
	elseif currentScreenCount < initialScreenCount then
		print("Screen count decreased from " .. initialScreenCount .. " to " .. currentScreenCount)
		hs.notify
			.new({
				title = "Monitor Disconnected",
				informativeText = "External monitor removed",
				withdrawAfter = 3,
			})
			:send()
	end

	-- Update the screen count
	initialScreenCount = currentScreenCount
end

-- Create and start the screen watcher
local screenWatcherObj = hs.screen.watcher.new(screenWatcher)
screenWatcherObj:start()

-- Startup notification
hs.notify
	.new({
		title = "Hammerspoon Loaded",
		informativeText = "External monitor detection active",
		withdrawAfter = 2,
	})
	:send()

print("Hammerspoon external monitor detection loaded")
print("Current screen count: " .. initialScreenCount)
print("Watching for external monitor connections...")
