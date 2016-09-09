//
//  NetWorking.m
//  视频播放2
//
//  Created by 684lhz on 16/9/7.
//  Copyright © 2016年 684lhz. All rights reserved.
//

#import "NetWorking.h"
#import "YMTopic.h"
#import <MJExtension.h>

@interface NetWorking ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;
@property (nonatomic, copy) NSString *maxtime;

@end

@implementation NetWorking

- (instancetype)init
{
    if (self = [super init]) {
        self.manager = [AFHTTPSessionManager manager];
    }
    return self;
}

- (void)downDataWithType:(YMTopicType) type
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"list";
    params[@"c"] = @"data";
    params[@"type"] = @(type);
    
    // 发送请求给服务器
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        字典转模型
        NSArray *topicArray = [YMTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        self.maxtime = responseObject[@"info"][@"maxtime"];
        
        if ([self.delegate respondsToSelector:@selector(networkingTopicResult:andIsSuccess:)]) {
            [self.delegate networkingTopicResult:topicArray andIsSuccess:YES];
        }
        
        NSLog(@" NetWorking success %@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@" NetWorking failure: %@",error);
        if ([self.delegate respondsToSelector:@selector(networkingTopicResult:andIsSuccess:)]) {
            [self.delegate networkingTopicResult:nil andIsSuccess:NO];
        }
    }];

}

- (void)downMoreDataWithType:(YMTopicType) type andPage:(NSInteger) page
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"list";
    params[@"c"] = @"data";
    params[@"type"] = @(type);
    params[@"page"] = @(page);
    params[@"maxtime"] = self.maxtime;
    // 发送请求给服务器
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray *moreTopicArray = [YMTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        if ([self.delegate respondsToSelector:@selector(networkingMoreTopicResult:andIsSuccess:)]) {
            [self.delegate networkingMoreTopicResult:moreTopicArray andIsSuccess:YES];
        }
        NSLog(@" NetWorking More success %@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@" NetWorking More failure: %@",error);
        if ([self.delegate respondsToSelector:@selector(networkingMoreTopicResult:andIsSuccess:)]) {
            [self.delegate networkingMoreTopicResult:nil andIsSuccess:NO];
        }
    }];
}


@end

