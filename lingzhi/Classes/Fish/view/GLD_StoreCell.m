//
//  GLD_StoreCell.m
//  lingzhi
//
//  Created by yiyangkeji on 2018/7/30.
//  Copyright © 2018年 com.lingzhi. All rights reserved.
//

#import "GLD_StoreCell.h"
#import "GLD_StoreViewController.h"
#import "CollectionViewController.h"
@interface GLD_StoreCell ()

@end
@implementation GLD_StoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)integralStoreClick:(UIButton *)sender {
    [self pushToStore:1];
}
- (IBAction)couponStoreClick:(id)sender {
    [self pushToStore:3];
}
- (IBAction)onSalesStoreClick:(id)sender {
    
    CollectionViewController *storeVC = [CollectionViewController new];
    storeVC.type = 1;
    [self.navigationController pushViewController:storeVC animated:YES];
}

- (void)pushToStore:(NSInteger)type{
    GLD_StoreViewController *storeVC = [GLD_StoreViewController new];
    storeVC.type = type;
    [self.navigationController pushViewController:storeVC animated:YES];
}

@end
