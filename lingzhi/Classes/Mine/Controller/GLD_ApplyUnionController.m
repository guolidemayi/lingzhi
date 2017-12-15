//
//  GLD_ApplyUnionController.m
//  lingzhi
//
//  Created by yiyangkeji on 2017/12/11.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_ApplyUnionController.h"
#import "BRStringPickerView.h"
#import "BRTextField.h"
#import "BRDatePickerView.h"
#import "NSDate+BRAdd.h"

@interface GLD_ApplyUnionController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (nonatomic, strong)UITableView *table_apply;
/** 门店名称 */
@property (nonatomic, strong) BRTextField *nameTF;

/** 负责人 */
@property (nonatomic, strong) BRTextField *PersonTF;
/** 折扣 */
@property (nonatomic, strong) BRTextField *discountTF;

/** 验证码 */
@property (nonatomic, strong) BRTextField *verificationTF;

/** 所在行业 */
@property (nonatomic, strong) BRTextField *industryTF;

/** 所在地区 */
@property (nonatomic, strong) BRTextField *addressTF;

/** 门店电话 */
@property (nonatomic, strong) BRTextField *phoneTF;

/** 邀请码 */
@property (nonatomic, strong) BRTextField *invitationTF;

@property (nonatomic, strong) NSArray *titleArr;//

//验证码定时器
@property (nonatomic, strong)NSTimer *verificationTimer;
@property (nonatomic, weak)UIButton *verificationBut;
@end

@implementation GLD_ApplyUnionController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.table_apply];
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
    cell.textLabel.textColor = RGB_HEX(0x464646, 1.0f);
    cell.textLabel.text = self.titleArr[indexPath.row];
    switch (indexPath.row) {
        case 0:{
            [self setupNameTF:cell];
        }break;
        case 1:{
            [self setupAddressTF:cell];
        }break;
        case 2:{
            cell.textLabel.textColor = [YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTnewGray];
            UILabel *label = [[UILabel alloc]init];
            [cell.contentView addSubview:label];
            label.font = WTFont(12);
            label.textColor = [YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTnewGray];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.contentView);
                make.right.equalTo(cell.contentView).offset(W(-15));
            }];
            label.text = @"123456";
        }break;
        case 3:{
            [self setupPhoneTF:cell];
        }break;
        case 4:{
            [self setupIndustryTF:cell];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }break;
        case 5:{
            [self setupDiscountTF:cell];
        }break;
        case 6:{
            [self setupVerificationTF:cell];
        }break;
        case 7:{
            [self setupPersonTF:cell];
        }break;
    }
    
    return cell;
}
- (BRTextField *)getTextField:(UITableViewCell *)cell {
    BRTextField *textField = [[BRTextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - W(230), 0, W(200), W(50))];
    textField.backgroundColor = [UIColor clearColor];
    textField.font = [UIFont systemFontOfSize:16.0f];
    textField.textAlignment = NSTextAlignmentRight;
    textField.textColor = RGB_HEX(0x666666, 1.0);
    textField.delegate = self;
    [cell.contentView addSubview:textField];
    return textField;
}
#pragma mark - 申请人姓名
- (void)setupNameTF:(UITableViewCell *)cell{
    if (!_nameTF) {
        _nameTF = [self getTextField:cell];
        _nameTF.placeholder = @"请输入";
        _nameTF.returnKeyType = UIReturnKeyDone;
        _nameTF.tag = 0;
    }
}

#pragma mark - 申请人地址
- (void)setupAddressTF:(UITableViewCell *)cell {
    if (!_addressTF) {
        _addressTF = [self getTextField:cell];
        _addressTF.placeholder = @"请填写完整地址";
        _nameTF.returnKeyType = UIReturnKeyDone;
        _nameTF.tag = 0;
    }
}
#pragma mark - 申请人身份证号
- (void)setupPhoneTF:(UITableViewCell *)cell{
    if (!_phoneTF) {
        _phoneTF = [self getTextField:cell];
        _phoneTF.placeholder = @"请填写身份证号";
        _phoneTF.returnKeyType = UIReturnKeyDone;
        _phoneTF.tag = 4;
    }
}
#pragma mark - 渠道类型
- (void)setupIndustryTF:(UITableViewCell *)cell {
    if (!_industryTF) {
        _industryTF = [self getTextField:cell];
        _industryTF.placeholder = @"请选择渠道商";
        __weak typeof(self) weakSelf = self;
        _industryTF.tapAcitonBlock = ^{
            //跳转地区
        };
    }
}
#pragma mark - 推荐人手机号
- (void)setupDiscountTF:(UITableViewCell *)cell{
    if (!_discountTF) {
        _discountTF = [self getTextField:cell];
        _discountTF.placeholder = @"请输入推荐人手机号（选填）";
        _discountTF.returnKeyType = UIReturnKeyDone;
        _discountTF.tag = 2;
        
    }
}
#pragma mark - 验证码
- (void)setupVerificationTF:(UITableViewCell *)cell{
    if (!_verificationTF) {
        _verificationTF = [self getTextField:cell];
        _verificationTF.placeholder = @"请输入验证码";
        _verificationTF.returnKeyType = UIReturnKeyDone;
        _verificationTF.tag = 3;
        UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - W(130), W(5), W(100), W(40))];
        but.titleLabel.font = WTFont(15);
        _verificationTF.frame = CGRectMake(SCREEN_WIDTH - W(260), 0, W(100), W(50));
        [cell.contentView addSubview:but];
        [but setTitleColor:[YXUniversal colorWithHexString:COLOR_YX_DRAKBLUE] forState:UIControlStateNormal];
        but.layer.cornerRadius = 3;
        but.layer.masksToBounds = YES;
        but.layer.borderColor = [YXUniversal colorWithHexString:COLOR_YX_DRAKBLUE].CGColor;
        but.layer.borderWidth = 1;
        self.verificationBut = but;
        [but setTitle:@"获取验证码" forState:UIControlStateNormal];
        [but addTarget:self action:@selector(sendVerificationClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
}
- (void)sendVerificationClick:(UIButton *)senser{
    //验证码
    senser.enabled = NO;
    [senser setTitle:@"59" forState:UIControlStateNormal];
    self.verificationTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                              target:self
                                                            selector:@selector(timerAction:)
                                                            userInfo:nil
                                                             repeats:YES];
    
    
}
- (void)timerAction:(NSTimer *)timer{
    
    
    NSInteger time = [self.verificationBut.titleLabel.text integerValue];
    [self.verificationBut setTitle:[NSString stringWithFormat:@"%zd",--time] forState:UIControlStateNormal];
    if(time == 0){
        self.verificationBut.selected = NO;
        [self.verificationBut setTitle:@"重新获取" forState:UIControlStateNormal];
        [self.verificationTimer invalidate];
        self.verificationTimer = nil;
    }
}

#pragma mark - 备注
- (void)setupPersonTF:(UITableViewCell *)cell{
    if (!_PersonTF) {
        _PersonTF = [self getTextField:cell];
        _PersonTF.placeholder = @"请输入";
        _PersonTF.returnKeyType = UIReturnKeyDone;
        _PersonTF.tag = 1;
    }
}
- (void)dealloc{
    [self.verificationTimer invalidate];
    self.verificationTimer = nil;
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
        _titleArr = @[@"申请人姓名",@"申请人地址",@"申请人手机号",@"申请人身份证号",@"渠道类型",@"土建人手机号",@"验证码",@"备注"];
    }
    return _titleArr;
}



@end
