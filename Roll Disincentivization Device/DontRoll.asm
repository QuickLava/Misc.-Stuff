##################################################################################################
Roll Disincentivization Device v1.0.1 [QuickLava]
# Replace "targetActionID" value with the Action ID you want Rolling/Spotdodging to trigger!
# Full list of actions on Fudge's Wiki: https://brawlre.github.io/public/
# To simply disable rolls and spotdodge, set ActionID to 0xFFFF!
# Other Notable Values: 0x56 = Shieldbreak, 0x5C =  Sleep, 0x89 =  Trip, 0xBD = Instant Death
##################################################################################################
.alias targetActionID = 0x56
HOOK @ $8077F9C4             # [in symbol "changeStatus/[soStatusModuleImpl]/so_status_module_impl.o" @ 0x8077F9C4]
{
  cmplwi r4, 0x1E            # \
  blt+ exit                  # |
  cmplwi r4, 0x20            # | If target action is between 0x1E and 0x20 (ie. is a Spotdodge or Roll)...
  bgt+ exit                  # /
  li r4, targetActionID      # ... target specified target action instead!
  cmpwi r4, 0xFFFF           # \ 
  bne exit                   # | If we're using the "disable" value though...
  blr                        # / ... simply return to avoid changing status at all.
exit:
  stwu r1, -0x40(r1)         # Restore Original Instruction
}
