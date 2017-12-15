//
//  GLD_LoginController.m
//  yxvzb
//
//  Created by yiyangkeji on 17/2/10.
//  Copyright © 2017年 sendiyang. All rights reserved.
//

#import "GLD_LoginController.h"
#import "OCPublicEngine.h"


@interface GLD_LoginController ()<ShareModuleDelegate,UITextFieldDelegate>{
    
    NSInteger _messageOrRecord; //0 短信  1语音
    NSString *_remindMessage;
    NSString *_yanzhengmaStr;
    BOOL  isSendMessage;
}
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *yanZhengMaField;
@property (weak, nonatomic) IBOutlet UIButton *loginBut;

@property (weak, nonatomic) IBOutlet UIButton *yanZhengMaBut;
@property (weak, nonatomic) IBOutlet UIButton *yuyinBut;
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
    isSendMessage = NO;
    // 判断是否安装微信
    BOOL isWx = [WXApi isWXAppInstalled];
//    if (isWx) {
//        self.weixinView.hidden = NO;
//
//    }else {
//        self.weixinView.hidden = YES;
//    }
    self.yuyinBut.enabled = NO;
    // 取上次登录时的手机号
    self.phoneField.delegate = self;
    self.phoneField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"LastLoginPhone"];
    self.phoneNumber = self.phoneField.text;
    if (self.phoneNumber.length == 11){
        [self.yanZhengMaBut setTitleColor:[YXUniversal colorWithHexString:COLOR_YX_DRAKBLUE] forState:UIControlStateNormal];
        
    }else{
        [self.yanZhengMaBut setTitleColor:[YXUniversal colorWithHexString:COLOR_YX_DRAKgray2] forState:UIControlStateNormal];
    }
    if (_isWechatLogin) {
        [self.loginBut setTitle:@"绑定手机号码并验证" forState:UIControlStateNormal];
    }else {
         [self.loginBut setTitle:@"登录" forState:UIControlStateNormal];
    }
    
    self.loginBut.enabled = NO;
    [self.loginBut setBackgroundImage:[UIImage imageNamed:@"bukedianji"] forState:UIControlStateNormal];
    [self setContentFont];
    // Do any additional setup after loading the view.
}


- (void)setContentFont{
    self.yanZhengMaBut.titleLabel.font = WTFont(15);
    self.yuyinBut.titleLabel.font = WTFont(15);
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
        [self.loginBut setBackgroundImage:[UIImage imageNamed:@"登录可点击"] forState:UIControlStateNormal];
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
   
//    YXNewGetValidateSMS *request = [YXNewGetValidateSMS shareManager];
//
//    [request httpPost:@"" parameters:@{@"phoneNo":self.phoneField.text,@"validateType":[NSNumber numberWithInteger:_messageOrRecord]} block:^(WTBaseRequest *request, NSError *error) {
//        isSendMessage = NO;
//        if (error) {
//
//        }else {            
//            // 获取成功
//            self.verificationCode = [request.resultData[@"data"] objectForKey:@"validCode"];
//            self.type = [[request.resultData[@"data"] objectForKey:@"status"] integerValue];
//            NSData *data =  [[self.verificationCode stringToHexData] AES128DecryptWithKey:@"YiYangKeJi++++++"];
//            //解密后转化成字符串
//            self.verificationCode = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//
//            NSLog(@"验证码 = %@",self.verificationCode);
//            [self toastInfo:_remindMessage];
//            self.countDownNumber = 60;
//            self.verificationCodeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(yanzhengmaDaojishi) userInfo:nil repeats:YES];
//            [self.yanZhengMaBut setTitleColor:[YXUniversal colorWithHexString:COLOR_YX_DRAKBLUE] forState:UIControlStateNormal];
//            [self.yuyinBut setTitleColor:[YXUniversal colorWithHexString:COLOR_YX_DRAKgray2] forState:UIControlStateNormal];
//            self.yanZhengMaBut.enabled = NO;
//            self.yuyinBut.enabled = NO;
//        }
//
//    }];
 
}

- (void)yanzhengmaDaojishi {
    
    if (self.countDownNumber == 1) {
        [self.verificationCodeTimer invalidate];
        self.verificationCodeTimer = nil;
        
        self.yanZhengMaBut.enabled = YES;
        self.yuyinBut.enabled = YES;
        [self.yuyinBut setTitleColor:[YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTBLACK] forState:UIControlStateNormal];
        [self.yanZhengMaBut setTitle:@"重新获取" forState:UIControlStateNormal];
        
        return;
    }
    
//    self.countDownNumber--;
    NSString *str2 = [NSString stringWithFormat:@"%lds",self.countDownNumber--];
    [self.yanZhengMaBut setTitle:str2 forState:UIControlStateNormal];

    
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
     NSString *codeStr = [self.yanZhengMaField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
//    if (!IsExist_String([AppDelegate shareDelegate].adId)) {
//        [AppDelegate shareDelegate].adId = @"";
//    }
//    if (!IsExist_String([AppDelegate shareDelegate].deviceId)) {
//        [AppDelegate shareDelegate].deviceId = @"";
//    }
    NSString *phoneNo = self.phoneNumber;
//    NSString *deviceId = [AppDelegate shareDelegate].deviceId;
//    NSString *adId = [AppDelegate shareDelegate].adId;
    NSString *openId = self.openId;
    NSString *token = self.token;
    
    if (_isWechatLogin) {
        //  微信绑定手机号
        
//        YXNewCodeLogin *request = [YXNewCodeLogin shareManager];
//        [request httpPost:@"" parameters:@{@"phoneNo":phoneNo,@"type":[NSNumber numberWithInteger:self.type],@"validateCode":codeStr,@"os":@"ios",@"openId":openId,@"token":token,@"deviceId":deviceId,@"idfa":adId} block:^(WTBaseRequest *request, NSError *error) {
//            if (error == nil) {
//
//                NSLog(@"调用成功:%@", request.resultArray);
//                if (IsExist_Array(request.resultArray)) {
//                    //保存本次登录的类型，0标识为手机号密码登录
//                    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:LastLoginTypeKey];
//                    //保存本次登录的手机号
//                    [[NSUserDefaults standardUserDefaults] setObject:phoneNo forKey:@"LastLoginPhone"];
//                    // 获取用户信息
//                    UserInfomationModel *infomationModel = (UserInfomationModel*)[request.resultArray firstObject];
//                    UserDataModel *userDataModel = infomationModel.user;
//                    NSLog(@"%@",userDataModel.password);
//                    //保存本次登录的密码
//                    if (userDataModel.phone && userDataModel.password) {
//                        [[NSUserDefaults standardUserDefaults] setObject:userDataModel.phone forKey:LastLoginPhoneNum];
//                        [[NSUserDefaults standardUserDefaults] setObject:userDataModel.password forKey:LastLoginPassword];
//                    }
//
//
//                    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",userDataModel.inviteCode] forKey:@"inviteCode"];
//                    [AppDelegate shareDelegate].token = infomationModel.token;
//                    [AppDelegate shareDelegate].userDataModel = userDataModel;
//                    //归档储存
//                    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:userDataModel];
//
//                    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"userDataModelGLD"];
//                    [[NSUserDefaults standardUserDefaults] setObject:infomationModel.token forKey:@"userToken"];
//
//                    [[SensorsAnalyticsSDK sharedInstance] identify:[AppDelegate shareDelegate].userDataModel.id];
//
//                    [[NSUserDefaults standardUserDefaults] synchronize];
//                    if (userDataModel.ident.length == 0) {
//                        //需要完善信息
//
//                        [self toastInfo:@"您已绑定成功!"];
//                        [self performSelector:@selector(registSuccessJoin) withObject:self afterDelay:1.0];
//
//                    }else{
//                        //进入主页
//                        //需要完善信息
//                        [self toastInfo:@"您已绑定成功！"];
//                        [self performSelector:@selector(registSuccessJoinMain) withObject:self afterDelay:1.0];
//                    }
//                }
//            } else {
//                [self toastInfo:error.localizedDescription];
//            }
//
//        }];
        
    }else {
        
//        YXNewCodeLogin *request = [YXNewCodeLogin shareManager];
//        [request httpPost:@"" parameters:@{@"phoneNo":phoneNo,@"type":[NSNumber numberWithInteger:self.type],@"validateCode":codeStr,@"os":@"ios",@"deviceId":deviceId,@"idfa":adId} block:^(WTBaseRequest *request, NSError *error) {
//            if (error == nil) {
//
//                if (IsExist_Array(request.resultArray)) {
//
//                    //保存本次登录的类型，0标识为手机号密码登录
//                    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:LastLoginTypeKey];
//                    //保存本次登录的手机号
//                    [[NSUserDefaults standardUserDefaults] setObject:phoneNo forKey:@"LastLoginPhone"];
//                    // 获取用户信息
//                    UserInfomationModel *infomationModel = (UserInfomationModel*)[request.resultArray firstObject];
//
//                    [[NSUserDefaults standardUserDefaults] setBool:infomationModel.relatedCompany forKey:@"relatedCompany"];
//                    [AppDelegate shareDelegate].relatedCompany = infomationModel.relatedCompany;
//                    UserDataModel *userDataModel = infomationModel.user;
//
//                    NSLog(@"%@",userDataModel.password);
//
//                    //保存本次登录的密码
//                    if (IsExist_String(userDataModel.phone) && IsExist_String(userDataModel.password)) {
//                        [[NSUserDefaults standardUserDefaults] setObject:userDataModel.phone forKey:LastLoginPhoneNum];
//                        [[NSUserDefaults standardUserDefaults] setObject:userDataModel.password forKey:LastLoginPassword];
//
//                    }
//
//                    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",userDataModel.inviteCode] forKey:@"inviteCode"];
//                    [AppDelegate shareDelegate].token = infomationModel.token;
//                    [AppDelegate shareDelegate].userDataModel = userDataModel;
//
//                    //归档储存
//                    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:userDataModel];
//
//                    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"userDataModelGLD"];
//                    [[NSUserDefaults standardUserDefaults] setObject:infomationModel.token forKey:@"userToken"];
//
//                    [[SensorsAnalyticsSDK sharedInstance] identify:[AppDelegate shareDelegate].userDataModel.id];
//
//
//                    [[NSUserDefaults standardUserDefaults] synchronize];
//
//                    if (userDataModel.ident.length == 0) {
//                        //需要完善信息
//                            [self toastInfo:@"注册成功！"];
//                            [self performSelector:@selector(registSuccessJoin) withObject:self afterDelay:1.0];
//
//                    }else{
//                        //进入主页
//                            [self performSelector:@selector(registSuccessJoinMain) withObject:self afterDelay:1.0];
//
//
//                    }
//                }
//            } else {
//                [self toastInfo:error.localizedDescription];
//            }
//
//        }];
//
    }
    

    
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
    if (proposedNewLength == 11){
        [self.yanZhengMaBut setTitleColor:[YXUniversal colorWithHexString:COLOR_YX_DRAKBLUE] forState:UIControlStateNormal];
        
    }else{
        [self.yanZhengMaBut setTitleColor:[YXUniversal colorWithHexString:COLOR_YX_DRAKgray2] forState:UIControlStateNormal];
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
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
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
