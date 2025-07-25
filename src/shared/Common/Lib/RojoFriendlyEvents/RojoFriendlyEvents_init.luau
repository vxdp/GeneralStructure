local RojoFriendlyEvents = {}

local EventsGenerated = {}
local HasStartedTimer = false
local reminderInterval = 120 -- default to 2 minutes

local lib = script.Parent.Parent
local EventRateLimiter = require(lib:WaitForChild("EventRateLimiter"):WaitForChild("EventRateLimiter_init"))


local function Warn_locked()
    	task.spawn(function()
		while true do
			task.wait(reminderInterval)
			if #EventsGenerated > 0 then
				warn("[RFE] Auto-generated events:")
				for _, evt in ipairs(EventsGenerated) do
					warn(` - {evt.Type} "{evt.Name}" under {evt.Parent}`)
				end
			end
		end
	end)
end

function  RojoFriendlyEvents.InitializeOnServer(EventName: string, RequestedType :string, Dir :Folder)
    if HasStartedTimer == false then
        Warn_locked()
    end

    local function AttemptToFind()
        local Event = Dir:FindFirstChild(EventName)
        if Event~= nil then
            if Event:IsA(RequestedType) then
                return Event, print("RojoFriendlyEvents: Found and passed an Event.")
            end 
        else
            return nil, print("RojoFriendlyEvents: Failed to locate an event with name: "..EventName.." of type "..RequestedType.." in: "..Dir.Name)
        end
    end

    local function GenerateAnEvent()
        local GeneratedEvent
        GeneratedEvent = Instance.new(RequestedType)
        GeneratedEvent.Name = EventName
        GeneratedEvent.Parent = Dir

        table.insert(EventsGenerated, {
            Name = EventName,
            Type = RequestedType,
            Parent = Dir:GetFullName()
	    })

        return GeneratedEvent, warn("RojoFriendlyEvents: RFE had to generate the event with name of: "..EventName.." inside: "..Dir.Name..". PLEASE CREATE THIS EVENT MANUALLY TO AVOID POTENTIAL SYNC ISSUES AND MUTE THIS WARNING.")
    end

    if Dir == nil then
        return nil, warn("RojoFriendlyEvents: Invalid Dir passed.")
    end

    if EventName ~= nil then
        if RequestedType~=nil then
            if RequestedType == "BindableEvent" or RequestedType == "RemoteEvent" or RequestedType == "UnreliableRemoteEvent" then
                local FoundEvent = AttemptToFind()
                if FoundEvent ~= nil then
                    return FoundEvent
                else
                    local GeneratedEvent = GenerateAnEvent()
                    return GeneratedEvent
                end
            else
                return nil, warn("RojoFriendlyEvents: Provided an invalid type!")
            end
        else
            return nil, warn("RojoFriendlyEvents: RequestedEventType is NIL")
        end
    else
        return nil, warn("RojoFriendlyEvents: RequestedEventNamem is NIL")
    end
end

function  RojoFriendlyEvents.FetchOnClient(EventName :string, RequestedType :string , Dir :Folder, Timeout :number)
    local function AttemptToFind(EventName, RequestedType, Dir)
        local Event = Dir:FindFirstChild(EventName)
        if Event~= nil then
            if Event:IsA(RequestedType) then
                return Event, print("RojoFriendlyEvents: Found and passed an Event on Client.")
            end 
        else
            return nil, print("RojoFriendlyEvents: Failed to locate an event with name: "..EventName.." of type "..RequestedType.." in: "..Dir.Name.." on client. Retrying.")
        end
    end

    local Event = AttemptToFind(EventName, RequestedType, Dir)
    if Event~=nil then
        return Event
    end

	-- Event not found, try again periodically (with a coroutine that returns the result)
	local cr = coroutine.create(function(timeout, eventName, requestedType, dir)
		local waitDuration = 3
		local waited = 0
		while waited <= timeout do
			task.wait(waitDuration)
			local found = AttemptToFind(eventName, requestedType, dir)
			if found then
				return found
			end
			waited += waitDuration
		end
		return nil
	end)

	local success :boolean, result :RemoteEvent? = coroutine.resume(cr, Timeout, EventName, RequestedType, Dir)
	if not success and type(result) == "string" then
		warn("RojoFriendlyEvents: Coroutine failed to run: ", result)
		return nil
	end

    if result == nil then
        warn("RojoFriendlyRequest: Client failed to fetch: "..EventName..". Please add it manually or ensure that it is initialized on server using  the 'RojoFriendlyEvents.InitializeOnServer' method. ")
    end
	return result
end

function RojoFriendlyEvents.FireWithDDOSProtection(Player, Event :RemoteEvent, ...)
    if Player == nil then return warn("RojoFriendlyEvents: Given Player is nil.") end
    if Player:IsA("Player") == false then return warn("RojoFriendlyEvents: Given Player is not a player.") end
    if Event == nil then return warn("RojoFriendlyEvents: Given Event is nil.") end
    if Event:IsA("RemoteEvent") == false then return warn("RojoFriendlyEvents: Given Event is not a RemoteEvent.") end
    EventRateLimiter.PostToServer(Player, Event, ...)
    print("RojoFriendlyEvents: Successfully posted to server with DDOS protection. ")
end

return RojoFriendlyEvents