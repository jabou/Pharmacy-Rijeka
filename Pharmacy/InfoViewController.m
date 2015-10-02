//
//  InfoViewController.m
//  Pharmacy
//
//  Created by Jasmin Abou Aldan on 28/09/15.
//  Copyright © 2015 Jasmin Abou Aldan. All rights reserved.
//

#import "InfoViewController.h"
#import "DBManager.h"

@interface InfoViewController ()

@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic) BOOL isBannerVisible;
//@property (nonatomic, strong)

-(void)showAd:(ADBannerView *)banner;
@end

@implementation InfoViewController

ADBannerView *adBanner;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[self navigationController] setTitle: @"Information"];
    
    adBanner = [[ADBannerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, 320, 50)];
    adBanner.delegate = self;
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename: @"PharmacyData.sql"];
    
    _nameLabel.text = self.pharmacyName;
    NSString *query = [NSString stringWithFormat:@"SELECT address, pictureName, telefon, mail, workDay, saturday FROM pharmacy WHERE name='%@'", self.pharmacyName];
    NSArray *results = [[NSArray alloc] initWithArray: [self.dbManager loadDataFromDB: query]];
    
    for (NSArray *result in results) {
        _addressLabel.text = result[0];
        _pictureView.image = [UIImage imageNamed: result[1]];
        _telefoneLabel.text = result[2];
        _mailLabel.text = result[3];
        _workDayLabel.text = result[4];
        _saturdayLabel.text = result[5];
    }
    

    if (adBanner.subviews !=nil) {
        [self showAd:adBanner];
    }
}

-(void)bannerViewDidLoadAd:(ADBannerView *)banner{
    
    [self showAd:banner];
    
}

-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
    
    if (self.isBannerVisible) {
        
        [UIView beginAnimations:@"animateAdBannerOff" context: NULL];
        
        banner.frame = CGRectOffset(banner.frame, 0, banner.frame.size.height);
        
        [UIView commitAnimations];
        
        self.isBannerVisible = NO;
    }
}

-(void)showAd:(ADBannerView *)banner{
    if (!self.isBannerVisible) {
        
        if (adBanner.superview == nil) {
            [self.view addSubview: adBanner];
        }
        
        [UIView beginAnimations: @"animateAdBannerOn" context: NULL];
        
        banner.frame = CGRectOffset(banner.frame, 0, -banner.frame.size.height);
        
        [UIView commitAnimations];
        
        self.isBannerVisible = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
