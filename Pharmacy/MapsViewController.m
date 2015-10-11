//
//  MapsViewController.m
//  Pharmacy
//
//  Created by Jasmin Abou Aldan on 28/09/15.
//  Copyright © 2015 Jasmin Abou Aldan. All rights reserved.
//

#import "MapsViewController.h"
#import "DBManager.h"
#import "AppDelegate.h"

@interface MapsViewController ()

@property (nonatomic, strong) DBManager *dbManager;

@property (nonatomic, strong) CLLocationManager *manager;
@property (nonatomic, strong) NSString *sendObject;
@property (nonatomic, strong) NSString *destination;
@property (nonatomic, strong) MKDirectionsRequest *userLoc;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonBottomConstraint;

@end

@implementation MapsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *currentVersion = [[UIDevice currentDevice] systemVersion];
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"PharmacyData.sql"];
    
    #pragma mark - Navigation bar title
    [[self navigationItem] setTitle:@"Pharmacy"];
    
    #pragma mark - Maps setup
    _mapView.mapType = MKMapTypeStandard;
    _mapView.showsUserLocation = YES;
    _mapView.showsPointsOfInterest = NO;
    _mapView.showsBuildings = NO;
    if ([currentVersion compare: @"8.0" options: NSNumericSearch] != NSOrderedAscending) {
        _mapView.pitchEnabled = YES;
    } else {
        _mapView.pitchEnabled = NO;
    }
    _mapView.delegate = self;
    
    #pragma mark - Setup location manager
    self.manager = [[CLLocationManager alloc] init];
    self.manager.delegate = self;
    self.manager.desiredAccuracy = kCLLocationAccuracyBest;
    if ([currentVersion compare: @"8.0" options: NSNumericSearch] != NSOrderedAscending) {
        [self.manager requestWhenInUseAuthorization];
    }
    [self.manager startUpdatingLocation];
    self.userLoc.source = MKMapItem.mapItemForCurrentLocation;
    
    #pragma mark Zoom on Rijena
    MKCoordinateRegion region;
    region.center.latitude = 45.335511;
    region.center.longitude = 14.427090;
    region.span = MKCoordinateSpanMake(0.15, 0.15);
    [_mapView setRegion:region animated:YES];
    
    NSString *query = [NSString stringWithFormat: @"SELECT name, address, latitude, longitude FROM pharmacy"];
    NSArray *results = [[NSArray alloc] initWithArray: [self.dbManager loadDataFromDB: query]];
    
    
    for (NSArray *result in results) {
        NSString *name = result[0];
        NSString *address = result[1];
        NSString *latitude = result[2];
        NSString *longitude = result[3];
        
        double lat = latitude.doubleValue;
        double lng = longitude.doubleValue;
        
        MKPointAnnotation *pharm = [[MKPointAnnotation alloc] init];
        pharm.title = name;
        pharm.subtitle = address;
        pharm.coordinate = CLLocationCoordinate2DMake(lat, lng);
        
        [_mapView addAnnotation:pharm];
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
        
        self.buttonBottomConstraint.constant = 60.0;
    } completion: nil];
}

-(void)adViewDidFailToLoadAd:(MPAdView *)view{
    [UIView animateWithDuration: 0.3 delay: 0.0 options: UIViewAnimationOptionCurveLinear animations:^{
        self.adView.frame = CGRectMake((self.view.bounds.size.width - MOPUB_BANNER_SIZE.width)/2, self.view.bounds.size.height, MOPUB_BANNER_SIZE.width, MOPUB_BANNER_SIZE.height);
        
        self.buttonBottomConstraint.constant = 16.0;
    } completion: nil];
}

-(UIViewController *)viewControllerForPresentingModalView {
    return self;
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    [manager stopUpdatingLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    if (mapView.userLocation == annotation) {
        return nil;
    }
    
    NSString *reuseID = @"pin";
    MKAnnotationView *pinView;
    
    if (pinView != nil) {
        
        MKAnnotationView *dequeuedView = [mapView dequeueReusableAnnotationViewWithIdentifier:reuseID];
        dequeuedView.annotation = annotation;
        pinView = dequeuedView;
        
    } else {
        pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseID];
        pinView.canShowCallout = YES;
        pinView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeInfoDark];
    }
    pinView.image = [UIImage imageNamed:@"PinImage"];
    
    return pinView;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    
    self.sendObject =  [view.annotation title];
    CLLocationDegrees latitude = view.annotation.coordinate.latitude;
    CLLocationDegrees longitude = view.annotation.coordinate.longitude;
    self.destination = [NSString stringWithFormat:@"%f,%f",latitude,longitude];
    
    [self performSegueWithIdentifier:@"pharmDetail" sender:self];
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier  isEqual: @"pharmDetail"]) {
        InfoViewController *sender = segue.destinationViewController;
        sender.pharmacyName = self.sendObject;
        sender.pharmacyCoordinates = self.destination;
        sender.userLocation = self.userLoc;
    }
    
}

- (IBAction)myLocation:(id)sender {
    
    switch ([CLLocationManager authorizationStatus]) {
        case kCLAuthorizationStatusDenied:
        case kCLAuthorizationStatusNotDetermined:
        case kCLAuthorizationStatusRestricted:
            
            [GPSAlert locationAccessError: self];
            break;
            
        default:
            if (_mapView.userLocation.location == nil) {
                [GPSAlert positionError:self];
            } else {
                MKCoordinateRegion newRegion = MKCoordinateRegionMake(_mapView.userLocation.coordinate, MKCoordinateSpanMake(0.007, 0.007));
                [_mapView setRegion:newRegion animated:YES];
            }
            break;
    }
}

@end

