//
//  GLD_GetCashController.m
//  lingzhi
//
//  Created by yiyangkeji on 2017/12/28.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_GetCashController.h"
#import "GLD_GetMoneyCell.h"
#import "GLD_ZFBPayCell.h"
#import "GLD_ZFBCashCell.h"

typedef NS_ENUM(NSInteger, payType) {
    CARD,
    ZFB,
};

@interface GLD_GetCashController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *table_apply;
@property (nonatomic, strong)NSArray *dataArr;
@property (nonatomic, strong)UIButton *applyBut;//现金
@property (nonatomic, strong)UIImageView *generalRankImgV;//普通商家
@property (nonatomic, strong)UIImageView *superRankImgV;//高级商家商家
@property (nonatomic, weak)GLD_GetMoneyCell *cardCashCell;
@property (nonatomic, weak)GLD_ZFBPayCell *ZFBPayCell;
@property (nonatomic, weak)GLD_ZFBCashCell *ZFBCashCell;
@property (nonatomic, assign)payType type;

@property (nonatomic, strong)GLD_NetworkAPIManager *NetManager;
@end

@implementation GLD_GetCashController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.table_apply];
    self.NetManager = [GLD_NetworkAPIManager shareNetManager];
    self.type = CARD;
    self.automaticallyAdjustsScrollViewInsets = NO;
}
- (void)getData{
    
    WS(weakSelf);
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
        [dict addEntriesFromDictionary:@{@"userId":[AppDelegate shareDelegate].userModel.userId}];
    
    
    GLD_APIConfiguration *config = [[GLD_APIConfiguration alloc]init];
    config.requestType = gld_networkRequestTypePOST;
    config.urlPath = @"api/user/getMoney";
    config.requestParameters = dict;
    
    [self.NetManager dispatchDataTaskWith:config andCompletionHandler:^(NSError *error, id result) {
        
        if(!error){
            
           
        }
        //        weakSelf.phoneCode = @"1111";
    }];
    
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.dataArr.count;
    }
    return 1;
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
    if(section > 1)
    return W(70);
    return 0.001;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cashCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cashCell"];
        }
        cell.textLabel.font = WTFont(15);
        NSDictionary *dict =  self.dataArr[indexPath.row];
        cell.textLabel.text = dict[@"title"];
        
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
        if(indexPath.section == 1){
            switch (self.type) {
                case CARD:
                    return [self getBankCardCell:indexPath];
                    break;
                case ZFB:
                    return [self getZFBPayCell:indexPath];
                    break;
            }
        }else if(indexPath.section == 2){
            switch (self.type) {
                case CARD:
                    return [self getGetMoneyCell:indexPath];
                    break;
                case ZFB:
                    return [self getZFBCashCell:indexPath];
                    break;
            }
        }
    }
    return [UITableViewCell new];
}
- (UITableViewCell *)getBankCardCell:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [self.table_apply dequeueReusableCellWithIdentifier:@"payCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"payCell"];
    }
    cell.textLabel.font = WTFont(15);
    cell.textLabel.text = @"添加银行卡";
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (GLD_ZFBPayCell *)getZFBPayCell:(NSIndexPath *)indexPath{
    GLD_ZFBPayCell *cell = [GLD_ZFBPayCell cellWithReuseIdentifier:@"GLD_ZFBPayCell"];
    self.ZFBPayCell = cell;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (GLD_ZFBCashCell *)getZFBCashCell:(NSIndexPath *)indexPath{
    GLD_ZFBCashCell *cell = [GLD_ZFBCashCell cellWithReuseIdentifier:@"GLD_ZFBCashCell"];
    self.ZFBCashCell = cell;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (GLD_GetMoneyCell *)getGetMoneyCell:(NSIndexPath *)indexPath{
    GLD_GetMoneyCell *cell = [GLD_GetMoneyCell cellWithReuseIdentifier:@"GLD_GetMoneyCell"];
    self.cardCashCell = cell;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return  W(44);
    }else if(indexPath.section == 1){
        return self.type == CARD ? 60 : 160;
    }else if(indexPath.section == 2){
        return self.type == CARD ? 200 : 140;
    }
    return 0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
            
        case 0:{
            
            if (indexPath.row == 0) {
                self.superRankImgV.hidden = YES;
                self.type = CARD;
                self.generalRankImgV.hidden = NO;
            }else if (indexPath.row == 1){
                self.superRankImgV.hidden = NO;
                self.generalRankImgV.hidden = YES;
                self.type = ZFB;
            }else{
                
            }
            [self.table_apply reloadData];
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
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
- (NSArray *)dataArr{
    if (!_dataArr) {
        _dataArr = @[
                     @{@"title":@"提现到银行卡"},
                     @{@"title":@"提现到支付宝"}];
    }
    return _dataArr;
}
- (UITableView *)table_apply{
    if (!_table_apply) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        self.table_apply = tableView;
        tableView.bounces = NO;
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
    
    NSDictionary *dictM = [NSDictionary dictionary];
    if (self.type == CARD) {
        [CAToast showWithText:@"银行卡支付暂未开通"];
        return;
    }else{
        
        
        if (!IsExist_String(self.ZFBPayCell.accountField.text)) {
            [CAToast showWithText:@"请输入支付宝账号"];
            return;
        }
        if (!IsExist_String(self.ZFBPayCell.nameField.text)) {
            [CAToast showWithText:@"请输入支付宝真实姓名"];
            return;
        }
        if (!IsExist_String(self.ZFBCashCell.cashField.text)) {
            [CAToast showWithText:@"请输入金额"];
            return;
        }
        if (!IsExist_String(self.ZFBPayCell.accountField.text)) {
            [CAToast showWithText:@"请输入支付宝账号"];
            return;
        }
        dictM = @{@"account":self.ZFBPayCell.accountField.text,
                  @"name":self.ZFBPayCell.nameField.text,
                  @"money":self.ZFBCashCell.cashField.text,
                  @"remark":GetString(self.ZFBPayCell.remarksField.text),
                  @"userId":GetString([AppDelegate shareDelegate].userModel.userId)
                  };
        
    }
    
    GLD_APIConfiguration *config = [[GLD_APIConfiguration alloc]init];
    config.requestType = gld_networkRequestTypePOST;
    config.urlPath = @"api/wx/tixian";
    config.requestParameters = dictM;
    WS(weakSelf)
    [self.NetManager dispatchDataTaskWith:config andCompletionHandler:^(NSError *error, id result) {
        if (!error) {
            if([result[@"code"] integerValue] == 200){
                
                [AppDelegate shareDelegate].userModel.cash = [AppDelegate shareDelegate].userModel.cash -self.ZFBCashCell.cashField.text.floatValue;
                [CAToast showWithText:@"操作成功"];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }else{
                [CAToast showWithText:result[@"msg"]];
            }
            
        }
        
        
    }];

}
- (UIButton *)applyBut{
    if (!_applyBut) {
        _applyBut = [[UIButton alloc]init];
        [_applyBut setTitleColor:[YXUniversal colorWithHexString:COLOR_YX_DRAKyellow] forState:UIControlStateNormal];
        
        [_applyBut setTitle:@"提现" forState:UIControlStateNormal];
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
