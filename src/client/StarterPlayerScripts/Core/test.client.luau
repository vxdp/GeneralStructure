local RojoFriendlyEvents = require(game.ReplicatedStorage.Common.Lib.RojoFriendlyEvents.RojoFriendlyEvents_init)

local EventToClient :RemoteEvent? = RojoFriendlyEvents.FetchOnClient("EventTest1", "RemoteEvent", game.ReplicatedStorage.Remotes.Reliable, 10)
RojoFriendlyEvents.FireWithDDOSProtection(game.Players.LocalPlayer, EventToClient, "")
RojoFriendlyEvents.FireWithDDOSProtection(game.Players.LocalPlayer, nil, "")