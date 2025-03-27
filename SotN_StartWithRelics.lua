--[[
	Castlevania SotN
	Start With Stuff Script
	By: MottZilla

	To give yourself something remove the -- infront of the line.
	To not give yourself something put the -- infront of memory.write again.

--]]

function GiveStuff()
	--memory.write_u8(0x97964,3) -- Soul of Bat
	--memory.write_u8(0x97965,3) -- Fire of Bat
	--memory.write_u8(0x97966,3) -- Echo of Bat
	--memory.write_u8(0x97967,3) -- Force of Echo
	--memory.write_u8(0x97968,3) -- Soul of Wolf
	--memory.write_u8(0x97969,3) -- Power of Wolf
	--memory.write_u8(0x9796A,3) -- Skill of Wolf
	--memory.write_u8(0x9796B,3) -- Form of Mist
	--memory.write_u8(0x9796C,3) -- Power of Mist
	--memory.write_u8(0x9796D,3) -- Gas Cloud
	--memory.write_u8(0x9796E,3) -- Cube of Zoe
	--memory.write_u8(0x9796F,3) -- Spirit Orb
	--memory.write_u8(0x97970,3) -- Gravity Boots
	--memory.write_u8(0x97971,3) -- Leap Stone
	--memory.write_u8(0x97972,3) -- Holy Symbol
	--memory.write_u8(0x97973,3) -- Faerie Scroll
	--memory.write_u8(0x97974,3) -- Jewel of Open
	--memory.write_u8(0x97975,3) -- Merman Statue
	--memory.write_u8(0x97976,3) -- Bat Card
	--memory.write_u8(0x97977,3) -- Ghost Card
	--memory.write_u8(0x97978,3) -- Faerie Card
	--memory.write_u8(0x97979,3) -- Demon Card
	--memory.write_u8(0x9797A,3) -- Sword Card
	--memory.write_u8(0x9797B,3) -- Sprite Card
	--memory.write_u8(0x9797C,3) -- Nosedevil Card
	--memory.write_u8(0x9797D,3) -- Heart of Vlad
	--memory.write_u8(0x9797E,3) -- Tooth of Vlad
	--memory.write_u8(0x9797F,3) -- Rib of Vlad
	--memory.write_u8(0x97980,3) -- Ring of Vlad
	--memory.write_u8(0x97981,3) -- Eye of Vlad

	SWR_StuffGiven = 1
	console.log("Stuff Given")
end

SWR_ZoneID = 0
SWR_RoomPtr = 0
SWR_StuffGiven = 0

while true do
	SWR_ZoneID = memory.read_u8(0x974A0)
	SWR_RoomPtr = memory.read_u32_le(0x73084)

	if(SWR_ZoneID == 0x41 and SWR_RoomPtr == 0x80198838) then GiveStuff() end
	if(SWR_StuffGiven == 1) then break end

	emu.frameadvance();
end