/*
* This file is part of the SDWebImage package.
* (c) Olivier Poitrey <rs@dailymotion.com>
*
* For the full copyright and license information, please view the LICENSE
* file that was distributed with this source code.
*/

#import "SDDeviceHelper.h"
#import <mach/mach.h>
#import <sys/sysctl.h>

@implementation SDDeviceHelper

+ (NSUInteger)totalMemory {
    return (NSUInteger)[[NSProcessInfo processInfo] physicalMemory];
}

+ (NSUInteger)freeMemory {
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t page_size;
    vm_statistics_data_t vm_stat;
    kern_return_t kern;
    
    kern = host_page_size(host_port, &page_size);
    if (kern != KERN_SUCCESS) return 0;
    kern = host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    if (kern != KERN_SUCCESS) return 0;
    return vm_stat.free_count * page_size;
}

+ (double)screenScale {
#if SD_VISION
    CGFloat screenScale = UITraitCollection.currentTraitCollection.displayScale;
#elif SD_WATCH
    CGFloat screenScale = [WKInterfaceDevice currentDevice].screenScale;
#elif SD_UIKIT
    CGFloat screenScale = [UIScreen mainScreen].scale;
#elif SD_MAC
    NSScreen *mainScreen = nil;
    if (@available(macOS 10.12, *)) {
        mainScreen = [NSScreen mainScreen];
    } else {
        mainScreen = [NSScreen screens].firstObject;
    }
    CGFloat screenScale = mainScreen.backingScaleFactor ?: 1.0f;
#endif
    return screenScale;
}

+ (double)screenEDR {
#if SD_VISION
    // no API to query, but it's HDR ready, from the testing, the value is 200 nits
    CGFloat EDR = 2.0;
#elif SD_WATCH
    // currently no HDR support, fallback to SDR
    CGFloat EDR = 1.0;
#elif SD_UIKIT
    CGFloat EDR = 1.0;
    if (@available(iOS 16.0, tvOS 16.0, *)) {
        UIScreen *mainScreen = [UIScreen mainScreen];
        EDR = mainScreen.currentEDRHeadroom;
    }
#elif SD_MAC
    CGFloat EDR = 1.0;
    if (@available(macOS 10.15, *)) {
        NSScreen *mainScreen = [NSScreen mainScreen];
        EDR = mainScreen.maximumExtendedDynamicRangeColorComponentValue;
    }
#endif
    return EDR;
}

+ (double)screenMaxEDR {
#if SD_VISION
    // no API to query, but it's HDR ready, from the testing, the value is 200 nits
    CGFloat maxEDR = 2.0;
#elif SD_WATCH
    // currently no HDR support, fallback to SDR
    CGFloat maxEDR = 1.0;
#elif SD_UIKIT
    CGFloat maxEDR = 1.0;
    if (@available(iOS 16.0, tvOS 16.0, *)) {
        UIScreen *mainScreen = [UIScreen mainScreen];
        maxEDR = mainScreen.potentialEDRHeadroom;
    }
#elif SD_MAC
    CGFloat maxEDR = 1.0;
    if (@available(macOS 10.15, *)) {
        NSScreen *mainScreen = [NSScreen mainScreen];
        maxEDR = mainScreen.maximumPotentialExtendedDynamicRangeColorComponentValue;
    }
#endif
    return maxEDR;
}

@end
