//
//  HttpTool.h
//  News(oc)
//
//  Created by fy on 16/3/31.
//  Copyright © 2016年 founder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpTool : NSObject

@property (nonatomic, copy) void (^ handlerBlock)(NSData *data,NSURLResponse *response,NSError *error);

- (void)getData:(NSString *)url;

- (void)getConversationWithUrl:(NSString *)url;
@end
