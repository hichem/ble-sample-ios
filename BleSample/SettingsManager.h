//
//  SettingsManager.h
//  BleSample
//


#import <Foundation/Foundation.h>



@interface SettingsManager : NSObject

@property (nonatomic, retain) NSString              * userID;


+(SettingsManager *)sharedSettingsManager;

-(void)saveSettings;
-(void)loadSettings;
-(void)checkDefaults;

@end
