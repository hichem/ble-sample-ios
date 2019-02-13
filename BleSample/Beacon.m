//
//  Beacon.m
//  BleSample
//


#import "Beacon.h"

@interface Beacon ()

-(double)computeDistance:(double)rssi :(double)txPower;

@end


@implementation Beacon

@synthesize distance = _distance;

-(id)init {
    if ((self = [super init])) {
        
        //Initialize the old values array - this will be used to compute the moving average of the distance
        memset(distanceValues, 0, LEVEL);
        history = 0;
        _distance = 0;
    }
    
    return self;
}

-(id)initWithIdentifier:(NSUUID *)uuid name:(NSString *)name major:(NSUInteger)major minor:(NSUInteger)minor {
    if ((self = [super init])) {
        
        self.identifier = uuid;
        self.name       = name;
        self.major      = major;
        self.minor      = minor;
        
    }
    
    return self;
}

-(void)dealloc {
    
}

-(double)computeDistance:(double)rssi :(double)txPower {
    double distance = 0;
    
    if (rssi == 0) {
        distance = -1.0;
    } else {
        double ratio = rssi/txPower;
        if (ratio < 1.0) {
            distance = pow(ratio,10);
        }
        else {
            distance =  (0.89976) * pow(ratio,7.7095) + 0.111;
        }
    }
    
    return distance;
}


-(void)updateDistance:(double)rssi :(double)txPower {
    
    //Compute new distance value
    double distance = [self computeDistance:rssi :txPower];
    
    //_distance = distance;
    
    //Update the average
    int i = 0;
    double lastAverage = distanceValues[history];
    _distance = _distance + (distance - lastAverage) / ++history;
    
    if (history == LEVEL) {
        history = LEVEL - 1;
    }
    
    for (i = 0; i < LEVEL - 1; i++) {
        distanceValues[i+1] = distanceValues[i];
    }
    distanceValues[0] = _distance;
}

@end
