#####################################################################################################
Menu Music Sticks Between Menu Transitions v1.0.1 [QuickLava]
# Prevents the game from changing the active BGM when moving between menus (eg. CSS -> Main Menu) if
# another BGM track is already playing (and not actively fading out). Notably, this means that
# unique sub-menu music (eg. Stage Builder, Replay Menu, Rotation Mode BGM) as well as music started
# from the My Music and Sound Test menus will persist after leaving those menus!
# Note: P+ and related builds re-rolling menu music when you enter most menus isn't vBrawl behavior,
# it's caused by the "op b 0x10 @ $80078E14" line often found towards the bottom of the
# "BootToCSS.asm" file usually found in "Source/Project+/". Commenting out or removing that line
# instead of using this code can restore vBrawl's original behavior, if that's desired.
#####################################################################################################
HOOK @ $80078DB0    # 0x04 bytes into symbol "isSeLoaded/[sndSystem]/snd_system.o" @ 0x80078DAC
{
  cmplwi r4, 0x2A           # Check if we're doing a menu music load...
  bne+ exit                 # ... and if not, just jump to exit, since that's all we care about.
  lis r12, 0x805A           # \ 
  lwz r12, 0x01D0(r12)      # | If we are picking menu music, then grab the sndSystem pointer....
  lwz r12, 0x06E0(r12)      # / ... and get the pointer to the currently playing song.
  cmplwi r12, 0x00          # If it's null...
  beq- exit                 # ... then nothing's playing, so go ahead with selecting something.
  lwz r11, 0x50(r12)        # If something *is* playing though, check its remaining fade out frames...
  cmplwi r11, 0x00          # ... and if it's not 0x00...
  bne- exit                 # ... then we're actively fading this song! Pick something else.
  lwz r1, 0x00(r1)          # Otherwise though, un-allocate the new stack frame...
  li r3, -1                 # ... set the return value to -1...
  blr                       # ... and return early.
exit:
  mflr r0                   # Restore Original Instruction
}
