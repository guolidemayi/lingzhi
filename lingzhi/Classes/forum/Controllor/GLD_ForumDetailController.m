//
//  GLD_ForumDetailController.m
//  yxvzb
//
//  Created by yiyangkeji on 2017/4/24.
//  Copyright © 2017年 sendiyang. All rights reserved.
//

#import "GLD_ForumDetailController.h"
#import "GLD_NewsCell.h"
#import "GLD_KeyWordCell.h"
#import "InputKeyboardView.h"
#import "GLD_PopView.h"
#import "GLD_CommentCell.h"
#import "GLD_CommentBottomView.h"
#import "GLD_ForumCell.h"
#import "YXLiveingHotModel.h"

#import "GLD_ForumNewsDetailModel.h"

#import "OCPublicEngine.h"
#import "GLD_AllDetailController.h"

//#import "GLD_AdjustSizeView.h"



@interface GLD_ForumDetailController ()<UITableViewDelegate,UITableViewDataSource,GLD_NewsCellDelegate,keyboardDelegate,GLD_CommentBottomViewDelegate,OCPublicEngineDelegate,GLD_KeyWordCellDelegate,GLD_CommentCellDelegate>{
    YXCommentListModel *commentListModel;
    NSInteger pageNo;    //页数
    
    GLD_ForumNewsDetailModel *forumDetailModel;
    GLD_NewsCell *newsCell;
}
@property(nonatomic,assign) CGFloat refreshHeight;
@property (nonatomic, weak)UITableView *detailTable;
@property (nonatomic, strong) InputKeyboardView *keyView;

@property (nonatomic, weak)GLD_CommentBottomView *commentView;

@property (nonatomic,strong) GLD_PopView *operationView;

@property(nonatomic,strong) NSMutableArray *commentArrM;//评论数据源

@property (nonatomic, copy) NSString *answerID;
@property (nonatomic, strong) NSString *replyNameString;//回复人
@property (nonatomic, strong) NSString *contentCopy;//回复人
@property (nonatomic, strong) NSIndexPath *indexP;//回复人
@property (nonatomic, strong) NSString *ext2Title;//回复标题
@property (nonatomic, strong)GLD_NetworkAPIManager *NetManager;
@end

@implementation GLD_ForumDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.automaticallyAdjustsScrollViewInsets = NO;
    self.NetManager = [GLD_NetworkAPIManager new];
    self.commentArrM = [NSMutableArray array];
    self.keyView = [[InputKeyboardView alloc] initWithFrame:CGRectMake(0, 64, DEVICE_WIDTH, DEVICE_HEIGHT)];
    self.keyView.delegate = self;
    [self commentView];
    [self getCommentList];
    
//    self.title = @"帖子详情";

//    // Do any additional setup after loading the view.
//    if ([_type isEqualToString:@"8"]) {
//        UIButton *tmpButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [tmpButton setImage:[UIImage imageNamed:@"post举报"] forState:UIControlStateNormal];
//        [tmpButton addTarget:self action:@selector(rightButClick) forControlEvents:UIControlEventTouchUpInside];
//        tmpButton.frame = CGRectMake(0, 0, 20, 20);
//        [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:tmpButton]];
//    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1&& !IsExist_Array(forumDetailModel.topicList))return 0.0;
    return section == 0? 0.01: H(42);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section > 0) {
        NSString *titleStr;
        UITableViewHeaderFooterView *headerView = [[UITableViewHeaderFooterView alloc]init] ;
//        headerView.contentView.backgroundColor = [UIColor whiteColor];
        UILabel *label = [UILabel creatLableWithText:@"" andFont:WTFont(15) textAlignment:NSTextAlignmentLeft textColor:[YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTBLACK]];
        switch (section) {
            case 1:
                titleStr = @"   相关话题";
                label.text = titleStr;
                break;
            case 2:
            {
                titleStr = @"";
                label.attributedText = [YXUniversal changeColorLabel:[NSString stringWithFormat:@"   讨论区 %@", titleStr] find:titleStr  flMaxFont:15 flMinFont:12 maxColor:[YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTBLACK] minColor:[YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTBLACK]];
                break;
            }
        }
        label.backgroundColor = [UIColor whiteColor];
        [headerView.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(headerView.contentView).offset(10);
            make.right.bottom.equalTo(headerView.contentView);
            make.left.equalTo(headerView.contentView);
        }];
        return headerView;
    }
    return nil;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_operationView dismiss];
    _operationView = nil;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    switch (section) {
        case 0:
            return 1;
        case 1:
            return IsExist_Array(forumDetailModel.topicList) ? 1 : 0;
        case 2:
            return self.commentArrM.count;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            return [self getNewsCellWith:indexPath];
        case 1:
            return [self getKeyWordCell:indexPath];
        case 2:
            return [self setQuestionCell:tableView andIndexPath:indexPath];
        default:
            break;
    }
    return [[UITableViewCell alloc]init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0: {
            CGFloat height = [YXUniversal calculateCellHeight:0 width:300 text:self.forumModel.summary font:12] + W(150);
            if (self.forumModel.pic.length > 10) {
                
                NSArray *arr = [self.forumModel.pic componentsSeparatedByString:@","];
                if(IsExist_Array(arr)){
                    if (arr.count > 3) {
                        height = height + W(200);
                    }else{
                        height = height + W(100);
                    }
                }
            }
           
            return height;
        }
            
        case 1:
            return H(60);
        case 2:
        {
            CGFloat cellHeight = 0;
            if (_commentArrM.count > 0) {
                YXCommentContent2Model *commentModel = _commentArrM[indexPath.row];
                cellHeight = 60 + commentModel.replyHieght + commentModel.beReplyHieght;
            }
            return H(cellHeight);
        }
    }
    return 0.01;
}

- (GLD_KeyWordCell *)getKeyWordCell:(NSIndexPath *)indexPath{
    
    [self.detailTable registerClass:[GLD_KeyWordCell class] forCellReuseIdentifier:GLD_KeyWordCellIdentifi];
    GLD_KeyWordCell *cell = [self.detailTable dequeueReusableCellWithIdentifier:GLD_KeyWordCellIdentifi];
    cell.keyWordArr = forumDetailModel.topicList;;
    cell.delegate = self;
    return cell;
}

- (void)gld_KeyWordCell:(GLD_TopicModel *)model andType:(NSInteger)type{
    //App-帖子详情-相关话题
   
    GLD_AllDetailController *vc = [[GLD_AllDetailController alloc]init];
    vc.keywordModel = model;
    vc.topImgType = type;
    vc.isCorrelation = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (GLD_ForumCell *)getNewsCellWith: (NSIndexPath *)indexPath{

    GLD_ForumCell *cell = [GLD_ForumCell cellWithReuseIdentifier:@"GLD_ForumCell"];
    cell.detailModel = self.forumModel;
    return cell;
}

- (UITableViewCell *)setQuestionCell:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath{
    [tableView registerClass:[GLD_CommentCell class] forCellReuseIdentifier:@"GLD_CommentCell"];
    GLD_CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLD_CommentCell" forIndexPath:indexPath];
    cell.commentIndexPath = indexPath;
    cell.delegate = self;
    if(IsExist_Array(_commentArrM))
        cell.commentModel = _commentArrM[indexPath.row];
    WS(weakSelf)
    cell.commentBlock = ^(NSIndexPath *index, GLD_CommentType type){
        switch (type) {
            case GLD_CommentLike:
                [weakSelf thumbupToggle:index];
                break;
            case GLD_CommentRecord:
                // App-评论-语音回复
               
//                [weakSelf showRecordView:index.row];
                break;
            case GLD_CommentUser:
                [weakSelf pushUserPersonalVc:index];
                break;
            default:
                break;
        }
    };
    return cell;
}

- (void)pushUserPersonalVc:(NSIndexPath *)indexPath{
    if(!IsExist_Array(_commentArrM))return;
//    YXDoctorViewController *doctorVc = [[YXDoctorViewController alloc]init];
//    YXCommentContent2Model *commentModel = _commentArrM[indexPath.row];
//    doctorVc.isFirstName = [commentModel.replyUserId isEqualToString:[AppDelegate shareDelegate].userDataModel.id] ? YES : NO;
//    doctorVc.doctorId = commentModel.replyUserId;
//    [self.navigationController pushViewController:doctorVc animated:YES];
}

//点赞
-(void)thumbupToggle:(NSIndexPath *)idex{
    
    if(!IsExist_Array(_commentArrM))
    {
        return;
    }
    YXCommentContent2Model *commentModel = _commentArrM[idex.row];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict addEntriesFromDictionary:@{@"id":GetString(commentModel.commentId)}];
    [dict addEntriesFromDictionary:@{@"userId":GetString([AppDelegate shareDelegate].userModel.userId)}];
    
    __weak typeof(self) weakSelf = self;
    
    
    GLD_APIConfiguration *config = [[GLD_APIConfiguration alloc]init];
    config.requestType = gld_networkRequestTypePOST;
    config.urlPath = @"api/comment/deleteComment";
    
    config.requestParameters = dict;
    [self.NetManager dispatchDataTaskWith:config andCompletionHandler:^(NSError *error, id result) {
        if (!error) {
            //            [CAToast showWithText:@"认证成功"];
            [weakSelf.commentArrM removeObject:commentModel];
            [weakSelf.detailTable reloadData];
            [CAToast showWithText:@"发送成功"];
        }else{
            [CAToast showWithText:@"网络错误"];
        }
        
    }];

}

#pragma NewsCellDelegate

- (void)refreshCellHeight:(CGFloat)height{
    if (self.refreshHeight == height) {
        return;
    }
    self.refreshHeight = height;
    [self.detailTable reloadData];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        
    }
}
- (void)showPopViewInSomeWhere:(NSIndexPath *)indexPath andLocation:(CGFloat)location{
    
    [self replyAction:indexPath andLocation:location];
}

- (void)replyAction:(NSIndexPath *)indexPath andLocation:(CGFloat)location{
    CGRect rectInTableView = [self.detailTable rectForRowAtIndexPath:indexPath];
    CGFloat origin_Y = rectInTableView.origin.y + H(location-40);
    CGRect targetRect = CGRectMake(CGRectGetMinX(rectInTableView), origin_Y, CGRectGetWidth(rectInTableView), CGRectGetHeight(rectInTableView));
    if (self.operationView.shouldShowed) {
        [self.operationView dismiss];
        _operationView = nil;
        return;
    }
    if(!IsExist_Array(_commentArrM))return;
    YXCommentContent2Model *commentModel = _commentArrM[indexPath.row];
    self.answerID = commentModel.commentId;
    self.replyNameString = [NSString stringWithFormat:@"回复@%@",commentModel.replyUserNickName];
    self.indexP = indexPath;
    self.ext2Title = commentModel.ext2;
    self.contentCopy = GetString(commentModel.replyContent);
    [self.operationView showAtView:self.detailTable rect:targetRect isFavour:YES];
}

#pragma mark -- keyboradDelegate

//显示键盘占位符 text
- (void)showKeyBoard: (NSString *)text{
    [_operationView dismiss];
    _operationView = nil;
  
    [self.keyView showKeyboardView:text isHideStatus:NO];
    [self.view addSubview:self.keyView];
}

-(void)closeKeyborad:(NSString *)text
{
//    self.replyString = text;
    self.commentView.textFeild.text = text;
    [self.keyView removeFromSuperview];
}

-(void)sendKeyboard:(NSString *)text
{
    [self.keyView removeFromSuperview];
    
//    if(!self.livingInfoModel){
//        return;
//    }
    if (text.length == 0) {
        
        return;
    }

    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict addEntriesFromDictionary:@{@"id":GetString(self.forumModel.newsId)}];
    [dict addEntriesFromDictionary:@{@"userId":GetString([AppDelegate shareDelegate].userModel.userId)}];
    [dict addEntriesFromDictionary:@{@"content":text}];
    __weak typeof(self) weakSelf = self;
   
    
    GLD_APIConfiguration *config = [[GLD_APIConfiguration alloc]init];
    config.requestType = gld_networkRequestTypePOST;
    config.urlPath = @"api/comment/addComment";
    
    config.requestParameters = dict;
    [self.NetManager dispatchDataTaskWith:config andCompletionHandler:^(NSError *error, id result) {
        if (!error) {
            //            [CAToast showWithText:@"认证成功"];
            [weakSelf getCommentList];
            [CAToast showWithText:@"发送成功"];
        }else{
            [CAToast showWithText:@"网络错误"];
        }
        
    }];
}
// 收藏
- (void)xuanfuWithShouCangAction: (UIButton *)senser {
    
    NSString *opt = @"1";
    if (!forumDetailModel.collected) {
        opt = @"1";
    }
    else
    {
        opt = @"2";
    }

//
}
- (void)getCommentList{
    __weak typeof(self) weakSelf = self;
//    if (weakSelf.cid.length == 0) {
//        return;
//    }
    NSInteger fid = 0;//条数id
    
//    [self showNoDataViewOrLoadView:nil];
    if (_commentArrM.count == 0) {
        fid = 0;
        pageNo = 1;
    }else{
        YXCommentContent2Model *model = (YXCommentContent2Model*)[_commentArrM lastObject];
        fid = model.fid;
        pageNo++;
    }
    
    NSInteger offset = _commentArrM.count;
    
    
    GLD_APIConfiguration *config = [[GLD_APIConfiguration alloc]init];
    config.requestType = gld_networkRequestTypePOST;
    config.urlPath = @"api/comment/getComments";
    
    config.requestParameters = @{@"limit":@"10",
                                 @"offset":[NSString stringWithFormat:@"%zd",offset],
                                 @"id":GetString(self.forumModel.newsId),
                                 };
    [self.NetManager dispatchDataTaskWith:config andCompletionHandler:^(NSError *error, id result) {
        if (!error) {
            //            [CAToast showWithText:@"认证成功"];
            YXCommentContent1Model *commentModel = [[YXCommentContent1Model alloc]initWithDictionary:result error:nil];
            [weakSelf handleCommentList:commentModel.data.copy];
            
        }else{
            [CAToast showWithText:@"网络错误"];
        }
        
                    [weakSelf.detailTable.mj_footer endRefreshing];
                    [weakSelf.detailTable.mj_header endRefreshing];
        
    }];

}

- (void)handleCommentList: (NSArray *)commentArr {
    
    for (YXCommentContent2Model *model in commentArr) {
        
        if (model.beReplyUserNickName) {
            
            if (model.beReplyDelFlag == 1) {
                model.beReplyHieght = 60;
                if (model.replyMediaId) {
                    model.replyHieght = 40;
                }else{
                    model.replyHieght = [YXUniversal calculateCellHeight:0 width:270 text:[NSString stringWithFormat:@"回复@%@ : %@",model.beReplyUserNickName,model.replyContent] font:15] +10;
                }
            }else{
                if(model.beReplyMediaId){
                    model.beReplyHieght = 60;
                }else if(model.beReplyContent){
                    model.beReplyHieght = [YXUniversal calculateCellHeight:0 width:260 text:[NSString stringWithFormat:@"@%@ : %@",model.beReplyUserNickName,model.beReplyContent] font:15] + 40;
                }
                if (model.replyMediaId) {
                    model.replyHieght = 40;
                }else{
                    model.replyHieght = [YXUniversal calculateCellHeight:0 width:270 text:[NSString stringWithFormat:@"回复@%@ : %@",model.beReplyUserNickName,model.replyContent] font:15] +10;
                }
            }
        }else{
            if (model.replyMediaId) {
                model.replyHieght = 40;
            }else if(model.replyContent){
                model.replyHieght =  [YXUniversal calculateCellHeight:0 width:270 text:model.replyContent font:15]+10;
            }
        }
        
        [_commentArrM addObject:model];
    }
    
    [self.detailTable reloadData];
}



//懒加载
- (UITableView *)detailTable{
    if (!_detailTable) {
        
        WS(weakSelf);
        UITableView *table = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _detailTable = table;
        table.delegate = self;
        table.dataSource = self;
        if (@available(iOS 11.0, *)) {
            table.estimatedRowHeight = 0;
            table.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
        table.mj_footer = [YXFooterRefresh footerWithRefreshingBlock:^{
            [weakSelf getCommentList];
        }];
        table.mj_header = [GLD_RefreshHeader headerWithRefreshingBlock:^{
            [weakSelf.commentArrM removeAllObjects];
            [weakSelf getCommentList];
        }];
        [self.view addSubview:table];
    }
    return _detailTable;
}

#pragma mark - bottomView

- (NSInteger)identOfUser{
    NSInteger ident = 3;
//    if (![[AppDelegate shareDelegate].userDataModel.roleType isEqualToString:@"0"]) {
//        ident = 1;
//    }else{
//        if ([AppDelegate shareDelegate].isAuth) {
//            ident = 2;
//        }else{
//            ident = 3;
//        }
//    }
    return ident;
}
- (GLD_CommentBottomView *)commentView{
    if (_commentView == nil) {
        GLD_CommentBottomView *commenView = [[GLD_CommentBottomView alloc]initWithFrame:CGRectMake(0, DEVICE_HEIGHT-H(45)-64-(iPhoneXBottomHeight ? (34 + 20):0), DEVICE_WIDTH, H(45)+iPhoneXBottomHeight)];
        [commenView showAuthOrOthersStates:[self identOfUser]];
        _commentView = commenView;
        commenView.delegate = self;
        [self.view addSubview:commenView];
        WS(weakSelf);
        [self.detailTable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.view);
            make.right.left.equalTo(weakSelf.view);
            make.bottom.equalTo(commenView.mas_top);
        }];
        _commentView.title = forumDetailModel.title;
        _commentView.type = @"tiezi";
    }
    return _commentView;
    
}
- (void)toAuth{
    WS(weakSelf);
//    [GLD_ToAuthView showToAuthViewWith:^(UIViewController *vc){
//        NSLog(@"%@",vc.class);
//        [weakSelf.navigationController pushViewController:vc animated:YES];
//    }];
}
- (void)record{
    
}
- (void)content{
    
    [self answerToggle:nil];
}
- (void)collection:(UIButton *)but{
    
//    [self xuanfuWithShouCangAction:but];
}
- (void)share{
//    [self requestShareMessageWithFenXiang];
}
- (void)requestShareMessageWithFenXiang {
 
    [OCPublicEngine getInstance].delegate = self;
    [OCPublicEngine showShareViewWithType:KShareViewTypeAll withDelegate:self shareText:GetString(forumDetailModel.shareTitle) shareUrl:GetString(forumDetailModel.shareUrl) shareDetail:GetString(forumDetailModel.shareDesc) shareImage:GetString(forumDetailModel.sharePic) shareTitle:GetString(forumDetailModel.shareTitle)];
    
}

//回答问题
- (void)answerToggle:(id)sender {
    self.answerID = nil;
    [self showKeyBoard:@"说点什么"];
}
- (void)wachatShareSuccess: (NSString *)formStr{
    
//    [[SensorsAnalyticsSDK sharedInstance] track:@"share_total" withProperties:@{@"target":self.newsId?self.newsId:@"",@"client_id":[AppDelegate shareDelegate].userDataModel.id,@"type":formStr,@"from":@"app_ios"}];
    // /app/user/shareCallback
    __weak typeof(self) weakSelf = self;
    
}

- (GLD_PopView *)operationView {
    
    if (!_operationView) {
        _operationView = [GLD_PopView initailzerWFOperationView];
        _operationView.title = forumDetailModel.title;
        _operationView.type = @"tiezi";
        WS(ws);
        _operationView.didSelectedOperationCompletion = ^(GLD_OperationType operationType) {
            switch (operationType) {
                case GLD_OperationTypeReply:
                    [ws showKeyBoard:ws.replyNameString];
                    break;
                case GLD_OperationTypeCopy:
                    [ws pastCotent];
                    break;
                case GLD_OperationTypeDelete:
                    
                    break;
                case GLD_OperationTypeJuBao:
                    [ws accusation];
                    break;
                default:
                    break;
            }
        };
    }
    return _operationView;
}
- (void)pastCotent{
    if (IsExist_String(self.contentCopy)) {
        
        UIPasteboard *pboard = [UIPasteboard generalPasteboard];
        pboard.string = self.contentCopy;
        [CAToast showWithText:@"复制成功"];
    }
}
-(void)accusation{
    __weak typeof(self) weakSelf = self;
//    YXBBSAddAnswerRequest *request = [YXBBSAddAnswerRequest shareManager];
//    [request httpPost:@"" parameters:@{@"id":GetString(self.answerID)} block:^(WTBaseRequest *request, NSError *error) {
//        if (error) {
//            [weakSelf handleError:error];
//        } else {
//            [CAToast showWithText:@"举报已收到，我们尽快核实"];
//
//        }
//    }];
}

@end
