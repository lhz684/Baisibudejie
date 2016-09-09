//
//  CommentCell.m
//  视频播放2
//
//  Created by 684lhz on 16/9/6.
//  Copyright © 2016年 684lhz. All rights reserved.
//

#import "CommentCell.h"
#import "UIImageView+WebCache.h"

@interface CommentCell ()

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *text;



@end

@implementation CommentCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setTopic:(YMTopic *)topic
{
    if (!_topic) {
        [self.icon sd_setImageWithURL:[NSURL URLWithString:topic.profile_image]];
        self.name.text = topic.name;
        self.time.text = topic.create_time;
        self.text.text = topic.text;
        self.cellHeight = topic.cellHeight;
        [self.videoImage sd_setImageWithURL:[NSURL URLWithString:topic.middle_image]];
        _topic = topic;
    }
}


//播放
- (IBAction)playVideo:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(playVideoWithCell:)]) {
        [self.delegate playVideoWithCell:self];
    }

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
