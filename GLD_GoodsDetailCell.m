//
//  GLD_GoodsDetailCell.m
//  
//
//  Created by yiyangkeji on 2018/7/30.
//

#import "GLD_GoodsDetailCell.h"


@interface GLD_GoodsDetailCell ()
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *priceLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *storeTitleLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *StoreDetailLabel;

@end

@implementation GLD_GoodsDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
