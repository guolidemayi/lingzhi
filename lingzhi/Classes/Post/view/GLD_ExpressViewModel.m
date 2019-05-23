//
//  GLD_ExpressViewModel.m
//  lingzhi
//
//  Created by 锅里的 on 2019/5/15.
//  Copyright © 2019 com.lingzhi. All rights reserved.
//

#import "GLD_ExpressViewModel.h"
#import "GLD_ExpressModel.h"
@interface GLD_ExpressViewModel ()

@property (nonatomic, strong) GLD_ExpressModel *expressModel;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) CGFloat contentHeight;
@property (nonatomic, strong) NSString *sendPhoneStr;
@property (nonatomic, strong) NSString *sendPersonStr;
@property (nonatomic, strong) NSString *receivedPhoneStr;
@property (nonatomic, strong) NSString *receivedPersonStr;
@property (nonatomic, strong) NSURL *goodsPic;
@property (nonatomic, strong) NSString *price;
@end
@implementation GLD_ExpressViewModel
- (instancetype)initWithModel:(GLD_ExpressModel *)model{
    if (self = [super init]) {
        self.expressModel = model;
    }
    return self;
}

- (void)setExpressModel:(GLD_ExpressModel *)expressModel{
    _expressModel = expressModel;
    
    CGFloat width = 80;
    if(expressModel.type.integerValue == 2)
        width = 300;
    self.contentHeight = MAX([YXUniversal calculateCellHeight:0 width:width text:expressModel.title font:(12)], 60);
    CGFloat addressHeight = MAX([YXUniversal calculateCellHeight:0 width:100 text:expressModel.start font:12], [YXUniversal calculateCellHeight:0 width:100 text:expressModel.end font:12]);
    
    self.cellHeight = 60 + self.contentHeight + MAX(addressHeight, 30);
    self.sendPhoneStr = [NSString stringWithFormat:@"手机号：%@",expressModel.phone];
    self.sendPersonStr = [NSString stringWithFormat:@"发件人：%@",expressModel.name];
    self.receivedPhoneStr = [NSString stringWithFormat:@"收件人：%@",expressModel.receivedPhone];
    self.receivedPersonStr = [NSString stringWithFormat:@"手机号：%@",expressModel.receivedPerson];
    self.goodsPic = [NSURL URLWithString:expressModel.goodsPic];
    self.price = [NSString stringWithFormat:@"¥ %zd",expressModel.price];
}
@end
