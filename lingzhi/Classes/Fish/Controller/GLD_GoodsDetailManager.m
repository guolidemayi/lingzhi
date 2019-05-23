//
//  GLD_GoodsDetailManager.m
//  lingzhi
//
//  Created by yiyangkeji on 2018/7/30.
//  Copyright © 2018年 com.lingzhi. All rights reserved.
//

#import "GLD_GoodsDetailManager.h"
#import "SDCycleScrollView.h"
#import "GLD_GoodsDetailCell.h"
#import "GLD_PictureCell.h"
#import "GLD_PictureView.h"
#import "GLD_GoodsDetailCell.h"
#import "GLD_GoodsPicCell.h"

@interface GLD_GoodsDetailManager ()<SDCycleScrollViewDelegate>

@property (nonatomic, strong)SDCycleScrollView *cycleView;
@property (nonatomic, strong) NSArray *dataArr;
@end
@implementation GLD_GoodsDetailManager


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UITableViewHeaderFooterView *headView = [UITableViewHeaderFooterView new];
    if (section > 0) return headView;
    [headView addSubview:self.cycleView];
    return headView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section)return 0.001;
    return 250;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section) {
        return self.dataArr.count;
    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        CGFloat titleH = [YXUniversal calculateCellHeight:0 width:300 text:self.storeModel.title font:15];
        CGFloat contentH = [YXUniversal calculateCellHeight:0 width:300 text:self.storeModel.summary font:15];
        return titleH + contentH + 100;
    }
    return H(200);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section) {
        return [self getGoodsPicCell:indexPath];
    }
    return [self getGoodsDetailCell:indexPath];
}
- (GLD_GoodsDetailCell *)getGoodsDetailCell:(NSIndexPath *)indexPath{
    GLD_GoodsDetailCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"GLD_GoodsDetailCell"];
    cell.storeModel = self.storeModel;
    return cell;
}
- (GLD_GoodsPicCell *)getGoodsPicCell:(NSIndexPath *)indexPath{
    GLD_GoodsPicCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"GLD_GoodsPicCell"];
    NSString *str = self.dataArr[indexPath.row];
    if (str.length > 0) {
        
        [cell.pic yy_setImageWithURL:[NSURL URLWithString:str] placeholder:WTImage(@"")];
    }
    return cell;
}
- (void)setStoreModel:(GLD_StoreDetailModel *)storeModel{
    _storeModel = storeModel;
    self.dataArr = [storeModel.pic componentsSeparatedByString:@","];
}
- (void)setComponentCorner{
    [self.tableView registerNib:[UINib nibWithNibName:@"GLD_GoodsDetailCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"GLD_GoodsDetailCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLD_GoodsPicCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"GLD_GoodsPicCell"];
//    self.tableView.rowHeight = H(200);
}
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"%zd", index);
    if([self.storeModel.pic containsString:@","]){
        NSArray *arr = [self.storeModel.pic componentsSeparatedByString:@","];
      
        GLD_PictureView * broser = [[GLD_PictureView alloc]initWithImageArray:arr currentIndex:index];
        
        [broser show];
    }
}
- (SDCycleScrollView *)cycleView{
    if (!_cycleView) {
        _cycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero
                                                        delegate:self
                                                placeholderImage:[UIImage imageNamed:@"tabbar_icon0_normal"]];
        
        if([self.storeModel.pic containsString:@","]){
            NSArray *arr = [self.storeModel.pic componentsSeparatedByString:@","];
            
            _cycleView.imageURLStringsGroup = arr;
        }else{
           _cycleView.imageURLStringsGroup = @[self.storeModel.pic];
        }
        _cycleView.autoScrollTimeInterval = 3;// 自动滚动时间间隔
        _cycleView.autoScroll = YES;
        _cycleView.frame = CGRectMake(0, 0, DEVICE_WIDTH, (250));
        //        _cycleView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;// 翻页 右下角
    }
    return _cycleView;
}
- (void)fetchMainData{
    [self.tableView.mj_header endRefreshing];
    [self.tableView reloadData];
//    GLD_APIConfiguration *config = [[GLD_APIConfiguration alloc]init];
//    config.urlPath = storeGoodsDetailRequest;
//
//    [super dispatchDataTaskWith:config andCompletionHandler:^(NSError *error, id result) {
//        if (!error) {
//
//        }
//    }];
}

- (void)reloadOrLoadMoreData{
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
}
@end
