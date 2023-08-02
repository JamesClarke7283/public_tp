function get_number_of_owned_places(player_name)
    local count = 0
    for _, place in ipairs(get_all_places()) do
        if place.owner == player_name then
            count = count + 1
        end
    end
    return count
end


function print_storage()
    for key, value in pairs(public_tp_mod_storage:to_table().fields) do
        local data = minetest.deserialize(value)
        minetest.log("action", "Key: " .. key .. ", Value: " .. minetest.serialize(data))
    end
end


-- Converts a position to a string
function pos_to_string(pos)
    minetest.log("action", "Converting position to string: " .. minetest.serialize(pos))
    local str = pos.x .. "_" .. pos.y .. "_" .. pos.z
    minetest.log("action", "Converted position to string: " .. str)
    return str
end

-- Converts a string to a position
function string_to_pos(str)
    minetest.log("action", "Converting string to position: " .. str)
    local x, y, z = string.match(str, "^([^_]+)_([^_]+)_([^_]+)$")
    if x and y and z then
        local pos = {x = tonumber(x), y = tonumber(y), z = tonumber(z)}
        minetest.log("action", "Converted string to position: " .. minetest.serialize(pos))
        return pos
    else
        minetest.log("error", "Failed to convert string to position: " .. str)
        return nil
    end
end

-- Fetches the place by name from the storage and returns it
function get_place(name)
    minetest.log("action", "Getting place: " .. name)
    local place_string = public_tp_mod_storage:get_string(name)
    if place_string == "" then
        minetest.log("error", "No place found with name: " .. name)
        return nil
    end
    local pos, owner, text = string.match(place_string, "^([^;]+);([^;]+);([^;]+)$")
    if pos and owner then
        local place = {name = name, pos = string_to_pos(pos), owner = owner, text = text}
        minetest.log("action", "Retrieved place: " .. minetest.serialize(place))
        return place
    else
        minetest.log("error", "Failed to parse place: " .. place_string)
        return nil
    end
end

-- Stores a place in the storage
function set_place(name, pos, owner)
    minetest.log("action", "Setting place with name: " .. name .. ", position: " .. minetest.serialize(pos) .. ", owner: " .. owner)
    local display_text = '"' .. name .. '" Created By "' .. owner .. '"'
    local place_string = pos_to_string(pos) .. ";" .. owner .. ";" .. display_text
    public_tp_mod_storage:set_string(name, place_string)
    minetest.log("action", "Set place: " .. name)
    minetest.log("action", "Place data: " .. place_string)
    minetest.log("action", "Display text: " .. display_text) -- Additional log to check the display text
end


-- Deletes a place from the storage
function delete_place(name)
    minetest.log("action", "Deleting place: " .. name)
    public_tp_mod_storage:set_string(name, "")
end

-- Fetches all places from the storage and returns them
function get_all_places()
    minetest.log("action", "Getting all places")
    local places = {}
    for name, entry in pairs(public_tp_mod_storage:to_table().fields) do
        local pos, owner, text = string.match(entry, "^([^;]+);([^;]+);([^;]+)$")
        if pos and owner then
            local place = {name = name, pos = string_to_pos(pos), owner = owner, text = text}
            table.insert(places, place)
        else
            minetest.log("error", "Failed to parse place: " .. entry)
        end
    end
    minetest.log("action", "Retrieved all places: " .. minetest.serialize(places))
    return places
end


-- Handles the addition of a new place
function handle_add_place(player_name, place_name)
    minetest.log("action", "Handling addition of place: " .. place_name)
    local player = minetest.get_player_by_name(player_name)
    if player then
        set_place(place_name, player:get_pos(), player_name)
    end
end

-- Handles the deletion of a place
function handle_delete_place(place_name)
    minetest.log("action", "Handling deletion of place: " .. place_name)
    delete_place(place_name)
end
