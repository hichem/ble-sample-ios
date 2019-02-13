//
//  SettingsManager.m
//  BleSample
//


#import "SettingsManager.h"

static SettingsManager * g_sharedSettingsManager = nil;


//Default value
#define DEFAULT_USER_ID                     @"12345"


@implementation SettingsManager


+(SettingsManager *)sharedSettingsManager {
    if (g_sharedSettingsManager == nil) {
        g_sharedSettingsManager = [[SettingsManager alloc] init];
    }
    return g_sharedSettingsManager;
}


-(id)init {
    if ((self = [super init])) {
        [self loadSettings];
    }
    return self;
}


-(void)loadSettings {
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    
    //Dump User Defaults
    NSDictionary *bundleInfo = [[NSBundle mainBundle] infoDictionary];
    NSString *bundleId = [bundleInfo objectForKey: @"CFBundleIdentifier"];
    
    NSUserDefaults *appUserDefaults = [[NSUserDefaults alloc] init];
    NSLog(@"Start dumping userDefaults for %@", bundleId);
    NSLog(@"userDefaults dump: %@", [appUserDefaults persistentDomainForName: bundleId]);
    NSLog(@"Finished dumping userDefaults for %@", bundleId);
    
    //Load the user defaults
    self.userID                 = [userDefaults stringForKey:@"user_id"];
    
    [self checkDefaults];
}

-(void)checkDefaults {
    if ((self.userID == nil) || ([self.userID isEqualToString:@""])) {
        self.userID = DEFAULT_USER_ID;
    }
}

-(void)saveSettings {
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    
    //Save the user defaults
    [userDefaults setObject:self.userID forKey:@"user_id"];
}

@end
