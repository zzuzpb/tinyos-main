
/*
 * Copyright (c) 2004-2005 Crossbow Technology, Inc.  All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 * 
 * IN NO EVENT SHALL CROSSBOW TECHNOLOGY OR ANY OF ITS LICENSORS BE LIABLE TO 
 * ANY PARTY FOR DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL 
 * DAMAGES ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN
 * IF CROSSBOW OR ITS LICENSOR HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH 
 * DAMAGE. 
 *
 * CROSSBOW TECHNOLOGY AND ITS LICENSORS SPECIFICALLY DISCLAIM ALL WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY 
 * AND FITNESS FOR A PARTICULAR PURPOSE. THE SOFTWARE PROVIDED HEREUNDER IS 
 * ON AN "AS IS" BASIS, AND NEITHER CROSSBOW NOR ANY LICENSOR HAS ANY 
 * OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR 
 * MODIFICATIONS.
 */

/*
 * Copyright (c) 2007, Vanderbilt University
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 * 
 * IN NO EVENT SHALL THE VANDERBILT UNIVERSITY BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE VANDERBILT
 * UNIVERSITY HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * THE VANDERBILT UNIVERSITY SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE VANDERBILT UNIVERSITY HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
 *
 */

/**
 * Internal component of the HPL interface to Atmega1281 timer 1.
 *
 * @author Martin Turon <mturon@xbow.com>
 * @author Janos Sallai <janos.sallai@vanderbilt.edu>
 */

#include <Atm128Timer.h>

module HplAtm1281Timer1P
{
  provides {
    // 16-bit Timers
    interface HplAtm128Timer<uint16_t>   as Timer;
    interface HplAtm128TimerCtrl16       as TimerCtrl;
    interface HplAtm128Capture<uint16_t> as Capture;
    interface HplAtm128Compare<uint16_t> as CompareA;
    interface HplAtm128Compare<uint16_t> as CompareB;
    interface HplAtm128Compare<uint16_t> as CompareC;
  }
}
implementation
{
  //=== Read the current timer value. ===================================
  async command uint16_t Timer.get() { return TCNT1; }

  //=== Set/clear the current timer value. ==============================
  async command void Timer.set(uint16_t t) { TCNT1 = t; }

  //=== Read the current timer scale. ===================================
  async command uint8_t Timer.getScale() { return TCCR1B & 0x7; }

  //=== Turn off the timers. ============================================
  async command void Timer.off() { call Timer.setScale(AVR_CLOCK_OFF); }

  //=== Write a new timer scale. ========================================
  async command void Timer.setScale(uint8_t s)  { 
    Atm128_TCCRB_t x = (Atm128_TCCRB_t) call TimerCtrl.getControlB();
    x.bits.cs = s;
    call TimerCtrl.setControlB(x.flat);  
  }

  //=== Read the control registers. =====================================
  async command uint8_t TimerCtrl.getControlA() { 
    return TCCR1A; 
  }

  async command uint8_t TimerCtrl.getControlB() { 
    return TCCR1B; 
  }

  async command uint8_t TimerCtrl.getControlC() { 
    return TCCR1C; 
  }

  //=== Write the control registers. ====================================
  async command void TimerCtrl.setControlA( uint8_t x ) { 
    TCCR1A = x; 
  }

  async command void TimerCtrl.setControlB( uint8_t x ) { 
    TCCR1B = x; 
  }

  async command void TimerCtrl.setControlC( uint8_t x ) { 
    TCCR1C = x; 
  }

  //=== Read the interrupt mask. =====================================
  async command uint8_t TimerCtrl.getInterruptMask() { 
    return TIMSK1; 
  }

  //=== Write the interrupt mask. ====================================
  async command void TimerCtrl.setInterruptMask( uint8_t x ) { 
    TIMSK1 = x; 
  }

  //=== Read the interrupt flags. =====================================
  async command uint8_t TimerCtrl.getInterruptFlag() { 
    return TIFR1; 
  }

  //=== Write the interrupt flags. ====================================
  async command void TimerCtrl.setInterruptFlag( uint8_t x ) { 
    TIFR1 = x; 
  }

  //=== Capture 16-bit implementation. ===================================
  async command void Capture.setEdge(bool up) { WRITE_BIT(TCCR1B,ICES1, up); }

  //=== Timer 16-bit implementation. ===================================
  async command void Timer.reset()    { TIFR1 = 1 << TOV1; }
  async command void Capture.reset()  { TIFR1 = 1 << ICF1; }
  async command void CompareA.reset() { TIFR1 = 1 << OCF1A; }
  async command void CompareB.reset() { TIFR1 = 1 << OCF1B; }
  async command void CompareC.reset() { TIFR1 = 1 << OCF1C; }

  async command void Timer.start()    { SET_BIT(TIMSK1,TOIE1); }
  async command void Capture.start()  { SET_BIT(TIMSK1,ICIE1); }
  async command void CompareA.start() { SET_BIT(TIMSK1,OCIE1A); }
  async command void CompareB.start() { SET_BIT(TIMSK1,OCIE1B); }
  async command void CompareC.start() { SET_BIT(TIMSK1,OCIE1C); }

  async command void Timer.stop()    { CLR_BIT(TIMSK1,TOIE1); }
  async command void Capture.stop()  { CLR_BIT(TIMSK1,ICIE1); }
  async command void CompareA.stop() { CLR_BIT(TIMSK1,OCIE1A); }
  async command void CompareB.stop() { CLR_BIT(TIMSK1,OCIE1B); }
  async command void CompareC.stop() { CLR_BIT(TIMSK1,OCIE1C); }

  async command bool Timer.test() { 
    return ((Atm128_TIFR_t)call TimerCtrl.getInterruptFlag()).bits.tov; 
  }
  async command bool Capture.test()  { 
    return ((Atm128_TIFR_t)call TimerCtrl.getInterruptFlag()).bits.icf; 
  }
  async command bool CompareA.test() { 
    return ((Atm128_TIFR_t)call TimerCtrl.getInterruptFlag()).bits.ocfa; 
  }
  async command bool CompareB.test() { 
    return ((Atm128_TIFR_t)call TimerCtrl.getInterruptFlag()).bits.ocfb; 
  }
  async command bool CompareC.test() { 
    return ((Atm128_TIFR_t)call TimerCtrl.getInterruptFlag()).bits.ocfc; 
  }

  async command bool Timer.isOn() {
    return ((Atm128_TIMSK_t)call TimerCtrl.getInterruptMask()).bits.toie;
  }
  async command bool Capture.isOn()  {
    return ((Atm128_TIMSK_t)call TimerCtrl.getInterruptMask()).bits.icie;
  }
  async command bool CompareA.isOn() {
    return ((Atm128_TIMSK_t)call TimerCtrl.getInterruptMask()).bits.ociea;
  }
  async command bool CompareB.isOn() {
    return ((Atm128_TIMSK_t)call TimerCtrl.getInterruptMask()).bits.ocieb;
  }
  async command bool CompareC.isOn() {
    return ((Atm128_TIMSK_t)call TimerCtrl.getInterruptMask()).bits.ociec;
  }

  //=== Read the compare registers. =====================================
  async command uint16_t CompareA.get() { return OCR1A; }
  async command uint16_t CompareB.get() { return OCR1B; }
  async command uint16_t CompareC.get() { return OCR1C; }

  //=== Write the compare registers. ====================================
  async command void CompareA.set(uint16_t t) { OCR1A = t; }
  async command void CompareB.set(uint16_t t) { OCR1B = t; }
  async command void CompareC.set(uint16_t t) { OCR1C = t; }

  //=== Read the capture registers. =====================================
  async command uint16_t Capture.get() { return ICR1; }

  //=== Write the capture registers. ====================================
  async command void Capture.set(uint16_t t)  { ICR1 = t; }

  //=== Timer interrupts signals ========================================
  default async event void CompareA.fired() { }
  AVR_NONATOMIC_HANDLER(SIG_OUTPUT_COMPARE1A) {
    signal CompareA.fired();
  }
  default async event void CompareB.fired() { }
  AVR_NONATOMIC_HANDLER(SIG_OUTPUT_COMPARE1B) {
    signal CompareB.fired();
  }
  default async event void CompareC.fired() { }
  AVR_NONATOMIC_HANDLER(SIG_OUTPUT_COMPARE1C) {
    signal CompareC.fired();
  }
  default async event void Capture.captured(uint16_t time) { }
  AVR_NONATOMIC_HANDLER(SIG_INPUT_CAPTURE1) {
    signal Capture.captured(call Timer.get());
  }
  default async event void Timer.overflow() { }
  AVR_NONATOMIC_HANDLER(SIG_OVERFLOW1) {
    signal Timer.overflow();
  }
}
