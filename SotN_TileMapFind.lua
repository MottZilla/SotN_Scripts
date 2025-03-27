--[[

Castlevania SotN Map Tool Thingy
by: MottZilla

Enter No Clipping mode with L2. Set 0x98850 to 1 to Enable NoClip.

While in NoClip Mode:
Right Click to copy a tile.
Left Click to place tile.
Hovering over a tile will output tile memory address in console.

Z and X Keys change current Layer.

Note: You must disable the Right Click Context menu in "Config -> Customize".
If you do not then you can't copy a tile with right clicking.

]]--

UpdateTimer = 0
RoomPTR = 0
LayerA = 0
LayerB = 0
CurrentLayer = 0
RoomWidth = 0
RoomHeight = 0
PlayerX = 0
PlayerY = 0
TMA = 0
OffsetX = 0
OffsetY = 0
Row = 0
RowSize = 0
Column = 0
CopiedTile = 0
Input = 0
Clipping = 0
MouseData = 0
ScrollX = 0
ScrollY = 0
ScrollColumn = 0
ScrollRow = 0

MouseRow = 0
MouseColumn = 0
MouseOffsetX = 0
MouseOffsetY = 0
MouseTMA = 0

MouseTileCopy = 0

TileSave1 = 0
TileSave2 = 0
TileSave3 = 0
TileSave4 = 0

while true do
	emu.frameadvance();

	if(UpdateTimer > 0) then
		UpdateTimer = UpdateTimer - 1
	end

	MouseData = input.getmouse()
	KeyInput = input.get()
	--print(KeyInput.Z)
	--print(MouseData)
	
		ScrollX = memory.read_u16_le(0x7308E) -- was 73074
		ScrollY = memory.read_u16_le(0x73092) -- was 7307C

		PlayerX = memory.read_u32_le(0x973F0)
		PlayerY = memory.read_u32_le(0x973F4)
		RoomWidth = memory.read_u16_le(0x730C8)
		RoomHeight = memory.read_u16_le(0x730CC)
		RoomPTR = memory.read_u32_le(0x73084)
		RoomPTR = bit.band(RoomPTR,0x1FFFFF)
		Clipping = memory.read_u8(0x1396EA)
		LayerA = RoomPTR

		LayerB = memory.read_u32_le(0x730D8)
		LayerB = bit.band(LayerB,0x1FFFFF)

		--print("Room Pointer",RoomPTR)
		--print("Layer A",LayerA)

		
		--str = bizstring.hex(LayerA)
		--print("LayerA",str)
		
		Row = PlayerY / 16
		Row = math.floor(Row)
		RowSize = (RoomWidth / 16) * 2

		Column = PlayerX / 16
		Column = math.floor(Column)

		OffsetX = Column * 2
		OffsetY = Row * RowSize

		TMA = LayerA + OffsetX + OffsetY

		ScrollColumn = math.floor(ScrollX / 16)
		ScrollRow = math.floor(ScrollY / 16)
		

		MouseRow = (MouseData.Y + 0 + (bit.band(ScrollY,0xF))) / 16
		MouseRow = math.floor(MouseRow)
		MouseColumn = (MouseData.X + 2 + bit.band(ScrollX,0xF) ) / 16 -- was - 6
		MouseColumn = math.floor(MouseColumn)
		MouseColumn = MouseColumn - 1

		MouseOffsetX = (MouseColumn + ScrollColumn) * 2
		MouseOffsetY = (MouseRow + ScrollRow) * RowSize

		if(CurrentLayer == 0) then
			MouseTMA = LayerA + MouseOffsetX + MouseOffsetY
		end

		if(CurrentLayer == 1) then
			MouseTMA = LayerB + MouseOffsetX + MouseOffsetY
		end

	if(MouseData.X < 270 and MouseData.X>=15 and MouseData.Y>=19 and MouseData.Y<227 and Clipping>0) then

		if(MouseData.Left == true) then
			memory.write_u16_le(MouseTMA,MouseTileCopy)
			--print("wrote tile")
		end

		if(MouseData.Right == true) then
			MouseTileCopy = memory.read_u16_le(MouseTMA)
			--print("Copied")
		end
	end

	if(KeyInput.Q == true) then
		TileSave1 = MouseTileCopy
	end

	if(KeyInput.A == true) then
		MouseTileCopy = TileSave1
	end

	if(KeyInput.Z == true) then
		CurrentLayer = 0
		print("Layer A")
	end

	if(KeyInput.X == true) then
		CurrentLayer = 1
		print("Layer B")
	end



	Input = memory.read_u16_le(0x3925C)
	Input = bit.bxor(Input,0xFFFF)

	--str = bizstring.hex(Input)
	--print("Input:",str)

	--[[
	if(Input == 8 and Clipping>0) then
		CopiedTile = memory.read_u16_le(TMA)
	end

	if(Input == 0x40 and Clipping>0) then
		memory.write_u16_le(TMA,CopiedTile)
	end
	]]--	


	if(UpdateTimer == 0) then
		--[[
		print("PlayerY",PlayerY)
		print("PlayerX",PlayerX)

		print("Row",Row)
		print("Column",Column)

		print("OfsX:",OffsetX)
		print("OfsY:",OffsetY)
		--]]

		--print("mouse X:",MouseData.X - 0)
		--print("mouse Y:",MouseData.Y - 0)

		TMA = LayerA + OffsetX + OffsetY
		str = bizstring.hex(TMA)
		--print("TileMap A Address",str)

		if(MouseData.X < 270 and MouseData.X>=15 and MouseData.Y>=19 and MouseData.Y<227) then
		str = bizstring.hex(MouseTMA)
		print("Mouse TMA:",str)
		end

		UpdateTimer = 60
	end

end