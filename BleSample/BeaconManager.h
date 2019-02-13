//
//  BeaconManager.h
//  BleSample
//

#import <Foundation/Foundation.h>
#import "Beacon.h"



@protocol BeaconManagerDelegate <NSObject>

-(void)onBeaconsDidUpdate;

@end



@interface BeaconManager : NSObject


@property (nonatomic, assign) id<BeaconManagerDelegate>         delegate;


+(BeaconManager *)sharedBeaconManager;
-(NSArray *)getBeacons;
-(void)updateBeacon:(Beacon *)beacon :(double)rssi :(double)txPower;
-(void)reset;

@end
