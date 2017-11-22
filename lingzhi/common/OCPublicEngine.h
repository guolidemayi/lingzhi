#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MTShareView.h"
//#import "OCInputTradeCodeView.h"
//#import "OCDatePickerView.h"

@protocol OCPublicEngineDelegate <NSObject>

- (void)wachatShareSuccess: (NSString *)formStr;

@end

@interface OCPublicEngine : NSObject
+ (OCPublicEngine *) getInstance;
@property (weak, nonatomic) id<OCPublicEngineDelegate> delegate;
@property (strong, nonatomic)NSString *fromString;

#pragma mark - 登录的处理
- (void)phoneNumloginHandle:(NSString *)phoneNum pwdStr:(NSString *)pwdStr isAutoLogin:(BOOL)isAutoLogin;

- (void)openLoginHandleWithOpenId:(NSString *)openId token:(NSString *)token isAutoLogin:(BOOL)isAutoLogin successBlock:(void (^)(NSString *thirdUserId))successBlock;

- (void)clearAutoLoginAccountData;
//add share view
+ (void)showShareViewWithType:(ShareViewType)type withDelegate:(UIViewController*)delegate shareText:(NSString *)tagStr shareUrl:(NSString *)tagUrl shareDetail:(NSString *)detailText shareImage:(NSString *)shareImgae shareTitle:(NSString *)title;

+ (void)showImageShareViewWithType:(ShareViewType)type withDelegate:(UIViewController *)delegate image:(UIImage *)image shareUrl:(NSString *)url originalImage:(NSData *)originalImage;
////add input code view
//+ (void)showInputCodeViewWithtype:(InputCodeViewType)type withDelegate:(UIViewController *)delegate;
//
////add date picker view
//+(void)showDatePickerViewWithDelegate:(id)delegate;
//
////add picker select data view
//+(void)showPicerSelectViewWithDelegate:(id)delegate withData:(id)data;
//
////
//+ (void)uploadUserPhotoWithType:(UploadImageType)uploadType withFinishBlock:(void (^)(NSString *imageId, NSError *error))finishBlock;
@end
