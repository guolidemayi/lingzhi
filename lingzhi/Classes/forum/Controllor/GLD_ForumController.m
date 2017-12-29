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

@interface GLD_ForumController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSArray *titleArr;
    NSInteger  pageNo;
//    NSMutableArray *forumListArrM;
    NSInteger addButIsShow;
}
@property (nonatomic, weak)UITableView *LTanTableView;
@property (nonatomic, strong)UIView *topView;
@property (nonatomic, assign)CGFloat lastContentOffset;
@property (nonatomic, weak)UIButton *addBut;
@property (nonatomic, strong)NSMutableArray *forumListArrM;
@end

@implementation GLD_ForumController

- (void)viewDidLoad {
    [super viewDidLoad];
    pageNo = 1;
    _lastContentOffset = 700;
    addButIsShow = 2; //首次addBut为显示状态
    _forumListArrM = [NSMutableArray arrayWithCapacity:0];
    
    // Do any additional setup after loading the view.
    [self addTableUP];
    [self titleArrRequest];
    [self forumDetailRequest];
   
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}
- (void)reLoadMainData{
    [self titleArrRequest];
    [self forumDetailRequest];
}
- (void)titleArrRequest{
//    GLD_ForumTopicRequest *request = [GLD_ForumTopicRequest shareManager];
//    [request httpPost:@"" parameters:nil block:^(WTBaseRequest *request, NSError *error) {
//        if (error) {
//
//        }else{
//            GLD_TopicDataModel *model = request.resultArray.firstObject;
//            titleArr = model.data;
//            [self.LTanTableView reloadData];
//
//        }
//    }];
//    titleArr = @[@"# 高血压",@"# 心脏病",@"#心脏病心脏病"];
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

    WS(weakSelf)
//    GLD_ForumRequest *request = [GLD_ForumRequest shareManager];
//    [request httpPost:@"" parameters:@{@"pageNo":[NSString stringWithFormat:@"%zd",pageNo]} block:^(WTBaseRequest *request, NSError *error) {
//        if (error) {
//            [weakSelf showNoDataViewOrLoadView:error];
//            [weakSelf.LTanTableView.mj_footer endRefreshing];
//            [weakSelf.LTanTableView.mj_header endRefreshing];
//        } else {
//            [weakSelf hiddenNoDataView];
//            GLD_ForumModel *model = request.resultArray.firstObject;
//            if (model.list.count > 0) {
//                [_forumListArrM addObjectsFromArray:model.list];
//                [weakSelf.LTanTableView.mj_footer endRefreshing];
//            } else {
//                [weakSelf.LTanTableView.mj_footer endRefreshingWithNoMoreData];
//            }
//            [weakSelf.LTanTableView.mj_header endRefreshing];
//            [weakSelf.LTanTableView reloadData];
//        }
//    }];
}

- (UIView *)topView{
    if (!_topView) {
        UIView *topview = [[UIView alloc]init];
        [self.view addSubview:topview];
            topview.backgroundColor = [YXUniversal colorWithHexString:COLOR_YX_GRAY_butbackColor];
        _topView = topview;
        UIButton *but = [[UIButton alloc]init];
        [but addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
        [topview addSubview:but];
        [but setImage:WTImage(@"icon_sousuo") forState:UIControlStateNormal];
        [but setTitle:@"  搜索" forState:UIControlStateNormal];
        [but setTitleColor:[YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTline2Gray] forState:UIControlStateNormal];
        but.backgroundColor = [YXUniversal colorWithHexString:@"#F2F2F2"];
        but.layer.cornerRadius = 5;
        but.layer.masksToBounds = YES;
        UIView *lineView = [[UIView alloc]init];
        lineView.backgroundColor = [YXUniversal colorWithHexString:COLOR_YX_GRAY_tableFooter];
        [topview addSubview:lineView];

        UIView *lineView1 = [[UIView alloc]init];
        lineView1.backgroundColor = [YXUniversal colorWithHexString:COLOR_YX_GRAY_tableFooter];
        [topview addSubview:lineView1];
        
        [but mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(topview);
            make.height.equalTo(HEIGHT(29));
            make.width.equalTo(WIDTH(345));
        }];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(topview);
            make.height.equalTo(HEIGHT(0.5));
        }];
        [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(topview);
            make.height.equalTo(HEIGHT(0.5));
        }];
    }
    return _topView;
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
    if ([model.type isEqualToString:@"2"]) {
        //病例
         return [self setBLMessageModel:model andIdexPath:indexPath];
    }else if([model.type isEqualToString:@"4"]){
        //课程答疑
        return [self setBMessageModel:model andIdexPath:indexPath];
    }
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
    cell.TZdetailModel = model;
    
    return cell;
}
- (UITableViewCell *)setBMessageModel:(GLD_ForumDetailModel *)model andIdexPath:(NSIndexPath *)indexPath{
    [self.LTanTableView registerClass:[GLD_BMessageCell class] forCellReuseIdentifier:GLD_BMessageCellIdentifi];
    GLD_BMessageCell *cell = [self.LTanTableView dequeueReusableCellWithIdentifier:GLD_BMessageCellIdentifi];
    cell.CCdetailModel = model;
    return cell;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
  
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *headerView = [[UITableViewHeaderFooterView alloc]init];
//    if (IsExist_Array(titleArr))
    [self setTopViewContent:titleArr andSupView:headerView];
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return W(98);
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GLD_ForumDetailController *detailVc = [[GLD_ForumDetailController alloc]init];
    GLD_ForumDetailModel *Model = _forumListArrM[indexPath.row];
    detailVc.type = Model.type;
    detailVc.newsId = Model.newsId;
    [self.navigationController pushViewController:detailVc animated:YES];
}
- (void)tieziButClick:(GLD_DrawBut *)but{
    
    GLD_AllDetailController *vc = [[GLD_AllDetailController alloc]init];
    vc.keywordModel = titleArr[but.tag];
    vc.topImgType = but.type;
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)setTopViewContent:(NSArray *)tArr andSupView:(UIView *)view{
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, W(44), DEVICE_WIDTH, W(54))];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.backgroundColor = [UIColor whiteColor];
    [view addSubview:scrollView];
    [view addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(view);
        make.height.equalTo(WIDTH(44));
        make.top.equalTo(view);
    }];
    [self.LTanTableView setContentOffset:CGPointMake(0, W(44)) animated:NO];
    CGFloat h = W(34);
    CGFloat x = W(15);
    for (int i = 0; i < tArr.count; i++) {
        GLD_TopicModel *model = tArr[i];
        CGFloat beW = [YXUniversal calculateLabelWidth:20 text:[NSString stringWithFormat:@"# %@",model.categoryName] font:WTFont(15)]+ 15;
        
        CGFloat butW = MAX(beW, W(90));
        NSString *butTitle = [NSString stringWithFormat:@"#%@",model.categoryName];
        
        NSInteger type = [butTitle hash] % 7;
        if (type < 0) {
            type = 0 - type;
        }
        NSLog(@"标题 = %@，type= %zd, hash = %zd ", butTitle ,type,[butTitle hash] );
        GLD_DrawBut *but = [[GLD_DrawBut alloc]initWithFrame:CGRectMake(x, W(10), butW, h) andType:type];
        but.tag = i;
        but.type = type;
        [but addTarget:self action:@selector(tieziButClick:) forControlEvents:UIControlEventTouchUpInside];
        [but setTitle:butTitle forState:UIControlStateNormal];
        [scrollView addSubview:but];
        [but setTitleColor:[YXUniversal colorWithHexString:COLOR_YX_DRAKBLUE] forState:UIControlStateNormal];
        but.titleLabel.font = WTFont(15);
        
        x = x + butW + W(15);
        [but startDrawlineChart];
    }
    scrollView.contentSize = CGSizeMake(x, 0);
    
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
