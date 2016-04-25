//
//  HttpTool.m
//  News(oc)
//
//  Created by fy on 16/3/31.
//  Copyright © 2016年 founder. All rights reserved.
//

#import "HttpTool.h"
#import "AFNetworking.h"

@implementation HttpTool{
    __weak typeof(HttpTool *)weakSelf;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        weakSelf = self;
    }
    return self;
}

- (void)getData:(NSString *)urlString
{
    NSString *baseURLString = @"http://c.m.163.com/nc/";
    NSString *fullURLString = [baseURLString stringByAppendingString:urlString];
    NSURL *url = [NSURL URLWithString:fullURLString];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [weakSelf callBackFromTask:data withReponse:response andError:error];
    }];
    [dataTask resume];
}

- (void)getConversationWithUrl:(NSString *)url
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf callBackFromTask:(NSData *)task withReponse:responseObject andError:nil];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void)callBackFromTask:(NSData *)data withReponse:(NSURLResponse *)response andError:(NSError *)error
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        weakSelf.handlerBlock(data,response,error);
    }];
}

@end
