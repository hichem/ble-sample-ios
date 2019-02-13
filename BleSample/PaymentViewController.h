//
//  PaymentViewController.h
//  BleSample
//


#import <UIKit/UIKit.h>

#import "BleCentralManager.h"

@interface PaymentViewController : UIViewController <BleCentralManagerDelegate, UIAlertViewDelegate>


@property (nonatomic, assign) IBOutlet UIButton                 * button0;
@property (nonatomic, assign) IBOutlet UIButton                 * button1;
@property (nonatomic, assign) IBOutlet UIButton                 * button2;
@property (nonatomic, assign) IBOutlet UIButton                 * button3;
@property (nonatomic, assign) IBOutlet UIButton                 * button4;
@property (nonatomic, assign) IBOutlet UIButton                 * button5;
@property (nonatomic, assign) IBOutlet UIButton                 * button6;
@property (nonatomic, assign) IBOutlet UIButton                 * button7;
@property (nonatomic, assign) IBOutlet UIButton                 * button8;
@property (nonatomic, assign) IBOutlet UIButton                 * button9;
@property (nonatomic, assign) IBOutlet UIButton                 * buttonClear;
@property (nonatomic, assign) IBOutlet UIButton                 * buttonCancel;
@property (nonatomic, assign) IBOutlet UIButton                 * buttonAccept;


@property (nonatomic, assign) IBOutlet UITextField              * pinText0;
@property (nonatomic, assign) IBOutlet UITextField              * pinText1;
@property (nonatomic, assign) IBOutlet UITextField              * pinText2;
@property (nonatomic, assign) IBOutlet UITextField              * pinText3;

@property (nonatomic, assign) IBOutlet UILabel                  * textMerchant;
@property (nonatomic, assign) IBOutlet UILabel                  * textAmount;
@property (nonatomic, assign) IBOutlet UILabel                  * textTransactionID;
@property (nonatomic, assign) IBOutlet UILabel                  * textCurrency;
@property (nonatomic, assign) IBOutlet UILabel                  * textDate;


@property (nonatomic, retain) NSString                          * amount;
@property (nonatomic, retain) NSString                          * merchant;
@property (nonatomic, retain) NSString                          * transactionID;
@property (nonatomic, retain) NSString                          * currency;
@property (nonatomic, retain) NSString                          * date;
@property (nonatomic, retain) NSString                          * thankYouMessage;

@property (nonatomic, assign) NSInteger                           beaconIndex;
@property (nonatomic, retain) NSString                          * userID;

-(IBAction)onNumberButtonPressed:(id)sender;
-(IBAction)acceptTransaction:(id)sender;
-(IBAction)cancelTransaction:(id)sender;
-(IBAction)clear:(id)sender;

-(void)displayTransactionInfo;


@end
