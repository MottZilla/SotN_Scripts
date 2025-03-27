--[[

	Castlevania SotN
	Permanent Death Script Demo

	By: MottZilla
	2024-05-03

	Development Notes:

	In the Lua Console type  Overlay = 1
	To Set Overlay = 1 to Draw Entity Slot Addresses
	Set Overlay higher such as 2, 3, or 4 if you are having trouble reading due to overlap.

	Use this to find the address for EnemyPermaDeath() for each enemy.
	The RoomPtr is displayed too for adding new rooms.
	You will also need to add a function for each Zone/Stage.
	
	Two zones are shown in this demo. Following the examples here you could add the rest of
	the Zones, Rooms, and enemies.

	*Extra Note*
	For enemies that die instantly use EnemyPermaDeathInstantDeath() instead. You will need to supply
	the entity id number for these which will be at offset 0x26 from the address slot start. 
]]--

ZoneID = 0
RoomPtr = 0
DeathStatus = {}
DeathResetIndex = 0
Overlay = 0
ShowRoomPtr = 0
ActiveStatus = {}
killcount = 0
killcountlastframe = 0



-- Resets Death Status when you start the Prologue (playing as Richter before Alucard)
function ResetDeathStatus()
	DeathStatus[ DeathResetIndex ] = 0
	DeathResetIndex = DeathResetIndex + 1
	if(DeathResetIndex > 512) then DeathResetIndex = 0 end
end

-- This function handles marking enemies as dead and enforcing perma-death.
-- address_slot is the address you would see using the Overlay, death_id needs to be a unique number
-- for each enemy so they have their own recorded state for perma-death
function EnemyPermaDeath(address_slot,death_id)
	local flags = memory.read_u8(address_slot + 0x35)
	
	-- If This Enemy is dying
	if bit.band(flags,0x1) == 1 then
		if(DeathStatus[death_id] == 0 or DeathStatus[death_id] == nil) then console.log("dead") end
		DeathStatus[death_id] = 1	-- Mark for Perma Death.
	else	-- Otherwise check if this Enemy is PermaDead
		if DeathStatus[death_id] then
			memory.write_u8(address_slot+0x7,0xfe) -- If it is, Place off Screen to remove.
		end
	end
end

-- This function handles marking enemies as dead and enforcing perma-death for enemies without Death Animation
-- address_slot is the address you would see using the Overlay, death_id needs to be a unique number
-- for each enemy so they have their own recorded state for perma-death
-- entity_id must match the id number for the enemy. This is at address slot offset 0x26
function EnemyPermaDeathInstantDeath(address_slot,death_id,entity_id)
	local id_read = memory.read_u8(address_slot + 0x26)

	if ActiveStatus[death_id] == 1 and id_read == 0 and killcount > killcountlastframe then
		ActiveStatus[death_id] = 0
		if(DeathStatus[death_id] == 0 or DeathStatus[death_id] == nil) then console.log("dead insta") end
		DeathStatus[death_id] = 1
	end

	if id_read == entity_id then
		ActiveStatus[death_id] = 1
	else
		ActiveStatus[death_id] = 0
	end

	if DeathStatus[death_id] then
		memory.write_u8(address_slot+0x7,0xfe) -- If it is, Place off Screen to remove.
	end
	
end

-- This Function will draw Entity Slot numbers on screen as well as the RoomPtr and ZoneID
function DrawSlotNumbers()
	local SlotAddr = 0x733D8
	local count = 0
	local FPtr = 0

	if(ShowRoomPtr) then gui.drawString(10,4,"RoomPtr:" .. bizstring.hex(RoomPtr) .. " ZoneID:" .. bizstring.hex(ZoneID)) end

	for count = 0,255,1 do
		FPtr = memory.read_u32_le(SlotAddr + 0x28)
		if(FPtr > 0) then
			gui.drawString(memory.read_u16_le(SlotAddr+0x2),memory.read_u16_le(SlotAddr+0x6),bizstring.hex(SlotAddr))
		end
		SlotAddr = SlotAddr + (0xBC * Overlay)

		if(SlotAddr > 0x7EFD8) then return end
	end
end

-- This Function is for ZoneID 0x41
-- Enemy Death IDs used [1 - 39]
function EntranceFirst()
	if(RoomPtr == 0x80198838) then
		EnemyPermaDeath(0x762D8,1)	-- Warg
	end
	if(RoomPtr == 0x80199E38) then
		EnemyPermaDeath(0x76E98,2)	-- Wargs
		EnemyPermaDeath(0x77A58,3)
		EnemyPermaDeath(0x78618,4)
		EnemyPermaDeath(0x791D8,5)

		-- Zombie. If 7A958 is Perma deathed, they don't spawn anymore.
		EnemyPermaDeathInstantDeath(0x7A958,28,0x4C)
	end
	if(RoomPtr == 0x8019CE38) then
		EnemyPermaDeath(0x7AAD0,6)	-- Merman
		EnemyPermaDeath(0x7AA14,7)
		EnemyPermaDeath(0x7AC48,8)
		EnemyPermaDeath(0x7ADC0,9)
		EnemyPermaDeath(0x7AA14,10)
		EnemyPermaDeath(0x77478,11)
		EnemyPermaDeath(0x7A958,12)
		EnemyPermaDeath(0x77188,13)
		EnemyPermaDeath(0x77300,14)
		EnemyPermaDeath(0x77010,15)
		EnemyPermaDeath(0x77244,16)
		EnemyPermaDeath(0x770CC,17)
		EnemyPermaDeath(0x76E98,18)
		EnemyPermaDeath(0x76F54,19)
		EnemyPermaDeath(0x773BC,20)

		EnemyPermaDeathInstantDeath(0x77B14,21,0x48)	-- Bats
		EnemyPermaDeathInstantDeath(0x77C8C,22,0x48)
		EnemyPermaDeathInstantDeath(0x77D48,23,0x48)
		EnemyPermaDeathInstantDeath(0x77E04,24,0x48)

	end
	if(RoomPtr == 0x8019EA38) then
		EnemyPermaDeath(0x762D8,25)	-- Warg
		EnemyPermaDeath(0x76E98,26)	-- Warg
		EnemyPermaDeath(0x77A58,27)	-- Warg
	end
end

-- This Function is for ZoneID 0x0C
-- Enemy Death IDs used [40 - 69]
function AlchemyLab()
	if(RoomPtr == 0x80198A5C) then
		EnemyPermaDeathInstantDeath(0x77478,40,0x27)	-- Bone Scimitar
		EnemyPermaDeathInstantDeath(0x77534,41,0x27)	-- Bone Scimitar
		EnemyPermaDeathInstantDeath(0x775F0,42,0x2E)	-- Skeleton
	end
	if(RoomPtr == 0x8019C85C) then
		EnemyPermaDeathInstantDeath(0x76E98,43,0x27)	-- Bone Scimitar
		EnemyPermaDeathInstantDeath(0x77010,44,0x27)	-- Bone Scimitar
		EnemyPermaDeathInstantDeath(0x76F54,45,0x27)	-- Bone Scimitar
		EnemyPermaDeath(0x770CC,46)	-- Axe Armor
	end
	if(RoomPtr == 0x8019A05C) then
		EnemyPermaDeathInstantDeath(0x77A58,46,0x2E)	-- Skeleton
	end
	if(RoomPtr == 0x8019BE5C) then
		EnemyPermaDeathInstantDeath(0x77768,47,0x31)	-- Spittle Bone
		EnemyPermaDeath(0x77478,48)	-- Axe Armor
		EnemyPermaDeath(0x775F0,49)	-- Axe Armor
	end
	if(RoomPtr == 0x8019925C) then
		EnemyPermaDeathInstantDeath(0x77BD0,50,0x31)	-- Spittle Bone
		EnemyPermaDeathInstantDeath(0x77A58,51,0x31)	-- Spittle Bone
	end
	if(RoomPtr == 0x8019D65C) then
		EnemyPermaDeathInstantDeath(0x77A58,52,0x27)	-- Bone Scimitar
		EnemyPermaDeathInstantDeath(0x77BD0,53,0x27)	-- Bone Scimitar
		EnemyPermaDeath(0x77D48,54)	-- Bloody Zombie
	end
	if(RoomPtr == 0x8019725C) then
		EnemyPermaDeath(0x77A58,55)	-- Bloody Zombie
		EnemyPermaDeath(0x77BD0,56)	-- Bloody Zombie
		EnemyPermaDeath(0x77D48,57)	-- Bloody Zombie
		EnemyPermaDeath(0x77EC0,58)	-- Bloody Zombie
	end
	if(RoomPtr == 0x8019E25C) then
		EnemyPermaDeath(0x77BD0,59)	-- Axe Armor
		EnemyPermaDeath(0x77A58,60)	-- Axe Armor
		EnemyPermaDeath(0x77D48,61)	-- Axe Armor
		EnemyPermaDeath(0x78038,62)	-- Axe Armor
		EnemyPermaDeath(0x77EC0,63)	-- Axe Armor
		EnemyPermaDeathInstantDeath(0x78328,64,0x31)	-- Spittle Bone
		EnemyPermaDeathInstantDeath(0x781B0,65,0x31)	-- Spittle Bone
		EnemyPermaDeathInstantDeath(0x7855C,66,0x31)	-- Spittle Bone
		EnemyPermaDeathInstantDeath(0x784A0,67,0x31)	-- Spittle Bone
	end
end


-- Fix Annoying Warning Messages on Bizhawk 2.9 and above.
-- This must be done or it will kill performance.
BizVersion = client.getversion()
if(bizstring.contains(BizVersion,"2.9")) then
	bit = (require "migration_helpers").EmuHawk_pre_2_9_bit();
end

while true do
	killcountlastframe = killcount
	killcount = memory.read_u32_le(0x97BF4)
	ZoneID = memory.read_u32_le(0x974A0)
	RoomPtr = memory.read_u32_le(0x73084)

	if(ZoneID == 0x1F) then ResetDeathStatus() end
	if(ZoneID == 0x41) then EntranceFirst() end
	if(ZoneID == 0x0C) then AlchemyLab() end

	if(Overlay>0) then DrawSlotNumbers() else gui.clearGraphics() end

	emu.frameadvance();
end

