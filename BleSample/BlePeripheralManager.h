//
//  BlePeripheralManager.h
//  BleSample
//


#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>


#define TEST_SERVICE_UUID                   @"624e957f-cb42-4cd6-bacc-84aeb898f69b"
#define TRANSACTION_ID_UUID                     @"e4c937b3-7f6d-41f9-b997-40c561f4453b"
#define USER_ID_UUID                            @"e4c937b3-7f6d-41f9-b997-40c561f4453c"


@interface BlePeripheralManager : NSObject <CBPeripheralManagerDelegate>


+(BlePeripheralManager *)sharedBlePeripheralManager;
-(NSString *)getLastError;

@end
