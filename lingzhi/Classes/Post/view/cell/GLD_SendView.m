//
//  GLD_SendView.m
//  lingzhi
//
//  Created by 锅里的 on 2019/5/14.
//  Copyright © 2019 com.lingzhi. All rights reserved.
//

#import "GLD_SendView.h"
#import "GLD_ExpressListController.h"
#import "CollectionViewController.h"


@interface GLD_SendView ()
@property (weak, nonatomic) IBOutlet UIImageView *paoTuiImageV;
@property (weak, nonatomic) IBOutlet UIImageView *daiMaiImageV;
@property (weak, nonatomic) IBOutlet UIImageView *bangBanImageV;
@property (weak, nonatomic) IBOutlet UIImageView *shareImageV;

@end
@implementation GLD_SendView

+ (instancetype)instanceSendView{
    GLD_SendView *sendView = [[NSBundle mainBundle]loadNibNamed:@"GLD_SendView" owner:nil options:nil].firstObject;
    
    return sendView;
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
        
    }else if(view == self.daiMaiImageV){
        type = 2;
    }else if(view == self.bangBanImageV){
        type = 1;
    }else if(view == self.shareImageV){
        CollectionViewController *viewC = [CollectionViewController new];
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
