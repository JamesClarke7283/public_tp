-- init.lua

modname = minetest.get_current_modname()

-- Load other files
dofile(minetest.get_modpath(modname) .. "/functions.lua")
dofile(minetest.get_modpath(modname) .. "/formspec.lua")

-- Create a global mod_storage variable
public_tp_mod_storage = minetest.get_mod_storage()

local function on_player_receive_fields(player, formname, fields)
    local player_name = player:get_player_name()

    minetest.log("action", "Entered minetest.register_on_player_receive_fields function. Form name: " .. formname)

    if formname == "public_tp:main_formspec" then
        if fields.teleport then
            local selected_place = fields.places
            handle_teleport(player_name, selected_place)
        elseif fields.delete then
            local selected_place = fields.places
            minetest.show_formspec(player_name, "public_tp:delete_confirmation", get_delete_confirmation_formspec(selected_place))
        elseif fields.add_place then
            minetest.show_formspec(player_name, "public_tp:add_place_formspec", get_add_place_formspec())
        end
    elseif formname == "public_tp:add_place_formspec" then
        if fields.save and fields.place_name then
            minetest.log("action", "Save button pressed with place name: " .. fields.place_name)
            handle_add_place(player_name, fields.place_name)
            minetest.show_formspec(player_name, "public_tp:main_formspec", get_main_formspec())
        end
    elseif formname == "public_tp:delete_confirmation" then
        if fields.confirm_delete then
            local selected_place = fields.place_to_delete
            handle_delete_place(selected_place)
            minetest.show_formspec(player_name, "public_tp:main_formspec", get_main_formspec())
        end
    end
end

minetest.register_on_player_receive_fields(on_player_receive_fields)

minetest.register_chatcommand("public_tp", {
    func = function(player_name, param)
        minetest.show_formspec(player_name, "public_tp:main_formspec", get_main_formspec())
    end
})
