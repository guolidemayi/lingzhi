//
//  GLD_ZFBCashCell.m
//  lingzhi
//
//  Created by yiyangkeji on 2018/2/2.
//  Copyright © 2018年 com.lingzhi. All rights reserved.
//

#import "GLD_ZFBCashCell.h"

@interface GLD_ZFBCashCell ()

@property (weak, nonatomic) IBOutlet UIImageView *noticeImgV;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@end

@implementation GLD_ZFBCashCell


+ (GLD_ZFBCashCell *)cellWithReuseIdentifier:(NSString *)reuseIdentifier{
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:reuseIdentifier owner:nil options:nil];
    GLD_ZFBCashCell *cell = (GLD_ZFBCashCell*)[topLevelObjects firstObject];
    cell.noticeImgV.hidden = YES;
    return cell;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    NSUInteger proposedNewLength = textField.text.length - range.length + string.length;
//    
//    if (proposedNewLength > 11) {
//        return NO;//限制长度
//    }
//    if (-textField.text.floatValue + [AppDelegate shareDelegate].userModel.cash1 <= 0) {
//        
//        textField.textColor = [UIColor redColor];
//        self.tipLabel.text = @"当前余额不足";
//        
//    }else{
//        textField.textColor = [UIColor blackColor];
//        self.tipLabel.text = @"输入一个最多两位小数的数字";
//    }
//    if (proposedNewLength > 3) {
//        NSString *str = [NSString stringWithFormat:@"当前手续费：%.2lf元",textField.text.floatValue * 0.02];
//        self.tipLabel.text = str;
//    }else if(proposedNewLength > 0){
//        
//    }else if(proposedNewLength == 0){
//        
//        self.tipLabel.text = @"输入一个最多两位小数的数字";
//    }
    return YES;
}

@end
