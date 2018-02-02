//
//  GLD_ZFBPayCell.h
//  lingzhi
//
//  Created by yiyangkeji on 2018/2/2.
//  Copyright © 2018年 com.lingzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GLD_ZFBPayCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *accountField;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *remarksField;


+ (GLD_ZFBPayCell *)cellWithReuseIdentifier:(NSString *)reuseIdentifier;
@end
