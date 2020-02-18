//
//  GLD_BusinessDetailManager.m
//  lingzhi
//
//  Created by yiyangkeji on 2017/12/4.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_BusinessDetailManager.h"
#import "GLD_DetailRankCell.h"
#import "GLD_DetaileCell.h"
#import "GLD_DetaileBusiCell.h"
#import "GLD_DetailIntroCell.h"
#import "SDCycleScrollView.h"
#import "GLD_BusnessModel.h"
#import "GLD_StoreDetailCell.h"
#import "GLD_GoodsDetailController.h"
#import "GLD_PictureView.h"
#import "GLDPhotoGroupBrowser.h"
#import "GLDPictureCell.h"

@interface GLD_BusinessDetailManager ()<SDCycleScrollViewDelegate>
@property (nonatomic, strong)SDCycleScrollView *cycleView;
@property (nonatomic, strong) NSArray *pidtureArr;

@end
@implementation GLD_BusinessDetailManager

- (void)reloadOrLoadMoreData{
//    [self fetchMainData];
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
}
- (void)setComponentCorner{
    [self.tableView registerClass:[GLD_DetailRankCell class] forCellReuseIdentifier:GLD_DetailRankCellIdentifier];
    [self.tableView registerClass:[GLD_DetaileCell class] forCellReuseIdentifier:GLD_DetaileCellIdentifier];
    [self.tableView registerClass:[GLD_DetaileBusiCell class] forCellReuseIdentifier:GLD_DetaileBusiCellIdentifier];
    [self.tableView registerClass:[GLD_DetailIntroCell class] forCellReuseIdentifier:GLD_DetailIntroCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"GLD_StoreDetailCell" bundle:nil] forCellReuseIdentifier:@"GLD_StoreDetailCell"];
     [self.tableView registerNib:[UINib nibWithNibName:@"GLDPictureCell" bundle:nil] forCellReuseIdentifier:@"GLDPictureCell"];
    
}
- (void)fetchMainData{
    WS(weakSelf);
    GLD_APIConfiguration *config = [[GLD_APIConfiguration alloc]init];
    config.requestType = gld_networkRequestTypePOST;
    config.urlPath = getShopGoodsListRequest;
    config.requestParameters = @{
                                 @"userId":GetString(self.busnessModel.userId)
                                 };
    
    [super dispatchDataTaskWith:config andCompletionHandler:^(NSError *error, id result) {
        if(error){
            [CAToast showWithText:@"网络出错"];
            
        }else{
           
            GLD_StoreDetaiListlModel *model = [[GLD_StoreDetaiListlModel alloc]initWithDictionary:result error:nil];
            if (model.data.count > 0) {
                [weakSelf.mainDataArrM addObjectsFromArray:model.data];
                [weakSelf.tableView.mj_footer endRefreshing];
            }else{
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView reloadData];
            
        }
        
    }];
}
- (void)setBusnessModel:(GLD_BusnessModel *)busnessModel{
    _busnessModel = busnessModel;
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 3) {
        GLD_GoodsDetailController *goodsVc = [GLD_GoodsDetailController new];
        goodsVc.storeModel = self.mainDataArrM[indexPath.row];
        goodsVc.type = 3;
        [self.tableView.navigationController pushViewController:goodsVc animated:YES];
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 3) {
        return self.mainDataArrM.count;
    }
    if (section == 2) {
        return self.pidtureArr.count + 1;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:{
            return [self getDetailIntroCell:indexPath];
        }break;
        case 1:{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            }
            cell.textLabel.textColor = [YXUniversal colorWithHexString:COLOR_YX_DRAKBLUE];
            NSString *str = ![self.busnessModel.busnessType isEqualToString:@"2"] ? @"普通商家":@"高级商家";
            cell.textLabel.text = str;
            cell.textLabel.font = WTFont(15);
            cell.imageView.image = WTImage(@"体验店图标");
            return cell;
        }break;
        case 2:{
            if (indexPath.row) {
                return [self getPictureCell:indexPath];
            }
            return  [self getDetailCell:indexPath];
            
        }break;
        case 3:{
            return [self getDetailRankCell:indexPath];
        }break;
    }
    return [UITableViewCell new];
}

- (GLDPictureCell *)getPictureCell:(NSIndexPath *)indexPath{
    NSString *str = self.pidtureArr[indexPath.row-1];
    GLDPictureCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"GLDPictureCell"];
    [cell.bgImageV yy_setImageWithURL:[NSURL URLWithString:str] placeholder:nil];
    return cell;
    
}
- (GLD_DetailIntroCell *)getDetailIntroCell:(NSIndexPath *)indexPath{
    GLD_DetailIntroCell *cell = [self.tableView dequeueReusableCellWithIdentifier:GLD_DetailIntroCellIdentifier];
    cell.busnessModel = self.busnessModel;
    return cell;
}
- (GLD_DetaileCell *)getDetailCell:(NSIndexPath *)indexPath{
    GLD_DetaileCell *cell = [self.tableView dequeueReusableCellWithIdentifier:GLD_DetaileCellIdentifier];
    cell.instroStr = self.busnessModel.desc;
    return cell;
}
- (GLD_StoreDetailCell *)getDetailRankCell:(NSIndexPath *)indexPath{
    GLD_StoreDetailCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"GLD_StoreDetailCell"];
    cell.storeModel = self.mainDataArrM[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:{
            return W(120);
        } break;
        case 1:{
            return W(50);
        } break;
        case 2:{
            if (indexPath.row) {
                return W(375);
            }
            CGFloat height = [YXUniversal calculateCellHeight:0 width:300 text:self.busnessModel.desc font:14];
            return W(50)+height;
        } break;
        case 3:{
            return W(120);
        } break;
    }
    return 0.001;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section != 0) return [UIView new];
    UITableViewHeaderFooterView *headerView = [[UITableViewHeaderFooterView alloc]init];
    UIImageView * imgV = [[UIImageView alloc]init];
    [imgV yy_setImageWithURL:[NSURL URLWithString:self.busnessModel.logo] placeholder:nil];
    [headerView.contentView addSubview:self.cycleView];
    
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) return W(375);
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}


- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    if ([self.busnessModel.logo containsString:@","]) {
               
        NSArray *arrM = [self.busnessModel.logo componentsSeparatedByString:@","];
        NSMutableArray *arr = [NSMutableArray array];
        for (int i = 0; i < arrM.count-1; i++) {
            
            NSString *str = arrM[i];
            if ([str hasPrefix:@"http"]) {
                [arr addObject:str];
            }
        }
           
        __block NSMutableArray *newArrM = [NSMutableArray array];
           [arr enumerateObjectsUsingBlock:^(NSString  * obj, NSUInteger idx, BOOL * _Nonnull stop) {
               if (IsExist_String(obj)) {
                   GLDPhotoItem *item = [GLDPhotoItem new];
                   item.thumbView = nil;
                   item.largeImage = obj;
                   [newArrM addObject:item];
               }
           }];
           
           GLDPhotoGroupBrowser *bre = [[GLDPhotoGroupBrowser alloc]initWithGroupItems:arrM];
           
           [bre presentFromImageView:self.cycleView toContainer:KEYWINDOW animated:YES currentPage:index completion:^{
               
           }];
    }
}
- (SDCycleScrollView *)cycleView{
    if (!_cycleView) {
        _cycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero
                                                        delegate:self
                                                placeholderImage:[UIImage imageNamed:@"tabbar_icon0_normal"]];
        if ([self.busnessModel.logo containsString:@","]) {
            
            NSArray *arrM = [self.busnessModel.logo componentsSeparatedByString:@","];
            NSMutableArray *arr = [NSMutableArray array];
            for (int i = 0; i < arrM.count-1; i++) {
                
                NSString *str = arrM[i];
                if ([str hasPrefix:@"http"]) {
                    [arr addObject:str];
                }
            }
            
            if (arrM.count > 0) {
                self.pidtureArr = arrM;
                _cycleView.imageURLStringsGroup = arr.copy;
            }
        }else{
            self.pidtureArr = @[GetString(self.busnessModel.logo)];
            _cycleView.imageURLStringsGroup = @[GetString(self.busnessModel.logo)];
        }
//        _cycleView.autoScrollTimeInterval = 3;// 自动滚动时间间隔
        _cycleView.autoScroll = NO;
        _cycleView.frame = CGRectMake(0, 0, DEVICE_WIDTH, W(375));
        [self.tableView reloadData];
        //        _cycleView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;// 翻页 右下角
    }
    return _cycleView;
}
@end
