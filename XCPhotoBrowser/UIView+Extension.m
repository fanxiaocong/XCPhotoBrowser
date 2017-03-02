//  Created by 樊小聪  on 15/8/29.
//  Copyright (c) 2015年 macbookAir2. All rights reserved.
//

#import "UIView+Extension.h"
#import <objc/runtime.h>

@implementation UIView (Extension)

- (CGFloat)x {
    return self.frame.origin.x;
}
- (void)setX:(CGFloat)x {
    CGRect tempRect = self.frame;
    tempRect.origin.x = x;
    self.frame = tempRect;
}

- (CGFloat)y {
    return self.frame.origin.y;
}


- (void)setY:(CGFloat)y {
    CGRect tempRect = self.frame;
    tempRect.origin.y = y;
    self.frame = tempRect;
}


- (CGFloat)height {
    return self.frame.size.height;
}


- (void)setHeight:(CGFloat)height {
    
    CGRect tempRect = self.frame;
    tempRect.size.height = height;
    self.frame = tempRect;
}

- (CGFloat)width {
    return self.frame.size.width;
}


- (void)setWidth:(CGFloat)width {
    CGRect tempRect = self.frame;
    tempRect.size.width = width;
    self.frame = tempRect;
}

- (CGFloat)centerX {
    return self.center.x;
}
- (void)setCenterX:(CGFloat)centerX {
    CGPoint point = self.center;
    point.x = centerX;
    self.center = point;
}

- (CGFloat)centerY {
    return self.center.y;
}
- (void)setCenterY:(CGFloat)centerY {
    CGPoint point = self.center;
    point.y = centerY;
    self.center = point;
}

- (CGPoint)origin {
    return self.frame.origin;
}
- (void)setOrigin:(CGPoint)origin {
    CGRect rect = self.frame;
    rect.origin = origin;
    self.frame = rect;
}

- (CGSize)size {
    return self.frame.size;
}
- (void)setSize:(CGSize)size {
    CGRect rect = self.frame;
    rect.size = size;
    self.frame = rect;
}

- (void) setTop:(CGFloat)t {
    self.frame = CGRectMake(self.left, t, self.width, self.height);
}
- (CGFloat) top {
    return self.frame.origin.y;
}
- (void) setBottom:(CGFloat)b {
    self.frame = CGRectMake(self.left,b-self.height,self.width,self.height);
}
- (CGFloat) bottom {
    return self.frame.origin.y + self.frame.size.height;
}
- (void) setLeft:(CGFloat)l {
    self.frame = CGRectMake(l,self.top,self.width,self.height);
}
- (CGFloat) left {
    return self.frame.origin.x;
}
- (void) setRight:(CGFloat)r {
    self.frame = CGRectMake(r-self.width,self.top,self.width,self.height);
}
- (CGFloat) right {
    return self.frame.origin.x + self.frame.size.width;
}

static char event_key;

- (void)setTapGestureHandle:(void (^)(UITapGestureRecognizer *, UIView *))tapGestureHandle
{
    self.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapHandle:)];
    
    [self addGestureRecognizer:tapGesture];
    
    objc_setAssociatedObject(self, &event_key, tapGestureHandle, OBJC_ASSOCIATION_COPY);
}

- (void (^)(UITapGestureRecognizer *, UIView *))tapGestureHandle
{
    return objc_getAssociatedObject(self, &event_key);
}



- (void)didTapHandle:(UITapGestureRecognizer *)tap
{
    void (^tapGestureHandle)(UITapGestureRecognizer *tap, UIView *tapView) = objc_getAssociatedObject(self, &event_key);
    
    if (tapGestureHandle)
    {
        tapGestureHandle(tap, tap.view);
    }
}


@end








