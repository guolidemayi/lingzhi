//
//  Created by 王卫 on 16/10/13.
//  Copyright © 2016年 医洋科技. All rights reserved.
//

#import "YXRecordButton.h"

@implementation YXRecordButton

+ (instancetype)creatButWithTitle:(NSString *)title andImageStr:(NSString *)imgStr andFont:(NSInteger)font andTextColorStr:(NSString *)colorStr {


    YXRecordButton *but = [[YXRecordButton alloc] init];

    [but setTitle:title forState:UIControlStateNormal];

    if (imgStr) {

        [but setImage:[UIImage imageNamed:imgStr] forState:UIControlStateNormal];

    }
    [but setTitleColor:[YXUniversal colorWithHexString:colorStr] forState:UIControlStateNormal];

    but.titleLabel.font = WTFont(font);

    return but;

}

@end
