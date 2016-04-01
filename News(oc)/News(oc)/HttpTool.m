//
//  HttpTool.m
//  News(oc)
//
//  Created by fy on 16/3/31.
//  Copyright © 2016年 founder. All rights reserved.
//

#import "HttpTool.h"
@implementation HttpTool{
    HttpTool *tool;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        HttpTool *tool = [[HttpTool alloc] init];
    }
    return self;
}

+ (void)getData:(NSURL *)url
{
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"");
    }];
    [dataTask resume];
}

@end
