//
//  WxHookSimulateLocationViewController.m
//  LingLi
//
//  Created by AQY on 2018/3/29.
//  Copyright © 2018年 LingLi. All rights reserved.
//

#import "WxHookApplication.h"

#import "WxHookSimulateLocationViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface WxHookSimulateLocationViewController ()
<MKMapViewDelegate>

@property (nonatomic, strong) UIView * locationView;
@property (nonatomic, strong) MKMapView * mapView;

@property (nonatomic, strong) UIButton * userLocationBtn;

@property (nonatomic, assign) CLLocationCoordinate2D currentSelectedCoordinate;
@end

@implementation WxHookSimulateLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"模拟定位";
    
    self.mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.mapView];
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    
    self.locationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 13, 13)];
    self.locationView.backgroundColor = [UIColor blueColor];
    self.locationView.center = self.mapView.center;
    self.locationView.layer.cornerRadius = 6.5;
    self.locationView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.locationView.layer.borderWidth = 2.0;
    [self.view addSubview:self.locationView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneClick:)];
    
    self.userLocationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.userLocationBtn setTitle:@"当前位置" forState:UIControlStateNormal];
    self.userLocationBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    self.userLocationBtn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    self.userLocationBtn.frame = CGRectMake(10, 70, 80, 35);
    [self.userLocationBtn addTarget:self action:@selector(userLocationBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.userLocationBtn];
    
    self.currentSelectedCoordinate = [WxHookApplication sharedInstance].simulateLocationCoordinate;
    if ([WxHookApplication sharedInstance].simulateLocation) {
        [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(self.currentSelectedCoordinate, 1000, 1000) animated:YES];
    }
}

- (void)userLocationBtnClick:(UIButton *)sender {
    [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(self.mapView.userLocation.coordinate, 1000, 1000) animated:YES];
}

- (void)doneClick:(UIBarButtonItem *)sender {
    CLLocationCoordinate2D coordinate = [self.mapView convertPoint:self.locationView.center toCoordinateFromView:self.mapView];
    [WxHookApplication sharedInstance].simulateLocationCoordinate = coordinate;
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.mapView removeFromSuperview];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    mapView.userTrackingMode = MKUserTrackingModeNone;
}

@end
