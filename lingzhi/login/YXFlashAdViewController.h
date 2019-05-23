//
//  YXFlashAdViewController.h
//  yxvzb
//
//  Created by sunming on 16/5/5.
//  Copyright © 2016年 sendiyang. All rights reserved.
//

#import "GLD_BaseViewController.h"
#import "UserADsModel.h"

@interface YXFlashAdViewController : GLD_BaseViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageV_flash;

@property (nonatomic,assign)BOOL isfirstLogin;


+ (void)writeDiskCache: (UserADsModel *)model;
+ (NSArray *)readDiskAllCache;
+ (void)removeAllObj;
@end
