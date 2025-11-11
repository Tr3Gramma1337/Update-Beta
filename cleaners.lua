local samp = require 'samp.events'
local cleaner = false
function main()
	while not isSampAvailable() do wait(10) end
	sampRegisterChatCommand('delped', function()
		cleaner = not cleaner
		if cleaner then
			local removedPlayers = 0
			for i, v in ipairs(getAllChars()) do
				if doesCharExist(v) and i ~= 1 then
					local _, id = sampGetPlayerIdByCharHandle(v)
					if id ~= -1 then
						removePlayer(id)
						removedPlayers = removedPlayers + 1
						printStringNow('Removing players...', 100)
					end
				end)
			end
          sampRegisterChatCommand('delcars', function()
                  cleaner = not cleaner
                  if cleaner then
			local removedVehicles = 0
			for i, v in ipairs(getAllVehicles()) do
				local res, id = sampGetVehicleIdByCarHandle(v)
				if res then
					removeVehicle(id)
					removedVehicles = removedVehicles + 1
					printStringNow('Removing vehicles...', 100)
				end
			end
			printStringNow(string.format('Successfully removed ~G~%s ~w~players and ~G~%s ~w~vehicles', removedPlayers, removedVehicles), 2000)
		else
			printStringNow('Cleaner ~R~OFF', 2000)
		end
	end)
end

function samp.onPlayerStreamIn(id, team, model, pos, rot, clr, fs)
	if cleaner then return false end
end

function samp.onVehicleStreamIn()
	if cleaner then return false end
end

function removePlayer(id)
	local bs = raknetNewBitStream()
	raknetBitStreamWriteInt16(bs, id)
	raknetEmulRpcReceiveBitStream(163, bs)
	raknetDeleteBitStream(bs)
end

function removeVehicle(id)
	local bs = raknetNewBitStream()
	raknetBitStreamWriteInt16(bs, id)
	raknetEmulRpcReceiveBitStream(165, bs)
	raknetDeleteBitStream(bs)
end