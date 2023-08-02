function get_main_formspec(player_name)
    local places = get_all_places()
    local place_rows = {}

    minetest.log("action", "places: " .. minetest.serialize(places))

    for i, place in ipairs(places) do
        -- Create a row string with format '"place_name" Created By "player_name"'
        table.insert(place_rows, minetest.formspec_escape(place.text))
    end    

    -- Concatenate all rows into a single string separated by semicolons
    place_rows = table.concat(place_rows, ",")

    local formspec =
        "size[8,9]" ..
        "textlist[0,0;8,5;places;" .. place_rows .. "]" ..
        "button[0,5;8,1;teleport;Teleport]" ..
        "button[0,6;8,1;delete;Delete]" ..
        "button[0,7;8,1;add_place;Add Current Place]"
    
    return formspec
end

function get_add_place_formspec(player_name)
    local formspec =
        "size[8,4]" ..
        "field[0,0;8,2;name;Place Name;]" ..
        "button[0,1;8,1;save;Save]" ..
        "button[0,2;8,1;cancel;Cancel]"

    return formspec
end

function get_delete_confirm_formspec(place_name)
    local formspec =
        "size[8,4]" ..
        "label[0,0;Are you sure you want to delete " .. place_name .. "? This action cannot be undone.]" ..
        "button[0,1;8,1;confirm_delete;Yes, delete it]" ..
        "button[0,2;8,1;cancel;No, keep it]"

    return formspec
end
