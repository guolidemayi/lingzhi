//
//  GLD_ForumController.m
//  yxvzb
//
//  Created by yiyangkeji on 2017/4/21.
//  Copyright © 2017年 sendiyang. All rights reserved.
//

#import "GLD_ForumController.h"
#import "GLD_TMessageCell.h"
#import "GLD_DrawBut.h"
#import "GLD_ForumDetailController.h"
#import "GLD_AllDetailController.h"
#import "GLD_PostController.h"

#import "GLD_ForumModel.h"
#import "GLD_BMessageCell.h"
#import "GLD_TopicModel.h"
//#import "GLD_NewSearchControllor.h"
#import "GLD_BBSStandardView.h"
#import "SDCycleScrollView.h"
#import "GLD_BannerDetailController.h"
#import "GLD_BannerModel.h"

@interface GLD_ForumController ()<UITableViewDelegate, UITableViewDataSource,SDCycleScrollViewDelegate>
{
    NSArray *titleArr;
    NSInteger  pageNo;
//    NSMutableArray *forumListArrM;
    NSInteger addButIsShow;
}
@property (nonatomic, weak)UITableView *LTanTableView;
//@property (nonatomic, strong)UIView *topView;
@property (nonatomic, assign)CGFloat lastContentOffset;
@property (nonatomic, weak)UIButton *addBut;
@property (nonatomic, strong)NSMutableArray *forumListArrM;
@property (nonatomic, strong)GLD_NetworkAPIManager *NetManager;


@property (nonatomic, strong)SDCycleScrollView *cycleView;
@property (nonatomic, strong)GLD_BannerLisModel *bannerListModel;
@end

@implementation GLD_ForumController

- (void)viewDidLoad {
    [super viewDidLoad];
    pageNo = 1;
    _lastContentOffset = 700;
    addButIsShow = 2; //首次addBut为显示状态
    _forumListArrM = [NSMutableArray arrayWithCapacity:0];
    
    // Do any additional setup after loading the view.
    self.NetManager = [GLD_NetworkAPIManager new];
    [self addTableUP];
    
   
    [self getBannerData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self forumDetailRequest];
}
- (void)reLoadMainData{
    [self forumDetailRequest];
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    _lastContentOffset = scrollView.contentOffset.y;
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (_lastContentOffset > scrollView.contentOffset.y) {
        if(addButIsShow == 1) [self showFaTieBut];
    } else {
        if(addButIsShow == 2) [self dismissFaTieBut];
    }
}

- (void)showFaTieBut{
    
    addButIsShow = 0;
    [UIView animateWithDuration:.5 animations:^{
        self.addBut.transform = CGAffineTransformIdentity;
    }completion:^(BOOL finished) {
        addButIsShow = 2;
    }];
}
- (void)dismissFaTieBut{
     addButIsShow = 0;
    [UIView animateWithDuration:.5 animations:^{
        self.addBut.transform = CGAffineTransformMakeScale(0.001, 0.001);
    }completion:^(BOOL finished) {
        addButIsShow = 1;
    }];
}

- (void)forumDetailRequest{
    
    if (_forumListArrM.count > 0) {
        pageNo ++;
    } else {
        pageNo = 1;
    }

    NSInteger offset = self.forumListArrM.count;
    WS(weakSelf);
    
    GLD_APIConfiguration *config = [[GLD_APIConfiguration alloc]init];
    config.requestType = gld_networkRequestTypePOST;
    config.urlPath = @"api/comment/bbslist";
  
    config.requestParameters = @{@"limit":@"10",
                                 @"offset":[NSString stringWithFormat:@"%zd",offset]
                                 };
    [self.NetManager dispatchDataTaskWith:config andCompletionHandler:^(NSError *error, id result) {
        if (!error) {
//            [CAToast showWithText:@"认证成功"];
            GLD_ForumModel *model = [[GLD_ForumModel alloc]initWithDictionary:result error:nil];
//            GLD_ForumDetailModel *TZdetailModel
            [weakSelf.forumListArrM addObjectsFromArray:model.data];
            [weakSelf.LTanTableView reloadData];
        }else{
            [CAToast showWithText:@"网络错误"];
        }
        [weakSelf.LTanTableView.mj_header endRefreshing];
        [weakSelf.LTanTableView.mj_footer endRefreshing];
        
    }];
}


- (void)addTableUP{
    
    [self.LTanTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(-3 +(iPhoneXTopHeight ? 10 : 0));
    }];
    
    UIButton *addbut = [[UIButton alloc]init];
    [addbut addTarget:self action:@selector(addButClick) forControlEvents:UIControlEventTouchUpInside];
    [addbut setBackgroundImage:WTImage(@"Group 9 Copy") forState:UIControlStateNormal];
    [self.view addSubview:addbut];
    self.addBut = addbut;
    [addbut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(W(-15));
        make.bottom.equalTo(self.view).offset(H(-60));
        make.width.height.equalTo(WIDTH(60));
    }];
    
}

- (void)addButClick{
    if (!hasLogin) {
        [CAToast showWithText:@"请登陆"];
        return;
    }
    BOOL bbsStandard = [[NSUserDefaults standardUserDefaults] boolForKey:@"bbsStandard"];
    WS(weakSelf);
    if (bbsStandard){
        [GLD_BBSStandardView showBBSStandardView:^{
            [weakSelf sendBBSContent];
        }];
        return;
    }
    [weakSelf sendBBSContent];
}

- (void)sendBBSContent{
    //App-论坛-发表帖子
    GLD_PostController *postVc = [GLD_PostController instancePost:^{
        self.LTanTableView.contentOffset = CGPointMake(0, 0);
        [self.forumListArrM removeAllObjects];
        [self forumDetailRequest];
    }];            
    [self.navigationController pushViewController:postVc animated:YES];
}
//搜索
- (void)searchClick{
    //App-论坛-搜索
    
//    GLD_NewSearchControllor *searchVc = [[GLD_NewSearchControllor alloc]init];
//    [self.navigationController pushViewController:searchVc animated:NO];
}
#pragma uitableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _forumListArrM.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!IsExist_Array(_forumListArrM))return [[UITableViewCell alloc]init];
    GLD_ForumDetailModel *model = _forumListArrM[indexPath.row];
//    if ([model.type isEqualToString:@"2"]) {
//        //病例
//         return [self setBLMessageModel:model andIdexPath:indexPath];
//    }else if([model.type isEqualToString:@"4"]){
//        //课程答疑
//        return [self setBMessageModel:model andIdexPath:indexPath];
//    }
    return [self setTMessageModel:model andIdexPath:indexPath];
}

- (UITableViewCell *)setBLMessageModel:(GLD_ForumDetailModel *)model andIdexPath:(NSIndexPath *)indexPath{
    [self.LTanTableView registerClass:[GLD_TMessageCell class] forCellReuseIdentifier:GLD_TMessageCellIdentifi];
    GLD_TMessageCell *cell = [self.LTanTableView dequeueReusableCellWithIdentifier:GLD_TMessageCellIdentifi];
    cell.BLdetailModel = model;
    
    return cell;
}
- (UITableViewCell *)setTMessageModel:(GLD_ForumDetailModel *)model andIdexPath:(NSIndexPath *)indexPath{
    [self.LTanTableView registerClass:[GLD_TMessageCell class] forCellReuseIdentifier:GLD_TMessageCellIdentifi];
    GLD_TMessageCell *cell = [self.LTanTableView dequeueReusableCellWithIdentifier:GLD_TMessageCellIdentifi];
    cell.BLdetailModel = model;
    
    return cell;
}
- (UITableViewCell *)setBMessageModel:(GLD_ForumDetailModel *)model andIdexPath:(NSIndexPath *)indexPath{
    [self.LTanTableView registerClass:[GLD_BMessageCell class] forCellReuseIdentifier:GLD_BMessageCellIdentifi];
    GLD_BMessageCell *cell = [self.LTanTableView dequeueReusableCellWithIdentifier:GLD_BMessageCellIdentifi];
    cell.CCdetailModel = model;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return W(150);
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UITableViewHeaderFooterView *headView = [UITableViewHeaderFooterView new];
    [headView addSubview:self.cycleView];
    return headView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GLD_ForumDetailController *detailVc = [[GLD_ForumDetailController alloc]init];
    GLD_ForumDetailModel *Model = _forumListArrM[indexPath.row];
    detailVc.type = Model.type;
    detailVc.newsId = Model.newsId;
    detailVc.forumModel = Model;
    [self.navigationController pushViewController:detailVc animated:YES];
}
- (void)tieziButClick:(GLD_DrawBut *)but{
    
    GLD_AllDetailController *vc = [[GLD_AllDetailController alloc]init];
    vc.keywordModel = titleArr[but.tag];
    vc.topImgType = but.type;
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)getBannerData{
    WS(weakSelf);
    GLD_APIConfiguration *config = [[GLD_APIConfiguration alloc]init];
    config.requestType = gld_networkRequestTypePOST;
    config.urlPath = @"api/main/banner";
    config.requestParameters = @{@"type":@"3"};
    [self.NetManager dispatchDataTaskWith:config andCompletionHandler:^(NSError *error, id result) {
        
        weakSelf.bannerListModel = [[GLD_BannerLisModel alloc] initWithDictionary:result error:nil];
        NSMutableArray *arrM = [NSMutableArray array];
        for (GLD_BannerModel *model in weakSelf.bannerListModel.data) {
            [arrM addObject:GetString(model.Pic)];
        }
        if (arrM.count > 0) {
            weakSelf.cycleView.imageURLStringsGroup = arrM.copy;
        }
        [weakSelf.LTanTableView reloadData];
    }];
}
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"%zd", index);
    GLD_BannerDetailController *bannerVc =[GLD_BannerDetailController new];
    bannerVc.bannerModel = self.bannerListModel.data[index];
    [self.navigationController pushViewController:bannerVc animated:YES];
}
- (SDCycleScrollView *)cycleView{
    if (!_cycleView) {
        _cycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero
                                                        delegate:self
                                                placeholderImage:[UIImage imageNamed:@"tabbar_icon0_normal"]];
        
        
        _cycleView.autoScrollTimeInterval = 3;// 自动滚动时间间隔
        _cycleView.autoScroll = YES;
        _cycleView.frame = CGRectMake(0, 0, DEVICE_WIDTH, W(150));
        //        _cycleView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;// 翻页 右下角
    }
    return _cycleView;
}
- (UITableView *)LTanTableView{
    if (!_LTanTableView) {
        UITableView *table = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        table.delegate = self;
        table.dataSource = self;
        table.estimatedRowHeight = 0;
        table.estimatedSectionHeaderHeight = 0;
        table.estimatedSectionFooterHeight = 0;
        [table setSeparatorInset:UIEdgeInsetsMake(0, W(15), 0, W(15))];
        WS(weakSelf);
        table.mj_header = [GLD_RefreshHeader headerWithRefreshingBlock:^{
            [weakSelf.forumListArrM removeAllObjects];
            weakSelf.bannerListModel = nil;
            [weakSelf getBannerData];
            [weakSelf forumDetailRequest];
        }];
        table.mj_footer = [YXFooterRefresh footerWithRefreshingBlock:^{
            [weakSelf forumDetailRequest];
        }];
        table.rowHeight = W(140);
        table.sectionFooterHeight = 0.001;
        [self.view addSubview:table];
        _LTanTableView = table;
    }
    return _LTanTableView;
}

@end
