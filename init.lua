-- Load additional Lua files
modname = minetest.get_current_modname()

dofile(minetest.get_modpath(modname) .. "/functions.lua")
dofile(minetest.get_modpath(modname) .. "/formspecs.lua")
dofile(minetest.get_modpath(modname) .. "/privs.lua")

-- Global storage
public_tp_mod_storage = minetest.get_mod_storage()

-- Chat command to open the teleport GUI
minetest.register_chatcommand("public_tp", {
    description = "Open the teleport GUI",
    func = function(name)
        local player = minetest.get_player_by_name(name)
        if player then
            minetest.log("action", "Player " .. name .. " opened the teleport GUI.")
            minetest.show_formspec(name, "public_tp:main_formspec", get_main_formspec(name))
        end
    end
})

dofile(minetest.get_modpath(modname) .. "/receive_fields.lua")