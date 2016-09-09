//
//  CommentController.m
//  视频播放2
//
//  Created by 684lhz on 16/9/6.
//  Copyright © 2016年 684lhz. All rights reserved.
//

#import "CommentController.h"
#import "CommentCell.h"
#import "NetWorking.h"
#import "YMConst.h"
#import "VideoPlayer.h"
#import "MJRefresh.h"

@interface CommentController () <NetWorkingDelegate, CommentCellDelegate>

@property (nonatomic, strong) NetWorking *netWork;
@property (nonatomic, strong) NSMutableArray *topicArray;
@property (nonatomic, strong) VideoPlayer *videoPlayer;
@property (nonatomic, assign) NSInteger page;

@end

@implementation CommentController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.netWork = [[NetWorking alloc]init];
    self.netWork.delegate = self;
    
    [self addTabelViewRefresh];
    self.page = 1;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - netWorking

/*--  networkingDelegate  --*/

- (void)networkingTopicResult:(NSArray *)topicArray andIsSuccess:(BOOL)isSuccess
{
    if (isSuccess) {
        if (self.topicArray.count == 0) {
            self.topicArray = (NSMutableArray *)topicArray;
            [self.tableView reloadData];
        }
        else
        {
//            刷新 是在原数组的前添加刷新出的数据
//            新数据
            NSMutableArray *newData = [NSMutableArray array];
            
            for (YMTopic *topic in topicArray) {
//                依次对比数据的视频链接，发现有与原数组第一个相同是停止对比
                YMTopic *atopic = self.topicArray[0];
                if (![topic.videouri isEqual:atopic.videouri]) {
                    [newData addObject:topic];
                }
                else break;
            }
            
            if (newData.count != 0) {
//                原数据数组位 4 5 6 7 ，取倒序数组 7 6 5 4
                NSMutableArray *aarray = (NSMutableArray *)[[self.topicArray reverseObjectEnumerator]allObjects];
//                新数据为 3 2 1 0 ，加入原数组为 7 6 5 4 3 2 1 0
                [aarray addObjectsFromArray:newData];
//                取原数组的正序 0 1 2 3 4 5 6 7 
                self.topicArray = (NSMutableArray *)[[aarray reverseObjectEnumerator]allObjects];
//                有新数据才重载
                [self.tableView reloadData];
            }
        }
        
        
        [self.tableView.mj_header endRefreshing];
    }
    else
    {
        [self.tableView.mj_header endRefreshing];
    }
    
}

- (void)networkingMoreTopicResult:(NSArray *)moreTopicArray andIsSuccess:(BOOL)isSuccess
{
    if (isSuccess) {
        [self.topicArray addObjectsFromArray:moreTopicArray];
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
    }
    else
    {
        self.page --;
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}

/*-- refresh --*/

- (void)addTabelViewRefresh
{
//    下拉
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopics)];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
//    上拉
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopics)];
}

//下拉
- (void)loadNewTopics
{
    [self.netWork downDataWithType:YMTopicTypeVideo];
}
//上拉
- (void)loadMoreTopics
{
    self.page ++;
    [self.netWork downMoreDataWithType:YMTopicTypeVideo andPage:self.page];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    if (self.topicArray.count != 0) {
        count = self.topicArray.count;
    }
    return count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"CommentCell";
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell = [[[NSBundle mainBundle]loadNibNamed:@"CommentCell" owner:self options:nil] firstObject];
    cell.topic = self.topicArray[indexPath.row];
    cell.delegate = self;
    tableView.rowHeight = cell.frame.size.height;
    NSLog(@"rowHeight: %f",tableView.rowHeight);
    
    return cell;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentCell *cell = [tableView cellForRowAtIndexPath:indexPath];
}

#pragma mark - commentCellDelegate
- (void)playVideoWithCell:(CommentCell *)cell
{
    static BOOL fistTime = YES;
    
    if (self.videoPlayer && fistTime == NO) {
        [self.videoPlayer removeObserverAndNotification];
        [self.videoPlayer removeFromSuperview];
        self.videoPlayer = nil;
    }
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"该行代码只执行一次");
        fistTime = NO;
    });
    
    self.videoPlayer = [VideoPlayer initVideoPlayerWithSupeView:cell.videoView videoImage:cell.videoImage.image];
    [cell.videoView addSubview:self.videoPlayer];
    [self.videoPlayer updatePlayerWith:[NSURL URLWithString:cell.topic.videouri]];
    
    
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
