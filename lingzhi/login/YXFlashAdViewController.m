//
//  YXFlashAdViewController.m
//  yxvzb
//
//  Created by sunming on 16/5/5.
//  Copyright © 2016年 sendiyang. All rights reserved.
//

#import "YXFlashAdViewController.h"


@interface YXFlashAdViewController ()
{
    
    UserADsModel *_adModel;
    BOOL          _isPopFormAd;
}

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic,assign)NSInteger iCount;
@property (nonatomic, weak)UIButton *endBut;
@end

@implementation YXFlashAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _isPopFormAd = NO;
    _iCount = 0;
    [self outLayoutSelfSubviews];
    
    self.imageV_flash.frame = CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT);
    [self.imageV_flash addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(flash_ImageClick)]];
    self.imageV_flash.image = [UIImage imageNamed:@"yanzhanye"];
    self.imageV_flash.userInteractionEnabled = YES;
    UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(DEVICE_WIDTH-100, 15, 80, 40)];
        self.endBut = but;
    but.layer.cornerRadius = 5;
    but.layer.masksToBounds = YES;
    but.alpha = 0.8;
    but.titleLabel.font = WTFont(15);
    but.backgroundColor = [YXUniversal colorWithHexString:COLOR_YX_DRAKwirte];
        [but setTitle:@"跳过" forState:UIControlStateNormal];
        but.hidden = YES;
        [but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [but addTarget:self action:@selector(tiaoguoButClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:but];
    
    [self getStartPicRequest];
    
}

- (void)tiaoguoButClick{
    _adModel = nil;
    [self endAds];
    
}

-(void)getStartPicRequest{
    
    
    NSArray *adArr = [YXFlashAdViewController readDiskAllCache];
    
    //获取系统当前日期
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init]; //初始化格式器。
        [formatter setDateFormat:@"MMddHHmm"];//定义时间为这种格式： YYYY-MM-dd hh:mm:ss 。
    NSString *currentTime = [formatter stringFromDate:[NSDate date]];
    CGFloat currentT = [currentTime floatValue];
    //遍历数组确定显示广告
    for (UserADsModel *model in adArr) {
        
        NSString *startTime =[YXUniversal intervalToDate:[model.startUsingTime longLongValue] withFormat:@"MMddHHmm"];
        NSString *endTime =[YXUniversal intervalToDate:[model.endUsingTime longLongValue] withFormat:@"MMddHHmm"];
      
        
        if (currentT > [startTime floatValue] && currentT < [endTime floatValue]) {
            
            _adModel = model;
            //拿到图片
            NSString *path_document = NSHomeDirectory();
            //设置一个图片的存储路径
            NSString *imagePath = [path_document stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@.png",model.adId]];
            UIImage *img = [UIImage imageWithContentsOfFile:imagePath];
            self.imageV_flash.image = img;
            [self startTimer];
            break;
        }
        
        if (currentT > [endTime floatValue]) {
            //移除
            [YXFlashAdViewController removeAdsList:model];
            
            [YXFlashAdViewController deleteBenDiFile:model];
        }
    }
    
    [self endAds];
}

+ (void)deleteBenDiFile: (UserADsModel *)model{
 
    NSString *documentsDirectory = NSHomeDirectory();
 
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    NSString *MapLayerDataPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/Documents/%@.png",model.adId]];
    
    BOOL bRet = [fileMgr fileExistsAtPath:MapLayerDataPath];
    
    if (bRet) {
        
        NSError *err;
        
        [fileMgr removeItemAtPath:MapLayerDataPath error:&err];
        if (err) {
            NSLog(@"%@", err);
        }
        
    }
    
}

- (void)endAds{
    
    if (!_adModel) {
            [[AppDelegate shareDelegate] initMainPageBody];
            //                [[AppDelegate shareDelegate] gotoSuccessView];
    }
}

+ (NSString *)path {
    return [NSString stringWithFormat:@"%@/Documents/adsObject/",NSHomeDirectory()];
}

+ (NSString *)cachePlistDirectory {
    return [NSString stringWithFormat:@"%@/Documents/GLDCachePlistDirectory/",NSHomeDirectory()];
}

+ (NSString *)plistPath {
    return [NSString stringWithFormat:@"%@GLDww.plist",[YXFlashAdViewController cachePlistDirectory]];
}

+ (UserADsModel *)readDiskCache:(NSString *)key {
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[NSString stringWithFormat:@"%@%@",[YXFlashAdViewController path],key]];
}

+ (void)createCacheDirectory:(NSString *)path {
    NSFileManager * fm = [NSFileManager defaultManager];
    BOOL isDirectory = YES;
    if (![fm fileExistsAtPath:path isDirectory:&isDirectory]) {
        [fm createDirectoryAtPath:path
      withIntermediateDirectories:YES
                       attributes:@{NSFileProtectionKey:NSFileProtectionNone} error:nil];
    }
}

+ (void)writeDiskCache: (UserADsModel *)model {
    if (model != nil) {
        [YXFlashAdViewController createCacheDirectory:[YXFlashAdViewController path]];
        [NSKeyedArchiver archiveRootObject:model
                                    toFile:[NSString stringWithFormat:@"%@%@",[YXFlashAdViewController path],model.adId]];
        [YXFlashAdViewController createCacheDirectory:[YXFlashAdViewController cachePlistDirectory]];
        NSMutableDictionary * cacheDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:[YXFlashAdViewController plistPath]];
        if (cacheDictionary == nil) {
            cacheDictionary = [NSMutableDictionary dictionary];
        }
        [cacheDictionary setObject:@"GLD" forKey:model.adId];
        [cacheDictionary writeToFile:[YXFlashAdViewController plistPath] atomically:YES];
    }
}
+ (void)removeAdsList: (UserADsModel *)model{
    
    NSFileManager * fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:[NSString stringWithFormat:@"%@%@",[YXFlashAdViewController path],model.adId]]) {
        [fm removeItemAtPath:[NSString stringWithFormat:@"%@%@",[YXFlashAdViewController path],model.adId] error:nil];
        NSMutableDictionary * cacheDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:[YXFlashAdViewController plistPath]];
        if (cacheDictionary != nil) {
            [cacheDictionary removeObjectForKey:model.adId];
            [cacheDictionary writeToFile:[YXFlashAdViewController plistPath] atomically:YES];
        }
    }
}
+ (NSArray *)readDiskAllCache {
    NSMutableArray * downloadObjectArr = [NSMutableArray array];
    NSMutableDictionary * cacheDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:[YXFlashAdViewController plistPath]];
    if (cacheDictionary != nil) {
        NSArray * allKeys = [cacheDictionary allKeys];
        for (NSString * key in allKeys) {
            [downloadObjectArr addObject:[YXFlashAdViewController readDiskCache:key]];
        }
    }
    return downloadObjectArr.copy;
}

+ (void)removeAllObj{
    
    NSMutableDictionary * cacheDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:[YXFlashAdViewController plistPath]];
    if (cacheDictionary != nil) {
        NSArray * allKeys = [cacheDictionary allKeys];
        for (NSString * key in allKeys) {
           UserADsModel *model = [YXFlashAdViewController readDiskCache:key];
            [YXFlashAdViewController removeAdsList:model];
        }
    }
}

// 广告页显示时长定时器
#pragma mark -- button Timer
-(void)startTimer
{
//    _iCount = _adModel.waitingTime;
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(moveTime) userInfo:nil repeats:YES];
    }
}

-(void)moveTime
{
    _iCount++;
    if(_iCount == 2){
        
        self.endBut.hidden = NO;
    }
    if (_iCount == _adModel.waitingTime) {
       
        
    
        if(self.timer){
            [self.timer invalidate];
            self.timer = nil;
            self.iCount = 0;
            _adModel = nil;
            [self endAds];
        }
    }
}

- (void)flash_ImageClick{
    
    NSString *type = _adModel.redirectType;
    NSInteger adNum = 0;
    
    if(self.timer && IsExist_String(type)){
        [self.timer invalidate];
        self.timer = nil;
         [[UIApplication sharedApplication] setStatusBarHidden:NO];
        _isPopFormAd = YES;
    }
   
    
}

- (void)viewWillAppear:(BOOL)animated{
    if (_isPopFormAd) {
        _adModel = nil;
        [self endAds];
    }
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)dealloc
{
    NSLog(@"sele");
}
@end
