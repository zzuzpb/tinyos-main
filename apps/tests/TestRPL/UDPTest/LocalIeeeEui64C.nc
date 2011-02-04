#include "PlatformIeeeEui64.h"

module LocalIeeeEui64C {
  provides interface LocalIeeeEui64;
} 
implementation {

  command ieee_eui64_t LocalIeeeEui64.getId() {
    ieee_eui64_t eui;

    eui.data[0] = IEEE_EUI64_COMPANY_ID_0;
    eui.data[1] = IEEE_EUI64_COMPANY_ID_1;
    eui.data[2] = IEEE_EUI64_COMPANY_ID_2;

    // 16 bits of the ID is generated by software
    // could be used for hardware model id and revision, for example
    eui.data[3] = IEEE_EUI64_SERIAL_ID_0;
    eui.data[4] = IEEE_EUI64_SERIAL_ID_1;

    eui.data[5] = 0;
    //eui.data[4] = TOS_NODE_ID << 8;
    //eui.data[5] = TOS_NODE_ID;
    eui.data[6] = TOS_NODE_ID << 8;
    eui.data[7] = TOS_NODE_ID;
    return eui;
  }
}
