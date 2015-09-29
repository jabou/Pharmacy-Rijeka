//
//  Alerts.m
//  Pharmacy
//
//  Created by Jasmin Abou Aldan on 28/09/15.
//  Copyright © 2015 Jasmin Abou Aldan. All rights reserved.
//

#import "Alerts.h"

@interface GPSAlert ()

+ (void)openSettings;

@end

@implementation GPSAlert

+ (void)openSettings{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}

+ (void)locationAccessError:(UIViewController *)view {
    
    if ([UIAlertController class]) {
        UIAlertController *location = [UIAlertController alertControllerWithTitle: @"GPS error" message: @"You need to allow location access" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *settings = [UIAlertAction actionWithTitle:@"Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [self openSettings];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle: @"Cancel" style:UIAlertActionStyleCancel handler:nil];
        [location addAction:settings];
        [location addAction:cancel];
        [view presentViewController:location animated:YES completion:nil];
    } else {
        UIAlertView *location = [[UIAlertView alloc] initWithTitle: @"GPS error" message: @"You need to allow location access" delegate:self cancelButtonTitle: @"OK" otherButtonTitles: nil];
        [location show];
    }
    
}

+(void)positionError:(UIViewController *)view{

    if ([UIAlertController class]) {
        UIAlertController *position = [UIAlertController alertControllerWithTitle: @"Position error" message: @"User location not obtained yet. If this is repeated, check your settings" preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction *settings = [UIAlertAction actionWithTitle: @"Settings" style: UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [self openSettings];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle: @"Cancel" style: UIAlertActionStyleCancel handler:nil];
        [position addAction:settings];
        [position addAction:cancel];
        [view presentViewController: position animated: YES completion: nil];
    } else {
        UIAlertView *location = [[UIAlertView alloc] initWithTitle: @"Position error" message: @"User location not obtained yet. If this is repeated, check your settings" delegate:self cancelButtonTitle: @"OK" otherButtonTitles: nil];
        [location show];
    }
    
    
}

@end