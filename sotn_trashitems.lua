--[[
	Castlevania: Symphony of the Night
	Trash Items with L3 Script
	By: MottZilla

	Possible Bugs.
	Probably Incomplete.
--]]

EquipMenuOpen = 0
EquipHandPos = 0
EquipHeadPos = 0
EquipArmorPos = 0
EquipCapePos = 0
EquipAccPos = 0
EquipCategory = 0

function RemoveItem()
	EquipCategory = memory.read_u8(0x3C9B0)
	EquipHandPos = memory.read_u8(0x3C9B4)
	EquipHeadPos = memory.read_u8(0x3C9B8)
	EquipArmorPos = memory.read_u8(0x3C9BC)
	EquipCapePos = memory.read_u8(0x3C9C0)
	EquipAccPos = memory.read_u8(0x3C9C4)

	if(EquipCategory == 0 or EquipCategory == 1) then
		local ItemType = memory.read_u8(0x97A8D + EquipHandPos)
		if(EquipHandPos > 0) then
			memory.write_u8(0x9798A + ItemType,0)
		end
	end

	if(EquipCategory == 2) then
		local ItemType = memory.read_u8(0x97B51 + EquipHeadPos)
		if(EquipHeadPos > 0 and ItemType~=0x23) then
			memory.write_u8(0x9798A + ItemType + 0xa8,0)
		end
		console.log("Trashed ItemType:" .. ItemType)
	end

	if(EquipCategory == 3) then
		local ItemType = memory.read_u8(0x97B36 + EquipArmorPos)
		if(EquipArmorPos > 0 and EquipArmorPos~=26 and ItemType~=14) then
			memory.write_u8(0x9798B + ItemType + 0xa8,0)
		end
		console.log("Trashed Armor ItemType:" .. ItemType)
	end

	if(EquipCategory == 4) then
		local ItemType = memory.read_u8(0x97B66 + EquipCapePos)
		if(EquipCapePos > 0) then
			memory.write_u8(0x9798B + ItemType + 0xa8,0)
		end
	end

	if(EquipCategory == 5) then
		local ItemType = memory.read_u8(0x97B70 + EquipAccPos)
		if(EquipAccPos > 0 and ItemType~=64 and ItemType~=65) then
			memory.write_u8(0x9798A + ItemType + 0xa8,0)
		end
		console.log("Trashed ItemType:" .. ItemType)
	end
end

while true do
	EquipMenuOpen = memory.read_u8(0x137948)

	if(EquipMenuOpen > 0) then
		if(memory.read_u16_le(0x97494) == 0x200) then
			RemoveItem()
		end
	end

	emu.frameadvance();
end