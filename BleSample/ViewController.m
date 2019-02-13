//
//  ViewController.m
//  BleSample
//


#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, assign) BlePeripheralManager  * blePeripheralManager;
@property (nonatomic, assign) BleCentralManager     * bleCentralManager;
@property (nonatomic, assign) BeaconManager         * beaconManager;
@property (nonatomic, assign) SettingsManager       * settings;
@property (nonatomic, assign) NSInteger               beaconIndex;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //self.blePeripheralManager = [BlePeripheralManager sharedBlePeripheralManager];
    self.bleCentralManager = [BleCentralManager sharedBleCentralManager];
    
    //initialize the beacon manager and subscribe to its events
    self.beaconManager = [BeaconManager sharedBeaconManager];
    self.beaconManager.delegate = self;
    
    //Load app settings
    self.settings = [SettingsManager sharedSettingsManager];
    
    //Display user id
    self.textUserID.text = self.settings.userID;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //Reset the beacon manager
    [[BeaconManager sharedBeaconManager] reset];
    
    //Subscribe for central manager events
    self.bleCentralManager.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIViewController * controller = segue.destinationViewController;
    
    if ([controller isKindOfClass:[PaymentViewController class]]) {
        
        ((PaymentViewController *)controller).beaconIndex   = self.beaconIndex;
        ((PaymentViewController *)controller).userID        = self.settings.userID;
        
    }
}


#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //Connect to the device at index path and get a message
    
    //Update settings
    self.settings.userID = self.textUserID.text;
    [self.settings saveSettings];
    
    //Get the index of the selected beacon
    self.beaconIndex = indexPath.row;
    
    //Open the Payment View Controller
    [self performSegueWithIdentifier:PAYMENT_VIEW_CONTROLLER_SEGUE sender:self];
}

#pragma mark --

#pragma mark UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = [[self.beaconManager getBeacons] count];
    return count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellIdentifier = @"CellIdentifier";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:nil];
    
    Beacon * beacon = [[self.beaconManager getBeacons] objectAtIndex:indexPath.row];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    if (beacon != nil) {
        cell.textLabel.text         = beacon.name;
        cell.detailTextLabel.text   = [NSString stringWithFormat:@"[Distance: %.02f meters, Major: %lu, Minor: %lu]", beacon.distance, (unsigned long)beacon.major, (unsigned long)beacon.minor];
    }
    
    return cell;
}

#pragma mark -

#pragma mark UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -

#pragma mark BeaconManagerDelegate

-(void)onBeaconsDidUpdate {
    
    //Update the table view
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

#pragma mark -

#pragma mark BleCentralManagerDelegate

-(void)onBleCentralManagerShouldTurnOnBluetooth {
    NSLog(@"%s", __FUNCTION__);
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please Turn Bluetooth On" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
    [alert show];
}

-(void)onBleCentralManagerDidConnect {
    
}

-(void)onBleCentralManagerDidDisconnect {
    
}

-(void)onBleCentralManagerDidWriteCharacteristic:(BOOL)success :(NSString *)characteristic {
    
}

-(void)onBleCentralManagerDidReadCharacteristic:(BOOL)succes :(NSString *)characteristic :(NSString *)value {
    
}

-(void)onBleCentralManagerDidWriteDescriptorForCharacteristic:(BOOL)success :(NSString *)characteristic {
    
}

#pragma mark -

@end
