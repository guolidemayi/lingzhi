//
//  GLD_GetVerificationController.m
//  lingzhi
//
//  Created by yiyangkeji on 2017/12/12.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_GetVerificationController.h"
#import "BRTextField.h"
#import "NSDate+BRAdd.h"
#import "GLD_NewPhoneController.h"

@interface GLD_GetVerificationController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (nonatomic, strong)UITableView *table_apply;

/** 验证码 */
@property (nonatomic, strong) BRTextField *verificationTF;

//验证码定时器
@property (nonatomic, strong)NSTimer *verificationTimer;
@property (nonatomic, weak)UIButton *verificationBut;
@property (nonatomic, strong)UILabel *titleLabel;//标题
@property (nonatomic, strong)UILabel *tipLabel;//副标题
@property (nonatomic, strong)UILabel *phoneLabel;//副标题

@property (nonatomic, strong)GLD_NetworkAPIManager *netManager;
@property (nonatomic, copy)NSString *loginCode;//验证码
@end

@implementation GLD_GetVerificationController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *rightBut = [[UIButton alloc]init];;
    
    rightBut.frame = CGRectMake(0, 0, 50, 44);
    [rightBut setImage:WTImage(@"") forState:UIControlStateNormal];
    [rightBut addTarget:self action:@selector(rightButClick) forControlEvents:UIControlEventTouchUpInside];
    [rightBut setTitle:@"下一步" forState:UIControlStateNormal];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithCustomView:rightBut];
    self.navigationItem.rightBarButtonItem = item1;
    [self.view addSubview:self.table_apply];
    self.netManager = [GLD_NetworkAPIManager new];
    self.loginCode = @"-1";
}
- (void)viewWillAppear:(BOOL)animated{
    
    NSString *str = [AppDelegate shareDelegate].userModel.phone;
    NSRange rang ;
    rang.location = 3;
    rang.length = 4;
    if (str.length > 5)
        str = [str stringByReplacingCharactersInRange:rang withString:@"****"];
    _titleLabel.text = [NSString stringWithFormat:@"手机绑定 ：%@",str];
}
- (void)rightButClick{
    if(![self.loginCode isEqualToString:self.verificationTF.text])
    {
        [CAToast showWithText:@"验证码不正确"];
        return;
    }
    GLD_NewPhoneController *verifica = [GLD_NewPhoneController new];
    [self.navigationController pushViewController:verifica animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return W(70);
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UITableViewHeaderFooterView *headerView = [UITableViewHeaderFooterView new];
    [headerView.contentView addSubview:self.titleLabel];
    [headerView.contentView addSubview:self.tipLabel];
    [headerView.contentView addSubview:self.phoneLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(headerView.contentView).offset(W(10));
        
    }];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(4);
    }];
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel);
        make.left.equalTo(self.titleLabel.mas_right);
    }];
    return headerView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"systemCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
    cell.textLabel.text = @"验证码";
    [self setupVerificationTF:cell];
    
    return cell;
    
}
- (void)sendVerificationClick:(UIButton *)senser{
    //验证码
    WS(weakSelf);
    
    GLD_APIConfiguration *config = [[GLD_APIConfiguration alloc]init];
    config.requestType = gld_networkRequestTypePOST;
    config.urlPath = @"api/user/sms";
    config.requestParameters = @{@"phone" : GetString([AppDelegate shareDelegate].userModel.phone)};
    
    [self.netManager dispatchDataTaskWith:config andCompletionHandler:^(NSError *error, id result) {
        senser.enabled = NO;
        [senser setTitle:@"59" forState:UIControlStateNormal];
        weakSelf.verificationTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                                  target:self
                                                                selector:@selector(timerAction:)
                                                                userInfo:nil
                                                                 repeats:YES];
        NSString *str = result[@"data"];
        [CAToast showWithText:str duration:3];

        weakSelf.loginCode = str;
    }];
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

- (BRTextField *)getTextField:(UITableViewCell *)cell {
    BRTextField *textField = [[BRTextField alloc]initWithFrame:CGRectMake(W(80), 0, W(200), W(50))];
    textField.backgroundColor = [UIColor clearColor];
    textField.font = [UIFont systemFontOfSize:12.0f];
    textField.textAlignment = NSTextAlignmentRight;
    textField.textColor = [YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTnewGray];
    textField.delegate = self;
    [cell.contentView addSubview:textField];
    return textField;
}
#pragma mark - 验证码
- (void)setupVerificationTF:(UITableViewCell *)cell{
    if (!_verificationTF) {
        _verificationTF = [self getTextField:cell];
        _verificationTF.placeholder = @"请输入验证码";
        _verificationTF.returnKeyType = UIReturnKeyDone;
        _verificationTF.tag = 3;
        UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(DEVICE_WIDTH - W(130), W(5), W(100), W(35))];
        but.titleLabel.font = WTFont(15);
        _verificationTF.frame = CGRectMake(DEVICE_WIDTH - W(260), 0, W(100), W(35));
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
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = WTFont(12);
        _titleLabel.text = @"点击获取验证码";
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = [YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTnewGray];
    }
    return _titleLabel;
}
- (UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [UILabel new];
        _tipLabel.font = WTFont(12);
        _tipLabel.text = @"验证码3分钟内有效";
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.textColor = [YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTnewGray];
    }
    return _tipLabel;
}
- (UILabel *)phoneLabel{
    if (!_phoneLabel) {
        _phoneLabel = [UILabel new];
        _phoneLabel.font = WTFont(12);
        NSString *str = [AppDelegate shareDelegate].userModel.phone;
        NSRange rang ;
        rang.location = 3;
        rang.length = 4;
        if (str.length == 11)
        str = [str stringByReplacingCharactersInRange:rang withString:@"****"];
        _phoneLabel.text = [NSString stringWithFormat:@"绑定手机为 ：%@",str];
        _phoneLabel.textAlignment = NSTextAlignmentCenter;
        _phoneLabel.textColor = [YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTBLACK];
    }
    return _phoneLabel;
}
@end
