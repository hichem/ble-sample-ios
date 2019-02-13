//
//  BleCentralManager.m
//  BleSample
//


#import "BleCentralManager.h"

//Singleton
static BleCentralManager * g_sharedBleCentralManager = nil;


//Private Interface
@interface BleCentralManager()

@property (nonatomic, retain) NSString                  * lastError;
@property (nonatomic, retain) CBCentralManager          * centralManager;
@property (nonatomic, retain) CBPeripheral              * currentPeripheral;
@property (nonatomic, assign) BOOL                        isConnected;
@property (nonatomic, retain) CBService                 * testService;
@property (nonatomic, retain) NSArray                   * filteredServices;

//Characteristics
@property (nonatomic, retain) NSMutableDictionary       * testServiceCharacteristics;
/*
@property (nonatomic, retain) CBCharacteristic          * characteristicTransactionID;
@property (nonatomic, retain) CBCharacteristic          * characteristicUserID;
@property (nonatomic, retain) CBCharacteristic          * characteristicAmount;
@property (nonatomic, retain) CBCharacteristic          * characteristicMerchant;
@property (nonatomic, retain) CBCharacteristic          * characteristicDate;
@property (nonatomic, retain) CBCharacteristic          * characteristicMessage;
@property (nonatomic, retain) CBCharacteristic          * characteristicValidation;
@property (nonatomic, retain) CBCharacteristic          * characteristicCurrency;
*/

-(void)setServiceDiscoveryFilters;

@end



@implementation BleCentralManager


+(BleCentralManager *)sharedBleCentralManager {
    if (g_sharedBleCentralManager == nil) {
        g_sharedBleCentralManager = [[BleCentralManager alloc] init];
    }
    
    return g_sharedBleCentralManager;
}


-(id)init {
    if ((self = [super init])) {
        //Initialize the central manager
        dispatch_queue_t centralQueue = dispatch_queue_create("mycentralqueue", DISPATCH_QUEUE_SERIAL);
        //self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:centralQueue];
        NSDictionary *options = @{CBCentralManagerOptionShowPowerAlertKey:@YES};
        self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:options];
        
        //Variable Initialization
        self.isConnected = NO;
        self.testServiceCharacteristics = [NSMutableDictionary dictionary];
    }
    
    return self;
}


-(NSString *)getLastError {
    return self.lastError;
}


-(void)setServiceDiscoveryFilters {
    NSLog(@"%s", __FUNCTION__);
    
    self.filteredServices = @[[CBUUID UUIDWithString:TEST_SERVICE_UUID]];
}


-(BOOL)startLeScanning {
    NSLog(@"%s", __FUNCTION__);
    
    BOOL success = YES;
    
    if (self.centralManager != nil) {
        
        //Set the scanning filter
        [self setServiceDiscoveryFilters];
        
        //Start service discovery
        [self.centralManager scanForPeripheralsWithServices:self.filteredServices options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @YES}];
        
    } else {
        
        self.lastError = @"Failed to initialize Central";
        NSLog(@"%s [Error: %@]", __FUNCTION__, self.lastError);
        
    }
    
    return success;
}

-(void)stopLeScanning {
    NSLog(@"%s", __FUNCTION__);
    
    [self.centralManager stopScan];
}


#pragma mark CBCentralManagerDelegate

-(void)centralManagerDidUpdateState:(CBCentralManager *)central {
    NSLog(@"%s", __FUNCTION__);
    
    if (central.state == CBCentralManagerStatePoweredOn) {
        [self startLeScanning];
    } else {
        self.lastError = @"Bluetooth Not Powered On";
        NSLog(@"%s [Error: %@]", __FUNCTION__, self.lastError);
        
        if ((self.delegate != nil) && ([self.delegate respondsToSelector:@selector(onBleCentralManagerShouldTurnOnBluetooth)])) {
            [self.delegate onBleCentralManagerShouldTurnOnBluetooth];
        }
    }
}

-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    
    if ([RSSI doubleValue] > 0) {
        return;
    }
    
    //parse the advertisement data
    if (advertisementData != nil) {
        NSData * advData = (NSData *)[advertisementData objectForKey:CBAdvertisementDataManufacturerDataKey];
        //NSLog(@"%s [Manufacturer Data: %@]", __FUNCTION__, advData);
        
        if (advData != nil) {
            NSUInteger len = [advData length];
            
            if (len >= 5) {
                const char * data = [advData bytes];
                
                uint16_t major = ntohs(*((uint16_t*)&data[0]));
                uint16_t minor = ntohs(*((uint16_t*)&data[2]));
                int8_t txPower = data[4];
                
                Beacon * beacon = [[Beacon alloc] initWithIdentifier:peripheral.identifier name:peripheral.name major:major minor:minor];
                [[BeaconManager sharedBeaconManager] updateBeacon:beacon :[RSSI doubleValue] :txPower];
                
                //NSLog(@"%s [Major: %d, Minor: %d, TX Power: %d]", __FUNCTION__, major, minor, txPower);
                
            } else {
                self.lastError = @"Invalid Beacon Format";
                NSLog(@"%s [Error: %@]", __FUNCTION__, self.lastError);
            }
        }
    }
}


-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    NSLog(@"%s", __FUNCTION__);
    
    //Set the connection state to connected
    self.isConnected = YES;
    
    //Discover BLE TEST Service
    [self.currentPeripheral discoverServices:@[[CBUUID UUIDWithString:TEST_SERVICE_UUID]]];
}

-(void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    NSLog(@"%s", __FUNCTION__);
    
    if (error != nil) {
        self.lastError = error.localizedDescription;
        NSLog(@"%s [Error: %@]", __FUNCTION__, self.lastError);
        
        self.isConnected = NO;
    }
    
    //notify delegate
    if ((self.delegate != nil) && ([self.delegate respondsToSelector:@selector(onBleCentralManagerDidDisconnect)])) {
        [self.delegate onBleCentralManagerDidDisconnect];
    }
}

#pragma mark -


#pragma mark CBPeripheralDelegate

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    NSLog(@"%s", __FUNCTION__);
    
    for (CBService * service in peripheral.services) {
        if ([service.UUID.UUIDString caseInsensitiveCompare:TEST_SERVICE_UUID] == NSOrderedSame) {
            self.testService = service;
            
            //We are not interested in other services
            break;
        }
    }
    
    //Discover BLE service's characteristics
    if (self.testService != nil) {
        [self.currentPeripheral discoverCharacteristics:nil forService:self.testService];
    }
}

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    NSLog(@"%s", __FUNCTION__);
    
    //Retrive Characteristics of BLE service
    NSString * uuid = nil;
    if (service == self.testService) {
        for (CBCharacteristic * characteristic in service.characteristics) {
            
            uuid = characteristic.UUID.UUIDString;
            
            [self.testServiceCharacteristics setObject:characteristic forKey:[uuid lowercaseString]];
            
            /*
            if ([uuid isEqualToString:TRANSACTION_ID_UUID]) {
                self.characteristicTransactionID = characteristic;
            } else if ([uuid isEqualToString:USER_ID_UUID]) {
                self.characteristicUserID = characteristic;
            } else if ([uuid isEqualToString:AMOUNT_UUID]) {
                self.characteristicAmount = characteristic;
            } else if ([uuid isEqualToString:MERCHANT_UUID]) {
                self.characteristicMerchant = characteristic;
            } else if ([uuid isEqualToString:DATE_UUID]) {
                self.characteristicDate = characteristic;
            } else if ([uuid isEqualToString:MESSAGE_UUID]) {
                self.characteristicMessage = characteristic;
            } else if ([uuid isEqualToString:VALIDATION_UUID]) {
                self.characteristicValidation = characteristic;
            } else if ([uuid isEqualToString:CURRENCY_UUID]) {
                self.characteristicCurrency = characteristic;
            }
            */
        }
        
        //notify delegate
        if ((self.delegate != nil) && ([self.delegate respondsToSelector:@selector(onBleCentralManagerDidConnect)])) {
            [self.delegate onBleCentralManagerDidConnect];
        }
    }
}

-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    NSLog(@"%s [Characteristic UUID: %@]", __FUNCTION__, characteristic.UUID.UUIDString);
    
    if (error != nil) {
        
        self.lastError = error.localizedDescription;
        NSLog(@"%s [Error: %@]", __FUNCTION__, self.lastError);
        
        if ((self.delegate != nil) && ([self.delegate respondsToSelector:@selector(onBleCentralManagerDidWriteCharacteristic::)])) {
            [self.delegate onBleCentralManagerDidWriteCharacteristic:NO :characteristic.UUID.UUIDString];
        }
        
    } else {
        
        if ((self.delegate != nil) && ([self.delegate respondsToSelector:@selector(onBleCentralManagerDidWriteCharacteristic::)])) {
            [self.delegate onBleCentralManagerDidWriteCharacteristic:YES :characteristic.UUID.UUIDString];
        }
    }
}

-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    NSLog(@"%s [Characteristic UUID: %@]", __FUNCTION__, characteristic.UUID.UUIDString);
    
    if (error != nil) {
        
        self.lastError = error.localizedDescription;
        NSLog(@"%s [Error: %@]", __FUNCTION__, self.lastError);
        
        if ((self.delegate != nil) && ([self.delegate respondsToSelector:@selector(onBleCentralManagerDidReadCharacteristic:::)])) {
            [self.delegate onBleCentralManagerDidReadCharacteristic:NO :characteristic.UUID.UUIDString :nil];
        }
        
    } else {
        
        //Get the new value
        NSData * rawValue = characteristic.value;
        NSString * value = [[NSString alloc] initWithBytes:rawValue.bytes length:rawValue.length encoding:NSASCIIStringEncoding];
        
        if ((self.delegate != nil) && ([self.delegate respondsToSelector:@selector(onBleCentralManagerDidReadCharacteristic:::)])) {
            [self.delegate onBleCentralManagerDidReadCharacteristic:YES :characteristic.UUID.UUIDString :value];
        }
    }
}

-(void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    NSLog(@"%s [Characteristic UUID: %@]", __FUNCTION__, characteristic.UUID.UUIDString);
    
    if (error != nil) {
        self.lastError = error.localizedDescription;
        NSLog(@"%s [Error: %@]", __FUNCTION__, self.lastError);
        
        if ((self.delegate != nil) && ([self.delegate respondsToSelector:@selector(onBleCentralManagerDidWriteDescriptorForCharacteristic::)])) {
            [self.delegate onBleCentralManagerDidWriteDescriptorForCharacteristic:NO :characteristic.UUID.UUIDString];
        }
    } else {
        if ((self.delegate != nil) && ([self.delegate respondsToSelector:@selector(onBleCentralManagerDidWriteDescriptorForCharacteristic::)])) {
            [self.delegate onBleCentralManagerDidWriteDescriptorForCharacteristic:YES :characteristic.UUID.UUIDString];
        }
    }
}

#pragma mark -



#pragma mark BleCentralManager API

-(BOOL)connectToPeripheralWithUUID:(NSUUID *)uuid {
    NSLog(@"%s", __FUNCTION__);
    
    BOOL result = YES;
    
    NSArray * beacons = [self.centralManager retrievePeripheralsWithIdentifiers:@[uuid]];
    
    if ([beacons count] > 0) {
        
        //Save the peripheral instance
        self.currentPeripheral = [beacons objectAtIndex:0];
        
        //Subscribe for peripheral events
        self.currentPeripheral.delegate = self;
    }
    if (self.currentPeripheral != nil) {
        [self.centralManager connectPeripheral:self.currentPeripheral options:nil];
        
    }
    
    return result;
}


-(BOOL)disconnectFromPeripheral {
    NSLog(@"%s", __FUNCTION__);
    
    BOOL result = YES;
    
    [self.centralManager cancelPeripheralConnection:self.currentPeripheral];
    
    self.isConnected = NO;
    
    return result;
}

-(BOOL)writeCharacteristic:(NSString *)characteristicUUID :(NSString *)value {
    NSLog(@"%s [Characteristic UUID: %@, Value: %@]", __FUNCTION__, characteristicUUID, value);
    
    BOOL result = YES;
    
    if (self.isConnected) {
        
        CBCharacteristic * characteristic = [self.testServiceCharacteristics valueForKey:[characteristicUUID lowercaseString]];
        
        if (characteristic != nil) {
            
            [self.currentPeripheral writeValue:[NSData dataWithBytes:[value UTF8String] length:[value length]] forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
            
        } else {
            self.lastError = [NSString stringWithFormat:@"Invalid Characteristic: %@", characteristicUUID];
            NSLog(@"%s [Error: %@]", __FUNCTION__, self.lastError);
            result = NO;
        }
        
    } else {
        self.lastError = @"Peripheral not connected";
        NSLog(@"%s [Error: %@]", __FUNCTION__, self.lastError);
        result = NO;
    }
    
    return result;
}

-(BOOL)readCharacteristic:(NSString *)characteristicUUID {
    NSLog(@"%s [Characteristic UUID: %@]", __FUNCTION__, characteristicUUID);
    
    BOOL result = YES;
    
    if (self.isConnected) {
        
        CBCharacteristic * characteristic = [self.testServiceCharacteristics valueForKey:[characteristicUUID lowercaseString]];
        
        if (characteristic != nil) {
            
            [self.currentPeripheral readValueForCharacteristic:characteristic];
            
        } else {
            self.lastError = [NSString stringWithFormat:@"Invalid Characteristic: %@", characteristicUUID];
            NSLog(@"%s [Error: %@]", __FUNCTION__, self.lastError);
            result = NO;
        }
        
    } else {
        self.lastError = @"Peripheral not connected";
        NSLog(@"%s [Error: %@]", __FUNCTION__, self.lastError);
        result = NO;
    }
    
    return result;
}

-(BOOL)registerForCharacteristicNotifications:(NSString *)characteristicUUID :(BOOL)enabled {
    NSLog(@"%s [Characteristic UUID: %@, Enabled: %@]", __FUNCTION__, characteristicUUID, ((enabled == YES) ? @"YES" : @"NO"));
    
    BOOL result = YES;
    
    if (self.isConnected) {
        
        CBCharacteristic * characteristic = [self.testServiceCharacteristics valueForKey:[characteristicUUID lowercaseString]];
        
        if (characteristic != nil) {
            
            [self.currentPeripheral setNotifyValue:enabled forCharacteristic:characteristic];
            
        } else {
            self.lastError = [NSString stringWithFormat:@"Invalid Characteristic: %@", characteristicUUID];
            NSLog(@"%s [Error: %@]", __FUNCTION__, self.lastError);
            result = NO;
        }
        
    } else {
        self.lastError = @"Peripheral not connected";
        NSLog(@"%s [Error: %@]", __FUNCTION__, self.lastError);
        result = NO;
    }
    
    return result;
}


#pragma mark -



@end
