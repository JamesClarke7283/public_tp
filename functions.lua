-- functions.lua

-- Converts a vector to a string in the form "x_y_z"
function pos_to_string(pos)
    -- Make sure that the position data is not nil
    if pos == nil or next(pos) == nil then
        minetest.log("error", "Attempted to convert nil or empty position to string")
        return nil
    end

    -- Make sure that each component of the position data is not nil
    local x = pos.x or 0
    local y = pos.y or 0
    local z = pos.z or 0

    return math.floor(x) .. " " .. math.floor(y) .. " " .. math.floor(z)
end

-- Converts a string in the form "x_y_z" to a vector
function string_to_pos(str)
    local x, y, z = str:match("([^ ]+)_([^ ]+)_([^ ]+)")
    return {x = tonumber(x), y = tonumber(y), z = tonumber(z)}
end

-- Sets a new place in the mod storage
function set_place(name, pos, owner)
    local place_data = pos_to_string(pos) .. ";" .. owner
    public_tp_mod_storage:set_string(name, place_data)
    minetest.log("action", "set_place called with: " .. name .. ", " .. pos_to_string(pos) .. ", " .. owner)
end

-- Gets a place from the mod storage
function get_place(name)
    local place_data = public_tp_mod_storage:get_string(name)
    if place_data == "" then
        return nil
    end
    local pos_string, owner = place_data:match("([^;]+);([^;]+)")
    return {pos = string_to_pos(pos_string), owner = owner}
end

-- Deletes a place from the mod storage
function delete_place(name)
    public_tp_mod_storage:set_string(name, "")
end

-- Handles adding a new place
function handle_add_place(player_name, place_name)
    local player = minetest.get_player_by_name(player_name)
    if player then
        local pos = player:get_pos()
        if pos then
            minetest.log("action", "handle_add_place called with: " .. player_name .. ", " .. place_name .. ", position: " .. pos_to_string(pos))
            set_place(place_name, pos, player_name)
        else
            minetest.log("error", "get_pos returned nil for player: " .. player_name)
        end
    end
end

-- Handles teleporting to a place
function handle_teleport(player_name, place_name)
    minetest.log("action", "handle_teleport called with: " .. player_name .. ", " .. (place_name or "nil"))
    local place = get_place(place_name)
    if place then
        local player = minetest.get_player_by_name(player_name)
        if player then
            player:set_pos(place.pos)
        end
    end
end

-- Handles deleting a place
function handle_delete_place(place_name)
    minetest.log("action", "handle_delete_place called with: " .. (place_name or "nil"))
    delete_place(place_name)
end

-- Gets all places
function get_all_places()
    local places = {}
    local storage_table = public_tp_mod_storage:to_table().fields

    if not storage_table then
        return places
    end

    for key, _ in pairs(storage_table) do
        local place = get_place(key)
        if place then
            places[#places+1] = {name = key, pos = place.pos, owner = place.owner}
        end
    end

    return places
end
