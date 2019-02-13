//
//  PaymentViewController.m
//  BleSample
//


#import "PaymentViewController.h"
#import "MBProgressHUD.h"

#define ALERT_PAYMENT_DONE      1


@interface PaymentViewController ()

@property (nonatomic, retain) NSMutableString           * pinString;
@property (nonatomic, retain) MBProgressHUD             * progressDialog;
@property (nonatomic, assign) BleCentralManager         * centralManager;

@end


@implementation PaymentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    UIImage *buttonImage = [[UIImage imageNamed:@"whiteButton.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    UIImage *buttonImageHighlight = [[UIImage imageNamed:@"whiteButtonHighlight.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    
    [self.button0 setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self.button0 setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
    [self.button1 setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self.button1 setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
    [self.button2 setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self.button2 setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
    [self.button3 setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self.button3 setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
    [self.button4 setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self.button4 setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
    [self.button5 setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self.button5 setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
    [self.button6 setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self.button6 setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
    [self.button7 setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self.button7 setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
    [self.button8 setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self.button8 setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
    [self.button9 setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self.button9 setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
    
    buttonImage = [[UIImage imageNamed:@"tanButton.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    buttonImageHighlight = [[UIImage imageNamed:@"tanButtonHighlight.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    [self.buttonClear setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self.buttonClear setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
    
    buttonImage = [[UIImage imageNamed:@"orangeButton.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    buttonImageHighlight = [[UIImage imageNamed:@"orangeButtonHighlight.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    [self.buttonCancel setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self.buttonCancel setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
    
    buttonImage = [[UIImage imageNamed:@"greenButton.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    buttonImageHighlight = [[UIImage imageNamed:@"greenButtonHighlight.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    [self.buttonAccept setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self.buttonAccept setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
    
    self.button0.clipsToBounds = YES;
    self.button1.clipsToBounds = YES;
    self.button2.clipsToBounds = YES;
    self.button3.clipsToBounds = YES;
    self.button4.clipsToBounds = YES;
    self.button5.clipsToBounds = YES;
    self.button6.clipsToBounds = YES;
    self.button7.clipsToBounds = YES;
    self.button8.clipsToBounds = YES;
    self.button9.clipsToBounds = YES;
    
    CALayer * layer = nil;
    layer = self.button0.layer;
    [layer setCornerRadius:2];
    layer = self.button1.layer;
    [layer setCornerRadius:2];
    layer = self.button2.layer;
    [layer setCornerRadius:2];
    layer = self.button3.layer;
    [layer setCornerRadius:2];
    layer = self.button4.layer;
    [layer setCornerRadius:2];
    layer = self.button5.layer;
    [layer setCornerRadius:2];
    layer = self.button6.layer;
    [layer setCornerRadius:2];
    layer = self.button7.layer;
    [layer setCornerRadius:2];
    layer = self.button8.layer;
    [layer setCornerRadius:2];
    layer = self.button9.layer;
    [layer setCornerRadius:2];
    
    self.pinString = [NSMutableString stringWithString:@""];
    
    //Initialize the central manager
    self.centralManager = [BleCentralManager sharedBleCentralManager];
    self.centralManager.delegate = self;
    
    //Connect to the selected beacon
    Beacon * selectedBeacon = [[[BeaconManager sharedBeaconManager] getBeacons] objectAtIndex:self.beaconIndex];
    [self.centralManager connectToPeripheralWithUUID:selectedBeacon.identifier];
    
    //Display a progress message
    [self showProgressDialog:@"" :@"Connecting to the payment terminal. Please wait..."];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



#pragma mark Helper Methods

-(void)showProgressDialog:(NSString *)title :(NSString *)message {
    NSLog(@"%s [Title: %@, Message: %@]", __FUNCTION__, title, message);
    
    if (self.progressDialog != nil) {
        [self.progressDialog removeFromSuperview];
    }
    self.progressDialog = [[MBProgressHUD alloc] initWithView:self.view];
    
    [self.view addSubview:self.progressDialog];
    
    self.progressDialog.labelText = message;
    
    [self.progressDialog show:YES];
}

-(void)dismissProgressDialog {
    NSLog(@"%s", __FUNCTION__);
    
    if (self.progressDialog) {
        [self.progressDialog removeFromSuperview];
        self.progressDialog = nil;
    }
}

-(void)showAlertDialog:(NSString *)title :(NSString *)message {
    NSLog(@"%s [Title: %@, Message: %@]", __FUNCTION__, title, message);
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
    
    [alert show];
}

-(void)showAlertDialog:(NSString *)title :(NSString *)message :(NSInteger)requestCode {
    NSLog(@"%s [Title: %@, Message: %@]", __FUNCTION__, title, message);
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
    alert.tag = requestCode;
    
    [alert show];
}

#pragma mark -


#pragma mark UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    switch (alertView.tag) {
        case ALERT_PAYMENT_DONE:
            
            //Dismiss view controller
            [self dismissViewControllerAnimated:YES completion:nil];
            
            break;
            
        default:
            break;
    }
}

#pragma mark -


#pragma mark UI Methods

-(IBAction)onNumberButtonPressed:(id)sender {
    NSString * digit = [NSString stringWithString:((UIButton *)sender).titleLabel.text];
    
    if ([self.pinString length] < 4) {
        [self.pinString appendString:digit];
        
        switch ([self.pinString length]) {
            case 1:
                self.pinText0.text = [self.pinString substringWithRange:NSMakeRange(0, 1)];
                break;
            case 2:
                self.pinText0.text = [self.pinString substringWithRange:NSMakeRange(0, 1)];
                self.pinText1.text = [self.pinString substringWithRange:NSMakeRange(1, 1)];
                break;
            case 3:
                self.pinText0.text = [self.pinString substringWithRange:NSMakeRange(0, 1)];
                self.pinText1.text = [self.pinString substringWithRange:NSMakeRange(1, 1)];
                self.pinText2.text = [self.pinString substringWithRange:NSMakeRange(2, 1)];
                break;
            case 4:
                self.pinText0.text = [self.pinString substringWithRange:NSMakeRange(0, 1)];
                self.pinText1.text = [self.pinString substringWithRange:NSMakeRange(1, 1)];
                self.pinText2.text = [self.pinString substringWithRange:NSMakeRange(2, 1)];
                self.pinText3.text = [self.pinString substringWithRange:NSMakeRange(3, 1)];
                break;
                
            default:
                break;
        }
    }
}

-(IBAction)acceptTransaction:(id)sender {
    //[self showProgressAnimation:@"Payment in progress..."];
    
    //Check the length of the Pin code
    if ([self.pinString length] != 4) {
        
        //Display Error
        [self showAlertDialog:@"Error" :@"Invalid Pin Code"];
        
        //Reset the pin
        [self clear:nil];
        
    } else {
        
        //Show progress message
        [self showProgressDialog:@"Validation" :@"Please wait until the transaction is processed..."];
        
        //accept the payment
        [self.centralManager writeCharacteristic:VALIDATION_UUID :@"1"];
    }
}


-(IBAction)cancelTransaction:(id)sender {
    //[self showProgressAnimation:@"Payment in progress..."];
    
    //Check the length of the Pin code
    if ([self.pinString length] != 4) {
        
        //Display Error
        [self showAlertDialog:@"Error" :@"Invalid Pin Code"];
        
        //Reset the pin
        [self clear:nil];
        
    } else {
        //process the payment
        //Show progress message
        [self showProgressDialog:@"Cancelling" :@"Please wait until the transaction is cancelled..."];
        
        //accept the payment
        [self.centralManager writeCharacteristic:VALIDATION_UUID :@"2"];
    }
}

-(IBAction)clear:(id)sender {
    NSLog(@"%s", __FUNCTION__);
    
    self.pinText0.text = @"";
    self.pinText1.text = @"";
    self.pinText2.text = @"";
    self.pinText3.text = @"";
    self.pinString = [NSMutableString stringWithString:@""];
}


-(void)displayTransactionInfo {
    NSLog(@"%s", __FUNCTION__);
    
    self.textAmount.text        = [NSString stringWithFormat:@"%@ €", self.amount];
    self.textMerchant.text      = self.merchant;
    self.textTransactionID.text = self.transactionID;
    self.textCurrency.text      = self.currency;
    self.textDate.text          = self.date;
}



#pragma mark -


#pragma mark BleCentralManagerDelegate

-(void)onBleCentralManagerShouldTurnOnBluetooth {
    NSLog(@"%s", __FUNCTION__);
    
}

-(void)onBleCentralManagerDidConnect {
    NSLog(@"%s", __FUNCTION__);
    
    //Subscribe for notifications on the transaction characteristic
    [self.centralManager registerForCharacteristicNotifications:TRANSACTION_ID_UUID :YES];
}

-(void)onBleCentralManagerDidDisconnect {
    NSLog(@"%s", __FUNCTION__);
    
}

-(void)onBleCentralManagerDidWriteCharacteristic:(BOOL)success :(NSString *)characteristic {
    NSLog(@"%s [Characteristic UUID: %@, Success: %@]", __FUNCTION__, characteristic, ((success) ? @"YES" : @"NO"));
    
}

-(void)onBleCentralManagerDidReadCharacteristic:(BOOL)success :(NSString *)characteristic :(NSString *)value {
    NSLog(@"%s [Characteristic UUID: %@, Success: %@, Value: %@]", __FUNCTION__, characteristic, ((success) ? @"YES" : @"NO"), value);
    
    if (success == YES) {
        
        //Check for characteristic with notifications
        if ([characteristic caseInsensitiveCompare:TRANSACTION_ID_UUID] == NSOrderedSame) {
            
            //Get the transaction id - this means the transaction information is available and that we can start to retrieve them
            self.transactionID = value;
            
            //Start by reading the amount
            [self.centralManager readCharacteristic:AMOUNT_UUID];
            
            //Exit the function
            return;
            
        } else if ([characteristic caseInsensitiveCompare:MESSAGE_UUID] == NSOrderedSame) {
            
            //Get the thank you message
            self.thankYouMessage = value;
            
            //Display the thank you message
            [self showAlertDialog:@"Transaction Done" :self.thankYouMessage :ALERT_PAYMENT_DONE];
            
            //Exit the function
            return;
        }
        
        //Check for non notified characteristics
        if ([characteristic caseInsensitiveCompare:AMOUNT_UUID] == NSOrderedSame) {
            
            //Get the amount
            self.amount = value;
            
            //Start reading the currency
            [self.centralManager readCharacteristic:CURRENCY_UUID];
            
        } else if ([characteristic caseInsensitiveCompare:CURRENCY_UUID] == NSOrderedSame) {
            
            //Get the currency
            self.currency = value;
            
            //Start reading the date
            [self.centralManager readCharacteristic:DATE_UUID];
            
        } else if ([characteristic caseInsensitiveCompare:DATE_UUID] == NSOrderedSame) {
            
            //Get the date
            self.date = value;
            
            //Start reading the merchant name
            [self.centralManager readCharacteristic:MERCHANT_UUID];
            
        } else if ([characteristic caseInsensitiveCompare:MERCHANT_UUID] == NSOrderedSame) {
            
            //Get the merchant name
            self.merchant = value;
        }
        
        if ((self.amount != nil) && (self.currency != nil) && (self.date != nil) && (self.merchant != nil)) {
            
            //Dismiss prorgess dialog
            [self dismissProgressDialog];
            
            //Display transaction info
            [self displayTransactionInfo];
        }
        
    } else {
        
        //Dismiss progress dialog
        [self dismissProgressDialog];
        
        //Show error message
        [self showAlertDialog:@"Error" :@"Failed to retrieve value of characteristic"];
        
    }
    
}

-(void)onBleCentralManagerDidWriteDescriptorForCharacteristic:(BOOL)success :(NSString *)characteristic {
    NSLog(@"%s [Characteristic UUID: %@, Success: %@]", __FUNCTION__, characteristic, ((success) ? @"YES" : @"NO"));
    
    if ([characteristic caseInsensitiveCompare:TRANSACTION_ID_UUID] == NSOrderedSame) {
        
        //Subscribe for notifications of the message characteristic
        [self.centralManager registerForCharacteristicNotifications:MESSAGE_UUID :YES];
        
    } else if ([characteristic caseInsensitiveCompare:MESSAGE_UUID] == NSOrderedSame) {
        
        //Send the user id
        [self.centralManager writeCharacteristic:USER_ID_UUID :self.userID];
    }
}

#pragma mark -



@end
