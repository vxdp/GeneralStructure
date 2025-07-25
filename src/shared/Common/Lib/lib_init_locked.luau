--WARNING! This is a MANIFESTO Module that links all services found in <LIB> with common_init_locked. 
--[[
	IT IS IMPERATIVE THAT:
	- When adding a new service to <Lib> you make a new folder for it
	- Optimally this folder should contain ONE Module that can be required and that serves as an interface between the code and this aggregator.
	- Optimally said module should be named "<FolderName>+'_init'"
	- Folder "Lib" may contain NO other scripts but this one. 

	Please be cautious when working on any files with a "locked" suffix. 
	Before commiting anything, ensure that the structure works.
	Minor mistakes may break the entire game, this is of CRITICAL importance. 
]]
local EventRateLimiter = require(script.Parent.EventRateLimiter.EventRateLimiter_init)
local RojoFriendlyEvents = require(script.Parent.RojoFriendlyEvents.RojoFriendlyEvents_init)

local Lib = {
	EventRateLimiter = EventRateLimiter,
	RojoFriendlyEvents = RojoFriendlyEvents,
}

return Lib