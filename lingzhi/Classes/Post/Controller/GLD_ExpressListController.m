//
//  GLD_ExpressListController.m
//  lingzhi
//
//  Created by yiyangkeji on 2018/7/31.
//  Copyright © 2018年 com.lingzhi. All rights reserved.
//

#import "GLD_ExpressListController.h"
#import "GLD_ExpressCell.h"
#import "MapNavigationManager.h"
#import "GLD_PostExpressController.h"
#import "SDCycleScrollView.h"
#import "GLD_BannerModel.h"
#import "GLD_BannerDetailController.h"

@interface GLD_ExpressListController ()<UITableViewDelegate,UITableViewDataSource,GLD_ExpressCellDelegate,SDCycleScrollViewDelegate>{
    NSInteger offset;
    NSInteger pagNo;
    UIView  *_remindView;
    UIView  *_commentView;
}
@property (nonatomic, weak)UIView *topView;
@property (nonatomic, weak)UIImageView *bgImageV;
@property (nonatomic, weak)UIImageView *changeImgV;
@property (nonatomic, weak)UIButton *lastBut;
@property (nonatomic, weak)UIButton *MyBut;
@property (nonatomic, weak)UIImageView *redPoint;
@property (nonatomic, weak)UIScrollView *bottomScrollView;
@property (nonatomic, weak)UITableView *remindTable;
@property (nonatomic, weak)UITableView *commentTable;
@property (nonatomic, strong)NSMutableArray *remindArrM;
@property (nonatomic, strong)NSMutableArray *commentArrM;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong)SDCycleScrollView *cycleView;
@property (nonatomic, strong)GLD_BannerLisModel *bannerListModel;
@end

@implementation GLD_ExpressListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"同城快送";
    
    _remindArrM = [NSMutableArray array];
    _commentArrM = [NSMutableArray array];
    offset = 0;
    pagNo = 0;
   
    self.NetManager = [GLD_NetworkAPIManager shareNetManager];
    [self setupTopView];
    [self layoutTopView];
    [self setContentView];
//    [self getCommentMessageContent];
   
    [self getBannerData];
    [self setUpNav];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [self getRemindMessageContent];
}
- (void)setUpNav
{
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"header_back_icon"] style:UIBarButtonItemStyleDone target:self action:@selector(pop)];
    self.navigationItem.leftBarButtonItem = backItem;
    UIBarButtonItem *sendItem = [[UIBarButtonItem alloc]initWithTitle:@"发表" style:UIBarButtonItemStyleDone target:self action:@selector(sendExpress)];
    self.navigationItem.rightBarButtonItem = sendItem;
}
- (void)pop
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)sendExpress{
    UIStoryboard *store = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    GLD_PostExpressController *postVc = [store instantiateViewControllerWithIdentifier:@"GLD_PostExpressController"];
    [self.navigationController pushViewController:postVc animated:YES];
}
- (void)getRemindMessageContent{
    WS(weakSelf);
    [self.remindArrM removeAllObjects];
    [self getDataRequest:@{@"city":IsExist_String([AppDelegate shareDelegate].placemark.area_name)? [AppDelegate shareDelegate].placemark.area_name :@"北京",
                           @"lat":@([AppDelegate shareDelegate].placemark.lat),
                           @"lng":@([AppDelegate shareDelegate].placemark.lon),
                           @"type":@(0)
                           } andComplentBlock:^(id result) {
        GLD_ExpressListModel *listModel = [[GLD_ExpressListModel alloc]initWithDictionary:result error:nil];
        
        if (listModel.data.count > 0) {
            [weakSelf.remindArrM addObjectsFromArray:listModel.data];
            [weakSelf.remindTable.mj_footer endRefreshing];
        }else{
            [weakSelf.remindTable.mj_footer endRefreshingWithNoMoreData];
        }
        [weakSelf.remindTable.mj_header endRefreshing];
        [weakSelf.remindTable reloadData];
    }];
    
}
- (void)getCommentMessageContent{
    WS(weakSelf);
    [self.commentArrM removeAllObjects];
    [self getDataRequest:@{@"userId":GetString([AppDelegate shareDelegate].userModel.userId),
                           @"type":@(1),
                           @"city":IsExist_String([AppDelegate shareDelegate].placemark.area_name)? [AppDelegate shareDelegate].placemark.area_name :@"北京",
                           } andComplentBlock:^(id result) {
        GLD_ExpressListModel *listModel = [[GLD_ExpressListModel alloc]initWithDictionary:result error:nil];
        
        if (listModel.data.count > 0) {
            [weakSelf.commentArrM addObjectsFromArray:listModel.data];
            [weakSelf.commentTable.mj_footer endRefreshing];
        }else{
            [weakSelf.commentTable.mj_footer endRefreshingWithNoMoreData];
        }
        [weakSelf.commentTable.mj_header endRefreshing];
        [weakSelf.commentTable reloadData];
    }];
    
   
}

- (void)getDataRequest:(NSDictionary *)parame andComplentBlock:(void(^)(id result))complentBlock{
    
    GLD_APIConfiguration *config = [[GLD_APIConfiguration alloc]init];
    config.requestType = gld_networkRequestTypePOST;
    config.urlPath = expressRequest;
    config.requestParameters = parame;
    [self.NetManager dispatchDataTaskWith:config andCompletionHandler:^(NSError *error, id result) {
        if (!error) {
        }else{
            [CAToast showWithText:@"网络错误"];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            complentBlock(result);
        });
        
    }];
}


- (void)getBannerData{
    WS(weakSelf);
    GLD_APIConfiguration *config = [[GLD_APIConfiguration alloc]init];
    config.requestType = gld_networkRequestTypePOST;
    config.urlPath = @"api/main/banner";
    config.requestParameters = @{@"type":@"4"};
    [self.NetManager dispatchDataTaskWith:config andCompletionHandler:^(NSError *error, id result) {
        
        weakSelf.bannerListModel = [[GLD_BannerLisModel alloc] initWithDictionary:result error:nil];
        NSMutableArray *arrM = [NSMutableArray array];
        for (GLD_BannerModel *model in weakSelf.bannerListModel.data) {
            [arrM addObject:GetString(model.Pic)];
        }
        if (arrM.count > 0) {
            weakSelf.cycleView.imageURLStringsGroup = arrM.copy;
        }
        [weakSelf.remindTable reloadData];
    }];
}
#pragma GLD_ExpressCellDelegate
- (void)robExpress:(GLD_ExpressModel *)model andType:(robType)type{
    switch (type) {
        case robTypeMyExpress:{
//            CLLocationCoordinate2D coordinate;
//            coordinate.latitude = model.latitude;
//            coordinate.longitude = model.longitude;
//            [MapNavigationManager showSheetWithCoordinate2D:coordinate];
        }break;
        case robTypeGetExpress:{
            model.state = 1;
            [self toRobExpressRequest:model];
        }break;
        case robTypeHasRob:{
            //完成
            model.state = 2;
        }break;
    }
}

- (void)toRobExpressRequest:(GLD_ExpressModel *)model{
    GLD_APIConfiguration *config = [[GLD_APIConfiguration alloc]init];
    config.requestType = gld_networkRequestTypePOST;
    config.urlPath = robExpressRequest;
    config.requestParameters = @{@"id":GetString(model.expressId),
                                 @"userId":GetString([AppDelegate shareDelegate].userModel.userId),
                                 @"status":@(model.state)
                                 };
    [self.NetManager dispatchDataTaskWith:config andCompletionHandler:^(NSError *error, id result) {
        if (!error) {
            [CAToast showWithText:@"请求成功"];
        }else{
            [CAToast showWithText:@"网络错误"];
        }
    }];
}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (section > 0 || [tableView isEqual:self.commentTable]) return 0.01;
//    return W(150);
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    if ([tableView isEqual:self.commentTable]) return nil;
//    UITableViewHeaderFooterView *headView = [UITableViewHeaderFooterView new];
//    if (section > 0) return headView;
//    [headView addSubview:self.cycleView];
//    return headView;
//}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:self.remindTable]) {
        return _remindArrM.count;
    }else{
        return _commentArrM.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if ([tableView isEqual:self.remindTable]) {
        return [self getRemindCell:indexPath andTableView:tableView];
    }else{
        
        return [self getCommentCell:indexPath andTableView:tableView];
    }
    
    return [UITableViewCell new];
}

//
//
- (GLD_ExpressCell *)getRemindCell:(NSIndexPath *)indexPath andTableView : (UITableView *)tableView{

    GLD_ExpressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLD_ExpressCell" forIndexPath:indexPath];
    
//    cell.type = robTypeGetExpress;
    cell.expressDelegate = self;
    if (IsExist_Array(_remindArrM))
        cell.expressModel = _remindArrM[indexPath.row];;
    return cell;

}
- (GLD_ExpressCell *)getCommentCell:(NSIndexPath *)indexPath andTableView : (UITableView *)tableView{

    GLD_ExpressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLD_ExpressCell" forIndexPath:indexPath];
   cell.expressDelegate = self;
//    cell.type = robTypeMyExpress;
    if(IsExist_Array(_commentArrM))
        cell.expressModel = _commentArrM[indexPath.row];
    return cell;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return H(160);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (void)MyButClick: (UIButton *)senser{
    
    _commentView.hidden = YES;
    self.changeImgV.image = [UIImage imageNamed:@"右tab"];
    [_MyBut setTitleColor:[YXUniversal colorWithHexString:COLOR_YX_DRAKwirte] forState:UIControlStateNormal];
    [_lastBut setTitleColor:[YXUniversal colorWithHexString:COLOR_YX_DRAKBLUE] forState:UIControlStateNormal];
    [UIView animateWithDuration:0.1 animations:^{
        
        self.changeImgV.frame = self.MyBut.frame;
        [self.view layoutIfNeeded];
    }];
    self.bottomScrollView.contentOffset = CGPointMake(DEVICE_WIDTH, 0);
    if (!IsExist_Array(self.commentArrM))
    [self getCommentMessageContent];
}

- (void)lastButClick: (UIButton *)senser{
    
    _remindView.hidden = YES;
    
    self.changeImgV.image = [UIImage imageNamed:@"左tab"];
    [_MyBut setTitleColor:[YXUniversal colorWithHexString:COLOR_YX_DRAKBLUE] forState:UIControlStateNormal];
    [_lastBut setTitleColor:[YXUniversal colorWithHexString:COLOR_YX_DRAKwirte] forState:UIControlStateNormal];
    
    [UIView animateWithDuration:0.1 animations:^{
        self.changeImgV.frame = self.lastBut.frame;
        [self.view layoutIfNeeded];
        
    }];
    self.bottomScrollView.contentOffset = CGPointMake(0, 0);
}


- (void)setupTopView{
    
    [self.view addSubview:self.cycleView];
    
    UIView *topView = [[UIView alloc] init];
    self.topView = topView;
    topView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *bgImageV = [[UIImageView alloc]init];
    self.bgImageV = bgImageV;
    //    bgImageV.backgroundColor = [YXUniversal colorWithHexString:COLOR_YX_DRAKBLUE];
    bgImageV.userInteractionEnabled = YES;
    bgImageV.image = [UIImage imageNamed:@"Shape"];
    //    bgImageV.layer.cornerRadius = 3;
    bgImageV.layer.masksToBounds = YES;
    
    UIImageView *changeImgV = [[UIImageView alloc]init];
    self.changeImgV = changeImgV;
    changeImgV.image = [UIImage imageNamed:@"左tab"];
    
    UIButton *lastBut = [[UIButton alloc]init];
    self.lastBut = lastBut;
    lastBut.titleLabel.font = WTFont(17);
    [lastBut setTitle:@"快递列表" forState:UIControlStateNormal];
    [lastBut setTitleColor:[YXUniversal colorWithHexString:COLOR_YX_DRAKwirte] forState:UIControlStateNormal];
    [lastBut addTarget:self action:@selector(lastButClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *MyBut = [[UIButton alloc]init];
    self.MyBut = MyBut;
    MyBut.titleLabel.font = WTFont(17);
    [MyBut setTitle:@"我的接单" forState:UIControlStateNormal];
    [MyBut setTitleColor:[YXUniversal colorWithHexString:COLOR_YX_DRAKBLUE] forState:UIControlStateNormal];
    [MyBut addTarget:self action:@selector(MyButClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *imgV = [[UIImageView alloc]init];
    imgV.backgroundColor = [UIColor redColor];
    imgV.layer.cornerRadius = 4;
    imgV.layer.masksToBounds = YES;
    self.redPoint = imgV;
    imgV.hidden = YES;
    
    //    UIView *messageRedPointView = [[UIView alloc]initWithFrame:CGRectMake(W(80), 0, 8, 8)];
    //    messageRedPointView.backgroundColor = [UIColor redColor];
    //    messageRedPointView.layer.cornerRadius = 4;
    //    messageRedPointView.layer.masksToBounds = YES;
    //    messageRedPointView.hidden = self.isHaveMessageRed?NO:YES;
    //    _remindView = messageRedPointView;
    UIView *commentRedPointView = [[UIView alloc]initWithFrame:CGRectMake(W(100), 0, 8, 8)];
    commentRedPointView.backgroundColor = [UIColor redColor];
    commentRedPointView.layer.cornerRadius = 4;
    commentRedPointView.layer.masksToBounds = YES;
    _commentView = commentRedPointView;
    commentRedPointView.hidden = YES;
    //    [lastBut addSubview:messageRedPointView];
    [MyBut addSubview:commentRedPointView];
    
    [self.view addSubview:topView];
    [topView addSubview:bgImageV];
    [bgImageV addSubview:changeImgV];
    [bgImageV addSubview:lastBut];
    [bgImageV addSubview:MyBut];
    [bgImageV addSubview:imgV];
    
    
}

- (void)setContentView{
    
    UIScrollView *scroll = [[UIScrollView alloc]init];
    scroll.contentSize = CGSizeMake(2*DEVICE_WIDTH, 0);
    scroll.bounces = NO;
    self.bottomScrollView = scroll;
    scroll.scrollEnabled = NO;
    scroll.pagingEnabled = YES;
    UITableView *remindT = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    remindT.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [remindT registerNib:[UINib nibWithNibName:@"GLD_ExpressCell" bundle:nil] forCellReuseIdentifier:@"GLD_ExpressCell"];
    remindT.delegate = self;
    remindT.dataSource = self;
    WS(weakSelf);
    remindT.mj_header = [GLD_RefreshHeader headerWithRefreshingBlock:^{
        offset = 0;
        [weakSelf.remindArrM removeAllObjects];
        [weakSelf getRemindMessageContent];
    }];
    remindT.mj_footer = [YXFooterRefresh footerWithRefreshingBlock:^{
        [weakSelf getRemindMessageContent];
    }];
    self.remindTable = remindT;
    
    UITableView *commentT = [[UITableView alloc]init];
    
    commentT.separatorStyle = UITableViewCellSeparatorStyleNone;
    commentT.delegate = self;
    commentT.dataSource = self;
    commentT.mj_header = [GLD_RefreshHeader headerWithRefreshingBlock:^{
        
        [weakSelf.commentArrM removeAllObjects];
        [weakSelf getCommentMessageContent];
    }];
    commentT.mj_footer = [YXFooterRefresh footerWithRefreshingBlock:^{
        [weakSelf getCommentMessageContent];
    }];
     [commentT registerNib:[UINib nibWithNibName:@"GLD_ExpressCell" bundle:nil] forCellReuseIdentifier:@"GLD_ExpressCell"];
    self.commentTable = commentT;
    [self.view addSubview:scroll];
    [scroll addSubview:remindT];
    [scroll addSubview:commentT];
    
    [scroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.bottom.left.right.equalTo(self.view);
        
    }];
    [remindT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(scroll);
        make.height.equalTo(scroll);
        make.width.equalTo(@(DEVICE_WIDTH));
    }];
    [commentT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(scroll);
        make.height.equalTo(scroll);
        make.width.equalTo(@(DEVICE_WIDTH));
        make.left.equalTo(remindT.mas_right);
    }];
    
    
}


- (void)layoutTopView{
    [self.cycleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.equalTo(HEIGHT(150));
    }];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(self.view);
        make.top.equalTo(self.cycleView.mas_bottom);
        make.height.equalTo(WIDTH(54));
    }];
    [self.bgImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.topView);
        make.centerY.equalTo(self.topView).offset(5);
        make.width.equalTo(WIDTH(240));
        make.height.equalTo(HEIGHT(30));
        
    }];
    [self.changeImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgImageV);
        make.width.equalTo(WIDTH(120));
        make.height.equalTo(HEIGHT(30));
        make.left.equalTo(self.bgImageV);
    }];
    [self.lastBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgImageV);
        make.width.equalTo(WIDTH(120));
        make.height.equalTo(HEIGHT(30));
        make.left.equalTo(self.bgImageV);
    }];
    [self.MyBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgImageV);
        make.width.equalTo(WIDTH(120));
        make.height.equalTo(HEIGHT(30));
        make.left.equalTo(self.lastBut.mas_right);
    }];
    [self.redPoint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.MyBut.mas_top);
        make.centerX.equalTo(self.MyBut.mas_right);
        make.width.height.equalTo(@10);
    }];
    
    
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
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"%zd", index);
    GLD_BannerDetailController *bannerVc =[GLD_BannerDetailController new];
    bannerVc.bannerModel = self.bannerListModel.data[index];
    [self.navigationController pushViewController:bannerVc animated:YES];
}
@end
