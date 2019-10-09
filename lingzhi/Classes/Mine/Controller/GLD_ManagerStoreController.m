//
//  GLD_ManagerStoreController.m
//  lingzhi
//
//  Created by Jin on 2017/12/17.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_ManagerStoreController.h"
#import "GLD_PayForMeController.h"
#import "GLD_UpdateViewController.h"
#import "GLD_ModifyDiscountController.h"
#import "GLD_MyOrderController.h"
#import "GLD_ApplyBusnessController.h"
#import "GLD_GoodsManagerController.h"
#import "GLD_PostGoodsViewController.h"

@interface GLD_ManagerStoreController ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImgV;//商店图标
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;//商店名称

@property (weak, nonatomic) IBOutlet UILabel *busnessType;//商店级别
@property (weak, nonatomic) IBOutlet UILabel *cashLabel;//本月营业额
@property (weak, nonatomic) IBOutlet UILabel *orderLabel;//订单
@property (weak, nonatomic) IBOutlet UILabel *turnoverLabel;//本日营业额

@property (nonatomic, strong)GLD_NetworkAPIManager *NetManager;
@property (nonatomic, strong)GLD_BusnessModel *model;
@end

@implementation GLD_ManagerStoreController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的门店";
    [self outLayoutSelfSubviews];
    self.view.backgroundColor = [YXUniversal colorWithHexString:COLOR_YX_BLUE_TABLE];
    self.NetManager = [GLD_NetworkAPIManager shareNetManager];
    [self getMyShopData];
}
- (IBAction)managerGoods:(id)sender {
    
    GLD_GoodsManagerController *goodsVc = [GLD_GoodsManagerController new];
    goodsVc.busnessModel = self.model;
    [self.navigationController pushViewController:goodsVc animated:YES];
}
- (IBAction)updateGood:(id)sender {
    
    //发布商品
    GLD_PostGoodsViewController *postVC = [[GLD_PostGoodsViewController alloc]initWith:^{
        
    }];
    [self.navigationController pushViewController:postVC animated:YES];
}

- (void)getMyShopData{
    WS(weakSelf);
    
    GLD_APIConfiguration *config = [[GLD_APIConfiguration alloc]init];
    config.requestType = gld_networkRequestTypePOST;
    config.urlPath = @"api/user/getMyShop";
    config.requestParameters = @{@"userId" : GetString([AppDelegate shareDelegate].userModel.userId)};
    
    [self.NetManager dispatchDataTaskWith:config andCompletionHandler:^(NSError *error, id result) {
        NSError *ee;
        weakSelf.model = [[GLD_BusnessModel alloc] initWithDictionary:result[@"data"] error:&ee];
        if([weakSelf.model.logo containsString:@","]){
            NSArray *arr = [weakSelf.model.logo componentsSeparatedByString:@","];
            [self.iconImgV yy_setImageWithURL:[NSURL URLWithString:arr.lastObject] placeholder:nil];
        }else{
            
            [self.iconImgV yy_setImageWithURL:[NSURL URLWithString:weakSelf.model.logo] placeholder:nil];
        }
        
        weakSelf.titleLabel.text = weakSelf.model.name;
        weakSelf.busnessType.text = [NSString stringWithFormat:@" %@ ",weakSelf.model.busnessType.integerValue == 1 ? @"高级商家联盟" : @"普通商家联盟"];
        weakSelf.cashLabel.text = [NSString stringWithFormat:@"本月收益 ￥ %.2f",[AppDelegate shareDelegate].userModel.Profit];
        weakSelf.orderLabel.text = [NSString stringWithFormat:@"%zd",[AppDelegate shareDelegate].userModel.Order];
        weakSelf.turnoverLabel.text = [NSString stringWithFormat:@"%.2f", [AppDelegate shareDelegate].userModel.dayCash];
//        weakSelf.phoneCode = @"1111";
    }];
}
//折扣设置
- (IBAction)discountClick:(id)sender {
    GLD_ModifyDiscountController *modifyVc = [GLD_ModifyDiscountController new];
    modifyVc.model = self.model;
    [self.navigationController pushViewController:modifyVc animated:YES];

}
//订单管理
- (IBAction)orderClick:(UIButton *)sender {
    GLD_MyOrderController *myCollect = [[GLD_MyOrderController alloc]init];
    [self.navigationController pushViewController:myCollect animated:YES];
}
- (IBAction)upgradeClick:(UIButton *)sender {
    //升级
    GLD_UpdateViewController *updateVC = [GLD_UpdateViewController new];
    [self.navigationController pushViewController:updateVC animated:YES];
}
//编辑门店
- (IBAction)editClick:(UIButton *)sender {
    GLD_ApplyBusnessController *applyVc = [GLD_ApplyBusnessController new];
    applyVc.isSuccss = YES;
    applyVc.busnessModel = self.model;
    [self.navigationController pushViewController:applyVc animated:YES];
}
- (IBAction)payForMe:(id)sender {
    GLD_PayForMeController *payforVc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"GLD_PayForMeController"];
    payforVc.model = self.model;
    [self.navigationController pushViewController:payforVc animated:YES];
}


@end
