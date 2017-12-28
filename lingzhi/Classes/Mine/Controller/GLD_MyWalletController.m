//
//  GLD_MyWalletController.m
//  lingzhi
//
//  Created by yiyangkeji on 2017/12/12.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_MyWalletController.h"
#import "GLD_WalletDetialController.h"

@interface GLD_MyWalletController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *table_apply;
@property (nonatomic, strong)NSArray *dataArr;
@property (nonatomic, strong)UIView *topView;

@end

@implementation GLD_MyWalletController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.topView];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.table_apply];
    self.topView.frame = CGRectMake(0, 0, DEVICE_WIDTH, W(150));
    [self.table_apply mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.equalTo(self.view);
        make.top.equalTo(self.topView.mas_bottom);
    }];
}

- (void)imgVClick:(UITapGestureRecognizer *)tap{
    UIImageView *imgV = (UIImageView *)tap.view;
    GLD_WalletDetialController *walletVc = [GLD_WalletDetialController new];
    switch (imgV.tag) {
        case 101:{
            NSLog(@"现金");
            walletVc.type = 1;
        }break;
        case 102:{
            walletVc.type = 2;
            NSLog(@"L币");
        }break;
        case 103:{
            walletVc.type = 3;
            NSLog(@"代金券");
        }break;
    }
    [self.navigationController pushViewController:walletVc animated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = @"商圈服务费";
    cell.detailTextLabel.text = [AppDelegate shareDelegate].userModel.serviceMoney;
    cell.imageView.image = WTImage(@"我的选中");
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GLD_WalletDetialController *walletVc = [GLD_WalletDetialController new];
    walletVc.type = 4;
    [self.navigationController pushViewController:walletVc animated:YES];
}
- (UIView *)topView{
    if (!_topView) {
        _topView = [UIView new];
        _topView.backgroundColor = [YXUniversal colorWithHexString:COLOR_YX_DRAKyellow];
        NSArray *titleArr = @[@"现金",@"L币",@"优惠券"];
        
        for (int i = 0; i < titleArr.count; i++) {
            UIImageView *imgV = [UIImageView new];
            imgV.image = WTImage(@"realNmaeIdentification");
            imgV.frame = CGRectMake(W(35) + W(125)*i, W(15), W(55), W(60));
            imgV.userInteractionEnabled = YES;
            [imgV addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgVClick:)]];
            imgV.tag = 101 + i;
            [_topView addSubview:imgV];
            UILabel *label = [UILabel new];
            label.font = WTFont(15);
            label.numberOfLines = 0;
            label.textColor = [UIColor whiteColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.frame = CGRectMake(DEVICE_WIDTH / 3 * i, W(70), DEVICE_WIDTH / 3, W(50));
            [_topView addSubview:label];
             NSString *str = nil;
            switch (i) {
                case 0:{
                    str = [NSString stringWithFormat:@"现金 \n￥%@",[AppDelegate shareDelegate].userModel.cashMoney];
                }break;
                case 1:{
                    str = [NSString stringWithFormat:@"L币 \n%@",[AppDelegate shareDelegate].userModel.LMoney];
                }break;
                case 2:{
                    str = [NSString stringWithFormat:@"代金券 \n￥%@",[AppDelegate shareDelegate].userModel.CouponMoney];
                }break;
            }
            [self adjusCashLabel:str andLabel:label];
           
            
            
        }    
    }
    return _topView;
}
- (void)adjusCashLabel:(NSString *)title andLabel:(UILabel *)label{
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:title];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:8];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [title length])];
    [label setAttributedText:attributedString1];
    label.textAlignment = NSTextAlignmentCenter;
}
- (UITableView *)table_apply{
    if (!_table_apply) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        self.table_apply = tableView;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
        [tableView setSeparatorInset:UIEdgeInsetsMake(0, W(15), 0, W(15))];
        tableView.rowHeight = W(60);
        //        [tableView registerClass:[GLD_CooperatCell class] forCellReuseIdentifier:GLD_CooperatCellIdentifier];
        //        tableView.rowHeight = 0;
        tableView.sectionFooterHeight = 0.001;
    }
    return _table_apply;
}

@end
