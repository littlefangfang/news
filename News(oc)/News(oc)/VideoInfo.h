//
//  VideoInfo.h
//  News(oc)
//
//  Created by yunyi3g5 on 16/4/20.
//  Copyright © 2016年 founder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoInfo : NSObject

@property (nonatomic,retain)NSString *url_mp4;

@property(nonatomic,retain)NSString *ref;

- (id)initWithInfo:(NSDictionary *)dic;
@end
