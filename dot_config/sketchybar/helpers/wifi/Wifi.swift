import CoreWLAN

if let iface = CWWiFiClient.shared().interface(),
   iface.powerOn() {
    
    let rssi = iface.rssiValue()
    
    if rssi == 0 {
        print("0") // Blocked by Location Services entirely or disconnected
    } else if rssi >= -60 {
        print("4")
    } else if rssi >= -70 {
        print("3")
    } else if rssi >= -80 {
        print("2")
    } else {
        print("1")
    }
} else {
    print("0") // Wi-Fi is physically turned off
}
