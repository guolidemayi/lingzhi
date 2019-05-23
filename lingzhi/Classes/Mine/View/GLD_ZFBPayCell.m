//
//  GLD_ZFBPayCell.m
//  lingzhi
//
//  Created by yiyangkeji on 2018/2/2.
//  Copyright © 2018年 com.lingzhi. All rights reserved.
//

#import "GLD_ZFBPayCell.h"

@implementation GLD_ZFBPayCell

+ (GLD_ZFBPayCell *)cellWithReuseIdentifier:(NSString *)reuseIdentifier{
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:reuseIdentifier owner:nil options:nil];
    GLD_ZFBPayCell *cell = (GLD_ZFBPayCell*)[topLevelObjects firstObject];

    return cell;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
@end
