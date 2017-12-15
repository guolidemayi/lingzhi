//
//  GLD_PayRechargeController.m
//  lingzhi
//
//  Created by yiyangkeji on 2017/12/13.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_PayRechargeController.h"
#import "GLD_CashCountCell.h"

@interface GLD_PayRechargeController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *table_apply;
@property (nonatomic, strong)NSArray *dataArr;
@property (nonatomic, strong)UIButton *applyBut;//现金
@property (nonatomic, weak)GLD_CashCountCell *cashCell;
@end

@implementation GLD_PayRechargeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.table_apply];
    self.automaticallyAdjustsScrollViewInsets = NO; 
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return self.dataArr.count;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UITableViewHeaderFooterView *header = [UITableViewHeaderFooterView new];
    [header.contentView addSubview:self.applyBut];
    [self.applyBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(header.contentView);
        make.width.equalTo(WIDTH(300));
        make.height.equalTo(WIDTH(44));
    }];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return W(70);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        return [self getCooperatCell:indexPath];
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cashCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cashCell"];
        }
        NSDictionary *dict =  self.dataArr[indexPath.row];
        cell.textLabel.text = dict[@"title"];
        cell.detailTextLabel.text =dict[@"tip"];
        cell.imageView.image = WTImage(dict[@"image"]);
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return W(100);
    }else{
        return W(44);
    }
}
- (GLD_CashCountCell *)getCooperatCell:(NSIndexPath *)indexPath{
    GLD_CashCountCell *cell = [self.table_apply dequeueReusableCellWithIdentifier:GLD_CashCountCellIdentifier];
    self.cashCell = cell;
    return cell;
}
- (NSArray *)dataArr{
    if (!_dataArr) {
        _dataArr = @[@{@"title":@"现金支付",@"tip":@"现金 0.00元",@"image":@"微信支付"},
                     @{@"title":@"支付宝支付",@"tip":@"需要安装支付宝客户端",@"image":@"支付宝-2 copy"},
                     @{@"title":@"微信支付",@"tip":@"需要安装微信客户端",@"image":@"微信支付"}];
    }
    return _dataArr;
}
- (UITableView *)table_apply{
    if (!_table_apply) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        self.table_apply = tableView;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
        [tableView setSeparatorInset:UIEdgeInsetsMake(0, W(15), 0, W(15))];
        tableView.rowHeight = W(60);
        [tableView registerClass:[GLD_CashCountCell class] forCellReuseIdentifier:GLD_CashCountCellIdentifier];
        //        tableView.rowHeight = 0;
        tableView.sectionFooterHeight = 0.001;
    }
    return _table_apply;
}

- (void)applybutClick{
    //
    NSLog(@"%@",self.cashCell.moneyStr);
}
- (UIButton *)applyBut{
    if (!_applyBut) {
        _applyBut = [[UIButton alloc]init];
        [_applyBut setTitleColor:[YXUniversal colorWithHexString:COLOR_YX_DRAKyellow] forState:UIControlStateNormal];
        [_applyBut setTitle:@"立即充值" forState:UIControlStateNormal];
        _applyBut.titleLabel.font = WTFont(15);
        _applyBut.layer.cornerRadius = 3;
        _applyBut.layer.masksToBounds = YES;
        _applyBut.layer.borderColor = [YXUniversal colorWithHexString:COLOR_YX_DRAKyellow].CGColor;
        _applyBut.layer.borderWidth = 1;
        [_applyBut addTarget:self action:@selector(applybutClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _applyBut;
}
@end
