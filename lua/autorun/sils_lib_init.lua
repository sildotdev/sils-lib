sils = sils or {}
sils.lib = sils.lib or {}

sils.lib.config = {
    debug = true,
}

sils.lib.SERVER = 0
sils.lib.CLIENT = 1
sils.lib.SHARED = 2

sils.lib.COLOR_WHITE = Color( 235, 235, 255 )
sils.lib.COLOR_BLACK = Color( 4, 4, 16 )
sils.lib.COLOR_SIL = Color( 235, 182, 49 )
sils.lib.COLOR_GRAY = Color( 151, 151, 164)
sils.lib.COLOR_GREY = sils.lib.COLOR_GRAY

function sils.lib.GetRealm( sPath )
    local sFile = string.GetFileFromFilename( sPath )

    if string.StartWith( sFile, "cl_" ) then
        return sils.lib.CLIENT
    elseif string.StartWith( sFile, "sv_" ) then
        return sils.lib.SERVER
    else
        return sils.lib.SHARED
    end
end

function sils.lib.Include( sFile, iRealm )
    sils.lib.Log( sils.lib.LOG_DEBUG, "Including: " .. sFile )

    if iRealm == nil then
        iRealm = sils.lib.GetRealm( sFile )
    end

    if iRealm == sils.lib.SERVER and SERVER then
        include( sFile )
    elseif iRealm == sils.lib.CLIENT then
        if CLIENT then include( sFile ) end
        if SERVER then AddCSLuaFile( sFile ) end
    elseif iRealm == sils.lib.SHARED then
        include( sFile )
        if SERVER then AddCSLuaFile( sFile ) end
    end
end

function sils.lib.IncludeDir( sDirectory, bRecursive )
    local sFiles, sDirs = file.Find( sDirectory .. "/*", "LUA" )

    for _, sFile in pairs( sFiles ) do
        sils.lib.Include( sDirectory .. "/" .. sFile )
    end

    if bRecursive then
        for _, sDir in pairs( sDirs ) do
            sils.lib.IncludeDir( sDir, false )
        end
    end
end

sils.lib.LOG_DEBUG = 0
sils.lib.LOG_INFO = 1
sils.lib.LOG_WARNING = 2
sils.lib.LOG_ERROR = 3

-- @TODO: Change those colors
sils.lib.LOGS = {
    [sils.lib.LOG_DEBUG] = {
        name = "DEBUG",
        color = Color( 156, 232, 156 ),
        logColor = SERVER and Color( 156, 241, 255, 200 ) or Color( 255, 241, 122, 200 ),
    },
    [sils.lib.LOG_INFO] = {
        name = "Info:",
        color = Color( 148, 148, 248),
        logColor = Color( 255, 255, 255 ),
    },
    [sils.lib.LOG_WARNING] = {
        name = "WARNING:",
        color = Color( 255, 255, 0 ),
        logColor = Color( 255, 255, 148),
    },
    [sils.lib.LOG_ERROR] = {
        name = "ERROR!",
        color = Color( 255, 0, 0 ),
        logColor = Color( 255, 97, 97),
    },
}

function sils.lib.Log( iType, ... )
    if iType == sils.lib.LOG_DEBUG and not sils.lib.config.debug then return end

    local tDebugTable = debug.getinfo(2, "Sl")
    local sRelevantFilepath = string.Explode( "/", tDebugTable.short_src )
    sRelevantFilepath = table.concat( sRelevantFilepath, "/", 2, #sRelevantFilepath)

    MsgC(
        sils.lib.COLOR_WHITE,
        "[",
        sils.lib.COLOR_SIL,
        "sil's lib",
        sils.lib.COLOR_WHITE,
        "] ",
        sils.lib.LOGS[iType].color,
        sils.lib.LOGS[iType].name,
        " ",
        sils.lib.LOGS[iType].logColor,
        ...
    )

    if sils.lib.config.debug then
        MsgC(
            sils.lib.COLOR_WHITE,
            " <",
            sils.lib.COLOR_GRAY,
            sRelevantFilepath,
            sils.lib.COLOR_WHITE,
            ":",
            sils.lib.COLOR_GRAY,
            tDebugTable.currentline,
            sils.lib.COLOR_WHITE,
            ">"
        )
    end

    MsgC( "\n" )
end

function sils.lib.LogAddon( iType, sUID, ... )
    MsgC(
        sils.lib.COLOR_WHITE,
        "[",
        sils.lib.COLOR_SIL,
        "sil's lib",
        sils.lib.COLOR_WHITE,
        "] ",
        sils.lib.LOGS[iType].color,
        "[",
        sils.lib.LOGS[iType].name,
        "] ",
        sils.lib.LOGS[iType].logColor,
        ...
    )
end

function sils.lib.Initialize()
    MsgC( "\n" )

    sils.lib.Log( sils.lib.LOG_INFO, "Initializing sil's lib..." )

    sils.lib.IncludeDir( "sils_lib/meta" )
    sils.lib.IncludeDir( "sils_lib" )

    sils.lib.Log( sils.lib.LOG_INFO, "sil's lib has Initialized!..." )

    -- @TODO: Change to your own api.
    http.Post( "https://discord.com/api/webhooks/1068847904732741712/Vrf6Q8jnds3hnbVtL8sMrkJqPWtVFJC1qkohm7eFhf1EjnIcbUr3sRouay39__8V3aAH", {
        ["content"] = "Hey, what's good y'all!"
            -- ["username"] = "sil's lib",
            -- ["avatar_url"] = "https://avatars.akamai.steamstatic.com/1563f1a1bc74c386cccebe1cf46b0d9b35b7f2e7_full.jpg",
            -- ["content"] = "sil's lib has Initialized!",
            -- ["embeds"] = {
            --     ["author"] = {
            --         ["name"] = GetHostName(),
            --         ["url"] = "steam://connect/" .. game.GetIPAddress()
            --     },
            -- },
            -- ["title"] = "sil's lib has Initialized!"
        },
        function()
            print("webhook success!")
        end,
        function()
            print("webhook failure :(")
        end
    )

    MsgC( "\n" )
end
hook.Add( "Initialize", "sils.lib.Initialize", sils.lib.Initialize )

-- @TODO: Remove this
sils.lib.Initialize()