//
//  GLD_GiveCouponController.m
//  lingzhi
//
//  Created by yiyangkeji on 2017/12/12.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_GiveCouponController.h"
#import "BRTextField.h"
#import "NSDate+BRAdd.h"

@interface GLD_GiveCouponController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong)UITableView *table_apply;
/** 门店名称 */
@property (nonatomic, strong) BRTextField *phoneTF;

/** 负责人 */
@property (nonatomic, strong) BRTextField *PersonTF;

@property (nonatomic, strong) NSArray *titleArr;//
@property (nonatomic, strong)UIButton *applyBut;//现金
@property (nonatomic, strong) GLD_NetworkAPIManager *NetManager;//
@end

@implementation GLD_GiveCouponController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.table_apply];
    self.NetManager = [GLD_NetworkAPIManager new];
}

- (void)sendVerificationClick:(UIButton *)senser{
    //验证码
    
    if (!IsExist_String(self.phoneTF.text)) {
        [CAToast showWithText:@"转赠人"];
        return;
    }
    if (!IsExist_String(self.PersonTF.text)) {
        [CAToast showWithText:@"转增数"];
        return;
    }
    WS(weakSelf);
    
    GLD_APIConfiguration *config = [[GLD_APIConfiguration alloc]init];
    config.requestType = gld_networkRequestTypePOST;
    config.urlPath = @"api/user/convertCoupon";
    config.requestParameters = @{@"coupon" : GetString(self.PersonTF.text),
                                 @"phone" : GetString(self.phoneTF.text),
                                 @"userId" : GetString([AppDelegate shareDelegate].userModel.userId)
                                 };
    
    [self.NetManager dispatchDataTaskWith:config andCompletionHandler:^(NSError *error, id result) {
       
        if(!error){
            if ([result[@"code"] integerValue] != 200) {
                [CAToast showWithText:result[@"msg"]];
                return ;
            }else{
                [CAToast showWithText:@"转增成功"];
                [AppDelegate shareDelegate].userModel.cash2 = [AppDelegate shareDelegate].userModel.cash2 - weakSelf.PersonTF.text.floatValue;
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
            
        }
//        weakSelf.phoneCode = @"1111";
    }];
    
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"systemCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
    cell.textLabel.textColor = [YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTnewGray];
    cell.textLabel.text = self.titleArr[indexPath.row];
    switch (indexPath.row) {
        case 0:{
            [self setupPhoneTF:cell];
        }break;
        case 1:{
            
            [self setupPersonTF:cell];
        }break;
            
            
    }
    
    return cell;
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
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
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
- (UIButton *)applyBut{
    if (!_applyBut) {
        _applyBut = [[UIButton alloc]init];
        [_applyBut setTitleColor:[YXUniversal colorWithHexString:COLOR_YX_DRAKyellow] forState:UIControlStateNormal];
        [_applyBut setTitle:@"确认转赠" forState:UIControlStateNormal];
        _applyBut.titleLabel.font = WTFont(15);
        _applyBut.layer.cornerRadius = 3;
        _applyBut.layer.masksToBounds = YES;
        _applyBut.layer.borderColor = [YXUniversal colorWithHexString:COLOR_YX_DRAKyellow].CGColor;
        _applyBut.layer.borderWidth = 1;
        [_applyBut addTarget:self action:@selector(sendVerificationClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _applyBut;
}

- (void)applybutClick{
    
}
- (BRTextField *)getTextField:(UITableViewCell *)cell {
    BRTextField *textField = [[BRTextField alloc]initWithFrame:CGRectMake(W(100), 0, W(200), W(50))];
    textField.backgroundColor = [UIColor clearColor];
    textField.font = [UIFont systemFontOfSize:16.0f];
    textField.textAlignment = NSTextAlignmentLeft;
    textField.textColor = [YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTnewGray];
    textField.delegate = self;
    [cell.contentView addSubview:textField];
    return textField;
}
#pragma mark - 申请人身份证号
- (void)setupPhoneTF:(UITableViewCell *)cell{
    if (!_phoneTF) {
        _phoneTF = [self getTextField:cell];
        _phoneTF.placeholder = @"请输入号/手机号";
        _phoneTF.returnKeyType = UIReturnKeyDone;
        _phoneTF.tag = 4;
    }
}

#pragma mark - 备注
- (void)setupPersonTF:(UITableViewCell *)cell{
    if (!_PersonTF) {
        _PersonTF = [self getTextField:cell];
        _PersonTF.placeholder = @"请输入赠送优惠券数量";
        _PersonTF.returnKeyType = UIReturnKeyDone;
        _PersonTF.tag = 1;
    }
}

- (NSArray *)titleArr {
    if (!_titleArr) {
        _titleArr = @[@"转赠对象",@"转赠数量"];
    }
    return _titleArr;
}
@end
