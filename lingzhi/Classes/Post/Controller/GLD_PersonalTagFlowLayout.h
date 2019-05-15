//
//  GLD_PersonalTagFlowLayout.h
//  xiyouji
//
//  Created by 锅里的 on 2019/2/21.
//  Copyright © 2019 Westrip. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger,AlignType){
    AlignWithLeft,
    AlignWithCenter,
    AlignWithRight
};
@interface GLD_PersonalTagFlowLayout : UICollectionViewFlowLayout

@property (nonatomic,assign)CGFloat betweenOfCell;
//cell对齐方式
@property (nonatomic,assign)AlignType cellType;

-(instancetype)initWthType : (AlignType)cellType;
//全能初始化方法 其他方式初始化最终都会走到这里
-(instancetype)initWithType:(AlignType) cellType betweenOfCell:(CGFloat)betweenOfCell;
@end

NS_ASSUME_NONNULL_END
