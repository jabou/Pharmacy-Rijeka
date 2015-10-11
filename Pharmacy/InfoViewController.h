//
//  InfoViewController.h
//  Pharmacy
//
//  Created by Jasmin Abou Aldan on 28/09/15.
//  Copyright © 2015 Jasmin Abou Aldan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MPAdView.h"


@interface InfoViewController : UIViewController <UIAlertViewDelegate, MPAdViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *pictureView;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *telefoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *mailLabel;
@property (weak, nonatomic) IBOutlet UILabel *workDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *saturdayLabel;
@property (nonatomic) MPAdView *adView;

@property NSString* pharmacyName;
@property NSString* pharmacyCoordinates;
@property MKDirectionsRequest* userLocation;

- (IBAction)startNavigation:(id)sender;
- (IBAction)starCall:(id)sender;
- (IBAction)sendMail:(id)sender;

@end
