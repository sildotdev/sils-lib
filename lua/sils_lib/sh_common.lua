sils.lib.common = sils.lib.common or {}

-- A bunch of common functions you can hook into and override.
-- By default, we assume we're running sandbox.

function sils.lib.common.Notify( pPlayer, sMessage, iType, iLength )
    if not hook.Run( "sils.lib.common.Notify" ) then
        pPlayer:ChatPrint( sMessage )
    end
end

function sils.lib.common.GiveMoney()
    if not hook.Run( "sils.lib.common.GiveMoney" ) then
        return false
    end
end