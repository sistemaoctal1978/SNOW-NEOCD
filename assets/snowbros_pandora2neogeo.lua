-- Snow Bros Pandora → NeoGeo Hardware Translation Layer
-- Cargar en MAME: mame neogeo snowbros_mvs -lua snowbros_pandora2neogeo.lua

-- Mapeo de direcciones Pandora → NeoGeo
local addr_map = {
    -- Input
    [0x11A000] = 0x300000,  -- P1 Input
    [0x11A002] = 0x300001,  -- P2 Input
    [0x11A004] = 0x300002,  -- System
    [0x11A006] = 0x300003,  -- Unused
    
    -- Sound
    [0x300000] = 0x320000,  -- YM2610 control
    [0x300002] = 0x320002,  -- YM2610 data
    
    -- Video
    [0x400000] = 0x3C0000,  -- VRAM base
    [0x400000] = 0x320000,  -- Palette
    
    -- Watchdog
    [0x118000] = 0x100000,  -- Watchdog
    
    -- Spriteram
    [0x700000] = 0x3C0000,  -- Spriteram → VRAM
    [0x700FFF] = 0x3C0FFF,
}

-- Hook de escritura
emu.register_frame_done(function()
    local cpu = manager.machine.devices[":maincpu"]
    local mem = cpu.spaces["program"]
    
    -- Traducir writes a spriteram Pandora → NeoGeo VRAM
    -- Pandora spriteram: $700000-$700FFF (4KB, 96 sprites)
    -- NeoGeo VRAM: $3C0000-$3C0002 (tile), $8600/$8680 (listas)
    
    -- Leer spriteram Pandora
    local spriteram = {}
    for i = 0, 0xFFF do
        spriteram[i] = mem:read_u8(0x700000 + i)
    end
    
    -- Convertir 96 sprites Pandora → NeoGeo sprite list
    -- Pandora: 4 bytes/sprite (x, y, tile, attr)
    -- NeoGeo: 6 bytes/sprite (y, x, tile, attr, chain, zoom)
    
    local neo_sprites = {}
    for i = 0, 95 do
        local base = i * 4
        local x = spriteram[base]
        local y = spriteram[base + 1]
        local tile = spriteram[base + 2] + (spriteram[base + 3] << 8)
        local attr = spriteram[base + 3] & 0x0F
        
        -- NeoGeo sprite format
        neo_sprites[i*6] = y
        neo_sprites[i*6+1] = x
        neo_sprites[i*6+2] = tile & 0xFF
        neo_sprites[i*6+3] = (tile >> 8) | (attr << 4)
        neo_sprites[i*6+4] = 0  -- chain
        neo_sprites[i*6+5] = 0  -- zoom
    end
    
    -- Escribir a NeoGeo VRAM
    local vram = manager.machine.devices[":maincpu"].spaces["program"]
    for i, v in ipairs(neo_sprites) do
        vram:write_u8(0x3C0000 + i - 1, v)
    end
end)

print("Snow Bros Pandora->NeoGeo translation layer loaded")
print("Use: mame neogeo snowbros_mvs -lua snowbros_pandora2neogeo.lua")