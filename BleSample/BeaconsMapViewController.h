//
//  BeaconsMapViewController.h
//  BleSample
//


#import <UIKit/UIKit.h>
#import "BeaconLocatorView.h"
#import "BeaconManager.h"

@interface BeaconsMapViewController : UIViewController <BeaconManagerDelegate>

@property (nonatomic, assign) IBOutlet BeaconLocatorView        * beaconLocatorView;

-(IBAction)onListButtonPressed:(id)sender;

@end
