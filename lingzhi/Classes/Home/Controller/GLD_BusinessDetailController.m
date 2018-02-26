//
//  GLD_BusinessDetailController.m
//  lingzhi
//
//  Created by yiyangkeji on 2017/12/4.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_BusinessDetailController.h"
#import "GLD_BusnessModel.h"

#import "GLD_BusinessDetailManager.h"
#import "MapNavigationManager.h"
#import "GLD_PayForBusinessController.h"

@interface GLD_BusinessDetailController ()

@property (nonatomic, strong)UITableView *detail_table;
@property (nonatomic, strong)GLD_BusinessDetailManager *busnessManager;
@property (nonatomic, strong)UIView *bottomView;

@property (nonatomic, strong)GLD_NetworkAPIManager *netManager;
@property (nonatomic, weak)UIButton *collectBut;
@property (nonatomic, assign)NSInteger isCollection;
//0 收藏  1 取消
@end

@implementation GLD_BusinessDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.busnessModel.name;
    self.detail_table = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:self.detail_table];
    self.busnessManager = [[GLD_BusinessDetailManager alloc]initWithTableView:self.detail_table];
    self.busnessManager.busnessModel = self.busnessModel;
    [self setupBottomView];
    self.netManager = [GLD_NetworkAPIManager new];
    [self setRightBut];
    [self isCollectionRequest];
}
- (void)setRightBut{
    UIButton *rightBut = [[UIButton alloc]init];;
    self.collectBut = rightBut;
    rightBut.frame = CGRectMake(0, 0, 50, 44);
    [rightBut setImage:WTImage(@"btn_shoucang_null") forState:UIControlStateNormal];
    [rightBut addTarget:self action:@selector(collectionClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithCustomView:rightBut];
    self.navigationItem.rightBarButtonItem = item1;
}

- (void)isCollectionRequest{
    WS(weakSelf);
    GLD_APIConfiguration *config = [[GLD_APIConfiguration alloc]init];
    config.requestType = gld_networkRequestTypePOST;
    config.urlPath = @"api/main/isCollect";
    config.requestParameters = @{
                                 @"dataId":GetString(self.busnessModel.industryId),
                                 @"userId":GetString([AppDelegate shareDelegate].userModel.userId),
                                 };
    
    
    [self.netManager dispatchDataTaskWith:config andCompletionHandler:^(NSError *error, id result) {
        if(error){
            
            
        }else{
            weakSelf.isCollection = [result[@"data"] integerValue];
            if(weakSelf.isCollection != 0){
                [weakSelf.collectBut setImage:WTImage(@"课程页-已收藏") forState:UIControlStateNormal];
            }
            
        }
        
    }];
}

- (void)collectionClick{
    WS(weakSelf);
    GLD_APIConfiguration *config = [[GLD_APIConfiguration alloc]init];
    config.requestType = gld_networkRequestTypePOST;
    config.urlPath = @"api/main/collectionShop";
    config.requestParameters = @{
                                 @"dataId":GetString(self.busnessModel.industryId),
                                 @"userId":GetString([AppDelegate shareDelegate].userModel.userId),
                                 @"collectionType":[NSString stringWithFormat:@"%zd",self.isCollection]
                                 };
    
    
    [self.netManager dispatchDataTaskWith:config andCompletionHandler:^(NSError *error, id result) {
        if(error){
            [CAToast showWithText:@"收藏失败，请稍后再试"];
            
        }else{
            weakSelf.busnessModel.isCollect = weakSelf.busnessModel.isCollect.integerValue == 1? @"0":self.busnessModel.isCollect;
            weakSelf.isCollection == 0 ? (weakSelf.isCollection = 1) : (weakSelf.isCollection = 0);
            if(weakSelf.isCollection != 0){
                [weakSelf.collectBut setImage:WTImage(@"课程页-已收藏") forState:UIControlStateNormal];
            }else{
                [weakSelf.collectBut setImage:WTImage(@"btn_shoucang_null") forState:UIControlStateNormal];
            }
            [CAToast showWithText:result[@"data"]];
            
        }
        
    }];
}
- (void)setupBottomView{
    [self.view addSubview:self.bottomView];
    self.bottomView.frame = CGRectMake(0, DEVICE_HEIGHT-W(44)-64, DEVICE_WIDTH, W(44));
    [self.detail_table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
}
- (void)bottomButClick:(UIButton *)but{
    switch (but.tag) {
        case 201:{
            //导航
//                [MapNavigationManager showSheetWithCity:self.title start:nil end:@"上海"];
                CLLocationCoordinate2D coordinate;
                coordinate.latitude = [self.busnessModel.xpoint floatValue];
                coordinate.longitude = [self.busnessModel.ypoint floatValue];
                [MapNavigationManager showSheetWithCoordinate2D:coordinate];
        }break;
        case 202:{
//            拨号
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[NSString stringWithFormat:@"tel://%@",self.busnessModel.cellphone] stringByReplacingOccurrencesOfString:@"-" withString:@""]]];
        }break;
        case 203:{
            GLD_PayForBusinessController *jumpVC = [[GLD_PayForBusinessController alloc] init];
            //        jumpVC.jump_URL = result;
                jumpVC.payForUserId = self.busnessModel.userId;

            [self.navigationController pushViewController:jumpVC animated:YES];
        }break;
    }
}
- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [UIView new];
        NSArray *arr = @[@"导航",@"拨号",@"向商家付款"];
        for (int i = 0; i < arr.count; i++) {
            UIButton *but = [UIButton new];
            UIImageView *imgV = [UIImageView new];
            imgV.image = WTImage(arr[i]);
            
            UILabel *label = [UILabel new];
            label.text = arr[i];
            label.textColor = [YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTBLACK];
            label.font = WTFont(12);
            [but addSubview:imgV];
            [but addSubview:label];
            [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(but);
                make.top.equalTo(but).offset(3);
            }];
            if (i == 2) {
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(but);
                    make.bottom.equalTo(but);
                }];
                label.textColor = [UIColor whiteColor];
                but.backgroundColor = [YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTyellow];
            }else{
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(imgV);
                make.top.equalTo(imgV.mas_bottom).offset(-3);
            }];
            }
            [_bottomView addSubview:but];
            but.frame = CGRectMake(DEVICE_WIDTH/3 * i, 0, DEVICE_WIDTH/3, W(44));
            [but addTarget:self action:@selector(bottomButClick:) forControlEvents:UIControlEventTouchUpInside];
            but.tag = 201 + i;
        }
    }
    return _bottomView;
}

@end
