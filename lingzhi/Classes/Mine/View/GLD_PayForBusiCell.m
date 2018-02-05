//
//  GLD_PayForBusiCell.m
//  lingzhi
//
//  Created by rabbit on 2018/2/3.
//  Copyright © 2018年 com.lingzhi. All rights reserved.
//

#import "GLD_PayForBusiCell.h"
#import "GLD_BusinessDetailController.h"
#import "GLD_BusnessModel.h"

@interface GLD_PayForBusiCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImgV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UITextField *cashField;

@end
@implementation GLD_PayForBusiCell

+ (GLD_PayForBusiCell *)cellWithReuseIdentifier:(NSString *)reuseIdentifier{
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:reuseIdentifier owner:nil options:nil];
    GLD_PayForBusiCell *cell = (GLD_PayForBusiCell*)[topLevelObjects firstObject];
    
    return cell;
}

- (void)setBusnessModel:(GLD_BusnessModel *)busnessModel{
    _busnessModel = busnessModel;
    
    [self.iconImgV yy_setImageWithURL:[NSURL URLWithString:busnessModel.logo] placeholder:nil];
    self.nameLabel.text = busnessModel.name;
}
- (IBAction)visitBusiBut:(id)sender {
    
    
    GLD_BusinessDetailController *detaileVc = [GLD_BusinessDetailController new];
    detaileVc.busnessModel = self.busnessModel;
    [self.contentView.navigationController pushViewController:detaileVc animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSLog(@"-----------%@,%@,%@\n",textField.text,string,NSStringFromRange(range));
    NSMutableString *strM = textField.text.mutableCopy;
    [strM replaceCharactersInRange:range withString:string ];
    if ([self.payDelegate respondsToSelector:@selector(updatePayCash:)]) {
        [self.payDelegate updatePayCash:strM];
    }
    return YES;
}
@end
