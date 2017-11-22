#import <Foundation/Foundation.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentOAuthObject.h>
#import "TencentOpenAPI/QQApiInterface.h"
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MFMessageComposeViewController.h>

typedef NS_ENUM (NSInteger) {
    QZone = 1,//QQ空间
    QQFriends = 2,//QQ好友
} QQShareToPlatformType;

@protocol WXApiManagerDelegate <NSObject>

@optional

- (void)managerDidRecvMessageResponse:(SendMessageToWXResp *)response;

- (void)managerDidRecvAuthResponse:(SendAuthResp *)response;

- (void)onResp:(BaseResp *)resp;

@end

@protocol ShareModuleDelegate <NSObject>

@optional
- (void)wechatAuthLoginResponse:(NSDictionary *)responseDic;

- (void)qqAuthLoginResponse:(TencentOAuth *)authResponse;

- (void)wechatSuccess;

@end


@interface MTShareModule : NSObject <TencentSessionDelegate, TCAPIRequestDelegate, QQApiInterfaceDelegate, WXApiManagerDelegate, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate>

@property(nonatomic, weak) id <ShareModuleDelegate> authRespDelegate;
@property (assign, nonatomic) int wxMedia;

//单例
+ (MTShareModule *)getInstance;

/**
  分享到QQ
 */
- (void)shareQQ;

/**
 * 分享到QQ空间
 */
- (void)shareQzone;

/**
 * 分享到新浪微博
 */
- (void)shareSina;

/**
 * 分享到微信好友
 */
- (void)shareWeChat;

/**
 * 分享到微信朋友圈
 */
- (void)shareFriendCircle;

/**
 * 短信分享
 */
- (void)shareSMS;

/**
 * 邮件分享
 */
- (void)shareEmail:(NSString *)targetEmail;

- (void)loginByQQ;

- (void)loginByWechatWithViewCtrlDelegate:(UIViewController *)viewCtrlDelegate;

+ (BOOL)getQQAppIsInstalled;

+ (BOOL)getWechatAppIsInstalled;

+ (BOOL)getWeiboAppIsInstalled;

/**
 * 接收新浪微博分享后的响应函数
 */
- (void)sinaShareResp:(NSString *)errcodeStr;

@property(strong, nonatomic) NSString *str_shareText;
@property(strong, nonatomic) NSString *str_shareUrl;
@property(strong, nonatomic) NSString *str_shareDetailText;
@property(nonatomic, strong) NSString *str_shareImage;

@property(nonatomic, strong) UIImage *img;
@property(nonatomic, strong) NSString *url;
@property(nonatomic, strong) NSData *originalImage;

@end

@interface WXApiManager : NSObject <WXApiDelegate>

@property(nonatomic, weak) id <WXApiManagerDelegate> delegate;

+ (instancetype)sharedManager;

@end
