//
//  WaveView.m
//  News(oc)
//
//  Created by xinyue-0 on 2016/10/24.
//  Copyright © 2016年 founder. All rights reserved.
//

#import "WaveView.h"

@implementation WaveView {
    CGFloat waveHeight;
    CGFloat waveSpeed;
    CAShapeLayer *shapeLayer;
    CAShapeLayer *behindShapeLayer;
    
    double currentWave;
    double currentBehindWave;
}



-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBase];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setBase];
    }
    return self;
}

-(void)setBase {
    waveHeight = 10;
    waveSpeed = 0.045;
    currentWave = 0;
    currentBehindWave = 0;
    
    shapeLayer = [CAShapeLayer layer];
    [self.layer addSublayer:shapeLayer];
    shapeLayer.fillColor = [UIColor whiteColor].CGColor;
    shapeLayer.opacity = 0.4;
    
    behindShapeLayer = [CAShapeLayer layer];
    [self.layer addSublayer:behindShapeLayer];
    behindShapeLayer.fillColor = [UIColor whiteColor].CGColor;
    behindShapeLayer.opacity = 0.2;
    
    CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(setWave)];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode: NSRunLoopCommonModes];
}

- (void)setWave {
    
    currentWave += waveSpeed;
    currentBehindWave += waveSpeed * 2;
    
    UIBezierPath *bPath = [UIBezierPath bezierPath];
    [bPath moveToPoint:CGPointMake(0, waveHeight / 2 * sinf(currentWave) + 100)];
    
    UIBezierPath *cPath = [UIBezierPath bezierPath];
    [cPath moveToPoint:CGPointMake(0, waveHeight / 2 * sinf(currentBehindWave) + 100)];
    
    
    for (int x = 1; x <= (int)[UIScreen mainScreen].bounds.size.width; x++) {
        CGFloat frontY = waveHeight / 2 * sinf(0.02 * x + currentWave) + 100;
        CGFloat behindY = waveHeight / 2 * sinf(0.02 * x + currentBehindWave) + 100;
        [bPath addLineToPoint:CGPointMake(x, frontY)];
        [cPath addLineToPoint:CGPointMake(x, behindY)];
    }
    
    [bPath addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height)];
    [bPath addLineToPoint:CGPointMake(0, self.frame.size.height)];
    [bPath closePath];
    
    [cPath addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height)];
    [cPath addLineToPoint:CGPointMake(0, self.frame.size.height)];
    [cPath closePath];
    
    shapeLayer.path = bPath.CGPath;
    behindShapeLayer.path = cPath.CGPath;
}


@end
