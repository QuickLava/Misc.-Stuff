#######################################################################################################
Sound Test and My Music Choices Persist Between Menus (vBrawl Ver.) v1.2.0 [QuickLava]
# Alternate Version of "Menu Music Sticks Between Menu Transitions"
# Makes it so that starting a song from the Sound Test or My Music sub-menus registers
# that song as the active menu song, preventing it from being re-rolled when moving between menus.
# Importantly, this code does not preserve unique sub-menu songs (eg. Rotation or Stage Builder themes)
# when returning to the Main Menu; use the "Menu Music Sticks Between Menu Transitions" code instead
# if that behavior is desired.
#######################################################################################################
# Register Sound Test / My Music Song Selection as Active Menu Track
HOOK @ $80073F64    # 0x1B4 bytes into symbol "playBGM/[sndSystem]/snd_system.o" @ 0x80073DB0
{
  lis r11, 0x805A            # \
  lwz r12, 0x0060(r11)       # / Get pointer to gfSceneManager!
  lwz r12, 0x04(r12)         # Load current scene pointer...
  lhz r12, 0x02(r12)         # ... and grab the bottom half of its name string address.
  cmplwi r12, 0xFDB0         # If it doesn't match the bottom half of the muMenuMain string address...
  bne exit                   # ... then we're not on Main Menu, so exit.
                             # Otherwise, we're either entering Main Menu or starting a My Music/Sound Test song!
  lwz r12, 0x01D8(r11)       # Get pointer to sndBGMRateSystem...
  stw r29, 0x190(r12)        # ... and store the requested song as the active Menu track!
exit:
  lwz r0, 0x24(r1)           # Restore Original Instruction
}
# Menu Track of 0x00 Force Accepts Next Re-Roll, Randomizing Non-Menu BGM Forces Menu Track to 0x00!
HOOK @ $800793F8    # 0x1BC bytes into symbol "setBgmId/[sndBgmRateSystem]/snd_bgmsys.o" @ 0x8007923C
{
  cmplwi r29, 0x2A           # Check if we re-rolled Menu Music...
  beq rolledMenuBGM          # ... and if so, jump to the relevant section.
rolledNonMenuBGM:            # Otherwise, we rolled for stage BGM!
  li r0, 0x00                # \
  stw r0, 0x190(r28)         # / Zero out registered Menu Track to flag it for the below portion!
  b exit                     # Exit.
rolledMenuBGM:               # If we're rolling Menu Music though...
  lwz r0, 0x190(r28)         # \
  cmplwi r0, 0x00            # / ... check if registered Menu Track is zero'd out.
  bne exit                   # If not, exit...
  stw r3, 0x190(r28)         # ... but if so, store newly rolled track to register it!
exit:
  addi r11, r1, 0x30         # Restore Original Instruction
}
