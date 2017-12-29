//
//  GLD_GetCashController.m
//  lingzhi
//
//  Created by yiyangkeji on 2017/12/28.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_GetCashController.h"
#import "GLD_GetMoneyCell.h"

@interface GLD_GetCashController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *table_apply;
@property (nonatomic, strong)NSArray *dataArr;
@property (nonatomic, strong)UIButton *applyBut;//现金
@property (nonatomic, strong)UIImageView *generalRankImgV;//普通商家
@property (nonatomic, strong)UIImageView *superRankImgV;//高级商家商家
@end

@implementation GLD_GetCashController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.table_apply];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
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
    if(section > 0)
    return W(70);
    return 0.001;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cashCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cashCell"];
        }
        NSDictionary *dict =  self.dataArr[indexPath.row];
        cell.textLabel.text = dict[@"title"];
        cell.imageView.image = WTImage(dict[@"image"]);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        switch (indexPath.row) {
            case 0:{
                [cell.contentView addSubview:self.generalRankImgV];
            }break;
            case 1:{
                [cell.contentView addSubview:self.superRankImgV];
            }break;
        }
        return cell;
        return cell;
    }else{
        return [self getGetMoneyCell:indexPath];
    }
    return [UITableViewCell new];
}
- (GLD_GetMoneyCell *)getGetMoneyCell:(NSIndexPath *)indexPath{
    GLD_GetMoneyCell *cell = [GLD_GetMoneyCell cellWithReuseIdentifier:@"GLD_GetMoneyCell"];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return W(44);
    }else{
        return W(180);
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
            
        case 0:{
            
            if (indexPath.row == 0) {
                self.superRankImgV.hidden = YES;
                
                self.generalRankImgV.hidden = NO;
            }else if (indexPath.row == 1){
        
                self.superRankImgV.hidden = NO;
                self.generalRankImgV.hidden = YES;
            }else{
                
            }
        }break;
            
    }
}
- (UIImageView *)generalRankImgV{
    if (!_generalRankImgV) {
        _generalRankImgV = [[UIImageView alloc]initWithImage:WTImage(@"粗勾")];
        _generalRankImgV.frame = CGRectMake( W(340), W(10), W(20), H(20));
    }
    return _generalRankImgV;
}
- (UIImageView *)superRankImgV{
    if (!_superRankImgV) {
        _superRankImgV = [[UIImageView alloc]initWithImage:WTImage(@"粗勾")];
        _superRankImgV.frame = CGRectMake( W(340), W(10), W(20), H(20));
        _superRankImgV.hidden = YES;
    }
    return _superRankImgV;
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
        [tableView registerClass:[GLD_GetMoneyCell class] forCellReuseIdentifier:@"GLD_GetMoneyCell"];
        //        tableView.rowHeight = 0;
        tableView.sectionFooterHeight = 0.001;
    }
    return _table_apply;
}

- (void)applybutClick{
    //
//    NSLog(@"%@",self.cashCell.moneyStr);
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
