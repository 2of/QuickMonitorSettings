// I genunely dont know much about macos here... this is all from my friend mr gpt.....
// essentially get display info & SN for unique str

import Foundation
import Cocoa
import CoreGraphics
import IOKit
import IOKit.graphics

struct DisplayUtils {
    
    
    
    
    // Returns a friendly, unique name for a given NSScreen
    static func friendlyName(for screen: NSScreen) -> String {
        guard let screenNumber = screen.deviceDescription[NSDeviceDescriptionKey("NSScreenNumber")] as? CGDirectDisplayID else {
            return screen.localizedName // fallback
        }
        
        // Try to get IOKit info for vendor/product
        if let service = IOServicePortFromDisplayID(screenID: screenNumber) {
            let vendorName = IORegistryEntryCreateCFProperty(service, "DisplayVendorName" as CFString, kCFAllocatorDefault, 0)?.takeRetainedValue() as? String
            let productName = IORegistryEntryCreateCFProperty(service, "DisplayProductName" as CFString, kCFAllocatorDefault, 0)?.takeRetainedValue() as? String
            let serialNumber = CGDisplaySerialNumber(screenNumber)
            
            IOObjectRelease(service)
            
            if let vendor = vendorName, let product = productName {
                return "\(vendor) \(product) (S/N \(serialNumber))"
            }
        }
        
        // Fallback: localizedName + serial
        return "\(screen.localizedName) (S/N \(CGDisplaySerialNumber(screenNumber)))"
    }
    
    private static func IOServicePortFromDisplayID(screenID: CGDirectDisplayID) -> io_service_t? {
        var iter: io_iterator_t = 0
        let matching = IOServiceMatching("IODisplayConnect")
        let result = IOServiceGetMatchingServices(kIOMainPortDefault, matching, &iter)
        if result != KERN_SUCCESS {
            return nil
        }
        
        var service: io_service_t?
        var serv: io_object_t = 1
        while serv != 0 {
            serv = IOIteratorNext(iter)
            let info = IODisplayCreateInfoDictionary(serv, UInt32(kIODisplayOnlyPreferredName)).takeRetainedValue() as NSDictionary
            let vendorID = info[kDisplayVendorID] as? UInt32
            let productID = info[kDisplayProductID] as? UInt32
            if vendorID != nil && productID != nil {
                if CGDisplayVendorNumber(screenID) == vendorID && CGDisplayModelNumber(screenID) == productID {
                    service = serv
                    break
                }
            }
        }
        IOObjectRelease(iter)
        return service
    }

}
//
//  DisplayUtils.swift
//  QuickMonitorSettings
//
//  Created by Noah King on 26/11/2025.
//

