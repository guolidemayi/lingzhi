//
//  GLD_LoginController.m
//  yxvzb
//
//  Created by yiyangkeji on 17/2/10.
//  Copyright © 2017年 sendiyang. All rights reserved.
//

#import "GLD_LoginController.h"
#import "OCPublicEngine.h"
#import "GLD_CustomBut.h"
#import "GLD_PerfectUserMController.h"
#import "GLD_BindingPhoneController.h"

@interface GLD_LoginController ()<ShareModuleDelegate,UITextFieldDelegate>{
    
    NSInteger _messageOrRecord; //0 短信  1语音
    NSString *_remindMessage;
    NSString *_yanzhengmaStr;
    BOOL  isSendMessage;
}
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *yanZhengMaField;
@property (weak, nonatomic) IBOutlet UIButton *loginBut;



@property (weak, nonatomic) IBOutlet UIView *weixinView;

//手机号码
@property (copy, nonatomic) NSString *phoneNumber;
//是否注册（类型）
@property (assign, nonatomic) NSInteger type;

//验证码
@property (strong, nonatomic) NSTimer *verificationCodeTimer;
//倒计时
@property (assign, nonatomic) NSInteger countDownNumber;
//验证码
@property (copy, nonatomic) NSString *verificationCode;
@end

@implementation GLD_LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self outLayoutSelfSubviews];
    
    GLD_CustomBut *locationBut = [[GLD_CustomBut alloc]init];;
    locationBut.frame = CGRectMake(0, 0, 50, 44);
    [locationBut image:@"导航栏返回箭头"];
    [locationBut addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:locationBut];
    self.navigationItem.leftBarButtonItem = item;
    isSendMessage = NO;
    // 判断是否安装微信
    BOOL isWx = [WXApi isWXAppInstalled];
//    if (isWx) {
//        self.weixinView.hidden = NO;
//
//    }else {
//        self.weixinView.hidden = YES;
//    }
    
    
    self.loginBut.enabled = NO;
    [self.loginBut setBackgroundImage:[UIImage imageNamed:@"bukedianji"] forState:UIControlStateNormal];
    [self setContentFont];
    // Do any additional setup after loading the view.
}
- (void)backAction{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (IBAction)registerClick:(UIButton *)sender {
    GLD_PerfectUserMController *UserVc = [[GLD_PerfectUserMController alloc]init];
    [self.navigationController pushViewController:UserVc animated:YES];
}
- (IBAction)forgetPassword:(id)sender {
    
    //忘记密码
    GLD_BindingPhoneController *bingVc = [GLD_BindingPhoneController new];
    [self.navigationController pushViewController:bingVc animated:YES];
}

- (void)setContentFont{
    
    self.loginBut.titleLabel.font = WTFont(17);
}
- (IBAction)commitClick:(UIButton *)sender {
    
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    // 跟踪登录注册手机号输入框
    
    if ([textField isEqual:self.phoneField]) {
        
       self.phoneNumber =  [self.phoneField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }else{
        
        _yanzhengmaStr = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
    
    if (self.phoneNumber.length == 11 && _yanzhengmaStr.length == 4) {
        self.loginBut.enabled = YES;
        [self.loginBut setBackgroundImage:[UIImage imageNamed:@"可点击登陆"] forState:UIControlStateNormal];
    }
    
}

//获取验证码
- (IBAction)messageTest:(UIButton *)sender {
    
//    if ([AppDelegate shareDelegate].reachabilityStatus == 3) {
//        [CAToast showWithText:@"网络不给力，请检查网络"];
//        return;
//    }
//    if (![YXUniversal isValidateMobile:self.phoneField.text]) {
//        [self toastInfo:@"请输入正确的手机号"];
//        return;
//    }
    if (isSendMessage) return;
    // 获取验证码埋点
    
    _messageOrRecord = 0;
    _remindMessage = @"短信验证码已发送";
    [self getMessageFromInternet];
    
}

- (void)getMessageFromInternet{
    isSendMessage = YES;
   

 
}




//语音
- (IBAction)speechClick:(UIButton *)sender {
    _messageOrRecord = 1;
    _remindMessage = @"请注意接听电话";
    if (isSendMessage) return;
    [self getMessageFromInternet];
    // 获取验证码埋点
    
}
//登录
- (IBAction)loginClick:(UIButton *)sender {
//     NSString *codeStr = [self.yanZhengMaField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:userHasLogin];
    }];
    
}
- (void)registSuccessJoin {
    // 进入完善信息
//    [[AppDelegate shareDelegate] initPerfectCardVC];
}

- (void)registSuccessJoinMain {
    // 进入主页
//    [[AppDelegate shareDelegate] gotoSuccessView];
    
}


- (IBAction)weixinLoginClick:(UIButton *)sender {
    // 跟踪微信登录按钮
    
    
    [MTShareModule getInstance].authRespDelegate = self;
    [[MTShareModule getInstance] loginByWechatWithViewCtrlDelegate:self];
    
}

//限制输入长度
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSUInteger proposedNewLength = textField.text.length - range.length + string.length;
    if([textField isEqual:self.phoneField]){
    if (proposedNewLength > 11) {
        return NO;//限制长度
    }
    
    }else if([textField isEqual:self.yanZhengMaField]){
        if (proposedNewLength > 4) {
            return NO;
        }
    }
    return YES;
}

#pragma mark - wechat login callback method
- (void)wechatAuthLoginResponse:(NSDictionary *)responseDic
{
    NSString *openId = [responseDic objectForKey:@"openid"];
    NSString *refreshToken = [responseDic objectForKey:@"refresh_token"];
    NSLog(@"微信授权成功");
    if (IsExist_String(openId) && IsExist_String(refreshToken)) {
        [self openLoginWithOpenId:openId token:refreshToken];
    }
    
}
- (void)openLoginWithOpenId:(NSString *)openId token:(NSString *)token
{    
    [[OCPublicEngine getInstance]  openLoginHandleWithOpenId:openId token:token isAutoLogin:NO successBlock:^(NSString *thirdUserId) {
        NSLog(@"%@",thirdUserId);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}
- (void)dealloc{
    if (self.verificationCodeTimer) {
        [self.verificationCodeTimer invalidate];
        self.verificationCodeTimer = nil;
    }
    NSLog(@"登陆页死了");
}
@end
