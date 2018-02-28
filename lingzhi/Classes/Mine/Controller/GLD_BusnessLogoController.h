//
//  GLD_BusnessLogoController.h
//  lingzhi
//
//  Created by yiyangkeji on 2018/2/28.
//  Copyright © 2018年 com.lingzhi. All rights reserved.
//

#import "GLD_BaseViewController.h"

@interface GLD_BusnessLogoController : GLD_BaseViewController

+(instancetype)instancePost:(void (^)(NSData *data, NSString *jsonStr))postReloadBlock;
@end
