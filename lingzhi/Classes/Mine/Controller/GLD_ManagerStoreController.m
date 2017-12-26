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

@interface GLD_ManagerStoreController ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImgV;//商店图标
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;//商店名称

@property (weak, nonatomic) IBOutlet UILabel *busnessType;//商店级别
@property (weak, nonatomic) IBOutlet UILabel *cashLabel;//本月营业额
@property (weak, nonatomic) IBOutlet UILabel *orderLabel;//订单
@property (weak, nonatomic) IBOutlet UILabel *turnoverLabel;//本日营业额

@end

@implementation GLD_ManagerStoreController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self outLayoutSelfSubviews];
    self.view.backgroundColor = [YXUniversal colorWithHexString:COLOR_YX_BLUE_TABLE];
}
//折扣设置
- (IBAction)discountClick:(id)sender {
    GLD_ModifyDiscountController *modifyVc = [GLD_ModifyDiscountController new];
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
    [self.navigationController pushViewController:applyVc animated:YES];
}
- (IBAction)payForMe:(id)sender {
    GLD_PayForMeController *payforVc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"GLD_PayForMeController"];
    [self.navigationController pushViewController:payforVc animated:YES];
}


@end
