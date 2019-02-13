//
//  BleManager.m
//  BleSample
//

#import "BlePeripheralManager.h"

//Singeton instance
static BlePeripheralManager * g_sharedBleManager = nil;


@interface BlePeripheralManager()

-(BOOL)initializeBleServices;
-(NSDictionary *)getAdvertisementData;
-(BOOL)advertize;

@property (nonatomic, retain) CBPeripheralManager       * peripheralManager;
@property (nonatomic, retain) CBMutableService          * testService;
@property (nonatomic, retain) CBUUID                    * testServiceUUID;
@property (nonatomic, retain) CBUUID                    * transactionIdUUID;
@property (nonatomic, retain) CBUUID                    * userIdUUID;
@property (nonatomic, retain) CBMutableCharacteristic   * characteristicTransactionID;
@property (nonatomic, retain) CBMutableCharacteristic   * characteristicUserID;
@property (nonatomic, retain) NSString                  * lastError;

@end



@implementation BlePeripheralManager


+(BlePeripheralManager *)sharedBlePeripheralManager {
    if (g_sharedBleManager == nil) {
        g_sharedBleManager = [[BlePeripheralManager alloc] init];
    }
    
    return g_sharedBleManager;
}


-(id)init {
    if ((self = [super init])) {
        //Initialize the peripheral manager
        self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
    }
    
    return self;
}

-(NSString *)getLastError {
    return self.lastError;
}


-(BOOL)initializeBleServices {
    NSLog(@"%s", __FUNCTION__);
    
    BOOL success = YES;
    
    if (self.peripheralManager == nil) {
        
        self.lastError = @"Failed to initialize the Ble Peripheral Manager";
        NSLog(@"%s [Error: %@]", __FUNCTION__, self.lastError);
        success = NO;
        
    } else {
        
        //Setup Service & Characteristics
        self.testServiceUUID    	= [CBUUID UUIDWithString:TEST_SERVICE_UUID];
        self.transactionIdUUID      = [CBUUID UUIDWithString:TRANSACTION_ID_UUID];
        self.userIdUUID             = [CBUUID UUIDWithString:USER_ID_UUID];
        
        NSString * sampleTransactionIdValue = @"Hi Hichem!";
        self.characteristicTransactionID = [[CBMutableCharacteristic alloc] initWithType:self.transactionIdUUID properties:CBCharacteristicPropertyRead value:[NSData dataWithBytes:[sampleTransactionIdValue UTF8String] length:[sampleTransactionIdValue length]] permissions:CBAttributePermissionsReadable];
        self.characteristicUserID = [[CBMutableCharacteristic alloc] initWithType:self.userIdUUID properties:CBCharacteristicPropertyWrite|CBCharacteristicPropertyRead value:nil permissions:CBAttributePermissionsWriteable];
        
        self.testService = [[CBMutableService alloc] initWithType:self.testServiceUUID primary:YES];
        self.testService.characteristics = @[self.characteristicTransactionID, self.characteristicUserID];
        
        //Publish the service / add it to the service database
        [self.peripheralManager addService:self.testService];
        
        //Set advertisement data
    }
    
    return success;
}


-(NSDictionary *)getAdvertisementData {
    NSLog(@"%s", __FUNCTION__);
    
    NSMutableDictionary * advertisement = [NSMutableDictionary dictionary];
    
    //Add the published service UUID
    [advertisement setValue:@[self.testService.UUID] forKey:CBAdvertisementDataServiceUUIDsKey];
    
    //Add the Manufacturer Data - Custom Data
    char advData[] = {
        //Length & Type Manufacturer Data
        0x00,
        0xFF,
        
        //Measured Tx Power
        0xBF,
        
        //User ID - 6 bytes
        0x06,
        0x05,
        0x04,
        0x03,
        0x02,
        0x01
    };
    
    [advertisement setValue:[NSData dataWithBytes:advData length:sizeof(advData)] forKey:CBAdvertisementDataManufacturerDataKey];
    
    return advertisement;
}


-(BOOL)advertize {
    NSLog(@"%s", __FUNCTION__);
    
    BOOL success = YES;
    
    //Initialize the Ble Services
    success = [self initializeBleServices];
    
    if (success) {
        //Advertize
        [self.peripheralManager startAdvertising:@{CBAdvertisementDataServiceUUIDsKey : @[self.testService.UUID]}];
        
        //By HB - Advertisement data containing Manufacturer key are not permitted for now
        //[self.peripheralManager startAdvertising:[self getAdvertisementData]];
    }
    
    return success;
}


#pragma mark CBPeripheralManagerDelegate

-(void)peripheralManager:(CBPeripheralManager *)peripheral didAddService:(CBService *)service error:(NSError *)error {
    if (error) {
        self.lastError = [error localizedDescription];
        NSLog(@"%s [Error: %@]", __FUNCTION__, self.lastError);
    }
}

-(void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error {
    if (error) {
        self.lastError = [error localizedDescription];
        NSLog(@"%s [Error: %@]", __FUNCTION__, self.lastError);
    }
}

-(void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveReadRequest:(CBATTRequest *)request {
    NSLog(@"%s", __FUNCTION__);
    
    if ([request.characteristic.UUID isEqual:self.transactionIdUUID]) {
        NSLog(@"%s Central Device just read Transaction ID", __FUNCTION__);
        
        if (request.offset > self.characteristicTransactionID.value.length) {
            
            self.lastError = @"Invalid Value Offset";
            NSLog(@"%s [Error: %@]", __FUNCTION__, self.lastError);
            [self.peripheralManager respondToRequest:request withResult:CBATTErrorInvalidOffset];
            
        } else {
            //Write the value to the central & Return success
            request.value = [self.characteristicTransactionID.value subdataWithRange:NSMakeRange(request.offset, self.characteristicTransactionID.value.length - request.offset)];
            [self.peripheralManager respondToRequest:request withResult:CBATTErrorSuccess];
        }
    } else {
        [self.peripheralManager respondToRequest:request withResult:CBATTErrorReadNotPermitted];
    }
}

-(void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveWriteRequests:(NSArray *)requests {
    NSLog(@"%s", __FUNCTION__);
    
    for (CBATTRequest * request in requests) {
        if ([request.characteristic.UUID isEqual:self.userIdUUID]) {
            NSLog(@"%s Central Device just wrote on User ID Characteristic", __FUNCTION__);
            
            if (request.offset > self.characteristicUserID.value.length) {
                
                self.lastError = @"Invalid Value Offset";
                NSLog(@"%s [Error: %@]", __FUNCTION__, self.lastError);
                [self.peripheralManager respondToRequest:request withResult:CBATTErrorInvalidOffset];
                return;
                
            } else {
                self.characteristicUserID.value = request.value;
            }
        } else {
            [self.peripheralManager respondToRequest:request withResult:CBATTErrorWriteNotPermitted ];
        }
    }
    [self.peripheralManager respondToRequest:[requests objectAtIndex:0] withResult:CBATTErrorSuccess];
}


-(void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    NSLog(@"%s", __FUNCTION__);
    
    //Start advertizing
    [self advertize];
}



#pragma mark -


@end
