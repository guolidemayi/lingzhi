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
#import "GLD_CustomBut.h"
#import "GLD_HomeViewManager.h"
#import "GLD_CityListController.h"
#import "GLD_SearchController.h"
#import "GLD_MessageController.h"
#import "LBTabBarController.h"
#import "GLD_GoodsCarListController.h"
#import "iflyMSC/IFlyMSC.h"

@interface LBHomeViewController ()<IFlySpeechSynthesizerDelegate>
{
    
    NSString * currentCity; //当前城市
}
@property (nonatomic, weak)GLD_CustomBut *locationBut;

@property (nonatomic, copy)UITableView *home_table;
@property (nonatomic, strong)GLD_HomeViewManager *homeManager;
@property (nonatomic, copy)NSString *locationStr;
@property (nonatomic, strong)GLD_CustomBut *redPointBut;
@property (nonatomic, strong) UIButton *goodsCarBut;
@property (nonatomic, strong) IFlySpeechSynthesizer *iFlySpeechSynthesizer;
@end


@implementation LBHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.homeManager = [[GLD_HomeViewManager alloc]initWithTableView:self.home_table];
    //获取用户信息
    [self.homeManager fetchMainUserData];
    
    WS(weakSelf);
    self.homeManager.versonUpdate = ^{
        [weakSelf versonUpdate];
    };
    [self startLocation];
    //导航到深圳火车站
    [self setNavUi];
    
    [self.view addSubview:self.goodsCarBut];
    [self.view bringSubviewToFront:self.goodsCarBut];
//    [self toLocaAudio];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self fetchRedPointRequest];
}




- (void)toLocaAudio{
    
    [IFlySetting setLogFile:LVL_ALL];
    
    //Set whether to output log messages in Xcode console
    [IFlySetting showLogcat:YES];
    //Set the local storage path of SDK
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    [IFlySetting setLogFilePath:cachePath];
    
    //Set APPID
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",@"5e148089"];
    
    //Configure and initialize iflytek services.(This interface must been invoked in application:didFinishLaunchingWithOptions:)
    [IFlySpeechUtility createUtility:initString];
//    //获取语音合成单例
    _iFlySpeechSynthesizer = [IFlySpeechSynthesizer sharedInstance];
    //设置协议委托对象
    _iFlySpeechSynthesizer.delegate = self;
    //设置合成参数
    //设置在线工作方式
    [_iFlySpeechSynthesizer setParameter:[IFlySpeechConstant TYPE_CLOUD]
     forKey:[IFlySpeechConstant ENGINE_TYPE]];
    //设置音量，取值范围 0~100
    [_iFlySpeechSynthesizer setParameter:@"50"
    forKey: [IFlySpeechConstant VOLUME]];
    //发音人，默认为”xiaoyan”，可以设置的参数列表可参考“合成发音人列表”
    [_iFlySpeechSynthesizer setParameter:@" xiaoyan "
     forKey: [IFlySpeechConstant VOICE_NAME]];
    //保存合成文件名，如不再需要，设置为nil或者为空表示取消，默认目录位于library/cache下
    [_iFlySpeechSynthesizer setParameter:@"tts.pcm"
     forKey: [IFlySpeechConstant TTS_AUDIO_PATH]];
    
    //启动合成会话
    [_iFlySpeechSynthesizer startSpeaking: @"你好，我是科大讯飞的小燕"];
}

//合成结束
- (void) onCompleted:(IFlySpeechError *) error {

    __weak __typeof(self)weakSelf = self;
    
  
   
}
- (void) onSpeakProgress:(int) progress beginPos:(int)beginPos endPos:(int)endPos {
    
    
}
- (void)versonUpdate{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"惠汇联盟" message:@"有新的版本更新" preferredStyle:  UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/%E6%83%A0%E6%B1%87%E8%81%94%E7%9B%9F/id1332960714?mt=8"]];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)setNavUi{
    GLD_CustomBut *locationBut = [[GLD_CustomBut alloc]init];;
    self.locationBut = locationBut;
    [locationBut setTitle:@"ddddddd" forState:UIControlStateNormal];
    [locationBut setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    locationBut.frame = CGRectMake(0, 0, 50, 44);
    [locationBut image:@"更多"];
    [locationBut addTarget:self action:@selector(mapNav) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:locationBut];
    self.navigationItem.leftBarButtonItem = item;
    
    UIButton *titleBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [titleBut setTitle:@"搜索" forState:UIControlStateNormal];
    [titleBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [titleBut setImage:WTImage(@"搜索-搜索") forState:UIControlStateNormal];
    titleBut.frame = CGRectMake(0, 0, W(180), W(30));
    titleBut.layer.cornerRadius = W(15);
    titleBut.layer.masksToBounds = YES;
    [titleBut addTarget:self action:@selector(SearchCLick) forControlEvents:UIControlEventTouchUpInside];
    titleBut.backgroundColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleBut;
    
    GLD_CustomBut *rightBut = [[GLD_CustomBut alloc]init];;
    
    rightBut.frame = CGRectMake(0, 0, 50, 44);
    [rightBut image:@"站内信"];
    BOOL isComment = [[NSUserDefaults standardUserDefaults]boolForKey:@"haveCommentRedPoint"];
    if (isComment) [rightBut showRedPoint];
    self.redPointBut = rightBut;
    [rightBut addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithCustomView:rightBut];
    GLD_CustomBut *rightBut2 = [[GLD_CustomBut alloc]init];;
    rightBut2.frame = CGRectMake(0, 0, 50, 44);
    [rightBut2 image:@"扫一扫"];
    [rightBut2 addTarget:self action:@selector(rightClick2) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc]initWithCustomView:rightBut2];
//    self.navigationItem.rightBarButtonItem = item1;
    [self.navigationItem setRightBarButtonItems:@[item2,item1]];
}

- (void)showRedPointNoti{
     [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"haveCommentRedPoint"];
    [self.redPointBut showRedPoint];
}
- (void)rightClick2{
   
    [(LBTabBarController *)self.tabBarController tabBarPlusBtnClick:nil];
}
- (void)rightClick{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"haveCommentRedPoint"];
    [self.redPointBut hiddenRedPoint];
    GLD_MessageController *message = [GLD_MessageController new];
    [self.navigationController pushViewController:message animated:YES];
}
//搜索
- (void)SearchCLick{
    GLD_SearchController *searchVc = [GLD_SearchController new];
    [self.navigationController pushViewController:searchVc animated:YES];
}
//购物车
- (void)goodsCarButClick{
    GLD_GoodsCarListController *goodVc = [GLD_GoodsCarListController new];
    [self.navigationController pushViewController:goodVc animated:YES];
}
- (void)fetchRedPointRequest{
    self.NetManager = [GLD_NetworkAPIManager shareNetManager];
    GLD_APIConfiguration *config = [[GLD_APIConfiguration alloc]init];
    config.urlPath = getRedPointRequest;
    config.requestParameters = @{
                                 };
    WS(weakSelf);
    [self.NetManager dispatchDataTaskWith:config andCompletionHandler:^(NSError *error, id result) {
        if (!error) {
           
            if ([result[@"code"] integerValue] == 200) {
                BOOL isShow = [result[@"data"] boolValue];
                if (isShow) {
                    [weakSelf showRedPointNoti];
                    
                }
            }
        }else{
//            [CAToast showWithText:@"请求失败，请重试"];
        }
        
    }];
}
//城市列表
- (void)mapNav{
    WS(weakSelf);
    GLD_CityListController *cityList = [GLD_CityListController new];
    cityList.locationCity = self.locationStr;
    cityList.cityListBlock = ^(GLD_CityModel *placemar) {
        [weakSelf.locationBut title:placemar.area_name];
//        weakSelf.locationStr = name;
        [AppDelegate shareDelegate].placemark = placemar;
        [weakSelf.homeManager fetchMainData];
    };
    
//    cityList.cityListBlock = ^(NSString *name) {
//        [weakSelf.locationBut title:name];
//    };
    [self.navigationController pushViewController:cityList animated:YES];

}


- (UITableView *)home_table{
    if (!_home_table) {
        UITableView *table = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [self.view addSubview:table];
        [table mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        _home_table = table;
    }
    return _home_table;
}

//定位
- (void)startLocation
{
    
    __weak typeof(self) weakSelf = self;
    [[GLD_LocationHelp sharedInstance] getLocationPlacemark:^(CLPlacemark *placemark) {
        
        if (placemark.locality) {

            [weakSelf.locationBut title:placemark.locality];
            weakSelf.locationStr = placemark.locality;
            GLD_CityModel *placemar = [GLD_CityModel new];
            placemar.area_name = placemark.locality;
            placemar.lat = placemark.location.coordinate.latitude;
            placemar.lon = placemark.location.coordinate.longitude;
            [AppDelegate shareDelegate].placemark = placemar;
            [AppDelegate shareDelegate].userAddress = [NSString stringWithFormat:@"%@%@%@",placemark.locality,placemark.subLocality,placemark.name];
           
//            CLLocationCoordinate2D
        } else {
            weakSelf.locationStr = @"定位失败";
            [weakSelf.locationBut title:@"定位失败"];
        }
        [weakSelf.homeManager fetchMainData];
    } status:^(CLAuthorizationStatus status) {
        
        if (status != kCLAuthorizationStatusAuthorizedAlways && status != kCLAuthorizationStatusAuthorizedWhenInUse) {
            //定位不能用
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"允许“惠汇联盟”在您使用该应用时访问您的位置吗？" message:@"是否允许访问您的位置以获取附近门店？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }];
            [alertController addAction:cancelAction];
            [alertController addAction:okAction];
            [weakSelf presentViewController:alertController animated:YES completion:nil];
        } else {
            [weakSelf.locationBut title:@"定位中..."];
            weakSelf.locationStr = @"定位失败";
        }
        
//        [weakSelf.homeManager fetchMainData];
    } didFailWithError:^(NSError *error) {
        [weakSelf.locationBut title:@"定位失败"];
        weakSelf.locationStr = @"定位失败";
        [weakSelf.homeManager fetchMainData];
        
    }];
}
- (UIButton *)goodsCarBut{
    if (!_goodsCarBut) {
        _goodsCarBut = [[UIButton alloc]init];
        [_goodsCarBut setImage:WTImage(@"Home_Versionf_ShoppingCart") forState:UIControlStateNormal];
        [_goodsCarBut addTarget:self action:@selector(goodsCarButClick) forControlEvents:UIControlEventTouchUpInside];
        _goodsCarBut.frame = CGRectMake(DEVICE_WIDTH - 100, DEVICE_HEIGHT - 200 - iPhoneXBottomHeight, 60, 60);
        
    }

    return _goodsCarBut;
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
