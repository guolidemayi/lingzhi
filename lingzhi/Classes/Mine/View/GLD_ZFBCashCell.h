//
//  GLD_ZFBCashCell.h
//  lingzhi
//
//  Created by yiyangkeji on 2018/2/2.
//  Copyright © 2018年 com.lingzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GLD_ZFBCashCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *cashField;
+ (GLD_ZFBCashCell *)cellWithReuseIdentifier:(NSString *)reuseIdentifier;
@end
