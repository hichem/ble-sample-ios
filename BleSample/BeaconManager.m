//
//  BeaconManager.m
//  BleSample
//


#import "BeaconManager.h"


//Singleton
static BeaconManager * g_sharedBeaconManager = nil;

@interface BeaconManager()

@property (nonatomic, retain) NSMutableArray            * beaconArray;

@end

@implementation BeaconManager

+(BeaconManager *)sharedBeaconManager {
    if (g_sharedBeaconManager == nil) {
        g_sharedBeaconManager = [[BeaconManager alloc] init];
    }
    
    return g_sharedBeaconManager;
}

-(id)init {
    if ((self = [super init])) {
        self.beaconArray = [NSMutableArray array];
        self.delegate = nil;
    }
    
    return self;
}

-(NSArray *)getBeacons {
    return self.beaconArray;
}

-(void)updateBeacon:(Beacon *)beacon :(double)rssi :(double)txPower {
    
    //Check if beacon identifier already exists and add it if required
    int index = -1;
    for (Beacon * beac in self.beaconArray) {
        
        index++;
        
        if ([beac.identifier isEqual:beacon.identifier]) {
            
            //Update the beacon distance
            [beac updateDistance:rssi :txPower];
            
            //Exit
            break;
            
        }
    }
    
    if ((index == -1) || (index == self.beaconArray.count)) {
        
        index++;
        
        //Add the beacon to the list
        [self.beaconArray addObject:beacon];
        
        //Update the beacon's distance
        [(Beacon *)[self.beaconArray lastObject] updateDistance:rssi :txPower];
    }
    
    //Notify the delegate
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(onBeaconsDidUpdate)]) {
        [(NSObject *)self.delegate performSelectorOnMainThread:@selector(onBeaconsDidUpdate) withObject:nil waitUntilDone:NO];
    }
}

-(void)reset {
    //Remove all beacons
    [self.beaconArray removeAllObjects];
    
    //notify delegate
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(onBeaconsDidUpdate)]) {
        [(NSObject *)self.delegate performSelectorOnMainThread:@selector(onBeaconsDidUpdate) withObject:nil waitUntilDone:NO];
    }
}

@end
