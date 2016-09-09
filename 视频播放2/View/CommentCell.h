//
//  CommentCell.h
//  视频播放2
//
//  Created by 684lhz on 16/9/6.
//  Copyright © 2016年 684lhz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoPlayer.h"
#import "YMTopic.h"
@class CommentCell;
@protocol CommentCellDelegate <NSObject>

- (void)playVideoWithCell:(CommentCell *) cell;


@end

@interface CommentCell : UITableViewCell

@property (weak, nonatomic) id<CommentCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *videoView;
@property (weak, nonatomic) IBOutlet UIImageView *videoImage;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (assign,nonatomic) CGFloat cellHeight;
@property (strong, nonatomic) YMTopic *topic;

@end
