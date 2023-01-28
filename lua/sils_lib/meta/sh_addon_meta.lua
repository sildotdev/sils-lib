local SILS_ADDON = {}

SILS_ADDON.uid = "unknown"
SILS_ADDON.name = "Unknown Addon"
SILS_ADDON.description = "Unknown Addon"
SILS_ADDON.version = "0.0.0"
SILS_ADDON.author = "sil"
SILS_ADDON.color = Color( 255, 255, 255 )
SILS_ADDON.license = "000000000" --@TODO: Add thing
SILS_ADDON.steamid = "000000000" --@TODO: Add steamid
SILS_ADDON.dependencies = {}

function SILS_ADDON:Log( iLogType, ... )
    if iLogType == sils.lib.LOG_DEBUG and not sils.lib.config.debug then return end

    local tDebugTable = debug.getinfo(2, "Sl")
    local sRelevantFilepath = string.Explode( "/", tDebugTable.short_src )
    sRelevantFilepath = table.concat( sRelevantFilepath, "/", 2, #sRelevantFilepath)

    MsgC(
        sils.lib.COLOR_WHITE,
        "[",
        self.color,
        self.name,
        sils.lib.COLOR_WHITE,
        "] ",
        sils.lib.LOGS[iLogType].color,
        sils.lib.LOGS[iLogType].name,
        " ",
        sils.lib.LOGS[iLogType].logColor,
        ...
    )

    if sils.lib.config.debug then
        MsgC(
            sils.lib.COLOR_WHITE,
            " <",
            sils.lib.COLOR_GRAY,
            tDebugTable.short_src,
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

sils.lib.addon = sils.lib.addon or {}
sils.lib.addon.META = SILS_ADDON