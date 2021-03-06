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

@property (nonatomic, weak)UILabel *cashLabel;

@end

@implementation GLD_MyWalletController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"我的钱包";
    [self.view addSubview:self.topView];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.table_apply];
    self.topView.frame = CGRectMake(0, 0, DEVICE_WIDTH, W(150));
    [self.table_apply mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.equalTo(self.view);
        make.top.equalTo(self.topView.mas_bottom);
    }];
}
- (void)viewWillAppear:(BOOL)animated{
    self.cashLabel.text = [NSString stringWithFormat:@"现金 \n￥%.2lf",[AppDelegate shareDelegate].userModel.cash];
}
- (void)imgVClick:(UITapGestureRecognizer *)tap{
    UIImageView *imgV = (UIImageView *)tap.view;
    GLD_WalletDetialController *walletVc = [GLD_WalletDetialController new];
    switch (imgV.tag) {
        case 101:{
            NSLog(@"现金");
            walletVc.type = 1;
            walletVc.title = @"我的现金";
        }break;
        case 102:{
            walletVc.type = 3;
            walletVc.title = @"我的代金券";
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f",[AppDelegate shareDelegate].userModel.cash1];
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
        NSArray *titleArr = @[@"现金图标144x144",@"代金券图标"];
        
        for (int i = 0; i < titleArr.count; i++) {
            UIImageView *imgV = [UIImageView new];
            imgV.image = WTImage(titleArr[i]);
            imgV.frame = CGRectMake(W(65) + W(375/2)*i, W(15), W(55), W(60));
            imgV.userInteractionEnabled = YES;
            [imgV addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgVClick:)]];
            imgV.tag = 101 + i;
            [_topView addSubview:imgV];
            UILabel *label = [UILabel new];
            label.font = WTFont(15);
            label.numberOfLines = 0;
            if (i == 0) {
                self.cashLabel = label;
            }
            label.textColor = [UIColor whiteColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.frame = CGRectMake(DEVICE_WIDTH / 2 * i, W(70), DEVICE_WIDTH / 2, W(50));
            [_topView addSubview:label];
             NSString *str = nil;
            switch (i) {
                case 0:{
                    str = [NSString stringWithFormat:@"现金 \n￥%.2lf",[AppDelegate shareDelegate].userModel.cash];
                }break;
                case 1:{
                    str = [NSString stringWithFormat:@"代金券 \n￥%.2lf",[AppDelegate shareDelegate].userModel.cash2];
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
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
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
