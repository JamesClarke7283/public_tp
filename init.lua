-- Load additional Lua files
modname = minetest.get_current_modname()

dofile(minetest.get_modpath(modname) .. "/functions.lua")
dofile(minetest.get_modpath(modname) .. "/formspecs.lua")

-- Global storage
public_tp_mod_storage = minetest.get_mod_storage()

-- Selected place table to store the selected place index for each player
local selected_place = {}

-- Chat command to open the teleport GUI
minetest.register_chatcommand("public_tp", {
    description = "Open the teleport GUI",
    func = function(name)
        local player = minetest.get_player_by_name(name)
        if player then
            minetest.show_formspec(name, "public_tp:main_formspec", get_main_formspec(name))
        end
    end
})

-- This function is called when a player sends a form submission.
minetest.register_on_player_receive_fields(function(player, formname, fields)
    local player_name = player:get_player_name()
    print("Entered minetest.register_on_player_receive_fields function. Form name: " .. formname)

    if formname == "public_tp:main_formspec" then
        if fields.places then
            local event = minetest.explode_textlist_event(fields.places)
            if event.type == "CHG" then
                selected_place[player_name] = event.index
            end
        end

        if fields.teleport and selected_place[player_name] then
            local place = get_place(player_name, selected_place[player_name])
            if place then
                local pos = string_to_pos(place.pos)
                player:set_pos(pos)
            end
        end

        if fields.delete and selected_place[player_name] then
            minetest.show_formspec(player_name, "public_tp:delete_confirm_formspec", get_delete_confirm_formspec(selected_place[player_name]))
        end

        if fields.add_place then
            minetest.show_formspec(player_name, "public_tp:add_place_formspec", get_add_place_formspec(player_name))
        end
    elseif formname == "public_tp:add_place_formspec" then
        if fields.save and fields.name then
            print("Save button pressed with place name: " .. fields.name)
            handle_add_place(player, fields.name)
            minetest.show_formspec(player_name, "public_tp:main_formspec", get_main_formspec(player_name)) -- Show the main formspec again
        end
    elseif formname == "public_tp:delete_confirm_formspec" then
        local selected_place_index = tonumber(fields.confirm_delete)
        if selected_place_index and selected_place[player_name] then
            local place = get_place(player_name, selected_place[player_name])
            if place then
                handle_delete_place(place.name)
                selected_place[player_name] = nil
                minetest.show_formspec(player_name, "public_tp:main_formspec", get_main_formspec(player_name))
            end
        end
    end
end)
