-- Register the necessary privileges
minetest.register_privilege("public_tp_add", {
    description = "Allows the player to add new teleport points",
    give_to_singleplayer = true,
})

minetest.register_privilege("public_tp_admin", {
    description = "Allows the player to administrate all teleport points",
    give_to_singleplayer = false,
})

minetest.register_privilege("public_tp_extra", {
    description = "Allows the player to add extra teleport points",
    give_to_singleplayer = true,
})