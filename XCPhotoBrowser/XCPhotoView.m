//
//  XCPhotoView.m
//  照片浏览器
//
//  Created by 樊小聪 on 2016/12/20.
//  Copyright © 2016年 樊小聪. All rights reserved.
//


/*
 *  备注：自定义 imageView 🐾
 */


#import "XCPhotoView.h"

@interface XCPhotoView ()

/** bounds */
@property (nonatomic,assign) CGRect screenBounds;

/** center */
@property (nonatomic,assign) CGPoint screenCenter;

@end



@implementation XCPhotoView

- (void)setImage:(UIImage *)image
{
    if(image == nil) return;
    
    if(![image isMemberOfClass:[UIImage class]])    return;
    
    [super setImage:image];
    
    [self calFrame];
}

/*
 *  确定frame
 */
- (void)calFrame
{
    CGSize size = self.image.size;
    
    CGFloat w = size.width;
    CGFloat h = size.height;
    
    CGRect superFrame = self.screenBounds;
    CGFloat superW = superFrame.size.width ;
    CGFloat superH = superFrame.size.height;
    
    CGFloat calW = superW;
    CGFloat calH = superW;
    
    // 较宽
    if (w >= h)
    {
        CGFloat scale = superW / w;
        
        // 确定宽度
        calW = w * scale;
        calH = h * scale;
    }
    // 较高
    else if(w < h)
    {
        CGFloat scale1 = superH / h;
        CGFloat scale2 = superW / w;
        
        // 比较胖
        BOOL isFat = w * scale1 > superW;
        
        CGFloat scale = isFat ? scale2 : scale1;
        
        // 比屏幕高
        if(h > superH)
        {
            // 确定宽度
            calW = w * scale;
            calH = h * scale;
        }
        // 比屏幕窄，直接居中显示
        else if (h <= superH)
        {
            // 确定宽度
            calW = w * scale;
            calH = h * scale;
        }
    }
    
    CGFloat calX = self.screenCenter.x - calW * 0.5;
    CGFloat calY = self.screenCenter.y - calH * 0.5;
    
    self.calF = CGRectMake(calX, calY, calW, calH);
    
}

- (CGRect)screenBounds
{
    if (CGRectEqualToRect(_screenBounds, CGRectZero))
    {
        _screenBounds = [UIScreen mainScreen].bounds;
    }
    
    return _screenBounds;
}

- (CGPoint)screenCenter
{
    if (CGPointEqualToPoint(_screenCenter, CGPointZero))
    {
        CGSize size = self.screenBounds.size;
        _screenCenter = CGPointMake(size.width * .5f, size.height * .5f);
    }
    
    return _screenCenter;
}



@end



































