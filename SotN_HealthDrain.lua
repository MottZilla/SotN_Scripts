--[[ 	
	Castlevania SotN
	Health Drain Script
	Written By: MottZilla
	March 6th, 2023

	Adjust DrainCycle to change how often DrainHP is subtracted from Player.
	Default DrainCycle is 60 (once every second).

	DrainPercentOfTotal if true will use DrainPercentage to Drain x% of total HP each cycle.
	Minimum of 1 HP drained.

	To go lower than 1HP per cycle such as lose 0.5HP per second you will have to set DrainCycle 
	to 120 with DrainHP at 1. DrainHP cannot be less than 1.

	HP will not drain in menu or while loading. HP does drain during cutscenes and other times Alucard
	is not under player control. 
--]]

DrainHP = 1			-- Set this to desired value (default: 1)
DrainCycle = 60			-- Set this to desired value (default: 60)
DrainPercentOfTotal = false	-- Set this to desired value (default: false)
DrainPercentage = 1		-- Set this to desired value (default: 1)
Gtick = 0
Gticko = 0

CurHP = 0
MaxHP = 0
DrainTicks = 0


console.log("Health Drain script started!")
if(DrainPercentOfTotal == true) then console.log("Health Drain " .. DrainPercentage .. "% of Total HP") end
if(DrainPercentOfTotal == false) then console.log("Health Drain HP " .. DrainHP .. " every " .. DrainCycle/60 .. " seconds.") end

while true do
	Gticko = Gtick
	Gtick = memory.read_u8(0x3C8C4)
	if(memory.read_u8(0x3C9A4) == 0x01 and memory.read_u8(0x137598) == 0 and Gtick ~= Gticko and memory.read_u8(0x72EFC) == 0) then
		-- Do Stuff
		DrainTicks = DrainTicks + 1
		if(DrainTicks > DrainCycle) then
			if(DrainPercentOfTotal == true) then
				--stuff
				MaxHP = memory.read_u16_le(0x97BA4)
				DrainHP = (MaxHP / 100) * DrainPercentage
				if(DrainHP > 1) then DrainHP = DrainHP - 1 end	-- Correction for fractional.
				if(DrainHP < 1) then DrainHP = 1 end
			end

			console.log("Draining HP: -" .. DrainHP)
			DrainTicks = 0
			CurHP = memory.read_u16_le(0x97BA0)
			CurHP = CurHP - DrainHP
			if(CurHP < 1) then CurHP = 0 end
			memory.write_u16_le(0x97BA0,CurHP)
			if(CurHP == 0 and memory.read_u8(0x73404) ~= 0x0D and memory.read_u8(0x73404) ~= 0x10) then
				memory.write_u32_le(0x73404,0x0000000D)
				console.log("Kill Player")
			end
		end
	end
	emu.frameadvance();
end

