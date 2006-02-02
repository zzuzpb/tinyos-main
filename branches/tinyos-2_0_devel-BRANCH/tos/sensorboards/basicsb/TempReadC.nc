/* $Id: TempReadC.nc,v 1.1.2.1 2006-02-02 00:13:46 idgay Exp $
 * Copyright (c) 2006 Intel Corporation
 * All rights reserved.
 *
 * This file is distributed under the terms in the attached INTEL-LICENSE     
 * file. If you do not find these files, copies can be found by writing to
 * Intel Research Berkeley, 2150 Shattuck Avenue, Suite 1300, Berkeley, CA, 
 * 94704.  Attention:  Intel License Inquiry.
 */
/**
 * Thermistor of the basicsb sensor board.
 * 
 * @author David Gay
 */

#include "basicsb.h"

generic configuration TempReadC() {
  provides interface Read<uint16_t>;
}
implementation {
  components TempReadP, TempDeviceP, new AdcReadClientC();

  enum {
    RESID = unique(UQ_TEMPDEVICE),
  };

  Read = TempReadP.Read[RESID];
  
  TempReadP.ActualRead[RESID] -> AdcReadClientC;
  TempReadP.Resource[RESID] -> TempDeviceP.Resource[RESID];

  AdcReadClientC.Atm128AdcConfig -> TempDeviceP;
}
