//  Created by 樊小聪  on 15/8/29.
//  Copyright (c) 2015年 macbookAir2. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)

@property (nonatomic,assign)CGFloat top;
@property (nonatomic,assign)CGFloat bottom;
@property (nonatomic,assign)CGFloat left;
@property (nonatomic,assign)CGFloat right;

- (CGFloat)x;
- (void)setX:(CGFloat)x;

- (CGFloat)y;
- (void)setY:(CGFloat)y;

- (CGFloat)height;
- (void)setHeight:(CGFloat)height;

- (CGFloat)width;
- (void)setWidth:(CGFloat)width;

- (CGFloat)centerX;
- (void)setCenterX:(CGFloat)centerX;

- (CGPoint)origin;
- (void)setOrigin:(CGPoint)origin;

- (CGFloat)centerY;
- (void)setCenterY:(CGFloat)centerY;

- (CGSize)size;
- (void)setSize:(CGSize)size;

/**
 *  手势事件
 */
@property (nullable, copy, nonatomic) void(^tapGestureHandle)(UITapGestureRecognizer * _Nullable gesture, UIView * _Nullable tapView);


@end





