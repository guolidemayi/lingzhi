//
//  GLD_PictureCell.h
//  yxvzb
//
//  Created by yiyangkeji on 2017/4/27.
//  Copyright © 2017年 sendiyang. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol  GLD_PictureCellDelegate <NSObject>

- (void)deletePicture:(NSInteger)index;

@end
@interface GLD_PictureCell : UICollectionViewCell
@property (nonatomic , weak)UIImageView *picImageV;
@property (nonatomic, weak)UIButton *deleteBut;
@property (nonatomic, weak)id<GLD_PictureCellDelegate> delegate;
@end
