//
//  VideoInfo.m
//  News(oc)
//
//  Created by yunyi3g5 on 16/4/20.
//  Copyright © 2016年 founder. All rights reserved.
//

#import "VideoInfo.h"

@implementation VideoInfo

- (id)initWithInfo:(NSDictionary *)dic
{
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
@end
