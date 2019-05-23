//
//  GLD_NormsVIew.m
//  lingzhi
//
//  Created by 锅里的 on 2019/5/16.
//  Copyright © 2019 com.lingzhi. All rights reserved.
//

#import "GLD_NormsVIew.h"

@interface GLD_NormsVIew ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textFeild;
@property (nonatomic, copy) void(^finishBlock)(NSString *key);
@end
@implementation GLD_NormsVIew

+ (instancetype)showInWindow:(void(^)(NSString *key))finishBlock{
    GLD_NormsVIew *norsV = [[NSBundle mainBundle]loadNibNamed:@"GLD_NormsVIew" owner:nil options:nil].firstObject;
    norsV.finishBlock = finishBlock;
    [KEYWINDOW addSubview:norsV];
    norsV.frame = KEYWINDOW.bounds;
    return norsV;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        return NO;
    }
    NSString *rangeStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (rangeStr.length > 10) {
        [CAToast showWithText:@"最多10个字"];return NO;
    }
    return YES;
}
- (IBAction)closeClick:(id)sender {
    [self removeFromSuperview];
}
- (IBAction)sureClick:(id)sender {
    if (self.textFeild.text.length == 0) {
        [CAToast showWithText:@"请输入规格"];
        return;
    }
    if (self.finishBlock) {
        [self removeFromSuperview];
        self.finishBlock(self.textFeild.text);
    }
}


@end
