//
//  Beacon.h
//  BleSample
//


#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

#define LEVEL       10

@interface Beacon : NSObject {
    
    double  distanceValues[LEVEL];
    int     history;
    
}

@property (nonatomic, retain) NSString              * name;
@property (nonatomic, assign) NSUInteger              major;
@property (nonatomic, assign) NSUInteger              minor;
@property (nonatomic, readonly) double                distance;
@property (nonatomic, retain) NSUUID                * identifier;

-(id)initWithIdentifier:(NSUUID *)uuid name:(NSString *)name major:(NSUInteger)major minor:(NSUInteger)minor;
-(void)updateDistance:(double)rssi :(double)txPower;

@end
