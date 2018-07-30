//
//  GLD_BaseCell.m
//  lingzhi
//
//  Created by yiyangkeji on 2017/11/29.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_BaseCell.h"

@implementation GLD_BaseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
        [self layout];
    }
    return self;
}
- (void)awakeFromNib{
    [super awakeFromNib];
     self.selectionStyle = UITableViewCellSelectionStyleNone;
}
- (void)setupUI{
    
}

- (void)layout{
    
}
@end
