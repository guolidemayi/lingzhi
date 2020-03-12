//
//  MTShareModule.m
//  MingTieApp
//
//  Created by liuxiting on 15/11/13.
//  Copyright © 2015年 SDY. All rights reserved.
//

#import "MTShareModule.h"
#import "WXApiObject.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"

//#import "UIImageView+YYWebImage.h"
@interface MTShareModule ()
@property (assign, nonatomic) int wechatShareScene;
@property (nonatomic, strong) TencentOAuth *tencentOAuth;
@property (nonatomic, strong) NSMutableArray* permissions;
@property (nonatomic, assign) QQShareToPlatformType platformType;
@property (nonatomic, strong)UIImageView *shareImgV;
@end

@implementation MTShareModule
+ (MTShareModule*) getInstance
{
    static MTShareModule* sInstance = nil;
    if(sInstance == nil){
        sInstance = [[MTShareModule alloc] init];
        [WXApiManager sharedManager].delegate = sInstance;
    }
    return sInstance;
}
+ (BOOL)getQQAppIsInstalled
{
    return [QQApiInterface isQQInstalled];
}
+ (BOOL)getWechatAppIsInstalled
{
    return [WXApi isWXAppInstalled];
}
- (UIImageView *)shareImgV{
    if (_shareImgV == nil) {
        _shareImgV = [UIImageView new];
    }
    return _shareImgV;
}
#pragma mark - 短信分享
- (void)shareSMS
{
    if ([MFMessageComposeViewController canSendText])
    {
        MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
        picker.messageComposeDelegate = self;
        picker.body = [NSString stringWithFormat:@"%@ %@", self.str_shareText, self.str_shareUrl];//短信的文字
        //分享到的手机号码
        //picker.recipients = [NSArray arrayWithObjects:@"13889284071", @"13897978640", @"18904000803", nil];
        [[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:picker animated:NO completion:NULL];
    }else{
        [CAToast showWithText:@"此设备不支持发送短信息"];
    }
}
#pragma mark MFMessageComposeViewControllerDelegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result)
    {
        case MessageComposeResultCancelled:
            //self.shareCompletion(ShareStatusCancel,@"用户取消");
            [CAToast showWithText:@"用户取消短信分享"];
            break;
        case MessageComposeResultSent:
            //分享成功 做缓存记录  为了被动评分
            //[[CMAppScoreHelper instance] shareRecorded];
            //self.shareCompletion(ShareStatusSucceed,@"短信分享成功");
            [CAToast showWithText:@"短信分享成功"];
            break;
        case MessageComposeResultFailed:
            //self.shareCompletion(ShareStatusFailed,@"短信分享失败");
            [CAToast showWithText:@"短信分享失败"];
            break;
    }
    
    [[[UIApplication sharedApplication] keyWindow].rootViewController dismissViewControllerAnimated:YES completion:NULL];
}
#pragma mark - 邮件分享
- (void)shareEmail:(NSString *)targetEmail
{
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (!mailClass) {
        //NSLog(@"当前系统版本不支持应用内发送邮件功能，您可以使用mailto方法代替");
        [CAToast showWithText:@"当前系统版本不支持应用内发送邮件功能"];
        return;
    }
    if (![mailClass canSendMail]) {
        //NSLog(@"用户没有设置邮件账户");
        [CAToast showWithText:@"请先在系统中配置发件人邮箱地址"];
        return;
    }
    [self displayMailPicker:targetEmail];
}
//调出邮件发送窗口
- (void)displayMailPicker:(NSString *)targetEmail
{
    MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
    mailPicker.mailComposeDelegate = self;
    //设置主题
    [mailPicker setSubject: @""];
    //添加收件人
    NSArray *toRecipients = [NSArray arrayWithObject: targetEmail];
    [mailPicker setToRecipients: toRecipients];
    //添加抄送
    //NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil];
    //[mailPicker setCcRecipients:ccRecipients];
    //添加密送
    //NSArray *bccRecipients = [NSArray arrayWithObjects:@"fourth@example.com", nil];
    //[mailPicker setBccRecipients:bccRecipients];
    
    // 添加一张图片
    //    UIImage *addPic = [UIImage imageNamed: @"Icon@2x.png"];
    //    NSData *imageData = UIImagePNGRepresentation(addPic);            // png
    //    //关于mimeType：http://www.iana.org/assignments/media-types/index.html
    //    [mailPicker addAttachmentData: imageData mimeType: @"" fileName: @"Icon.png"];
    //
    //    //添加一个pdf附件
    //    NSString *file = [self fullBundlePathFromRelativePath:@"高质量C++编程指南.pdf"];
    //    NSData *pdf = [NSData dataWithContentsOfFile:file];
    //    [mailPicker addAttachmentData: pdf mimeType: @"" fileName: @"高质量C++编程指南.pdf"];
    //添加一个视频
//    NSString *path=[NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),@"20121219.avi"];
//    NSData *video = [NSData dataWithContentsOfFile:path];
//    [mailPicker addAttachmentData:video mimeType: @"" fileName:@"20121219.avi"];
//    NSString *emailBody = @"eMail 正文";
//    [mailPicker setMessageBody:emailBody isHTML:YES];
    [[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:mailPicker animated:YES completion:nil];
    //[mailPicker release];
}
#pragma mark - 实现 MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    //关闭邮件发送窗口
    [[[UIApplication sharedApplication] keyWindow].rootViewController dismissViewControllerAnimated:YES completion:nil];
    NSString *msg;
    switch (result) {
        case MFMailComposeResultCancelled:
            msg = @"用户取消编辑邮件";
            break;
        case MFMailComposeResultSaved:
            msg = @"用户成功保存邮件";
            break;
        case MFMailComposeResultSent:
            msg = @"用户点击发送，将邮件放到队列中，还没发送";
            break;
        case MFMailComposeResultFailed:
            msg = @"用户试图保存或者发送邮件失败";
            break;
        default:
            msg = @"";
            break;
    }
    NSLog(@"%@",msg);
}
#pragma mark - 微信登陆
- (void)loginByWechatWithViewCtrlDelegate:(UIViewController *)viewCtrlDelegate
{
    SendAuthReq* req = [[SendAuthReq alloc] init];
    req.scope = WeiXinAuthScope; // @"post_timeline,sns"
    req.state = WeiXinAuthState;
    //req.openID = WeiXinAuthOpenID;
    NSString *tmpOpenId = [[NSUserDefaults standardUserDefaults] objectForKey:Last_YXVZB_WeiXinAuthOpenId];
    if (IsExist_String(tmpOpenId)) {
        req.openID = tmpOpenId;
    }
    [WXApi sendReq:req];
//    [WXApi sendAuthReq:req
//        viewController:viewCtrlDelegate
//              delegate:[WXApiManager sharedManager]];

}
#pragma mark 接收微信登录后的响应函数
- (void)managerDidRecvAuthResponse:(SendAuthResp *)response {
    //    NSString *strTitle = [NSString stringWithFormat:@"Auth结果"];
    //    NSString *strMsg = [NSString stringWithFormat:@"code:%@,state:%@,errcode:%d", response.code, response.state, response.errCode];
    //
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle
    //                                                    message:strMsg
    //                                                   delegate:self
    //                                          cancelButtonTitle:@"OK"
    //                                          otherButtonTitles:nil, nil];
    //    [alert show];
    if (response.errCode == 0) {
        [self getAccess_token:response.code];
    }
}


-(void)getAccess_token:(id)code
{
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",WeiXinAppKey,WeiXinAppSecret,code];
    __weak MTShareModule *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"微信登录后调用api的结果：%@", dic);
                NSString *openId = [dic objectForKey:@"openid"];
                [[NSUserDefaults standardUserDefaults] setObject:openId forKey:Last_YXVZB_WeiXinAuthOpenId];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [weakSelf.authRespDelegate wechatAuthLoginResponse:dic];
                //登录成功后的处理
                
                //根据accesstoken和openid获取用户信息
                NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",dic[@"access_token"], dic[@"openid"]];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSURL *zoneUrl = [NSURL URLWithString:url];
                    NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
                    NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (data){
                            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                            
//                            [0]    (null)    @"openid" : @"oo1Uo1JpdStkz99-oHfr1P85f6Xg"
//                            [1]    (null)    @"city" : @"Zhengzhou"
//                            [2]    (null)    @"country" : @"CN"
//                            [3]    (null)    @"nickname" : @"锅里的"
//                            [4]    (null)    @"privilege" : @"0 elements"
//                            [5]    (null)    @"language" : @"zh_CN"
//                            [6]    (null)    @"headimgurl" : @"http://thirdwx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTJANJpsEAYns8cs3d6FNwVbafegYqJaS6vK1KRibn6R8dMSfiawHQq52oVsrco1uBwwzRZIZAoTAQhg/132"
//                            [7]    (null)    @"unionid" : @"ogWMJ01v8pkxCZMKLMX9fvYl0aK4"
//                            [8]    (null)    @"sex" : (long)1
//                            [9]    (null)    @"province" : @"Henan"
                            NSLog(@"%@",dic);
                            [AppDelegate shareDelegate].userModel.name = dic[@"nickname"];
                            [AppDelegate shareDelegate].userModel.iconImage = dic[@"headimgurl"];
                        }
                    });
                });
                
            }
        });
    });
}
#pragma mark - 微信分享相关
- (void)shareWeChat
{
    if([WXApi isWXAppInstalled] == YES)//已安装微信
    {
        self.wechatShareScene = WXSceneSession;
        if (self.wxMedia == WXMediaImage) {
            [self shareImageWithScene:WXSceneSession];
        } else {
            [self shareLinkContent];
        }
    }
    else
    {
        [CAToast showWithText:@"微信还未安装"];
    }
}
- (void)shareFriendCircle
{
    if([WXApi isWXAppInstalled] == YES)//已安装微信
    {
        self.wechatShareScene = WXSceneTimeline;
        if (self.wxMedia == WXMediaImage) {
            [self shareImageWithScene:WXSceneTimeline];
        } else {
            [self shareLinkContent];
        }
    }
    else
    {
        [CAToast showWithText:@"微信还未安装"];
    }
}

-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}


-(void)shareLinkContent
{
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    myDelegate.shareModuleDelegate = self;
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = self.str_shareText;
    if(self.str_shareDetailText.length > 500)
    {
        message.description = [self.str_shareDetailText substringToIndex:500];
    }
    else
    {
        message.description = self.str_shareDetailText;
    }
    
    [self.shareImgV sd_setImageWithURL:[NSURL URLWithString:self.str_shareImage] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
          if (image) {
              [self setMessage:message andImage:image];
          }else{
              [self setMessage:message andImage:[UIImage imageNamed:@"WechatIMG43"]];
          }
      }];
}

- (void)setMessage:(WXMediaMessage *)message andImage:(UIImage *)image
{
    UIImage *img = [self imageWithImage:image scaledToSize:CGSizeMake(80, 80)];
    [message setThumbImage:img];
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = self.str_shareUrl;
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = self.wechatShareScene;
    
    [WXApi sendReq:req];
}

- (void)shareImageWithScene:(int)scene
{
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:self.img];
    
    NSString *originalUrl = [self.url stringByReplacingOccurrencesOfString:@"!poster" withString:@""];
    WXImageObject *imageObj = [WXImageObject object];
    imageObj.imageUrl = originalUrl;//分享链接
    imageObj.imageData = self.originalImage;
    message.mediaObject = imageObj;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    [WXApi sendReq:req];
}

#pragma mark 接收微信分享后的响应函数
- (void)managerDidRecvMessageResponse:(SendMessageToWXResp *)response
{
    if([response isKindOfClass:[SendMessageToWXResp class]])
    {
        //NSLog(@"errcode:%d\terrStr:%@",resp.errCode, resp.errStr);
        NSString *errStr = [self getErrorStr:response.errCode];//根据错误码获得错误信息
        if (response.errCode == 0) {//分享成功
            NSLog(@"微信 %@", errStr);
//            [CAToast showWithText:@"分享成功"];
            [self.authRespDelegate wechatSuccess];
        } else {
            NSLog(@"微信 %@", errStr);
            [CAToast showWithText:errStr];
        }
    }
}

#pragma mark 根据微信客户端返回的错误码得到错误描述文字
-(NSString *)getErrorStr:(NSInteger)errcode
{
    NSString *errStr = @"";
    switch (errcode)
    {
        case WXSuccess:
        {
            errStr = @"分享成功";
            break;
        }
        case WXErrCodeCommon:
        {
            errStr = @"插件错误";
            break;
        }
        case WXErrCodeUserCancel:
        {
            errStr = @"取消分享";
            break;
        }
        case WXErrCodeSentFail:
        {
            errStr = @"发送失败";
            break;
        }
        case WXErrCodeAuthDeny:
        {
            errStr = @"授权失败";
            break;
        }
        case WXErrCodeUnsupport:
        {
            errStr = @"微信客户端不支持该种分享";
            break;
        }
        default:
        {
            break;
        }
    }
    return errStr;
}



#pragma mark - QQ开放平台相关功能
- (void)loginByQQ
{
    if ([TencentOAuth iphoneQQSupportSSOLogin] != YES) {
        [CAToast showWithText:@"当前手机QQ版本不支持第三方登录"];
    } else {
        //要用户授权的权限
        if (self.permissions == nil) {
            self.permissions = [NSMutableArray arrayWithObjects:
                            kOPEN_PERMISSION_GET_VIP_INFO,
                            kOPEN_PERMISSION_GET_USER_INFO,
                            kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                            kOPEN_PERMISSION_ADD_TOPIC,
                            kOPEN_PERMISSION_ADD_ONE_BLOG,
                            kOPEN_PERMISSION_ADD_SHARE,
                            kOPEN_PERMISSION_ADD_PIC_T,
                            kOPEN_PERMISSION_GET_INFO,
                            nil];
        }
        [self initQQSDK];
        [self.tencentOAuth authorize:self.permissions];
    }
}
#pragma mark QQ分享相关
- (void)shareQQ
{
    if ([QQApiInterface isQQInstalled] == YES) {
        [self initQQSDK];
        self.platformType = QQFriends;
        [self QQ_sendNewsMessageWithLocalImage];
        //[self shareQQPlatformText:@"M生活QQ分享文字"];
    }
    else
    {
        [CAToast showWithText:@"手机QQ未安装"];
    }
}
- (void)shareQzone
{
    if ([QQApiInterface isQQInstalled] == YES) {
        [self initQQSDK];
        self.platformType = QZone;
        [self QQ_sendNewsMessageWithLocalImage];
        //[self shareQQPlatformText:@"M生活QQ分享文字"];
    }
    else
    {
        [CAToast showWithText:@"手机QQ未安装"];
    }
}
#pragma mark 初始化QQSDK
-(void)initQQSDK
{
    if (self.tencentOAuth == nil) {
        NSString *appid = __TencentDemoAppid_;
        self.tencentOAuth = [[TencentOAuth alloc] initWithAppId:appid
                                                    andDelegate:self];
    }
}
//QQ登陆的三个回调函数 必须实现
- (void)tencentDidLogin
{
    if (_tencentOAuth.accessToken && 0 != [_tencentOAuth.accessToken length])
    {
        // 记录登录用户的OpenID、Token以及过期时间
        NSLog(@"accessToken:%@", _tencentOAuth.accessToken);
        if (![_tencentOAuth getUserInfo]) {//获得登陆的QQ账号昵称
            //NSLog(@"api调用失败，可能授权已过期，请重新获取");
            [CAToast showWithText:@"api调用失败，可能授权已过期，请重新获取"];
        }
        else
        {
            //待获得qq账户信息后才执行回调
            [CAToast showWithText:@"登录成功"];
        }
    }
    else
    {
        [CAToast showWithText:@"登录不成功 没有获取accesstoken"];
    }
}

-(void)tencentDidNotLogin:(BOOL)cancelled
{
    if (cancelled)
    {
        [CAToast showWithText:@"用户取消登录"];
    }
    else
    {
        [CAToast showWithText:@"登录失败"];
    }
}
-(void)tencentDidNotNetWork
{
    [CAToast showWithText:@"无网络连接，请设置网络"];
}
- (void)getUserInfoResponse:(APIResponse*) response {
    if (response.retCode == URLREQUEST_SUCCEED)
    {
        NSString *nickStr = [response.jsonResponse objectForKey:@"nickname"];
        NSLog(@"QQ_token:%@, 用户名：%@，openid:%@", _tencentOAuth.accessToken, nickStr, _tencentOAuth.openId);
        [self.authRespDelegate qqAuthLoginResponse:_tencentOAuth];
    }
    else
    {
        [CAToast showWithText:@"未能成功获取账户信息"];
    }
}
#pragma mark 分享文字
-(void)shareQQPlatformText:(NSString *)shareText
{
    NSLog(@"即将分享的文字：%@",shareText);
    QQApiTextObject *txtObj = [QQApiTextObject objectWithText:shareText];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:txtObj];
    //将内容分享到qq
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onResp:) name:kTencentApiResp object:[sdkCall getinstance]];
    [self handleQQPlatformSendResult:sent];
    
}
#pragma mark 分享连接
- (void)QQ_sendNewsMessageWithLocalImage
{
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    myDelegate.shareModuleDelegate = self;
    NSURL *picUrl = [NSURL URLWithString:self.str_shareImage];
    NSURL* url = [NSURL URLWithString:self.str_shareUrl];
    
    QQApiNewsObject *newObject = [QQApiNewsObject objectWithURL:url title:@"" description:self.str_shareText previewImageURL:picUrl];
    // 设置分享到QZone的标志位
    if (self.platformType == QQFriends) {
        [newObject setCflag: kQQAPICtrlFlagQQShare];
    }else {
        [newObject setCflag: kQQAPICtrlFlagQZoneShareOnStart ];
    }
    
    SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:newObject];
    
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    [self handleQQPlatformSendResult:sent];
    
}
#pragma mark QQ好友和QQ空间定向分享的回调函数
- (void)handleQQPlatformSendResult:(QQApiSendResultCode)sendResult
{
//    NSString *errStr = @"";
//    switch (sendResult)
//    {
//        case EQQAPIAPPNOTREGISTED:
//        {
//            errStr = @"App未注册";
//            break;
//        }
//        case EQQAPIMESSAGECONTENTINVALID:
//        case EQQAPIMESSAGECONTENTNULL:
//        case EQQAPIMESSAGETYPEINVALID:
//        {
//            errStr = @"分享发送参数错误";
//            break;
//        }
//        case EQQAPIQQNOTINSTALLED:
//        {
//            errStr = @"未安装手机客户端";
//            break;
//        }
//        case EQQAPIQQNOTSUPPORTAPI:
//        {
//            errStr = @"API接口不支持";
//            break;
//        }
//        case EQQAPISENDFAILD:
//        {
//            errStr = @"发送失败";
//            break;
//        }
//        case EQQAPIQZONENOTSUPPORTTEXT:
//        {
//            errStr = @"空间分享不支持纯文本分享，请使用图文分享";
//            break;
//        }
//        case EQQAPIQZONENOTSUPPORTIMAGE:
//        {
//            errStr = @"空间分享不支持纯图片分享，请使用图文分享";
//            break;
//        }
//        default:
//        {
//            break;
//        }
//    }
}
#pragma mark QQApiInterfaceDelegate
+ (void)onReq:(QQBaseReq *)req
{
    switch (req.type)
    {
        case EGETMESSAGEFROMQQREQTYPE:
        {
            break;
        }
        default:
        {
            break;
        }
    }
}

+ (void)onResp:(QQBaseResp *)resp
{
    switch (resp.type)
    {
        case ESENDMESSAGETOQQRESPTYPE:
        {
            SendMessageToQQResp* sendResp = (SendMessageToQQResp*)resp;
            NSInteger resultCode = [sendResp.result integerValue];
            
            switch (resultCode) {
                case -4:
                {
                    NSLog(@"用户取消分享");
                    [CAToast showWithText:@"用户取消分享"];
                    break;
                }
                case 0:
                {
                    NSLog(@"分享成功");
                    [CAToast showWithText:@"分享成功"];
                    break;
                }
                default:
                    break;
            }
        }
        default:
        {
            break;
        }
    }
    
}

//QQApiInterfaceDelegate 需要实现的方法，暂时无实际意义，调用+(void)onReq:(QQBaseReq *)req 和 +(void)onResp:(QQBaseResp *)resp
- (void)onReq:(QQBaseReq *)req
{
    
}
- (void)onResp:(QQBaseResp *)resp
{
    
}
//处理QQ在线状态的回调
- (void)isOnlineResponse:(NSDictionary *)response
{
    
}
@end

#pragma mark - WXApiManager
@implementation WXApiManager
+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static WXApiManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[WXApiManager alloc] init];
    });
    return instance;
}
#pragma mark WXApiDelegate
- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvMessageResponse:)]) {
            SendMessageToWXResp *messageResp = (SendMessageToWXResp *)resp;
            [_delegate managerDidRecvMessageResponse:messageResp];
        }
    } else if ([resp isKindOfClass:[SendAuthResp class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvAuthResponse:)]) {
            SendAuthResp *authResp = (SendAuthResp *)resp;
            [_delegate managerDidRecvAuthResponse:authResp];
        }
    } else if([resp isKindOfClass:[PayResp class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(onResp:)]) {
            [_delegate onResp:resp];
        }
    }
}

- (void)onReq:(BaseReq *)req {
    
}

@end
