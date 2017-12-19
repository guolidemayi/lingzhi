//
//  GLD_UpdateViewController.m
//  lingzhi
//
//  Created by yiyangkeji on 2017/12/19.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_UpdateViewController.h"
#import "GLD_PayRechargeController.h"

@interface GLD_UpdateViewController ()<UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong)UITableView *table_apply;
@property (nonatomic, strong) NSArray *titleArr;//
@property (nonatomic, strong)UIImageView *generalRankImgV;//全额支付
@property (nonatomic, strong)UIImageView *superRankImgV;//分期付款

@property (nonatomic, strong)UIImageView *zhiFuBaoImgV;//全额支付
@property (nonatomic, strong)UIImageView *weiChatImgV;//微信付款
@property (nonatomic, strong)UILabel *footerTipLabel;//
@property (nonatomic, strong)UIButton *footerTipBut;
@property (nonatomic, strong)UIButton *applyBut;//升级

@end

@implementation GLD_UpdateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.table_apply];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 1)
        return self.generalRankImgV.hidden ? 0 : 2;
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = [YXUniversal colorWithHexString:COLOR_YX_DRAKblackNew];
    switch (indexPath.section) {
        case 0:{
            if (indexPath.row == 0) {
                cell.textLabel.text = @"全额支付";
                [cell.contentView addSubview:self.generalRankImgV];
            }else{
                cell.textLabel.text = @"分期扣";
                [cell.contentView addSubview:self.superRankImgV];
                cell.detailTextLabel.text = @"按照每天2元从预存服务费中扣取，如服务费不足，将不能享受高级联盟商家权益";
                cell.detailTextLabel.numberOfLines = 0;
            }
        }break;
        case 1:{
            NSDictionary *ditt = self.titleArr[indexPath.row];
            cell.imageView.image = WTImage(ditt[@"image"]);
            cell.textLabel.text = ditt[@"title"];
            if (indexPath.row == 0) {
                [cell.contentView addSubview:self.weiChatImgV];
            }else{
                [cell.contentView addSubview:self.zhiFuBaoImgV];
            }
        }break;
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 1) {
        return W(50);
    }
    return W(44);
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UITableViewHeaderFooterView *headView = [UITableViewHeaderFooterView new];
    UILabel *titleLabel = [UILabel new];
    titleLabel.font = WTFont(12);
    titleLabel.textColor = [YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTnewGray];
    if (section == 0) {
        titleLabel.text = @"支付联盟版权费：600元";
    }else{
        titleLabel.text = @"请选择支付方式";
    }
    [headView.contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(headView.contentView);
    }];
    return headView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UITableViewHeaderFooterView *footerView = [UITableViewHeaderFooterView new];
    
    [footerView.contentView addSubview:self.applyBut];
    [footerView.contentView addSubview:self.footerTipLabel];
    [footerView.contentView addSubview:self.footerTipBut];
    
    [self.applyBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(footerView.contentView);
        make.height.equalTo(WIDTH(44));
        make.right.equalTo(footerView.contentView).offset(W(-15));
        make.left.equalTo(footerView.contentView).offset(W(15));
    }];
    
    [self.footerTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(footerView.contentView).offset(W(15));
    }];
    
    [self.footerTipBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.footerTipLabel);
        make.left.equalTo(self.footerTipLabel.mas_right);
    }];
    
    return footerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 1)
        return self.generalRankImgV.hidden ? 0.001 : W(30);
    return W(30);
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return self.generalRankImgV.hidden ? W(100):W(70);
    }
    return 0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:{
            if (indexPath.row == 0) {
                self.generalRankImgV.hidden = NO;
                self.superRankImgV.hidden = YES;
                self.footerTipBut.hidden = YES;
                self.footerTipLabel.hidden = YES;
            }else{
                self.generalRankImgV.hidden = YES;
                self.superRankImgV.hidden = NO;
                self.footerTipBut.hidden = NO;
                self.footerTipLabel.hidden = NO;
            }
            [tableView reloadData];
        }break;
        case 1:{
            if (indexPath.row == 0) {
                self.weiChatImgV.hidden = NO;
                self.zhiFuBaoImgV.hidden = YES;
            }else{
                self.weiChatImgV.hidden = YES;
                self.zhiFuBaoImgV.hidden = NO;
            }
        }break;
            
    }
}
//
- (void)footerTipButClick{
    GLD_PayRechargeController *payVc = [GLD_PayRechargeController new];
    [self.navigationController pushViewController:payVc animated:YES];
}

//升级
- (void)applybutClick{
    NSLog(@"立即升级充值");
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
        tableView.mj_insetB = W(50);
        //        [tableView registerClass:[GLD_MapDetailCell class] forCellReuseIdentifier:GLD_MapDetailCellIdentifier];
        //        tableView.rowHeight = 0;
        tableView.sectionFooterHeight = 0.001;
    }
    return _table_apply;
}
- (NSArray *)titleArr {
    if (!_titleArr) {
        _titleArr = @[@{@"title":@"微信",@"image":@"微信支付"},
                      @{@"title":@"支付宝",@"image":@"支付宝-2 copy"}];
    }
    return _titleArr;
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
- (UIImageView *)zhiFuBaoImgV{
    if (!_zhiFuBaoImgV) {
        _zhiFuBaoImgV = [[UIImageView alloc]initWithImage:WTImage(@"粗勾")];
        _zhiFuBaoImgV.frame = CGRectMake( W(340), W(10), W(20), H(20));
        _zhiFuBaoImgV.hidden = YES;
    }
    return _zhiFuBaoImgV;
}
- (UIImageView *)weiChatImgV{
    if (!_weiChatImgV) {
        _weiChatImgV = [[UIImageView alloc]initWithImage:WTImage(@"粗勾")];
        _weiChatImgV.frame = CGRectMake( W(340), W(10), W(20), H(20));
        _weiChatImgV.hidden = YES;
    }
    return _weiChatImgV;
}
- (UIButton *)footerTipBut{
    if (!_footerTipBut) {
        _footerTipBut = [UIButton new];
        [_footerTipBut setTitleColor:[YXUniversal colorWithHexString:COLOR_YX_DRAKBLUE] forState:UIControlStateNormal];
        [_footerTipBut addTarget:self action:@selector(footerTipButClick) forControlEvents:UIControlEventTouchUpInside];
        _footerTipBut.hidden = YES;
        [_footerTipBut setTitle:@"立即充值" forState:UIControlStateNormal];
        _footerTipBut.titleLabel.font = WTFont(12);
    }
    return _footerTipBut;
}
- (UILabel *)footerTipLabel{
    if (!_footerTipLabel) {
        _footerTipLabel = [UILabel new];
        _footerTipLabel.font = WTFont(12);
        _footerTipLabel.hidden = YES;
        _footerTipLabel.text = @"余额不足";
        _footerTipLabel.textColor = [YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTRED];
    }
    return _footerTipLabel;
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
