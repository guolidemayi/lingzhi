//
//  GLD_ExpressAddressView.m
//  lingzhi
//
//  Created by yiyangkeji on 2018/8/13.
//  Copyright © 2018年 com.lingzhi. All rights reserved.
//

#import "GLD_ExpressAddressView.h"


@interface GLD_ExpressAddressView ()
@property (weak, nonatomic) IBOutlet UITextField *phoneTextFeild;
@property (weak, nonatomic) IBOutlet UITextField *addressTextFeild;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (nonatomic, strong)GLD_NetworkAPIManager *netManager;
@property (nonatomic, copy)void (^sureBlick)(void);
@end
@implementation GLD_ExpressAddressView


+ (instancetype)expressAddressView:(void(^)(void))sureBlock{
    NSString *className = NSStringFromClass([self class]);
    UINib *nib = [UINib nibWithNibName:className bundle:nil];
    
    GLD_ExpressAddressView *view = [nib instantiateWithOwner:nil options:nil].firstObject;
    view.sureBlick = sureBlock;
    [[AppDelegate shareDelegate].window addSubview:view];
    view.frame = [AppDelegate shareDelegate].window.bounds;
    return view;
}
- (void)awakeFromNib{
    [super awakeFromNib];
    [self setCompent];
}
- (void)setCompent{
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)]];
    self.userInteractionEnabled = YES;
    self.backgroundColor = [YXUniversal colorWithHexString:COLOR_YX_DRAKblackNew alpha:.3];
    self.bgView.backgroundColor = [UIColor whiteColor];
    self.bgView.layer.cornerRadius = 5;
    self.bgView.layer.masksToBounds = YES;
    self.netManager = [GLD_NetworkAPIManager new];
}
- (void)tap{
    [self endEditing:YES];
}
- (IBAction)sureButClick:(id)sender {
    
    if (!IsExist_String(self.addressTextFeild.text)) {
        [CAToast showWithText:@"请输入地址"];
        return;
    }
    if (!IsExist_String(self.phoneTextFeild.text)) {
        [CAToast showWithText:@"请输入联系电话"];
        return;
    }
    GLD_APIConfiguration *config = [[GLD_APIConfiguration alloc]init];
    
    config.urlPath = mailAdressRequest;
    config.requestParameters = @{@"userId":GetString([AppDelegate shareDelegate].userModel.userId),
                                 @"phone":self.phoneTextFeild.text,
                                 @"address":self.addressTextFeild.text
                                 };
    WS(weakSelf);
    [self.netManager dispatchDataTaskWith:config andCompletionHandler:^(NSError *error, id result) {
        if (!error) {
            [CAToast showWithText:@"提交成功"];
            [weakSelf removeFromSuperview];
            weakSelf.sureBlick();
        }else{
            [CAToast showWithText:@"提交失败,请重试"];
        }
    }];
}
- (IBAction)cancleButClick:(UIButton *)sender {
    
    [self removeFromSuperview];
}

@end
