-- name: [CS] Clank (Ratchet&Clank64)
-- description: Clank has arrived in N64 style! With a custom moveset + sounds! Made by CrypticTM.\n\Requires Character Select.

-- description: 
local E_MODEL_CLANK = smlua_model_util_get_id("w_test3_geo")

-- 🍄 PLACEHOLDER BOLT MODEL
local E_MODEL_BOLT = E_MODEL_MUSHROOM

local TEXT_MOD_NAME = "Clank"
local TEX_CLANK = get_texture_info("clankhud_icon")

local SOUND_BOLT_SHOT = audio_sample_load("Bolts.ogg")

local id_bhvClankBolt

-- voicetable

local VOICETABLE_CLANK = {
    [CHAR_SOUND_ATTACKED] = {"silence.ogg", "Attacked2.ogg","clanksound.ogg"},
    [CHAR_SOUND_GROUND_POUND_WAH] = "Star Get.ogg",
    [CHAR_SOUND_HAHA] = "silence.ogg",
    [CHAR_SOUND_HAHA_2] = "silence.ogg",
    [CHAR_SOUND_HERE_WE_GO] = "clanksound.ogg",
    [CHAR_SOUND_HOOHOO] = {"Bolts.ogg", "Bolts.ogg"},
    [CHAR_SOUND_ON_FIRE] = "silence.ogg",
    [CHAR_SOUND_OOOF] = "silence.ogg",
    [CHAR_SOUND_OOOF2] = {"Bolts.ogg","clanksound.ogg","Bolts.ogg"},
    [CHAR_SOUND_PUNCH_HOO] = "Punch Hoo.ogg",
    [CHAR_SOUND_PUNCH_WAH] = "Punch Wah.ogg",
    [CHAR_SOUND_PUNCH_YAH] = "Punch Yah.ogg",
    [CHAR_SOUND_SNORING1] = "silence.ogg",
    [CHAR_SOUND_SNORING2] = "silence.ogg",
    [CHAR_SOUND_SNORING3] = {"Bolts.ogg", "silence.ogg", "silence.ogg"},
    [CHAR_SOUND_SO_LONGA_BOWSER] = "silence.ogg",
    [CHAR_SOUND_TWIRL_BOUNCE] = "CompleteDisaster.ogg",
    [CHAR_SOUND_WAAAOOOW] = {"Bolts.ogg", "Bolts.ogg", "clanksound.ogg"},
    [CHAR_SOUND_WAH2] = "Bolts.ogg",
    [CHAR_SOUND_WHOA] = "silence.ogg",
    [CHAR_SOUND_YAHOO] = "Jump2.ogg",
    [CHAR_SOUND_YAHOO_WAHA_YIPPEE] = {"silence.ogg", "Jump2.ogg"},
    [CHAR_SOUND_YAH_WAH_HOO] = {"Jump1.ogg", "silence.ogg"},
    [CHAR_SOUND_OKEY_DOKEY] = "Jump2.ogg",
    [CHAR_SOUND_LETS_A_GO] = "silence.ogg",
    [CHAR_SOUND_DYING] = {"Bolts.ogg","silence.ogg","clanksound.ogg"},
    [CHAR_SOUND_DROWNING] = "silence.ogg",
    [CHAR_SOUND_EEUH] = {"Climbup.ogg","silence.ogg","silence.ogg"},
    [CHAR_SOUND_MAMA_MIA] = {"Star Get.ogg","Star Get.ogg","clanksound.ogg"},
    [CHAR_SOUND_COUGHING1] = "Cough1.ogg",
    [CHAR_SOUND_COUGHING2] = "silence.ogg",
    [CHAR_SOUND_COUGHING3] = "silence.ogg",
    [CHAR_SOUND_DOH] = {"CompleteDisaster.ogg","Bolts.ogg","clanksound.ogg"},
    [CHAR_SOUND_HRMM] = {"CompleteDisaster.ogg","Botls.ogg","clanksound.ogg"},
    [CHAR_SOUND_PANTING] = "silence.ogg",
    [CHAR_SOUND_UH] = "Bolts.ogg",
    [CHAR_SOUND_YAWNING] = 'silence.ogg',
}

-- pallete is basic

local PALLETE_CLANK = {
    [PANTS]  = {r = 0x60, g = 0x64, b = 0x64},
    [SHIRT]  = {r = 0xf7, g = 0xef, b = 0xb1},
    [GLOVES] = {r = 0xff, g = 0xff, b = 0xff},
    [SHOES]  = {r = 0x68, g = 0x40, b = 0x1b},
    [HAIR]   = {r = 0x73, g = 0x06, b = 0x00},
    [SKIN]   = {r = 0xfe, g = 0xd5, b = 0xa1},
    [CAP]    = {r = 0x76, g = 0xb4, b = 0xce},
}

-- states


local function init_clank_state()
    if not gCharacterStates then gCharacterStates = {} end

    for i = 0, (MAX_PLAYERS or 1) - 1 do
        if not gCharacterStates[i] then gCharacterStates[i] = {} end
        if not gCharacterStates[i].clank then
            gCharacterStates[i].clank = {
                cooldown = 0,
            }
        end
    end
end



local function is_clank(m)
    if not _G.charSelectExists then return false end
    return _G.charSelect.character_get_voice(m) == VOICETABLE_CLANK
end

-- ill finish this later for their shooting arm

local function get_shot_pos(m)
    local pos = gVec3fZero()
    local yaw = m.faceAngle.y

    pos.x = m.pos.x + sins(yaw) * 45
    pos.y = m.pos.y + 60
    pos.z = m.pos.z + coss(yaw) * 45

    return pos
end



local function get_active_bolts(m)
    local count = 0
    local gIndex = network_global_index_from_local(m.playerIndex)

    local bolt = obj_get_first_with_behavior_id(id_bhvClankBolt)
    while bolt do
        if bolt.globalPlayerIndex == gIndex then
            count = count + 1
        end
        bolt = obj_get_next_with_same_behavior_id(bolt)
    end

    return count
end



local function spawn_bolt(m)
    local state = gCharacterStates[m.playerIndex].clank

    if state.cooldown > 0 then return end
    if get_active_bolts(m) >= 6 then return end

    local gIndex = network_global_index_from_local(m.playerIndex)
    local pos = get_shot_pos(m)
    local yaw = m.faceAngle.y

    audio_sample_play(SOUND_BOLT_SHOT, m.pos, 1)

    spawn_sync_object(
        id_bhvClankBolt,
        E_MODEL_BOLT,
        pos.x, pos.y, pos.z,
        function(o)
            o.oMoveAngleYaw = yaw
            o.oMoveAnglePitch = 0

            o.oForwardVel = math.max(m.forwardVel + 90, 140)
            o.oVelY = 0

            o.globalPlayerIndex = gIndex
            o.oIntangibleTimer = 2

            spawn_mist_particles_variable(0, 0, 0)
        end
    )

    state.cooldown = 6
end



function bhv_clank_bolt_init(o)
    o.oFlags = OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE | OBJ_FLAG_COMPUTE_DIST_TO_MARIO
    o.oGravity = 0
    o.oFriction = 1
    o.oDragStrength = 0

    o.hitboxRadius = 60
    o.hitboxHeight = 60

    network_init_object(o, true, { 'globalPlayerIndex' })
end

function bhv_clank_bolt_loop(o)
    if o.oTimer > 90 then
        spawn_mist_particles()
        obj_mark_for_deletion(o)
        return
    end

    -- projectile movement
    cur_obj_update_floor_and_walls()

    o.oPosX = o.oPosX + sins(o.oMoveAngleYaw) * o.oForwardVel
    o.oPosZ = o.oPosZ + coss(o.oMoveAngleYaw) * o.oForwardVel

    -- hit mario
    local m = nearest_mario_state_to_object(o)

    if m and dist_between_objects(o, m.marioObj) < 140 then
        m.health = m.health - 2
        spawn_mist_particles()
        obj_mark_for_deletion(o)
        return
    end

    -- wall hit
    if o.oMoveFlags & (OBJ_MOVE_HIT_WALL | OBJ_MOVE_ON_GROUND) ~= 0 then
        spawn_mist_particles()
        obj_mark_for_deletion(o)
        return
    end
end



local function on_update(m)
    if not is_clank(m) then return end

    local state = gCharacterStates[m.playerIndex].clank

    if state.cooldown > 0 then
        state.cooldown = state.cooldown - 1
    end

    if (m.controller.buttonPressed & B_BUTTON) ~= 0 then
        spawn_bolt(m)
    end
end

-- register

if _G.charSelectExists then

    _G.charSelect.character_add(
        "Clank v1.0",
        {"Clank from Ratchet & Clank universe. On another secret mission in another galaxy.."},
        "CrypticTM",
        {r = 255, g = 102, b = 0},
        E_MODEL_CLANK,
        CT_MARIO,
        TEX_CLANK
    )

    _G.charSelect.character_add_voice(E_MODEL_CLANK, VOICETABLE_CLANK)

    hook_event(HOOK_CHARACTER_SOUND, function(m, sound)
        if _G.charSelect.character_get_voice(m) == VOICETABLE_CLANK then
            return _G.charSelect.voice.sound(m, sound)
        end
    end)

    hook_event(HOOK_ON_LEVEL_INIT, init_clank_state)
    hook_event(HOOK_MARIO_UPDATE, on_update)

    id_bhvClankBolt = hook_behavior(
        nil,
        OBJ_LIST_GENACTOR,
        true,
        bhv_clank_bolt_init,
        bhv_clank_bolt_loop,
        "bhvClankBolt"
    )

else
    djui_popup_create(
        "\\#ffffdc\\\n"..TEXT_MOD_NAME..
        "\nRequires Character Select!\nEnable and restart.",
        6
    )
end