-- formspec.lua

function get_main_formspec(player_name)
    local places = places_list
    local place_rows = {}
    local place_options = {}
    
    minetest.log("action", "places: " .. minetest.serialize(places))

    for i, place in ipairs(places) do
        local pos_string = pos_to_string(place.pos)
        if pos_string then
            place_rows[#place_rows + 1] = minetest.formspec_escape(place.name) .. "," .. pos_string .. "," .. minetest.formspec_escape(place.owner)
            table.insert(place_options, minetest.formspec_escape(place.name))
        else
            minetest.log("error", "Invalid position data for place: " .. place.name)
        end
    end

    if #place_rows > 0 then
        local formspec = {
            "formspec_version[4]",
            "size[10,9]",
            "tablecolumns[text;text;text]",
            "tableoptions[background=#00000000;border=false]",
            "table[0,0;10,7;places;Name,Position,Owner;",
            table.concat(place_rows, ";"),
            ";0]",
            "dropdown[0.5,8;4;selected_place;" .. table.concat(place_options, ",") .. ";1]",
            "button[4.5,7.5;2,1;teleport;Teleport]",
            "button[6.5,7.5;2,1;delete;Delete]",
            "button[8.5,7.5;2,1;add_place;Add Place]",
        }

        return table.concat(formspec, "")
    else
        local formspec = {
            "formspec_version[4]",
            "size[10,9]",
            "label[0.5,3;No places available]",
            "button[4.5,7.5;2,1;add_place;Add Place]",
        }

        return table.concat(formspec, "")
    end
end

function get_add_place_formspec(player_name)
    local formspec = {
        "formspec_version[4]",
        "size[6,4]",
        "field[0.5,1;5,1;place_name;Place Name;]",
        "button[2,2.5;2,1;save;Save]",
    }

    return table.concat(formspec, "")
end

function get_delete_confirmation_formspec(place_name)
    local formspec = {
        "formspec_version[4]",
        "size[6,4]",
        "label[0.5,1;Are you sure you want to delete " .. minetest.formspec_escape(place_name) .. "?]",
        "button[0.5,2.5;2,1;confirm_delete;Yes]",
        "button[3,2.5;2,1;cancel_delete;No]",
    }

    return table.concat(formspec, "")
end
