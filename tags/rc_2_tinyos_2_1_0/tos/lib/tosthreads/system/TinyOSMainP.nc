// $Id: TinyOSMainP.nc,v 1.1 2008-06-12 14:02:47 klueska Exp $

/*									tab:4
 * "Copyright (c) 2000-2003 The Regents of the University  of California.  
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
 * Copyright (c) 2002-2003 Intel Corporation
 * All rights reserved.
 *
 * This file is distributed under the terms in the attached INTEL-LICENSE     
 * file. If you do not find these files, copies can be found by writing to
 * Intel Research Berkeley, 2150 Shattuck Avenue, Suite 1300, Berkeley, CA, 
 * 94704.  Attention:  Intel License Inquiry.
 */
/*
 *
 * Authors:		Philip Levis
 * Date last modified:  $Id: TinyOSMainP.nc,v 1.1 2008-06-12 14:02:47 klueska Exp $
 *
 */

/**
 * RealMain implements the TinyOS boot sequence, as documented in TEP 107.
 *
 * @author Philip Levis
 * @author Kevin Klues <klueska@cs.stanford.edu> 
 */

module TinyOSMainP {
  provides {
    interface Boot;
    interface ThreadInfo;
  }
  uses {
    interface Boot as TinyOSBoot;
    interface TaskScheduler;
    interface Init as PlatformInit;
    interface Init as SoftwareInit;
    interface Leds;
  }
}
implementation {
  thread_t thread_info;

  event void TinyOSBoot.booted() {
    atomic {
      /*  Initialize all of the very hardware specific stuff, such
	  as CPU settings, counters, etc. After the hardware is ready,
	  initialize the requisite software components and start
	  execution. */
	  platform_bootstrap();
    
	  // First, initialize the Scheduler so components can post tasks.
	  call TaskScheduler.init(); 
    
	  /* Initialize the platform. Then spin on the Scheduler, passing
	   * FALSE so it will not put the system to sleep if there are no
	   * more tasks; if no tasks remain, continue on to software
	   * initialization */
	  call PlatformInit.init();
	  while (call TaskScheduler.runNextTask());
	  
	  /* Initialize software components.Then spin on the Scheduler,
	   * passing FALSE so it will not put the system to sleep if there
	   * are no more tasks; if no tasks remain, the system has booted
	   * successfully.*/
	  call SoftwareInit.init(); 
	  while (call TaskScheduler.runNextTask());
    }

    /* Enable interrupts now that system is ready. */
    __nesc_enable_interrupt();

    signal Boot.booted();

    /* Spin in the TaskScheduler */
    call TaskScheduler.taskLoop();
    
  }

  async command thread_t* ThreadInfo.get() {
    return &thread_info;
  }

  default command error_t PlatformInit.init() { return SUCCESS; }
  default command error_t SoftwareInit.init() { return SUCCESS; }
  default event void Boot.booted() { }
}

