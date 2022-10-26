//
//  NXViewController.m
//  TencentLBS
//
//  Created by 804258952@qq.com on 06/21/2021.
//  Copyright (c) 2021 804258952@qq.com. All rights reserved.
//

#import "NXViewController.h"
#import <TencentLBS/TencentLBSLocationManager.h>
#import <Masonry/Masonry.h>

@interface NXViewController ()<TencentLBSLocationManagerDelegate>

@property (nonatomic, strong) TencentLBSLocationManager * locationManager;

@property (nonatomic, strong) UILabel *displayLabel;

@property (nonatomic, strong) UIButton *locBtn;
@end

@implementation NXViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.displayLabel = [[UILabel alloc] init];
    self.displayLabel.numberOfLines = 0;
    self.displayLabel.textColor =  [UIColor redColor];
    self.displayLabel.backgroundColor = UIColor.cyanColor;
    [self.view addSubview:self.displayLabel];
    
    [self.displayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
        make.width.lessThanOrEqualTo(self.view.mas_width).multipliedBy(0.5);
    }];
    
    self.locBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.locBtn setTitle:@"点我定位" forState:UIControlStateNormal];
    self.locBtn.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:self.locBtn];
    [self.locBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.equalTo(self.displayLabel.mas_bottom).offset(20);
        make.height.mas_equalTo(50);
    }];
    [self.locBtn addTarget:self action:@selector(startSingleLocation) forControlEvents:UIControlEventTouchUpInside];
	// Do any additional setup after loading the view, typically from a nib.
    [self configurationManger];
}

- (void)configurationManger {
    self.locationManager = [[TencentLBSLocationManager alloc] init];
    [self.locationManager setDelegate: self];
    [self.locationManager setApiKey:@"your api key"];
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    [self.locationManager setRequestLevel:TencentLBSRequestLevelName];
    CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
    if (authorizationStatus == kCLAuthorizationStatusNotDetermined) {
        [self.locationManager requestWhenInUseAuthorization];
    }
}

- (void)startSingleLocation {
    __weak typeof(self) weakSelf = self;
    [self.locationManager requestLocationWithCompletionBlock:^(TencentLBSLocation * _Nullable location, NSError * _Nullable error) {
        NSLog(@"%@, %@, %@", location.location, location.name, location.address);
        weakSelf.displayLabel.text = location.address;
    }];
}

- (void)startSerialLocation {
    //开始定位
    [self.locationManager startUpdatingLocation];
}
 
- (void)stopSerialLocation {
    //停止定位
    [self.locationManager stopUpdatingLocation];
}
 
- (void)tencentLBSLocationManager:(TencentLBSLocationManager *)manager
                 didFailWithError:(NSError *)error {
    CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
    if (authorizationStatus == kCLAuthorizationStatusDenied ||
        authorizationStatus == kCLAuthorizationStatusRestricted) {
        [self.displayLabel setText:@"定位权限没开启！"];
 
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                       message:@"定位权限未开启，是否开启？"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"是"
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction * _Nonnull action) {
            if( [[UIApplication sharedApplication]canOpenURL:
                [NSURL URLWithString:UIApplicationOpenSettingsURLString]] ) {
                [[UIApplication sharedApplication] openURL:
                    [NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }
        }]];
 
        [alert addAction:[UIAlertAction actionWithTitle:@"否"
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction * _Nonnull action) {
        }]];
 
        [self presentViewController:alert animated:true completion:nil];
 
    } else {
        [self.displayLabel setText:[NSString stringWithFormat:@"%@", error]];
    }
}
 
 
- (void)tencentLBSLocationManager:(TencentLBSLocationManager *)manager
                didUpdateLocation:(TencentLBSLocation *)location {
    //定位结果
    NSLog(@"location:%@", location.location);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
