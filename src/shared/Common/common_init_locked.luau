--WARNING! This is a MANIFESTO Module that links all services found in <COMMON> with common_init_locked. 
--[[
	IT IS IMPERATIVE THAT:

	You are to NEVER personally make any changes to this script. 


    - UTILS : Used for short modules that help streamline basic functions such as Vector/CFrame math, Magnitudes, Tweens and so on. 
    They generally contain well specialized functions that help avoid writing boilerplate code.

    - LIBS : Used for more advanced systems of multiple specialized functions or subsystems that add new functionalities to the engine.
    This is where you should preferably import any external modules into.

    - MISC : Other stuff. 
]]
local Lib = require(script.Parent.Lib.lib_init_locked)

local Common = {
	Lib = Lib
}

return Common