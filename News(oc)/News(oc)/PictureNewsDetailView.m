//
//  PictureNewsDetailView.m
//  News(oc)
//
//  Created by yunyi3g5 on 16/5/23.
//  Copyright © 2016年 founder. All rights reserved.
//

#import "PictureNewsDetailView.h"

@implementation PictureNewsDetailView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.anyObject;
    CGPoint location = [touch locationInView:self];
    CGPoint previousLocation = [touch previousLocationInView:self];
//    self.center.y = location.y - previousLocation.y
    [self setFrame:CGRectMake(0, self.frame.origin.y + location.y - previousLocation.y, self.frame.size.width, [UIScreen mainScreen].bounds.size.height - self.frame.origin.y)];
    if (location.y - previousLocation.y > 0) {
        [UIView animateWithDuration:0.5 animations:^{
            [self setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 30, self.frame.size.width, 30)];
        }];
    }
//    if (self.frame.origin.y > [UIScreen mainScreen].bounds.size.height - 30) {
//        [self setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 30, self.frame.size.width, 30)];
//    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.frame.size.height > _titleLabel.frame.size.height + _subTitleLabel.frame.size.height + 24) {
        [UIView animateWithDuration:0.5 animations:^{
            [self setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - (_titleLabel.frame.size.height + _subTitleLabel.frame.size.height + 24), self.frame.size.width, _titleLabel.frame.size.height + _subTitleLabel.frame.size.height + 24)];
        } completion:^(BOOL finished) {
            
        }];
    }
}

@end
