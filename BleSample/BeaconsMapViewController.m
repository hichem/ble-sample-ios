//
//  BeaconsMapViewController.m
//  BleSample
//


#import "BeaconsMapViewController.h"

@interface BeaconsMapViewController ()

@property (nonatomic, assign) BeaconManager         * beaconManager;

@end

@implementation BeaconsMapViewController

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
    // Do any additional setup after loading the view.
    
    //Initialize the beacon manager
    self.beaconManager = [BeaconManager sharedBeaconManager];
    self.beaconManager.delegate = self;
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


-(IBAction)onListButtonPressed:(id)sender {
    NSLog(@"%s", __FUNCTION__);
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}


-(BOOL)shouldAutorotate {
    
    [self.beaconLocatorView setNeedsDisplay];
    
    return YES;
}


#pragma mark BeaconManagerDelegate

-(void)onBeaconsDidUpdate {
    //Update the locator's view beacon arrary
    self.beaconLocatorView.beaconArray = [self.beaconManager getBeacons];
    [self.beaconLocatorView setNeedsDisplay];
}

#pragma mark -


@end
