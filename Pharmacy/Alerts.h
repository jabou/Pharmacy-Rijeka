//
//  Alerts.h
//  Pharmacy
//
//  Created by Jasmin Abou Aldan on 28/09/15.
//  Copyright © 2015 Jasmin Abou Aldan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GPSAlert : NSObject

+ (void)locationAccessError:(UIViewController *)view;
+ (void)positionError:(UIViewController *)view;

@end
