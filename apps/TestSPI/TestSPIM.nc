// $Id: TestSPIM.nc,v 1.1.2.1 2005-02-25 19:36:44 jpolastre Exp $

/*									tab:4
 * "Copyright (c) 2000-2005 The Regents of the University  of California.  
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 * 
 * IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE UNIVERSITY OF
 * CALIFORNIA HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE UNIVERSITY OF CALIFORNIA HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 *
 */

/**
 **/

module TestSPIM {
  uses interface Boot;
  uses interface Leds;
  uses interface BusArbitration;
  uses interface SPIPacket;
}
implementation {

  uint8_t txdata[10];
  uint8_t rxdata[10];

  event void Boot.booted() {
    call Leds.yellowToggle();
    call BusArbitration.getBus();
    if (call SPIPacket.send(txdata, rxdata, 10) == SUCCESS)
      call Leds.redToggle();
  }

  event void SPIPacket.sendDone(uint8_t* txbuffer, uint8_t* rxbuffer, uint8_t length, error_t success) {
    call Leds.greenToggle();
    if (call SPIPacket.send(txdata, rxdata, 10) == SUCCESS)
      call Leds.redToggle();
  }

  event error_t BusArbitration.busFree() { return SUCCESS; }
}


