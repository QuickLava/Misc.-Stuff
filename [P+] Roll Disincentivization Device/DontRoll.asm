##################################################################################################
Roll Disincentivization Device v1.0.0 [QuickLava]
# Replace "targetActionID" value with the Action ID you want Rolling/Spotdodging to trigger!
# Full List of Actions on Fudge's Wiki: https://brawlre.github.io/public/
# Notable Punishment Values: 0x56 = Shieldbreak, 0x5C =  Sleep, 0x89 =  Trip, 0xBD = Instant Death
##################################################################################################
.alias targetActionID = 0x56
HOOK @ $8077F9DC             # [in symbol "changeStatus/[soStatusModuleImpl]/so_status_module_impl.o" @ 0x8077F9C4]
{
  mr r29, r3
  cmplwi r4, 0x1E            # \
  blt %END%                  # |
  cmplwi r4, 0x20            # | If target action is between 0x1E and 0x20 (ie. is a Spotdodge or Roll)...
  bgt %END%                  # /
  li r4, targetActionID      # ... target specified target action instead!
}
