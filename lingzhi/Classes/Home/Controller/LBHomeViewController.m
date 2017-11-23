//
//  LBHomeViewController.m
//  XianYu
//
//  Created by li  bo on 16/5/28.
//  Copyright © 2016年 li  bo. All rights reserved.
//

#import "LBHomeViewController.h"
#import "GLD_LocationHelp.h"
#import <MapKit/MapKit.h>
#import "MapNavigationManager.h"

@interface LBHomeViewController ()
{
    
    NSString * currentCity; //当前城市
}
@property (nonatomic,assign) CLLocationCoordinate2D coordinate;  //!< 要导航的坐标
@end
#define IS_SystemVersionGreaterThanEight  ([UIDevice currentDevice].systemVersion.doubleValue >= 8.0)
@implementation LBHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self startLocation];
    UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(100, 200, 50, 50)];
    [but setTitle:@"ditu" forState:UIControlStateNormal];
    [but addTarget:self action:@selector(mapNav) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:but];
    //导航到深圳火车站
    self.coordinate = CLLocationCoordinate2DMake(22.53183, 114.117206);
}

- (void)mapNav{
    
    
    [MapNavigationManager showSheetWithCity:self.title start:@"北京" end:@"上海"];
}


- (void)startLocation
{
    
    __weak typeof(self) weakSelf = self;
    [[GLD_LocationHelp sharedInstance] getLocationPlacemark:^(CLPlacemark *placemark) {
        
        if (placemark.locality) {
        
//            cityLocationView.cityButton.enabled = YES;
//            cityLocationView.locationCity = placemark.locality;
            self.title = placemark.locality;
//            if (weakSelf.Id == 0) {
//                BOOL flag = NO;
//                for (SLCity *city in weakSelf.cityModel.hotCity) {
//                    if ([placemark.locality containsString:city.name]) {
//                        weakSelf.Id = city.Id;
//                        flag = YES;
//                        break;
//                    }
//                }
//                if (!flag) {
//                    for (SLCityList *cityList in weakSelf.cityModel.list) {
//                        for (SLCity *city in cityList.citys) {
//                            if ([placemark.locality containsString:city.name]) {
//                                weakSelf.Id = city.Id;
//                                break;
//                            }
//
//                        }
//                    }
//                }
//            }
        
            
        } else {
//            cityLocationView.cityButton.enabled = NO;
            self.title = @"定位失败";
        }
        
    } status:^(CLAuthorizationStatus status) {
        
        if (status != kCLAuthorizationStatusAuthorizedAlways && status != kCLAuthorizationStatusAuthorizedWhenInUse) {
            //定位不能用
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"允许“城市列表”在您使用该应用时访问您的位置吗？" message:@"是否允许访问您的位置？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }];
            [alertController addAction:cancelAction];
            [alertController addAction:okAction];
            [weakSelf presentViewController:alertController animated:YES completion:nil];
        } else {
            
            self.title = @"定位中...";
//            cityLocationView.cityButton.enabled = NO;
        }
        
        
    } didFailWithError:^(NSError *error) {
        self.title = @"定位失败";
//        cityLocationView.cityButton.enabled = NO;
        
    }];
}


@end
