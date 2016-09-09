//
//  NetWorking.h
//  视频播放2
//
//  Created by 684lhz on 16/9/7.
//  Copyright © 2016年 684lhz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "YMConst.h"

@class NetWorking;

@protocol NetWorkingDelegate <NSObject>

- (void)networkingTopicResult:(NSArray *) topicArray andIsSuccess:(BOOL) isSuccess;
- (void)networkingMoreTopicResult:(NSArray *) moreTopicArray andIsSuccess:(BOOL) isSuccess;

@end

@interface NetWorking : NSObject

@property (nonatomic, weak) id<NetWorkingDelegate> delegate;

- (void)downDataWithType:(YMTopicType) type;
- (void)downMoreDataWithType:(YMTopicType) type andPage:(NSInteger) page;

@end
