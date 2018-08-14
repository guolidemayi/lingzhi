#ifndef Constants_h
#define Constants_h

#define MAINSCREEN_BOUNDS   [UIScreen mainScreen].bounds
#define DEVICE_WIDTH        [UIScreen mainScreen].bounds.size.width
#define DEVICE_HEIGHT       [UIScreen mainScreen].bounds.size.height
#define STATUS_HEIGHT       [UIApplication sharedApplication].statusBarFrame.size.height
#define NAVIGATION_HEIGHT   44.0
#define TAB_HEIGHT          49.0
#define NAVBAR_HEIGHT 64
#define MAIN_VIEW_HEIGHT    (DEVICE_HEIGHT - NAVIGATION_HEIGHT)
#define DEVICEWIDTH_SCALE   (DEVICE_WIDTH / 375.0)
#define DEVICEHEIGHT_SCALE  (DEVICE_HEIGHT / 667)
//点击视频讲座通知name
#define NotificationCenterName  @"NotificationCenterClickName"
// for 事件上报
// appid
#define kTCCloudPlayerSDKTestAppId @"1251132611"
#define AppleStoreURL @"https://itunes.apple.com/cn/app/yi-sheng-hui/id1108784538?mt=8"
// logid
#define kTCCloudPlayerSDKTestLogId @"100043"

//get current device size
#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size)) : NO)

#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) || (CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size)&&CGSizeEqualToSize(CGSizeMake(375, 667), [[UIScreen mainScreen] bounds].size))) : NO)

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640,1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640,960), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhoneX ([[UIDevice deviceModel] isEqualToString:Device_iPhoneX])
#define iPhoneXTopHeight ([UIScreen mainScreen].bounds.size.height == 812 ? 24 : 0)
#define iPhoneXBottomHeight ([UIScreen mainScreen].bounds.size.height == 812 ? 34 : 0)
//get current device size

//international
#define XNSLocalizedString(key, comment) [WTUniversal NSlocalizedStingKey:(key)]


//
#define KAUTORESIZINGMask (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)

/** String: System Version **/
#define SYSTEM_VERSION ( [[[UIDevice currentDevice ] systemVersion ] integerValue] )

#define WTImage(_image) [UIImage imageNamed:_image]
#define WTFont(_fontSize) [UIFont systemFontOfAdaptSize:_fontSize]
//屏幕适配
#define WIDTH(_width) @((_width) * DEVICEWIDTH_SCALE)
#define HEIGHT(_height) @((_height) * DEVICEHEIGHT_SCALE)
#define W(_width) ((_width) * DEVICEWIDTH_SCALE)
#define H(_height) ((_height) * DEVICEHEIGHT_SCALE)

#define WS(weakSelf)  __weak __typeof(self)weakSelf = self;


#define IsExist_Array(_array) (_array!= nil && _array.count>0)
#define IsExist_String(_str) (_str!=nil && _str.length!=0 && ![_str isEqualToString:@""])
#define GetString(_str) (IsExist_String(_str) ? _str: @"1")

//神策统计
#define SensorsAnalyticsTimeBegin(_name) [[SensorsAnalyticsSDK sharedInstance] trackTimerBegin:_name]
#define SensorsAnalyticsTimeEnd(_name, _propertis) [[SensorsAnalyticsSDK sharedInstance] trackTimerEnd:_name withProperties:_propertis]

#define SensorsAnalyticsTrack(_name, _propertis) [[SensorsAnalyticsSDK sharedInstance] track:_name withProperties:_propertis]



#define GLD_SOBOTKIT_APPKEY             @"88ac95b9fc9d47cbb669827c33da6c8a"
#define YX_UPLOAD_KEY                   @"lljjddsszz"
#define YX_HMACMD5_KEY                  @"FILEAAFFAAB"
#define PASSWORD_HMACMD5_KEY            @"LIVEXASXLBD"
//color
#define COLOR_YX_BLUE1          @"#025AFA"
#define COLOR_YX_BLUE           @"#609ce5"
#define COLOR_YX_LIGHT_BLUE     @"#BBD8F9"
#define COLOR_YX_GRAY_TEXT      @"#808080"
#define COLOR_YX_GRAY_SECTION   @"#cccccc"
#define COLOR_YX_EMPTY_SECTION  @"#f5f7f6"
#define COLOR_YX_RED_TEXT       @"#FC4738"
#define COLOR_YX_GRAY_BUTTON    @"#9B9C9D"
#define COLOR_YX_BLUE_TABLE     @"F3F7F7"
#define COLOR_YX_HUI            @"#CACACA"
#define COLOR_YX_LINEVIEW       @"#F8F8F8F"
#define COLOR_YX_LINETITLE              @"#F9F9F9"
#define COLOR_YX_DRAKBLUE               @"#027cfa"
#define COLOR_YX_DRAKgray               @"#878f9e"
#define COLOR_YX_DRAKgray2              @"#878787"
#define COLOR_YX_DRAKblack              @"#4a4a4a"
#define COLOR_YX_DRAKblackNew           @"#191919"
#define COLOR_YX_DRAKyellow             @"#027cfa"//nav颜色
#define COLOR_YX_DRAKwirte              @"#ffffff"
#define COLOR_YX_DRAKgray3              @"#707070"
#define COLOR_YX_DRAKgrayBIANK          @"#8F9395"
#define COLOR_YX_DRAKgrayNEI            @"#D5D8E0"
#define COLOR_YX_GRAY_TEXTBLACK         @"#161616"
#define COLOR_YX_GRAY_TEXTRED           @"#F63636"
#define COLOR_YX_GRAY_TEXTnewGray       @"#666666"
#define COLOR_YX_GRAY_TEXTline          @"#E5E5E5"
#define COLOR_YX_GRAY_TEXTTopLine       @"#EBEBEB"
#define COLOR_YX_GRAY_TEXTlineGray      @"#D8D8D8"
#define COLOR_YX_GRAY_TEXTGrayTable     @"#F3F3F3"
#define COLOR_YX_GRAY_TEXTline2Gray     @"#999999"
#define COLOR_YX_GRAY_TEXTred           @"#E42B18"
#define COLOR_YX_GRAY_TEXTorange        @"#FF7100"
#define COLOR_YX_GRAY_TEXTyellow        @"#FFDA8B"
#define COLOR_YX_GRAY_TEXTlightorange   @"#FFB900"
#define COLOR_YX_GRAY_tableFooter       @"#EEEEEE"
#define COLOR_YX_GRAY_butbackColor      @"#FFFFFF"
#define COLOR_YX_ANSWER_BLUEColor       @"#A5F0FF"
#define COLOR_YX_SIGNUPColor            @"#9FCDFD"
#define COLOR_YX_Text_Red               @"#F35A5A"
#define COLOR_YX_shadowColor            @"#000000"
#define COLOR_YX_shadowColor2           @"#7B7B7B"
#define COLOR_YX_tableViewBgColor       @"#F2F4F7"
#define COLOR_YX_courseButColor         @"#FAB202"
#define COLOR_YX_GREANColor             @"#58CD46"
#define COLOR_YX_UpdateColor            @"#F2F2F2"
#define COLOR_YX_cuteBuleColor          @"#E5F2FF"
#define COLOR_YX_cutePinkColor          @"#FFE9E9"
#define COLOR_YX_blackLabelColor        @"#888888"
#define COLOR_YX_blueLabelColor         @"#017BF8"


//string
#define STR_ZHUSHU              @"• 主诉 病史 •"
#define STR_CHATI               @"• 查体 辅查 •"
#define STR_ZHENDUAN            @"• 诊断 治疗 •"
#define STR_SUIFAN              @"• 随访 讨论 •"

//cell
#define YX_TABLE_LIMIT          @"15"

#define LIVECELLID              @"LiveCell"
#define BANNERCELLID            @"BannerCell"
//border width
#define KBorderWidth 1.0
#define Scroll_error 0.6

//userDefault
#define isFirstLogin @"isFirstLogin"
#define LastLoginPhoneNum @"lastLoginPhoneNum"
#define LastLoginPassword @"lastLoginPassword"
#define ThirdAuthKey @"thirdAuthKey"
#define LastLoginTypeKey @"lastLoginTypeKey"
#define ServiceName @"com.shendiyang.yxvzb"
#define Last_YXVZB_WeiXinAuthOpenId @"last_yxvzb_WeiXinAuthOpenId"

#define Live_SigninBottomView @"signinBottomView"

//红点
#define myChannelapperRedPoint @"myChannelapperRedPoint" //频道红点
#define myMeetingApperRedPoint @"myMeetingApperRedPoint" //会议红点


//第三方分享宏定义
//微信
#define WeiXinAppKey @"wx007f5aef7d8bbc0a"
//微信登陆
#define WeiXinAppSecret @"02d671e1a891e42d721dae8dd42999a5"
#define WeiXinAuthScope @"snsapi_message,snsapi_userinfo,snsapi_friend,snsapi_contact"
#define WeiXinAuthState @"MingTieWeiXinAuth"


//微博
#define kSinaAppKey     @"3349785626"
#define kRedirectURI    @"http://www.sina.com"
//qq
#define __TencentDemoAppid_  @"1105309423"

//第三方分享使用
#define ShareIconPath [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"share_logo"]
#define ShareTitleStr @"我在医生汇等你加入！精华都在这里哟~"
#define ShareDetailStr @"医生汇-专家临床讲座直播，医生社区有问必答"

//分享帖子
#define SHARE_QA(SERVER, QAID) [NSString stringWithFormat:@"%@/bbs/qa?qaId=%@&toShare=1",SERVER, QAID];
//分享课程
#define SHARE_COURSE(SERVER, COURSEID) [NSString stringWithFormat:@"%@/course/detail?id=%@&shareFlag=true",SERVER, COURSEID];
//个人主页、科室主页、集团主页
#define SHARE_PERSONAL(SERVER, PID) [NSString stringWithFormat:@"%@/lecturer/details?userId=%@&toShare=1",SERVER, PID];
//用户协议
#define USER_PROTOCOL_URL   @"about/xieyi/xieyi.html"

//实现分页需要用到的一些常量
#define LOADMORE_BOTTOM_HEIGHT 52.0f//用于判断是否上划到底了
#define LOADMORE_PRECENT 0.8//上划到总页面长度的80%即开始加载更多
#define SCROLLDIS 25//判断scrollView滚动的方向
#define PAGINGCOUNT 10//分页时每页请求的数量
#define MaxNumberOfInputTitleChars  16//组织云和活动云标题的长度限制
#define MaxNumberOfDescriptionChars  500//简介和反馈的字数限制


#if __has_feature(objc_arc)
#define __AUTORELEASE(x)   (x)
#define __RELEASE(x)       (x) = nil;
#define __RETAIN(x)        (x)
#define __SUPER_DEALLOC    ;
#else
#define __RETAIN(x)      [(x) retain];
#define __AUTORELEASE(x) [(x) autorelease];

#define __RELEASE(x) \
if(nil != (x)) \
{\
[(x) release];\
(x) = nil;\
}
#define __SUPER_DEALLOC    [super dealloc];
#endif

#pragma mark - 公用的结构体
typedef enum LanguageType {
    English = 0,
    Chinese
} LanguageType;

typedef enum {
    ShowViewMaskTypeNone = 0, // allow user interactions while HUD is displayed
    ShowViewMaskTypeClear = 1, // don't allow
    ShowViewMaskTypeBlack = 2, // don't allow and dim the UI in the back of the HUD
    ShowViewMaskTypeGradient = 3 // don't allow and dim the UI with a a-la-alert-view bg gradient

} ShowViewMaskType;



//CG_INLINE CGRect WTCGRectMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
CG_INLINE CGRect WTCGRectMake(CGRect frame) {
    //NSLog(@"height+++++:%f===%f",NAVIGATION_HEIGHT,DEVICE_HEIGHT);
    CGRect rect;
    CGFloat heightConsult = (DEVICE_HEIGHT - STATUS_HEIGHT - NAVIGATION_HEIGHT) / 603;
    CGFloat widthConsult = (DEVICE_WIDTH) / 375;

    if (frame.size.height == 667 - NAVIGATION_HEIGHT - STATUS_HEIGHT) {
        heightConsult = (DEVICE_HEIGHT - NAVIGATION_HEIGHT - STATUS_HEIGHT) / 603;
    } else if (frame.size.height == 667) {
        heightConsult = DEVICE_HEIGHT / 667;
    }

    if (!iPhone4 && (frame.size.width * heightConsult - DEVICE_WIDTH) < 1 && (frame.size.height * heightConsult == DEVICE_HEIGHT || frame.size.height * heightConsult == DEVICE_HEIGHT - NAVIGATION_HEIGHT - STATUS_HEIGHT)) {
        CGRect rect = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width * widthConsult, frame.size.height * heightConsult);
        return rect;
    }

    if (iPhone4) {
        CGFloat consult4 = 568.0 / 667.0;
        CGPoint center = CGPointMake((frame.origin.x + frame.size.width / 2) * consult4, (frame.origin.y + frame.size.height / 2) * heightConsult);
        CGFloat _width = frame.size.width * consult4;
        CGFloat _height = frame.size.height * heightConsult;

        rect.origin.x = center.x - _width / 2;
        rect.origin.y = center.y - _height / 2;
        rect.size.width = _width;
        rect.size.height = _height;

    } else {

        CGPoint center = CGPointMake((frame.origin.x + frame.size.width / 2) * widthConsult, (frame.origin.y + frame.size.height / 2) * heightConsult);

        CGFloat _width = frame.size.width * widthConsult;
        CGFloat _height = frame.size.height * heightConsult;


        rect.origin.x = center.x - _width / 2;
        rect.origin.y = center.y - _height / 2;
        rect.size.width = _width;
        if (frame.size.width == 375.0) {
            rect.size.width = DEVICE_WIDTH;
        }
        if (frame.size.height == 1.0) {
            _height = 1.0;
        }
        if (frame.origin.y + frame.size.height == 603 || frame.origin.y + frame.size.height == 667) {
            if (iPhone6) {
                _height = _height + 10;
            } else if (iPhone6Plus) {
                _height = _height + 19;
            } else if (iPhone5) {

            }
        }

        rect.size.height = _height;
    }
    return rect;
}

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
//


//noti

#define RECIV_EQRCODEPAY_ACTION @"reciveQRCodePayAction"

#endif /* Constants_h */
