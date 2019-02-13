//
//  BleCentralManager.h
//  BleSample
//


#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "Beacon.h"
#import "BeaconManager.h"

#define TEST_SERVICE_UUID                   	@"624e957f-cb42-4cd6-bacc-84aeb898f69b"
#define TRANSACTION_ID_UUID                     @"e4c937b3-7f6d-41f9-b997-40c561f4453b"
#define USER_ID_UUID                            @"e4c937b3-7f6d-41f9-b997-40c561f4453c"
#define AMOUNT_UUID                             @"e4c937b3-7f6d-41f9-b997-40c561f4453d"
#define MERCHANT_UUID                           @"e4c937b3-7f6d-41f9-b997-40c561f4453e"
#define DATE_UUID                               @"e4c937b3-7f6d-41f9-b997-40c561f4453f"
#define MESSAGE_UUID                            @"e4c937b3-7f6d-41f9-b997-40c561f4451b"
#define VALIDATION_UUID                         @"e4c937b3-7f6d-41f9-b997-40c561f4451c"
#define CURRENCY_UUID                           @"e4c937b3-7f6d-41f9-b997-40c561f4451d"

#define CHARACTERISTIC_CONFIG_UUID              @"00002902-0000-1000-8000-00805f9b34fb"


@protocol BleCentralManagerDelegate <NSObject>

@required
-(void)onBleCentralManagerShouldTurnOnBluetooth;
-(void)onBleCentralManagerDidConnect;
-(void)onBleCentralManagerDidDisconnect;
-(void)onBleCentralManagerDidWriteCharacteristic:(BOOL)success :(NSString *)characteristic;
-(void)onBleCentralManagerDidReadCharacteristic:(BOOL)success :(NSString *)characteristic :(NSString *)value;
-(void)onBleCentralManagerDidWriteDescriptorForCharacteristic:(BOOL)success :(NSString *)characteristic;

@end


@interface BleCentralManager : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate>

@property (nonatomic, assign) id<BleCentralManagerDelegate> delegate;

+(BleCentralManager *)sharedBleCentralManager;
-(NSString *)getLastError;
-(BOOL)startLeScanning;
-(void)stopLeScanning;
-(BOOL)connectToPeripheralWithUUID:(NSUUID *)uuid;
-(BOOL)disconnectFromPeripheral;
-(BOOL)writeCharacteristic:(NSString *)characteristicUUID :(NSString *)value;
-(BOOL)readCharacteristic:(NSString *)characteristicUUID;
-(BOOL)registerForCharacteristicNotifications:(NSString *)characteristicUUID :(BOOL)enabled;

@end
