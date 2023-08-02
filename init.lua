-- init.lua

modname = minetest.get_current_modname()

-- Load other files
dofile(minetest.get_modpath(modname) .. "/functions.lua")
dofile(minetest.get_modpath(modname) .. "/formspec.lua")

-- Create a global mod_storage variable
public_tp_mod_storage = minetest.get_mod_storage()

places_list = get_all_places() or {}

local function on_player_receive_fields(player, formname, fields)
    local player_name = player:get_player_name()

    minetest.log("action", "Entered minetest.register_on_player_receive_fields function. Form name: " .. formname)

    if formname == "public_tp:main_formspec" then
        local selected_place = places_list[tonumber(fields.selected_place)]
        if selected_place then
            if fields.teleport then
                handle_teleport(player_name, selected_place.name)
            elseif fields.delete then
                minetest.show_formspec(player_name, "public_tp:delete_confirmation", get_delete_confirmation_formspec(selected_place.name))
            end
        else
            minetest.log("error", "No place selected.")
        end

        if fields.add_place then
            minetest.show_formspec(player_name, "public_tp:add_place_formspec", get_add_place_formspec())
        end
    elseif formname == "public_tp:add_place_formspec" then
        if fields.save and fields.place_name then
            minetest.log("action", "Save button pressed with place name: " .. fields.place_name)
            handle_add_place(player_name, fields.place_name)
            places_list = get_all_places() -- Update places list after adding new place
            minetest.show_formspec(player_name, "public_tp:main_formspec", get_main_formspec())
        end
    elseif formname == "public_tp:delete_confirmation" then
        if fields.confirm_delete then
            local selected_place = fields.place_to_delete
            handle_delete_place(selected_place)
            places_list = get_all_places() -- Update places list after deleting place
            minetest.show_formspec(player_name, "public_tp:main_formspec", get_main_formspec())
        end
    end
end

minetest.register_on_player_receive_fields(on_player_receive_fields)

minetest.register_chatcommand("public_tp", {
    func = function(player_name, param)
        places_list = get_all_places() -- Fill the places list
        minetest.show_formspec(player_name, "public_tp:main_formspec", get_main_formspec())
    end
})
