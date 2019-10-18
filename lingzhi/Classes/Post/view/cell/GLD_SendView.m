//
//  GLD_SendView.m
//  lingzhi
//
//  Created by 锅里的 on 2019/5/14.
//  Copyright © 2019 com.lingzhi. All rights reserved.
//

#import "GLD_SendView.h"
#import "GLD_ExpressListController.h"
#import "GLD_ShareAppViewController.h"


@interface GLD_SendView ()
@property (weak, nonatomic) IBOutlet UIImageView *paoTuiImageV;
@property (weak, nonatomic) IBOutlet UIImageView *daiMaiImageV;
@property (weak, nonatomic) IBOutlet UIImageView *bangBanImageV;
@property (weak, nonatomic) IBOutlet UIImageView *shareImageV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftCanterC;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightCenterC;

@end
@implementation GLD_SendView

+ (instancetype)instanceSendView{
    GLD_SendView *sendView = [[NSBundle mainBundle]loadNibNamed:@"GLD_SendView" owner:nil options:nil].firstObject;
    [sendView initdata];
    return sendView;
}

- (void)initdata{
    
    self.rightCenterC.constant = W(89);
    self.leftCanterC.constant = W(-89);
    GLD_APIConfiguration *config = [[GLD_APIConfiguration alloc]init];
    config.urlPath = deliveryCategoryRequest;
    config.requestParameters = @{
                                 };
    WS(weakSelf);
    [[GLD_NetworkAPIManager shareNetManager] dispatchDataTaskWith:config andCompletionHandler:^(NSError *error, id result) {
        if (!error) {
            NSArray *arr = result[@"data"];
            for (int i = 0; i < arr.count; i++) {
                NSDictionary *dcit = arr[i];
                NSString *str = dcit[@"photo"];
                if (![str isKindOfClass:[NSString class]]) {
                    return ;
                }
                switch (i) {
                    case 0:
                        [weakSelf.paoTuiImageV yy_setImageWithURL:[NSURL URLWithString:str] placeholder:WTImage(@"")];
                        break;
                    case 1:
                        [weakSelf.daiMaiImageV yy_setImageWithURL:[NSURL URLWithString:str] placeholder:WTImage(@"")];
                        break;
                    case 2:
                        [weakSelf.bangBanImageV yy_setImageWithURL:[NSURL URLWithString:str] placeholder:WTImage(@"")];
                        break;
                    case 3:
                        [weakSelf.shareImageV yy_setImageWithURL:[NSURL URLWithString:str] placeholder:WTImage(@"")];
                        break;
                }
            }
        }else{
            [CAToast showWithText:@"请求失败，请重试"];
        }
        
    }];
}
- (void)awakeFromNib{
    [super awakeFromNib];
    [self.paoTuiImageV addGestureRecognizer:[self getTapGesture]];
    [self.daiMaiImageV addGestureRecognizer:[self getTapGesture]];
    [self.bangBanImageV addGestureRecognizer:[self getTapGesture]];
    [self.shareImageV addGestureRecognizer:[self getTapGesture]];
}
- (void)tapClick:(UITapGestureRecognizer *)tap{
    UIView *view = tap.view;
    NSInteger type = 0;//0跑腿 1 帮办 2 代买 4 快递
    if (view == self.paoTuiImageV) {
        type = 2;
    }else if(view == self.daiMaiImageV){
        type = 3;
    }else if(view == self.bangBanImageV){
        type = 4;
    }else if(view == self.shareImageV){
        GLD_ShareAppViewController *viewC = [GLD_ShareAppViewController new];
        [self.navigationController pushViewController:viewC animated:YES];
        return;
    }
    GLD_ExpressListController *expressVc = [[GLD_ExpressListController alloc]initWithType:type];
    
    [self.navigationController pushViewController:expressVc animated:YES];
}
- (UITapGestureRecognizer *)getTapGesture{
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    
    return tap;
}


@end
