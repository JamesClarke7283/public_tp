-- Selected place table to store the selected place index for each player
local selected_place = {}

-- This function is called when a player sends a form submission.
minetest.register_on_player_receive_fields(function(player, formname, fields)
    local player_name = player:get_player_name()
    minetest.log("action", "Player " .. player_name .. " submitted a form: " .. formname)

    if formname == "public_tp:main_formspec" then
        minetest.log("action", "Fields: " .. minetest.serialize(fields))
        if fields.places then
            local event = minetest.explode_textlist_event(fields.places)
            minetest.log("action", "Event: " .. minetest.serialize(event))
            if event.type == "CHG" then
                if event.text then
                    minetest.log("action", "Selected text: " .. event.text)
                    -- Parse the place name and player name from the selected place string
                    for _, place in ipairs(get_all_places()) do
                        if place.text == event.text then
                            selected_place[player_name] = {name = place.name, owner = place.owner}
                            minetest.log("action", "Player " .. player_name .. " selected place: " .. minetest.serialize(selected_place[player_name]))
                            break
                        end
                    end
                else
                    minetest.log("error", "Player " .. player_name .. " selected a place, but no text was found.")
                end
            end
        end

        if fields.teleport and selected_place[player_name] then
            minetest.log("action", "Teleport button pressed by " .. player_name .. " for place: " .. minetest.serialize(selected_place[player_name]))
            local place = get_place(selected_place[player_name].name)
            if place then
                player:set_pos(place.pos)
                minetest.log("action", "Player " .. player_name .. " teleported to place: " .. selected_place[player_name].name)
            end
        end

        if fields.delete and selected_place[player_name] then
            local place = get_place(selected_place[player_name].name)
            if place then
                if minetest.check_player_privs(player_name, {public_tp_admin=true}) or place.owner == player_name then
                    minetest.show_formspec(player_name, "public_tp:delete_confirm_formspec", get_delete_confirm_formspec(selected_place[player_name].name))
                else
                    minetest.chat_send_player(player_name, "You do not have the permission to delete this place.")
                end
            end
        end

        if fields.add_place then
            minetest.show_formspec(player_name, "public_tp:add_place_formspec", get_add_place_formspec(player_name))
        end
    elseif formname == "public_tp:add_place_formspec" then
        if fields.save and fields.name then
            -- Check if player has reached the limit
            local owned_places = get_number_of_owned_places(player_name)
            local public_tp_limit = tonumber(minetest.settings:get("public_tp_limit")) or 2
            local public_tp_extra_limit = tonumber(minetest.settings:get("public_tp_extra_limit")) or 5

            if minetest.check_player_privs(player_name, {public_tp_admin=true}) then
                -- Admins can add as many places as they want
                handle_add_place(player_name, fields.name)
            elseif minetest.check_player_privs(player_name, {public_tp_add=true}) and owned_places >= public_tp_limit then
                -- If the player has public_tp_add privilege but has reached the limit
                minetest.chat_send_player(player_name, "You have reached the maximum limit of " .. public_tp_limit .. " places. You cannot add more.")
                return
            elseif minetest.check_player_privs(player_name, {public_tp_extra=true}) and owned_places >= public_tp_extra_limit then
                -- If the player has public_tp_extra privilege but has reached the extra limit
                minetest.chat_send_player(player_name, "You have reached the maximum limit of " .. public_tp_extra_limit .. " places. You cannot add more.")
                return
            else
                handle_add_place(player_name, fields.name)
            end

            minetest.show_formspec(player_name, "public_tp:main_formspec", get_main_formspec(player_name)) -- Show the main formspec again
            print_storage()
        end
    elseif formname == "public_tp:delete_confirm_formspec" then
        if fields.confirm_delete then
            local place = get_place(selected_place[player_name].name)
            if place and (minetest.check_player_privs(player_name, {public_tp_admin=true}) or place.owner == player_name) then
                handle_delete_place(place.name)
                selected_place[player_name] = nil
                minetest.show_formspec(player_name, "public_tp:main_formspec", get_main_formspec(player_name))
            end
        end
    end
end)
