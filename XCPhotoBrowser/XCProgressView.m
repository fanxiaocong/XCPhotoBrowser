//
//  XCProgressView.m
//  照片浏览器
//
//  Created by 樊小聪 on 2016/12/20.
//  Copyright © 2016年 樊小聪. All rights reserved.
//



/*
 *  备注：进度圈视图 🐾
 */


#import "XCProgressView.h"

#import "LFRoundProgressView.h"


#define CIRCLE_WH 40    // 进度环的宽高
#define RING_DIMA 5     // 进度环的直径


@interface XCProgressView ()

/** 进度圈 */
@property (strong, nonatomic) LFRoundProgressView *progressView;

@end

@implementation XCProgressView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        // 设置默认参数
        [self setUpDefaults];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        // 设置默认参数
        [self setUpDefaults];
    }
    return self;
}

#pragma mark -- defaults

- (void)setUpDefaults
{
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds   = YES;
    
    self.progressView = [[LFRoundProgressView alloc] initWithFrame:CGRectMake(0, 0, CIRCLE_WH, CIRCLE_WH)];
    self.progressView.percentShow = YES;
    [self addSubview:self.progressView];
}

- (void)setProgress:(CGFloat)progress
{
    if (progress <= fabs(0.0001))
    {
        progress = 0;
    }
    
    _progress = progress;
    
    self.progressView.progress = progress;
    
    if(fabs(progress - 1) <= 0.0001)
    {
        [UIView animateWithDuration:.5f animations:^{
            self.alpha = 0;
        } completion:NULL];
    }
}


@end







































