//
//  ViewController.h
//  BleSample
//


#import <UIKit/UIKit.h>

#import "BlePeripheralManager.h"
#import "BleCentralManager.h"
#import "BeaconManager.h"
#import "PaymentViewController.h"
#import "SettingsManager.h"

#define PAYMENT_VIEW_CONTROLLER_SEGUE           @"PaymentViewSegue"



@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, BeaconManagerDelegate, UITextFieldDelegate, BleCentralManagerDelegate>

@property (nonatomic, assign) IBOutlet UITableView          * tableView;

@property (nonatomic, assign) IBOutlet UITextField          * textUserID;

@end
