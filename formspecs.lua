-- formspecs.lua

dofile(minetest.get_modpath(modname) .. "/functions.lua")

-- formspec.lua

function get_main_formspec(player_name)
    local places = get_all_places()
    local place_rows = {}

    minetest.log("action", "places: " .. minetest.serialize(places))

    for i, place in ipairs(places) do
        local pos_string = pos_to_string(place.pos)
        if pos_string then
            -- Add the new row as a single string to the table
            local row_string = '"' .. place.name .. '" at pos "' .. pos_string .. '" by "' .. place.owner .. '"'
            table.insert(place_rows, minetest.formspec_escape(row_string))
        else
            minetest.log("error", "Invalid position data for place: " .. place.name)
        end
    end    

    -- Concatenate all rows into a single string separated by semicolons
    place_rows = table.concat(place_rows, ",")

    if place_rows ~= "" then
        local formspec = 
        "formspec_version[4]" ..
        "size[10,9]" ..
        "textlist[0,0;10,7;places;" ..
        place_rows ..
        ";0]" ..
        "button[3.5,7.5;2,1;teleport;Teleport]" ..
        "button[5.5,7.5;2,1;delete;Delete]" ..
        "button[7.5,7.5;2,1;add_place;Add Place]"

        return formspec
    else
        local formspec = 
        "formspec_version[4]" ..
        "size[10,9]" ..
        "label[0.5,3;No places available]" ..
        "button[5.5,7.5;2,1;add_place;Add Place]"

        return formspec
    end
end


function get_add_place_formspec(player_name)
    local formspec = 
        "formspec_version[4]" ..
        "size[6,4]" ..
        "field[0.5,1;5,1;place_name;Place Name;]" ..
        "button[2,2.5;2,1;save;Save]"
    return formspec
end

function get_delete_confirm_formspec(selected_place)
    local formspec = 
        "formspec_version[4]" ..
        "size[6,3]" ..
        "label[0.5,0.5;Are you sure you want to delete " .. minetest.formspec_escape(selected_place) .. "?]" ..
        "button[1,1.5;2,1;confirm_delete;Yes]" ..
        "button[3,1.5;2,1;cancel_delete;No]"
    return formspec
end
