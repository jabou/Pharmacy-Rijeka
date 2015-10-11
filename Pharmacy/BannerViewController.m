//
//  BannerViewController.m
//  Pharmacy
//
//  Created by Jasmin Abou Aldan on 11/10/15.
//  Copyright © 2015 Jasmin Abou Aldan. All rights reserved.
//
/*
#import "BannerViewController.h"

NSString * const BannerViewActionWillBegin = @"adViewDidLoadAd";
NSString * const BannerViewActionDidFinish = @"BannerViewActionDidFinish";

@interface BannerViewController () <MPAdViewDelegate>

@property (nonatomic) MPAdView *adView;
@property (nonatomic, strong) UIViewController *contentController;
@property (nonatomic) BOOL bannerLoaded;

@end

@implementation BannerViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    
    
    [self.view addSubview: self.adView];
    [self.adView loadAd];
    
    //self.contentController = self.childViewControllers[0];
}

- (void)viewDidLayoutSubviews {
    
    CGRect contentFrame = self.view.bounds;
    CGRect bannerFrame = CGRectZero;
    
    // Ask the banner for a size that fits into the layout area we are using.
    // At this point in this method contentFrame=self.view.bounds, so we'll use that size for the layout.
    bannerFrame.size = [self.adView sizeThatFits:contentFrame.size];
    
    if (self.bannerLoaded) {
        contentFrame.size.height -= bannerFrame.size.height;
        bannerFrame.origin.y = contentFrame.size.height;
    }
    else {
        bannerFrame.origin.y = contentFrame.size.height;
    }
    self.contentController.view.frame = contentFrame;
    self.adView.frame = bannerFrame;
}

#pragma mark - ADBannerViewDelegate

-(void)adViewDidLoadAd:(MPAdView *)view{
    
    self.bannerLoaded = YES;
    
    [UIView animateWithDuration: 0.3 delay: 0.0 options: UIViewAnimationOptionCurveLinear animations:^{
        self.adView.frame = CGRectMake((self.view.bounds.size.width - MOPUB_BANNER_SIZE.width)/2, self.view.bounds.size.height - MOPUB_BANNER_SIZE.height, MOPUB_BANNER_SIZE.width, MOPUB_BANNER_SIZE.height);
        
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];

        //self.buttonBottomConstraint.constant = 60.0;
    } completion: nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:BannerViewActionWillBegin object:self];

}

-(void)adViewDidFailToLoadAd:(MPAdView *)view{
    
    self.bannerLoaded = NO;
    
    [UIView animateWithDuration: 0.3 delay: 0.0 options: UIViewAnimationOptionCurveLinear animations:^{
        self.adView.frame = CGRectMake((self.view.bounds.size.width - MOPUB_BANNER_SIZE.width)/2, self.view.bounds.size.height, MOPUB_BANNER_SIZE.width, MOPUB_BANNER_SIZE.height);
        
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];

        //self.buttonBottomConstraint.constant = 16.0;
    } completion: nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:BannerViewActionDidFinish object:self];

}

-(UIViewController *)viewControllerForPresentingModalView{
    return self;
}


@end
*/