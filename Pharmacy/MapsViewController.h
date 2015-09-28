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


@interface MapsViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;


@end
