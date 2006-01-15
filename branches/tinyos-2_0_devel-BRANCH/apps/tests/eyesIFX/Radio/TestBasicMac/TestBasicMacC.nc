/*                                  tab:4
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
/**
*
**/

#include <Timer.h>
#include <message.h>

configuration TestBasicMacC {
}
implementation {
	components MainC, TestBasicMacP
		, new AlarmMilliC() as SendTimer
		, new OSKITimerMilliC() as RxTimeoutTimer
		, LedsC
		, TDA5250RadioC
		, RandomLfsrC
		, UARTPhyP
		, PacketSerializerP
		, BasicMacP
	;

	MainC.SoftwareInit -> TDA5250RadioC.Init;
	MainC.SoftwareInit -> RandomLfsrC.Init;
	MainC.SoftwareInit -> LedsC.Init;
	MainC.SoftwareInit -> UARTPhyP.Init;
	MainC.SoftwareInit -> PacketSerializerP.Init;
	MainC.SoftwareInit -> BasicMacP.Init;
	TestBasicMacP -> MainC.Boot;

	TestBasicMacP.Random -> RandomLfsrC.Random;
	TestBasicMacP.SendTimer -> SendTimer;
	TestBasicMacP.Leds  -> LedsC;
	TestBasicMacP.Send -> PacketSerializerP.Send; 
	TestBasicMacP.Receive -> PacketSerializerP.Receive; 
	TestBasicMacP.MacSplitControl -> BasicMacP.SplitControl; 

	PacketSerializerP.RadioByteComm -> BasicMacP.RadioByteComm;
	PacketSerializerP.PhyPacketTx -> BasicMacP.PhyPacketTx;
	PacketSerializerP.PhyPacketRx -> BasicMacP.PhyPacketRx;    

	BasicMacP.TDA5250Control -> TDA5250RadioC.TDA5250Control; 
	BasicMacP.TDA5250RadioByteComm -> UARTPhyP.SerializerRadioByteComm;
	BasicMacP.TDA5250PhyPacketTx -> UARTPhyP.PhyPacketTx;
	BasicMacP.TDA5250PhyPacketRx -> UARTPhyP.PhyPacketRx;     
	BasicMacP.RxTimeoutTimer -> RxTimeoutTimer;  
	BasicMacP.RadioSplitControl -> TDA5250RadioC.SplitControl;    

	UARTPhyP.RadioByteComm -> TDA5250RadioC.RadioByteComm;    
}



