//
//  InfoViewController.m
//  Pharmacy
//
//  Created by Jasmin Abou Aldan on 28/09/15.
//  Copyright © 2015 Jasmin Abou Aldan. All rights reserved.
//

#import "InfoViewController.h"
#import "DBManager.h"
#import "AppDelegate.h"

@interface InfoViewController ()

@property (nonatomic, strong) DBManager *dbManager;

@property (nonatomic, strong) NSString *telNumber;
@property (nonatomic, strong) UIAlertView *callMessage;
@property (nonatomic, strong) NSString *mailAddress;
@property (nonatomic, strong) UIAlertView *mailMessage;
@property (nonatomic, strong) UIAlertView *startNavigation;

-(void)provideDirections:(NSString *) dest;

@end

@implementation InfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[self navigationController] setTitle: @"Information"];
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename: @"PharmacyData.sql"];
    
    _nameLabel.text = self.pharmacyName;
    NSString *query = [NSString stringWithFormat:@"SELECT address, pictureName, telefon, mail, workDay, saturday FROM pharmacy WHERE name='%@'", self.pharmacyName];
    NSArray *results = [[NSArray alloc] initWithArray: [self.dbManager loadDataFromDB: query]];
    
    for (NSArray *result in results) {
        
        self.telNumber = result[2];
        self.mailAddress = result[3];
        
        _addressLabel.text = result[0];
        _pictureView.image = [UIImage imageNamed: result[1]];
        
        _telefoneLabel.text = self.telNumber;
        
        _mailLabel.text = self.mailAddress;
        _workDayLabel.text = result[4];
        _saturdayLabel.text = result[5];
    }
}

-(AppDelegate *) appdelegate{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

-(void)viewWillAppear:(BOOL)animated{
    _adView = [[self appdelegate] adView];
    _adView.delegate = self;
    _adView.frame = CGRectMake((self.view.bounds.size.width - MOPUB_BANNER_SIZE.width)/2, self.view.bounds.size.height, MOPUB_BANNER_SIZE.width, MOPUB_BANNER_SIZE.height);
    [self.view addSubview: _adView];
    [self.adView loadAd];
}

-(void)viewWillDisappear:(BOOL)animated{
    self.adView.delegate = nil;
    self.adView = nil;
    [self.adView removeFromSuperview];
}

-(void)adViewDidLoadAd:(MPAdView *)view{
    [UIView animateWithDuration: 0.3 delay: 0.0 options: UIViewAnimationOptionCurveLinear animations:^{
        self.adView.frame = CGRectMake((self.view.bounds.size.width - MOPUB_BANNER_SIZE.width)/2, self.view.bounds.size.height - MOPUB_BANNER_SIZE.height, MOPUB_BANNER_SIZE.width, MOPUB_BANNER_SIZE.height);
    } completion: nil];
}

-(void)adViewDidFailToLoadAd:(MPAdView *)view{
    [UIView animateWithDuration: 0.3 delay: 0.0 options: UIViewAnimationOptionCurveLinear animations:^{
        self.adView.frame = CGRectMake((self.view.bounds.size.width - MOPUB_BANNER_SIZE.width)/2, self.view.bounds.size.height, MOPUB_BANNER_SIZE.width, MOPUB_BANNER_SIZE.height);
    } completion: nil];
}

-(UIViewController *)viewControllerForPresentingModalView {
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startNavigation:(id)sender {
    
    if ([UIAlertController class]) {
        UIAlertController *startNavigation = [UIAlertController alertControllerWithTitle: @"Start navigation" message: @"Would you like to start navigatin?" preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction *start = [UIAlertAction actionWithTitle: @"Yes" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self provideDirections: self.pharmacyCoordinates];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle: @"No" style: UIAlertActionStyleCancel handler: nil];
        [startNavigation addAction: start];
        [startNavigation addAction: cancel];
        [self presentViewController: startNavigation animated: YES completion: nil];
    } else {
        self.startNavigation = [[UIAlertView alloc] initWithTitle: @"Start navigation" message: @"Would you like to start navigatin?" delegate: self cancelButtonTitle: @"No" otherButtonTitles: @"Yes", nil];
        [self.startNavigation show];
    }
    
}

- (IBAction)starCall:(id)sender{
    
    NSString *telMessage = [NSString stringWithFormat: @"Would you like to call the number:\n%@",self.telNumber];
    NSString *callPhone = [NSString stringWithFormat:@"tel://%@",self.telNumber];

    if ([UIAlertController class]) {
        UIAlertController *callMessage = [UIAlertController alertControllerWithTitle: @"Call Pharmacy" message: telMessage preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction *call = [UIAlertAction actionWithTitle: @"Call" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [[UIApplication sharedApplication] openURL: [NSURL URLWithString: callPhone]];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle: @"Cancel" style: UIAlertActionStyleCancel handler: nil];
        [callMessage addAction: call];
        [callMessage addAction: cancel];
        [self presentViewController: callMessage animated: YES completion: nil];
    } else {
        self.callMessage = [[UIAlertView alloc] initWithTitle: @"Call Pharmacy" message: telMessage delegate: self cancelButtonTitle: @"Cancel" otherButtonTitles: @"Call", nil];
        [self.callMessage show];
    }
    
}

- (IBAction)sendMail:(id)sender{
    
    NSString *mailMessage = [NSString stringWithFormat: @"Would you like to send an email to:\n%@",self.mailAddress];
    NSString *sendMail = [NSString stringWithFormat:@"mailto:%@",self.mailAddress];
    
    if ([self.mailAddress isEqual: @"no data"]) {
        
        if ([UIAlertController class]) {
            UIAlertController *callMessage = [UIAlertController alertControllerWithTitle: @"Email Pharmacy" message: @"Selected pharmacy does not have an email address" preferredStyle: UIAlertControllerStyleAlert];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle: @"Ok" style: UIAlertActionStyleCancel handler: nil];
            [callMessage addAction: cancel];
            [self presentViewController: callMessage animated: YES completion: nil];
        } else {
            self.mailMessage = [[UIAlertView alloc] initWithTitle: @"Email Pharmacy" message: @"Selected pharmacy does not have an email address" delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
            [self.mailMessage show];
        }
        
    } else {
        
        if ([UIAlertController class]) {
            UIAlertController *callMessage = [UIAlertController alertControllerWithTitle: @"Email Pharmacy" message: mailMessage preferredStyle: UIAlertControllerStyleAlert];
            UIAlertAction *call = [UIAlertAction actionWithTitle: @"Send" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [[UIApplication sharedApplication] openURL: [NSURL URLWithString: sendMail]];
            }];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle: @"Cancel" style: UIAlertActionStyleCancel handler: nil];
            [callMessage addAction: call];
            [callMessage addAction: cancel];
            [self presentViewController: callMessage animated: YES completion: nil];
        } else {
            self.mailMessage = [[UIAlertView alloc] initWithTitle: @"Email Pharmacy" message: mailMessage delegate: self cancelButtonTitle: @"Cancel" otherButtonTitles: @"Send", nil];
            [self.mailMessage show];
        }
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSString *callPhone = [NSString stringWithFormat:@"tel://%@",self.telNumber];
    NSString *sendMail = [NSString stringWithFormat:@"mailto:%@",self.mailAddress];

    if ([alertView isEqual: self.callMessage]) {
        if (buttonIndex == 1) {
            [[UIApplication sharedApplication] openURL: [NSURL URLWithString: callPhone]];
        }
    }
    else if ([alertView isEqual: self.mailMessage]){
        if (buttonIndex == 1) {
            [[UIApplication sharedApplication] openURL: [NSURL URLWithString: sendMail]];
        }
    }
    else if ([alertView isEqual: self.startNavigation]){
        if (buttonIndex == 1) {
            [self provideDirections: self.pharmacyCoordinates];
        }
    }
}

-(void)provideDirections:(NSString *)dest{
    
    //NSString *destination = dest;
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    
    [geoCoder geocodeAddressString: dest completionHandler:^(NSArray<CLPlacemark *> *placemarks, NSError *error) {
        
        if (error != nil) {
            //handle error
        } else {
            
            MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
            request.source = [MKMapItem mapItemForCurrentLocation];
            
            //Convert corelocation destination to mapkit placemark
            CLPlacemark *placemark = placemarks.firstObject;
            CLLocationCoordinate2D destinationCoordinates = placemark.location.coordinate;
            
            //get placemark of destination address
            MKPlacemark *destination = [[MKPlacemark alloc] initWithCoordinate: destinationCoordinates addressDictionary: nil];
            request.destination = [[MKMapItem alloc] initWithPlacemark: destination];
            
            //set transportation method to any
            request.transportType = MKDirectionsTransportTypeAny;
            
            //get direction
            MKDirections *directions = [[MKDirections alloc] initWithRequest: request];
            
            [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
                

                NSDictionary *launchOptions = @{
                                                MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeKey,
                                                MKLaunchOptionsMapTypeKey:[NSNumber numberWithInteger: MKMapTypeStandard]
                                                };
                NSArray<MKMapItem *> *items = @[response.destination];
                [MKMapItem openMapsWithItems: items launchOptions: launchOptions];
            }];
        }
    }];
    
}

@end





