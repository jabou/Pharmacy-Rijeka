//
//  MapsViewController.m
//  Pharmacy
//
//  Created by Jasmin Abou Aldan on 28/09/15.
//  Copyright © 2015 Jasmin Abou Aldan. All rights reserved.
//

#import "MapsViewController.h"


@interface MapsViewController ()

@end

@implementation MapsViewController

CLLocationManager *manager;
NSString *sendObject;
NSString *destination;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *currentVersion = [[UIDevice currentDevice] systemVersion];
    
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
    manager = [[CLLocationManager alloc] init];
    manager.delegate = self;
    manager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if ([currentVersion compare: @"8.0" options: NSNumericSearch] != NSOrderedAscending) {
        [manager requestWhenInUseAuthorization];
    }
    [manager startUpdatingLocation];
    
    #pragma mark Zoom on Rijena
    MKCoordinateRegion region;
    region.center.latitude = 45.335511;
    region.center.longitude = 14.427090;
    region.span = MKCoordinateSpanMake(0.15, 0.15);
    [_mapView setRegion:region animated:YES];
    
    NSArray *pharmacies = [NSArray arrayWithObjects: @"Ljekarne Čabrijan 1;Prilepići 1;45.349502;14.388666",@"Ljekarna Kušen 2;Franje Čandeka 46;45.340412;14.405827",@"Ljekarna N. Malnar i T. Ćosić;Kvaternikova 65B;45.320792;14.474923",@"Ljekarna Rijeka 1;Braće Monjac 13;45.344628;14.386661",@"Ljekarna Rijeka 2;Vukovarska 96A;45.339929;14.418552",@"Ljekarna Rijeka 3;Cambierieva 11;45.331944;14.430393",@"Ljekarna Ana Pantelić;Osječka 40;45.339281;14.428985",@"Ljekarna Ankica Huljev;Mihanovićeva 53;45.323735;14.466740",@"Ljekarna Brajda;Krešimirova 24;45.330215;14.432900",@"Ljekarna Centar;Riva 18;45.327494;14.438023",@"Ljekarna D. Kopajtić Borovčak;Tizianova 5C;45.333855;14.437343",@"Ljekarna Kazalištu;Uljarska 3;45.325436;14.443495",@"Ljekarna KBC Rijeka 1;Krešimirova 42;45.330936;14.428522",@"Ljekarna KBC Rijeka 2;Tome Strižića 3;45.325827;14.470287",@"Ljekarna KBC Rijeka 3;Istarska 53;45.341955;14.369138",@"Ljekarna Korzo;Korzo 22;45.327217;14.441731",@"Ljekarna Marica Lulić;Krešimirova 34;45.330641;14.430143",@"Ljekarna Mazzi 1;Đ. Šporera 3;45.330641;14.430143",@"Ljekarna Mazzi 2;Srdoči 16A;45.355987;14.369922",@"Ljekarna Merica Juretić;Osječka BB;45.342983;14.423967",@"Ljekarna M. Đukić i A.M. Đukić;Slavka Krautzeka 27;45.330457;14.459160",@"Ljekarna Neda Banić;Liburnijska 2A;45.339060;14.400938",@"Ljekarna Nikša Brlić;Braće Cetina 2;45.342211;14.385447",@"Ljekarna Rijeka 5;M. Albaharija 7C;45.326795;14.441923",@"Ljekarna Rijeka 6;Istarska 6;45.340089;14.379874",@"Ljekarna Riva Boduli;Riva Boduli 7;45.324503;14.441424",@"Ljekarna Strossmayer;Petra Jurčića 2A;45.342983;14.423967",@"Ljekarna Zamet;Avelina Turka 2;45.342983;14.423967",@"Ljekarna Zorka Muvrin;Pehlin BB;45.359930;14.396429",@"Ljekarne Pablo 1;F. Belulovića 5;45.323529;14.479438",@"Ljekarne Pablo 2;Baštijanova 26;45.332758;14.442397",@"Ljekarne Prima Pharme 10;F. la. Guardia 2A;45.330640;14.434527",@"Ljekarne Prima Pharme 15;Riva Boduli 1;45.325373;14.442144",@"Ljekarne Prima Pharme 26;Cavtatska 2C;45.339639;14.415964",@"Ljekarne Prima Pharme 29;Kumičićeva 13;45.322539;14.460989",@"Ljekarne Prima Pharme 45;Cvetkov trg 1;45.353735;14.431421", nil];
    
    for (NSString *pharmacy in pharmacies) {
        NSArray *tmp = [pharmacy componentsSeparatedByString:@";"];
        NSString *name = tmp[0];
        NSString *address = tmp[1];
        NSString *latitude = tmp[2];
        NSString *longitude = tmp[3];
        
        double lat = latitude.doubleValue;
        double lng = longitude.doubleValue;
        
        MKPointAnnotation *pharm = [[MKPointAnnotation alloc] init];
        pharm.title = name;
        pharm.subtitle = address;
        pharm.coordinate = CLLocationCoordinate2DMake(lat, lng);
        
        [_mapView addAnnotation:pharm];
    }
    
    ADBannerView *iAdBannerView = [[ADBannerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, 320, 38)];
    [self.view addSubview:iAdBannerView];
    
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
    pinView.image = [UIImage imageNamed:@"pinImage"];
    
    return pinView;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    
    sendObject =  [view.annotation title];
    CLLocationDegrees latitude = view.annotation.coordinate.latitude;
    CLLocationDegrees longitude = view.annotation.coordinate.longitude;
    destination = [NSString stringWithFormat:@"%f,%f",latitude,longitude];
    
    [self performSegueWithIdentifier:@"pharmDetail" sender:self];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
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

