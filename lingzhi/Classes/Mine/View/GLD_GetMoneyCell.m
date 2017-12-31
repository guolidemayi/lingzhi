//
//  GLD_GetMoneyCell.m
//  lingzhi
//
//  Created by yiyangkeji on 2017/12/28.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_GetMoneyCell.h"

@interface GLD_GetMoneyCell ()
@property (weak, nonatomic) IBOutlet UITextField *textFeild;
@property (weak, nonatomic) IBOutlet UIImageView *noticeImgV;
@property (weak, nonatomic) IBOutlet UILabel *needPayLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *helpLabel;

@end
@implementation GLD_GetMoneyCell

+ (GLD_GetMoneyCell *)cellWithReuseIdentifier:(NSString *)reuseIdentifier{
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:reuseIdentifier owner:nil options:nil];
    GLD_GetMoneyCell *cell = (GLD_GetMoneyCell*)[topLevelObjects firstObject];
    cell.noticeImgV.hidden = YES;
    return cell;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSUInteger proposedNewLength = textField.text.length - range.length + string.length;
    
        if (proposedNewLength > 11) {
            return NO;//限制长度
        }
    if (-textField.text.floatValue + [AppDelegate shareDelegate].userModel.cash1.floatValue <= 0) {
        
        textField.textColor = [UIColor redColor];
        self.helpLabel.text = @"当前余额不足";
        
    }else{
        textField.textColor = [UIColor blackColor];
        self.helpLabel.text = @"输入一个最多两位小数的数字";
    }
    if (proposedNewLength > 3) {
        NSString *str = [NSString stringWithFormat:@"当前手续费：%.2lf元",textField.text.floatValue * 0.02];
        self.needPayLabel.text = str;
    }else if(proposedNewLength > 0){
        self.needPayLabel.text = @"当前手续费：2.00元";
    }else if(proposedNewLength == 0){
        self.needPayLabel.text = @"当前手续费：0.00元";
        self.helpLabel.text = @"输入一个最多两位小数的数字";
    }
    return YES;
}
@end
