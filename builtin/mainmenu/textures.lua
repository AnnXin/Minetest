--Minetest
--Copyright (C) 2013 sapier
--
--This program is free software; you can redistribute it and/or modify
--it under the terms of the GNU Lesser General Public License as published by
--the Free Software Foundation; either version 3.0 of the License, or
--(at your option) any later version.
--
--This program is distributed in the hope that it will be useful,
--but WITHOUT ANY WARRANTY; without even the implied warranty of
--MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--GNU Lesser General Public License for more details.
--
--You should have received a copy of the GNU Lesser General Public License along
--with this program; if not, write to the Free Software Foundation, Inc.,
--51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.


mm_texture = {}

--------------------------------------------------------------------------------
function mm_texture.init()
    mm_texture.defaulttexturedir = minetest.get_texturepath_share() .. DIR_DELIM .. "base" ..
                        DIR_DELIM .. "pack" .. DIR_DELIM
    mm_texture.basetexturedir = mm_texture.defaulttexturedir

    mm_texture.texturepack = minetest.setting_get("texture_path")

    mm_texture.gameid = nil
end

--------------------------------------------------------------------------------
function mm_texture.update(tab,gamedetails)
    if gamedetails == nil then
        return
    end
    mm_texture.update_game(gamedetails)
end

--------------------------------------------------------------------------------
function mm_texture.reset()
    mm_texture.gameid = nil
    local have_bg      = false
    local have_overlay = mm_texture.set_generic("overlay")

    if not have_overlay then
        have_bg = mm_texture.set_generic("background")
    end

    mm_texture.clear("header")
    mm_texture.clear("footer")
    minetest.set_clouds(false)

    mm_texture.set_generic("footer")
    mm_texture.set_generic("header")

    if not have_bg then
        if minetest.setting_getbool("menu_clouds") then
            minetest.set_clouds(true)
        else
            mm_texture.set_dirt_bg()
        end
    end
end

--------------------------------------------------------------------------------
function mm_texture.update_game(gamedetails)
    if mm_texture.gameid == gamedetails.id then
        return
    end

    local have_bg      = false
    local have_overlay = mm_texture.set_game("overlay",gamedetails)

    if not have_overlay then
        have_bg = mm_texture.set_game("background",gamedetails)
    end

    mm_texture.clear("header")
    mm_texture.clear("footer")
    minetest.set_clouds(false)

    if not have_bg then

        if minetest.setting_getbool("menu_clouds") then
            minetest.set_clouds(true)
        else
            mm_texture.set_dirt_bg()
        end
    end

    mm_texture.set_game("footer",gamedetails)
    --print(dump(gamedetails))
    mm_texture.set_game("header",gamedetails)

    mm_texture.gameid = gamedetails.id
end

--------------------------------------------------------------------------------
function mm_texture.clear(identifier)
    minetest.set_background(identifier,"")
end

--------------------------------------------------------------------------------
function mm_texture.set_generic(identifier)
    --try texture pack first
    if mm_texture.texturepack ~= nil then
        local path = mm_texture.texturepack .. DIR_DELIM .."menu_" ..
                                        identifier .. ".png"
        if minetest.set_background(identifier,path) then
            return true
        end
    end

    if mm_texture.defaulttexturedir ~= nil then
        local path = mm_texture.defaulttexturedir .. DIR_DELIM .."menu_" ..
                                        identifier .. ".png"
        if minetest.set_background(identifier,path) then
            return true
        end
    end

    return false
end

--------------------------------------------------------------------------------
function mm_texture.set_game(identifier,gamedetails)

    if gamedetails == nil then
        return false
    end

    if mm_texture.texturepack ~= nil then
        local path = mm_texture.texturepack .. DIR_DELIM ..
                        gamedetails.id .. "_menu_" .. identifier .. ".png"
        if minetest.set_background(identifier,path) then
            return true
        end
    end

    local path = gamedetails.path .. DIR_DELIM .."menu" ..
                                     DIR_DELIM .. identifier .. ".png"
    if minetest.set_background(identifier,path) then
        return true
    end

    return false
end

function mm_texture.set_dirt_bg()
    if mm_texture.texturepack ~= nil then
        local path = mm_texture.texturepack .. DIR_DELIM .."default_stone.png"
        if minetest.set_background("background", path, true, 128) then
            return true
        end
    end

    --use base pack
    local minimalpath = defaulttexturedir .. "dirt_bg.png"
    minetest.set_background("background", minimalpath, true, 128)
end
