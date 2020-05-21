//
//  XCProgressHUDWarningIndicatorView.m
//  TATAT
//
//  Created by 樊小聪 on 2018/4/25.
//  Copyright © 2018年 樊小聪. All rights reserved.
//


/*
 *  备注：警告的视图 🐾
 */

#import "XCProgressHUDWarningIndicatorView.h"

@implementation XCProgressHUDWarningIndicatorView

- (instancetype)initWithContentView:(UIView *__unused)contentView
{
    if (self = [super initWithContentView:contentView])
    {
        [self drawWarning];
    }
    
    return self;
}

- (void)drawWarning
{
    NSInteger const kRadius = MIN(self.bounds.size.width, self.bounds.size.height);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(kRadius * 0.5, kRadius * 0.5) radius:kRadius * 0.5 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineCapRound;
    
    [path moveToPoint:CGPointMake(kRadius * 0.5, kRadius/6)];
    CGPoint p1 = CGPointMake(kRadius * 0.5, kRadius/6*3.8);
    [path addLineToPoint:p1];
    
    [path moveToPoint:CGPointMake(kRadius * 0.5, kRadius/6*4.5)];
    [path addArcWithCenter:CGPointMake(kRadius * 0.5, kRadius/6*4.5) radius:2 startAngle:0 endAngle:M_PI*2 clockwise:YES];
    
    
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.lineWidth = 2;
    layer.path = path.CGPath;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = [UIColor whiteColor].CGColor;
    
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(strokeEnd))];
    animation.fromValue = @0;
    animation.toValue = @1;
    animation.duration = .7f;
    [layer addAnimation:animation forKey:NSStringFromSelector(@selector(strokeEnd))];
    
    [self.layer addSublayer:layer];
}

- (instancetype)init
{
    return [self initWithContentView:nil];
}

- (void)updateAccessibility
{
    self.accessibilityLabel = NSLocalizedString(@"Error",);
}

@end
