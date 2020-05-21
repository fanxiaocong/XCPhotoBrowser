//
//  XCProgressHUDErrorIndicatorView.m
//  TATAT
//
//  Created by 樊小聪 on 2018/4/25.
//  Copyright © 2018年 樊小聪. All rights reserved.
//


/*
 *  备注：错误的视图 🐾
 */

#import "XCProgressHUDErrorIndicatorView.h"

@implementation XCProgressHUDErrorIndicatorView

- (instancetype)initWithContentView:(UIView *__unused)contentView
{
    if (self = [super initWithContentView:contentView])
    {
        [self drawError];
    }
    
    return self;
}

- (void)drawError
{
    NSInteger const kRadius = MIN(self.bounds.size.width, self.bounds.size.height);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(kRadius * 0.5, kRadius * 0.5) radius:kRadius * 0.5 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    
    CGPoint p1 =  CGPointMake(kRadius * 0.25, kRadius * 0.25);
    [path moveToPoint:p1];
    
    CGPoint p2 =  CGPointMake(kRadius * 0.25 * 3, kRadius * 0.25 * 3);
    [path addLineToPoint:p2];
    
    CGPoint p3 =  CGPointMake(kRadius * 0.25 * 3, kRadius * 0.25);
    [path moveToPoint:p3];
    
    CGPoint p4 =  CGPointMake(kRadius * 0.25, kRadius * 0.25 * 3);
    [path addLineToPoint:p4];
    
    
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

- (instancetype)init {
    return [self initWithContentView:nil];
}

- (void)updateAccessibility {
    self.accessibilityLabel = NSLocalizedString(@"Error",);
}


@end
