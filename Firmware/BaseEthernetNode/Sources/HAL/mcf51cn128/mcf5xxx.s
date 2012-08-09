/*
 * File:    mcf5xxx_lo.s
 * Purpose: Lowest level routines for all MCF5xxx
 *
 * Notes:   Low level routines suitable for most ColdFire devices
 *
 */

/*
 * Only need underscore for C functions. The assembly functions will
 * provide both style names.
 */
    
    .extern VECTOR_TABLE
    .extern _VECTOR_TABLE
   
    /*FSL*/
    .global mcf5xxx_wr_cpucr
    .global _mcf5xxx_wr_cpucr
    
    /*FSL*/
    .global mcf5xxx_byterev
    .global _mcf5xxx_byterev
    
    /*FSL*/
    .global mcf5xxx_reset
    .global _mcf5xxx_reset

    .global asm_set_ipl
    .global _asm_set_ipl
    .global asm_sc_exit_to_dbug
    .global _asm_sc_exit_to_dbug
    .global asm_isr_handler
    .global _asm_isr_handler
    .global mcf5xxx_wr_cacr
    .global _mcf5xxx_wr_cacr
    .global mcf5xxx_wr_asid
    .global _mcf5xxx_wr_asid
    .global mcf5xxx_wr_acr0
    .global _mcf5xxx_wr_acr0
    .global mcf5xxx_wr_acr1
    .global _mcf5xxx_wr_acr1
    .global mcf5xxx_wr_acr2
    .global _mcf5xxx_wr_acr2
    .global mcf5xxx_wr_acr3
    .global _mcf5xxx_wr_acr3
    .global mcf5xxx_wr_mmubar
    .global _mcf5xxx_wr_mmubar
    .global mcf5xxx_wr_other_a7
    .global _mcf5xxx_wr_other_a7
    .global mcf5xxx_wr_vbr
    .global _mcf5xxx_wr_vbr
    .global mcf5xxx_wr_macsr
    .global _mcf5xxx_wr_macsr
    .global mcf5xxx_wr_mask
    .global _mcf5xxx_wr_mask
    .global mcf5xxx_wr_acc0
    .global _mcf5xxx_wr_acc0
    .global mcf5xxx_wr_accext01
    .global _mcf5xxx_wr_accext01
    .global mcf5xxx_wr_accext23
    .global _mcf5xxx_wr_accext23
    .global mcf5xxx_wr_acc1
    .global _mcf5xxx_wr_acc1
    .global mcf5xxx_wr_acc2
    .global _mcf5xxx_wr_acc2
    .global mcf5xxx_wr_acc3
    .global _mcf5xxx_wr_acc3
    .global mcf5xxx_wr_sr
    .global _mcf5xxx_wr_sr
    .global mcf5xxx_wr_pc
    .global _mcf5xxx_wr_pc
    .global mcf5xxx_wr_rombar0
    .global _mcf5xxx_wr_rombar0
    .global mcf5xxx_wr_rombar1
    .global _mcf5xxx_wr_rombar1
    .global mcf5xxx_wr_rambar0
    .global _mcf5xxx_wr_rambar0
    .global mcf5xxx_wr_rambar1
    .global _mcf5xxx_wr_rambar1
    .global mcf5xxx_wr_mpcr
    .global _mcf5xxx_wr_mpcr
    .global mcf5xxx_wr_secmbar
    .global _mcf5xxx_wr_secmbar
    .global mcf5xxx_wr_mbar
    .global _mcf5xxx_wr_mbar

    .text

/********************************************************************/
/*
 * This routines changes the IPL to the value passed into the routine.
 * It also returns the old IPL value back.
 * Calling convention from C:
 *   old_ipl = asm_set_ipl(new_ipl);
 * For the Diab Data C compiler, it passes return value thru D0.
 * Note that only the least significant three bits of the passed
 * value are used.
 */

    .text

asm_set_ipl:
_asm_set_ipl:
    link    a6,#-8
    movem.l d6-d7,(sp)

    move.w  sr,d7       /* current sr    */

    move.l  d7,d0       /* prepare return value  */
    andi.l  #0x0700,d0  /* mask out IPL  */
    lsr.l   #8,d0       /* IPL   */

    move.l  8(a6),d6    /* get argument  */
    andi.l  #0x07,d6        /* least significant three bits  */
    lsl.l   #8,d6       /* move over to make mask    */

    andi.l  #0x0000F8FF,d7  /* zero out current IPL  */
    or.l    d6,d7           /* place new IPL in sr   */
    move.w  d7,sr

    movem.l (sp),d6-d7
    lea     8(sp),sp
    unlk    a6
    rts

/********************************************************************/
/*
 * These routines write to the special purpose registers in the ColdFire
 * core.  Since these registers are write-only in the supervisor model,
 * no corresponding read routines exist.
 */

/*FSL: new for V1 processors!!!*/
mcf5xxx_wr_cpucr:
_mcf5xxx_wr_cpucr:
    //move.l  4(SP),D0
    .long   0x4e7b0802      /* movec d0,CPUCR */
    nop
    rts

/*FSL: useful for byte reversing*/
mcf5xxx_byterev:
_mcf5xxx_byterev:
    .short   0x02c0      /* byterev.l, D0   */
    rts 

mcf5xxx_reset:
_mcf5xxx_reset:
    nop
    nop
    /*wont reset if using debug tool*/
    .long   0x4e7b0807   /* invalid opcode */
    nop
    rts
 
mcf5xxx_wr_sr:
_mcf5xxx_wr_sr:
    //move.l  4(SP),D0
    move.w  D0,SR
    rts
    
mcf5xxx_wr_cacr:
_mcf5xxx_wr_cacr:
    //move.l  4(SP),D0
    .long   0x4e7b0002      /* movec d0,cacr */
    nop
    rts

mcf5xxx_wr_asid:
_mcf5xxx_wr_asid:
    //move.l  4(SP),D0
    .long   0x4e7b0003      /* movec d0,asid */
    nop
    rts

mcf5xxx_wr_acr0:
_mcf5xxx_wr_acr0:
    //move.l  4(SP),D0
    .long   0x4e7b0004      /* movec d0,ACR0 */
    nop
    rts

mcf5xxx_wr_acr1:
_mcf5xxx_wr_acr1:
    //move.l  4(SP),D0
    .long   0x4e7b0005      /* movec d0,ACR1 */
    nop
    rts

mcf5xxx_wr_acr2:
_mcf5xxx_wr_acr2:
    //move.l  4(SP),D0
    .long   0x4e7b0006      /* movec d0,ACR2 */
    nop
    rts

mcf5xxx_wr_acr3:
_mcf5xxx_wr_acr3:
    //move.l  4(SP),D0
    .long   0x4e7b0007      /* movec d0,ACR3 */
    nop
    rts

mcf5xxx_wr_mmubar:
_mcf5xxx_wr_mmubar:
    //move.l  4(SP),D0
    .long   0x4e7b0008      /* movec d0,MBAR */
    nop
    rts

mcf5xxx_wr_other_a7:
_mcf5xxx_wr_other_a7:
    //move.l  4(SP),D0
    .long   0x4e7b0800      /* movec d0,OTHER_A7 */
    nop
    rts
    
mcf5xxx_wr_vbr:
_mcf5xxx_wr_vbr:
    //move.l  4(SP),D0
    .long   0x4e7b0801      /* movec d0,VBR */
    nop
    rts

mcf5xxx_wr_macsr:
_mcf5xxx_wr_macsr:
    //move.l  4(SP),D0
    .long   0x4e7b0804      /* movec d0,MACSR */
    nop
    rts

mcf5xxx_wr_mask:
_mcf5xxx_wr_mask:
    //move.l  4(SP),D0
    .long   0x4e7b0805      /* movec d0,MASK */
    nop
    rts

mcf5xxx_wr_acc0:
_mcf5xxx_wr_acc0:
    //move.l  4(SP),D0
    .long   0x4e7b0806      /* movec d0,ACC0 */
    nop
    rts

mcf5xxx_wr_accext01:
_mcf5xxx_wr_accext01:
    //move.l  4(SP),D0
    .long   0x4e7b0807      /* movec d0,ACCEXT01 */
    nop
    rts

mcf5xxx_wr_accext23:
_mcf5xxx_wr_accext23:
    //move.l  4(SP),D0
    .long   0x4e7b0808      /* movec d0,ACCEXT23 */
    nop
    rts

mcf5xxx_wr_acc1:
_mcf5xxx_wr_acc1:
    //move.l  4(SP),D0
    .long   0x4e7b0809      /* movec d0,ACC1 */
    nop
    rts

mcf5xxx_wr_acc2:
_mcf5xxx_wr_acc2:
    //move.l  4(SP),D0
    .long   0x4e7b080A      /* movec d0,ACC2 */
    nop
    rts

mcf5xxx_wr_acc3:
_mcf5xxx_wr_acc3:
    //move.l  4(SP),D0
    .long   0x4e7b080B      /* movec d0,ACC3 */
    nop
    rts

mcf5xxx_wr_pc:
_mcf5xxx_wr_pc:
    //move.l  4(SP),D0
    .long   0x4e7b080F      /* movec d0,PC */
    nop
    rts

mcf5xxx_wr_rombar0:
_mcf5xxx_wr_rombar0:
    //move.l  4(SP),D0
    .long   0x4e7b0C00      /* movec d0,ROMBAR0 */
    nop
    rts

mcf5xxx_wr_rombar1:
_mcf5xxx_wr_rombar1:
    //move.l  4(SP),D0
    .long   0x4e7b0C01      /* movec d0,ROMBAR1 */
    nop
    rts

mcf5xxx_wr_rambar0:
_mcf5xxx_wr_rambar0:
    //move.l  4(SP),D0
    .long   0x4e7b0C04      /* movec d0,RAMBAR0 */
    nop
    rts

mcf5xxx_wr_rambar1:
_mcf5xxx_wr_rambar1:
    //move.l  4(SP),D0
    .long   0x4e7b0C05      /* movec d0,RAMBAR1 */
    nop
    rts

mcf5xxx_wr_mpcr:
_mcf5xxx_wr_mpcr:
    //move.l  4(SP),D0
    .long   0x4e7b0C0C      /* movec d0,MPCR */
    nop
    rts

mcf5xxx_wr_secmbar:
_mcf5xxx_wr_secmbar:
    //move.l  4(SP),D0
    .long   0x4e7b0C0E      /* movec d0,MBAR1   */
    nop
    rts

mcf5xxx_wr_mbar:
_mcf5xxx_wr_mbar:
    //move.l  4(SP),D0
    .long   0x4e7b0C0F      /* movec d0,MBAR0   */
    nop
    rts

/********************************************************************/

    .end
