//
//  MapsViewController.h
//  Pharmacy
//
//  Created by Jasmin Abou Aldan on 28/09/15.
//  Copyright © 2015 Jasmin Abou Aldan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <iAd/iAd.h>
#import "Alerts.h"
#import "InfoViewController.h"


@interface MapsViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, ADBannerViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
-(IBAction)myLocation:(id)sender;


@end
