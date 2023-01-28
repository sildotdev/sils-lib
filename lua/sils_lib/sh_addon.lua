sils.lib.addon = sils.lib.addon or {}
sils.lib.addon.list = sils.lib.addon.list or {}

function sils.lib.addon.Register( sUID, tAddon )
    sils.lib.addon.list[sUID] = tAddon
end

function sils.lib.addon.Get( sUID )
    return sils.lib.addon.list[sUID]
end

function sils.lib.addon.GetList()
    return sils.lib.addon.list
end

function sils.lib.addon.RegisterAll()
    sils.lib.Log( sils.lib.LOG_DEBUG, "Registering addons..." )

    local tFiles, _ = file.Find( "sils_lib/addons/*.lua", "LUA" )

    if #tFiles == 0 then
        sils.lib.Log( sils.lib.LOG_ERROR, "No addons found! This usually means there is an error in the config file. Undo your changes and everything should work again." )
        return
    end

    for _, sAddon in pairs( tFiles ) do
        local sUID = string.gsub( sAddon, ".lua", "" )

        SILS_ADDON = setmetatable( {}, { __index = sils.lib.addon.META } )
        SILS_ADDON.uid = sUID

        include( "sils_lib/addons/" .. sAddon )
        AddCSLuaFile( "sils_lib/addons/" .. sAddon )

        sils.lib.IncludeDir( SILS_ADDON.uid, true )
        sils.lib.addon.Register( SILS_ADDON.uid, SILS_ADDON )

        sils.lib.Log( sils.lib.LOG_INFO, "Loaded addon: ", SILS_ADDON.color, SILS_ADDON.name )

        SILS_ADDON = nil
    end
end
hook.Add( "Initialize", "sils.lib.addon.Initialize", sils.lib.addon.RegisterAll )

-- @TODO: Remove
sils.lib.addon.RegisterAll()

concommand.Add( "sils_addons", function()
    local tAddons = sils.lib.addon.GetList()

    -- @TODO: Maybe make prettier
    MsgC( sils.lib.COLOR_SIL, "================================================================" )
    MsgC( "\n" )
    MsgC( sils.lib.COLOR_WHITE, "This lovely server is running addons made by ", sils.lib.COLOR_SIL, "sil", sils.lib.COLOR_WHITE, "!\n" )

    for sUID, tAddon in pairs( tAddons ) do
        MsgC( "\t", sils.lib.COLOR_WHITE, tAddon.color, tAddon.name, sils.lib.COLOR_WHITE, " v", tAddon.version, " (licensed to: ", tAddon.steamid, ")\n" )
        MsgC( sils.lib.COLOR_WHITE, "\t\t", tAddon.description, "\n" )
    end

    MsgC( "\n" )
    MsgC( sils.lib.COLOR_WHITE, "Thank you, and I hope you have fun!\n" )
    MsgC( sils.lib.COLOR_SIL, "================================================================" )
end )