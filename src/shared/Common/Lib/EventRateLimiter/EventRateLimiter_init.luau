local EventRateLimiter = {}

local RecentlyFired = {}
function EventRateLimiter.PostToServer(Player:Player,Event,...)
	print("Handler")
	print(RecentlyFired)
	if Event:IsA("RemoteEvent") or Event:IsA("BindableEvent") then
		if RecentlyFired[Player.Name] == nil then
			RecentlyFired[Player.Name] = {}
		end
		if table.find(RecentlyFired[Player.Name],Event.Name) ==nil then
			if Event:IsA("RemoteEvent") then Event:FireServer(...) end
			if Event:IsA("BindableEvent") then Event:Fire(...) end
			table.insert(RecentlyFired[Player.Name],Event.Name)
			task.delay(2,function()
				table.remove(RecentlyFired[Player.Name],table.find(RecentlyFired[Player.Name],Event.Name))
			end)
		else
			warn("Player is being rate limited!")
		end
	else
		warn("AttemptToFire.PostToServer: Event is not RemoteEvent or BindableEvent")
		return
	end		
end

return EventRateLimiter
