//
//  Created by 郭勇 on 3/9/16.
//  Copyright © 2016 医洋科技. All rights reserved.
//

#import "OCPublicEngine.h"
#import "GLD_PerfectUserMController.h"
@interface OCPublicEngine () <MTShareViewDelegate>

@end

@implementation OCPublicEngine
static OCPublicEngine *sInstance = nil;
+ (OCPublicEngine *)getInstance {
    
    if (sInstance == nil) {
        sInstance = [[OCPublicEngine alloc] init];
    }
    return sInstance;
}

#pragma mark - 自动登录
- (void)phoneNumloginHandle:(NSString *)phoneNum pwdStr:(NSString *)pwdStr isAutoLogin:(BOOL)isAutoLogin {
    // ,@"deviceId":[AppDelegate shareDelegate].deviceId,@"idfa":[AppDelegate shareDelegate].adId
//    if (!IsExist_String([AppDelegate shareDelegate].adId)) {
//        [AppDelegate shareDelegate].adId = @"";
//    }
//    if (!IsExist_String([AppDelegate shareDelegate].deviceId)) {
//        [AppDelegate shareDelegate].deviceId = @"";
//    }
//    NSString *deviceId = [AppDelegate shareDelegate].deviceId;
//    NSString *adId = [AppDelegate shareDelegate].adId;
//
//    YXLoginRequest *request = [YXLoginRequest shareManager];
//    [request httpPostWithNoneHUD:@"" parameters:@{@"phoneNo": phoneNum, @"password": pwdStr, @"os": @"ios", @"deviceId": deviceId, @"idfa": adId} block:^(WTBaseRequest *request, NSError *error) {
//        NSLog(@"%@", error.localizedDescription);
//        if (error == nil) {
//            NSLog(@"调用成功:%@", request.resultArray);
//            if (IsExist_Array(request.resultArray)) {
//
//                //保存本次登录的类型，0标识为手机号密码登录
//                [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:LastLoginTypeKey];
//                //保存本次登录的手机号
//                [[NSUserDefaults standardUserDefaults] setObject:phoneNum forKey:@"LastLoginPhone"];
//
//                UserInfomationModel *infomationModel = (UserInfomationModel *) [request.resultArray firstObject];
//                UserDataModel *userDataModel = infomationModel.user;
//
//                //保存本次登录的密码
//                if (userDataModel.phone && userDataModel.password) {
//                    [[NSUserDefaults standardUserDefaults] setObject:userDataModel.phone forKey:LastLoginPhoneNum];
//                    [[NSUserDefaults standardUserDefaults] setObject:userDataModel.password forKey:LastLoginPassword];
//                }
//
//                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", userDataModel.inviteCode] forKey:@"inviteCode"];
//                [AppDelegate shareDelegate].token = infomationModel.token;
//                [AppDelegate shareDelegate].userDataModel = userDataModel;
//
//                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:userDataModel];
//
//                [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"userDataModelGLD"];
//                [[NSUserDefaults standardUserDefaults] setObject:infomationModel.token forKey:@"userToken"];
//                [[SensorsAnalyticsSDK sharedInstance] identify:[AppDelegate shareDelegate].userDataModel.id];
//
//                [[NSUserDefaults standardUserDefaults] synchronize];
//
//                if (userDataModel.ident.length == 0) {
//                    //需要完善信息
//                    [[AppDelegate shareDelegate] initPerfectCardVC];
//                } else {
//                    //进入主页
//                    [[AppDelegate shareDelegate] gotoSuccessView];
//                }
//            }
//        } else {
//            //超时error.code = -1004
//            //无网络error.code = -1009
//            if (error.code != WEB_SERVERCALLBACK_ERROR_CODE && error.code != WEB_ANALYSIS_ERROR_CODE) {
//                //非服务器接口返回的错误，而是如请求超时、无网络等其他类似错误
//                if (isAutoLogin == YES) {
//                    //自动登录情况下，若请求错误是由于无网络或请求超时引起的则进入首页
//                    //否则清除上次登录的数据后进入手动登录页
//                    if (error.code == NETWORK_NONE_CODE || error.code == NETWORK_TIMEOUT_CODE) {
//                        [[OCPublicEngine getInstance] netWorkNotGoodHandle];
//                    } else {
//                        [CAToast showWithText:@"自动登录失败，请重新登录"];
//                        //清除上次登录的数据
////                        [[OCPublicEngine getInstance] clearAutoLoginAccountData];
//                        [[AppDelegate shareDelegate] initLoginViewController];
//                    }
//
//                } else {
//
//                    [CAToast showWithText:error.localizedDescription];
////                    if (error.code == NETWORK_NONE_CODE || error.code == NETWORK_TIMEOUT_CODE) {
////                        //手动登录下，提示网络异常
////                        [CAToast showWithText:@"请检查网络"];
////                    } else {
////                        //手动登录下，提示登录失败
////                        [CAToast showWithText:@"登录失败"];
////                    }
//
//                }
//            } else {
//                //接口调用成功，网络可用，但是功能调用失败
//                if (isAutoLogin == YES) {
//                    //自动登录情况下清除上次登录的数据后进入手动登录页
//                    //清除上次登录的数据
//                    [[OCPublicEngine getInstance] clearAutoLoginAccountData];
//                    [[AppDelegate shareDelegate] initLoginViewController];
//                }
//            }
//        }
//
//    }];
}

#pragma mark - 第三方登录

- (void)openLoginHandleWithOpenId:(NSString *)openId token:(NSString *)token isAutoLogin:(BOOL)isAutoLogin successBlock:(void (^)(NSString *thirdUserId))successBlock {

   
    if (!IsExist_String([AppDelegate shareDelegate].deviceId)) {
        [AppDelegate shareDelegate].deviceId = @"";
    }
    NSString *deviceId = [AppDelegate shareDelegate].deviceId;
    
    NSDictionary *dic;
    if (IsExist_String(deviceId)) {
        dic = [NSDictionary dictionaryWithObjectsAndKeys:openId, @"openId", token, @"token", @"ios", @"os", deviceId, @"deviceId", nil];
    } else {
        dic = [NSDictionary dictionaryWithObjectsAndKeys:openId, @"openId", token, @"token", @"ios", @"os", nil];
    }
    //dic = [NSDictionary dictionaryWithObjectsAndKeys: openId, @"openId", token, @"token",nil];
    //第三方登录
    GLD_APIConfiguration *config = [[GLD_APIConfiguration alloc]init];
    config.requestType = gld_networkRequestTypePOST;
    config.urlPath = @"api/wx/wxLogin";
    config.requestParameters = dic;
    
    [[GLD_NetworkAPIManager shareNetManager] dispatchDataTaskWith:config andCompletionHandler:^(NSError *error, id result) {
        if (error == nil) {
            
           
            //第三方平台登录，存储账号信息，做为自动登录数据源
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:LastLoginTypeKey];
            //[[NSUserDefaults standardUserDefaults] setObject: forKey:LastLoginExpiredTime];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            GLD_UserMessageModel *infomationModel = [[GLD_UserMessageModel alloc]initWithDictionary:result[@"data"] error:nil];
            NSString *token = result[@"token"];
            [AppDelegate shareDelegate].token = @"";
            [AppDelegate shareDelegate].userModel = infomationModel;
            
            
            if (IsExist_String(infomationModel.loginToken)) {
                [[NSUserDefaults standardUserDefaults] setObject:infomationModel.loginToken forKey:@"loginToken"];
            }
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:infomationModel];
            
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"userDataModelGLD"];
            [[NSUserDefaults standardUserDefaults] setObject:GetString(token) forKey:@"userToken"];
            
            [[NSUserDefaults standardUserDefaults] setObject:[AppDelegate shareDelegate].userModel.phone forKey:@"LastLoginPhone"];
            
            
            if (infomationModel.userId.length == 0) {
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"weixinLogin"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                //需要绑定手机
                
              [[AppDelegate shareDelegate] finishUserData];
            } else {
                 [[NSUserDefaults standardUserDefaults] setBool:YES forKey:userHasLogin];
                //进入主页
                [[AppDelegate shareDelegate] initMainPageBody];
            }
        } 
    }];
   
}

/**
 网络不好时的处理，进入首页
 */
- (void)netWorkNotGoodHandle {
}
//{
//    OCDiscoverModel *tmpModel = (OCDiscoverModel *)[WTUniversal getDataForKey:KDISCOVERDEFAULTDATA];
//    //即使有网络的时候也先加载上次记录的首页数据
//    if (tmpModel != nil) {
//        //[self processResultData:tmpModel];
//        
//        [AppDelegate shareDelegate].userInfo.user_Id = tmpModel.cardInfo.userId;
//        [AppDelegate shareDelegate].userInfo.userName = tmpModel.cardInfo.userName;
//        [AppDelegate shareDelegate].userInfo.headUrl = tmpModel.cardInfo.headUrl;
//    }
//    else
//    {
//        [AppDelegate shareDelegate].userInfo.user_Id = @"";
//        [AppDelegate shareDelegate].userInfo.qrCode = @"";
//        [AppDelegate shareDelegate].userInfo.userCode = @"";
//        [AppDelegate shareDelegate].userInfo.userName = @"";
//        [AppDelegate shareDelegate].userInfo.headUrl = @"";
//        [AppDelegate shareDelegate].userInfo.user_Tel = @"";
//        [AppDelegate shareDelegate].userInfo.user_Sex = @"";
//        [AppDelegate shareDelegate].userInfo.user_Age = @"";
//        [AppDelegate shareDelegate].userInfo.eduDegree = @"";
//        [AppDelegate shareDelegate].userInfo.graduatedSchool = @"";
//        [AppDelegate shareDelegate].userInfo.industryId = @"";
//        [AppDelegate shareDelegate].userInfo.homeAddr = @"";
//        [AppDelegate shareDelegate].userInfo.city = @"";
//        [AppDelegate shareDelegate].userInfo.signature = @"";
//        [AppDelegate shareDelegate].userInfo.msgMode = @"";
//        [AppDelegate shareDelegate].userInfo.addVerification = @"";
//        [AppDelegate shareDelegate].userInfo.allowQqSearch = @"";
//        [AppDelegate shareDelegate].userInfo.allowTelSearch = @"";
//        [AppDelegate shareDelegate].userInfo.allowWxSearch = @"";
//    }
//    
//    [[AppDelegate shareDelegate] initDiscoverViewController];
//}
/**
 清除记录的上次登录的账户信息，但不删除本地保存的人脉云数据
 */
- (void)clearAutoLoginAccountData {
    //清除记录的上次登录的类型，这样自动登录时就无法判断上次登录的类型，就进入手动登录页
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:LastLoginTypeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];

    //清除上次登录的账号信息
    NSString *currentLoginUserPhoneNum = [[NSUserDefaults standardUserDefaults] objectForKey:LastLoginPhoneNum];
    //删除上次登录成功账户在本地保存的首页接口的数据
    //[WTUniversal deleteDataForKey:KDISCOVERDEFAULTDATA];

    if (IsExist_String(currentLoginUserPhoneNum)) {
        //有值说明上次登录是手机号密码登录
        //删除密码
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:LastLoginPassword];
        //删除手机号
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:LastLoginPhoneNum];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        //有值说明上次登录是第三方授权登录
        //删除token和openId
//        [[AppDelegate shareDelegate] deleteKeychainInfo:ThirdAuthKey];
    }

}

//#pragma mark - 显示分享view
+ (void)showShareViewWithType:(ShareViewType)type withDelegate:(UIViewController *)delegate shareText:(NSString *)tagStr shareUrl:(NSString *)tagUrl shareDetail:(NSString *)detailText shareImage:(NSString *)shareImgae shareTitle:(NSString *)title {
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"MTShareView" owner:nil options:nil];
    MTShareView *shareView = (MTShareView *) [topLevelObjects objectAtIndex:0];
    shareView.delegate = [OCPublicEngine getInstance];
    shareView.frame = CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT);
    shareView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    [shareView setShareViewWithType:type shareText:tagStr shareUrl:tagUrl withDelegate:delegate shareDetail:detailText shareImage:shareImgae];
    [shareView setLabelTitleSring:title];
#warning
//    [[AppDelegate shareDelegate].window addSubview:shareView];

    [UIView animateWithDuration:0.3 animations:^{
        shareView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        shareView.shareView2.frame = CGRectMake(0, DEVICE_HEIGHT-190, DEVICE_WIDTH, 190);

    }];
}

+ (void)showImageShareViewWithType:(ShareViewType)type withDelegate:(UIViewController *)delegate image:(UIImage *)image shareUrl:(NSString *)url originalImage:(NSData *)originalImage {
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"MTShareView" owner:nil options:nil];
    MTShareView *shareView = (MTShareView *) [topLevelObjects objectAtIndex:0];
    shareView.delegate = [OCPublicEngine getInstance];
    shareView.frame = CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT);
    shareView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    [shareView setImageShareViewWithType:type image:image shareUrl:url originalImage:originalImage withDelegate:delegate];
    #warning
//    [[AppDelegate shareDelegate].window addSubview:shareView];
    shareView.isImageShare = YES;
    [UIView animateWithDuration:0.3 animations:^{
        shareView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        shareView.shareView2.frame = CGRectMake(0, DEVICE_HEIGHT-190, DEVICE_WIDTH, 190);
    }];
}

- (void)shareSuccess {


    [self.delegate wachatShareSuccess:self.fromString];

}

//
//#pragma mark - 显示输入密码页
//+ (void)showInputCodeViewWithtype:(InputCodeViewType)type withDelegate:(id)delegate
//{
//    NSArray *topLevelObjects = [[NSBundle mainBundle]loadNibNamed:@"OCInputTradeCodeView" owner:nil options:nil];
//    OCInputTradeCodeView *shareView = (OCInputTradeCodeView *)[topLevelObjects objectAtIndex:0];
//    shareView.frame = CGRectMake(0, DEVICE_HEIGHT,DEVICE_WIDTH, DEVICE_HEIGHT);
//    [shareView setShareViewWithType:type withDelegate:delegate];
//    [[AppDelegate shareDelegate].window addSubview:shareView];
//    
//    [UIView animateWithDuration:0.3 animations:^{
//        shareView.frame = CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT);
//    } completion:^(BOOL finished) {
//        
//    }];
//}
//
//
//#pragma mark - 显示时间选择页
//+ (void)showDatePickerViewWithDelegate:(id)delegate
//{
//    NSArray *topLevelObjects = [[NSBundle mainBundle]loadNibNamed:@"OCDatePickerView" owner:nil options:nil];
//    OCDatePickerView *datePickerView = (OCDatePickerView *)[topLevelObjects objectAtIndex:0];
//    datePickerView.frame = CGRectMake(0, DEVICE_HEIGHT,DEVICE_WIDTH, DEVICE_HEIGHT);
//    [datePickerView setDatePickerViewWithDelegate:delegate];
//    [[AppDelegate shareDelegate].window addSubview:datePickerView];
//    
//    [UIView animateWithDuration:0.3 animations:^{
//        datePickerView.frame = CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT);
//    } completion:^(BOOL finished) {
//        
//    }];
//}
//#pragma mark - 显示数据选择器
//+(void)showPicerSelectViewWithDelegate:(id)delegate withData:(NSMutableArray *)data
//{
//    NSArray *topLevelObjects = [[NSBundle mainBundle]loadNibNamed:@"OCPickerSelectView" owner:nil options:nil];
//    OCPickerSelectView *datePickerView = (OCPickerSelectView *)[topLevelObjects objectAtIndex:0];
//    datePickerView.frame = CGRectMake(0, DEVICE_HEIGHT,DEVICE_WIDTH, DEVICE_HEIGHT);
//    [datePickerView setpickerSelectViewWithDelegate:delegate withData:data];
//
//    [[AppDelegate shareDelegate].window addSubview:datePickerView];
//    
//    [UIView animateWithDuration:0.3 animations:^{
//        datePickerView.frame = CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT);
//    } completion:^(BOOL finished) {
//        
//    }];
//}
//
//#pragma mark - 上传图片
//+ (void)uploadUserPhotoWithType:(UploadImageType)uploadType withFinishBlock:(void (^)(NSString *imageId, NSError *error))finishBlock
//{
//    
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSString *filePath = [NSTemporaryDirectory() stringByAppendingString:@"file"];
//    [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
//    NSString *newPath = [filePath stringByAppendingString:@"/image.png"];
//    NSData *imageData = [NSData dataWithContentsOfFile:newPath];
//    UIImage *image = [UIImage imageWithData:imageData];
//    NSData *postData = UIImageJPEGRepresentation(image, 0.65);
//    //NSDictionary *dicdd = [NSDictionary dictionaryWithObjectsAndKeys:postData,@"filepath", @"image.png",@"serverfilename",nil];
//    NSString *time = [WTUniversal getTimeStap];
//    [[OCUploadImageRequest shareManager] uploadImageRequestWithParam:postData withToken:token withTime:time withFinishBlock:^(id responseObject, WTBaseRequest *request) {
//        if (request.resultData) {
//            NSArray *resultDic = (NSArray *)[request.resultData objectForKey:@"data"];
//            NSString *imageId;
//            if (IsExist_Array(resultDic)) {
//                 imageId = [resultDic objectAtIndex:0];
//            }
//            
//            NSError *error = nil;
//            BOOL isRemove = [fileManager removeItemAtPath:newPath error:&error];
//            NSLog(@"remove image!%@",isRemove?@"yes":@"no");
//            
//            if (finishBlock != nil) {
//                finishBlock(imageId, error);
//            }
//        }
//        else
//        {
//            
//            [CAToast showWithText:@""];
//        }
//
//    } failedBlock:^(id responseObject, NSError *error) {
//        finishBlock(nil, error);
//        [CAToast showWithText:@"上传失败，请重新上传！"];
//    }];
//}

@end
