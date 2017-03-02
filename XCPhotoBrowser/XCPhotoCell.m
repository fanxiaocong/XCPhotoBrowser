//
//  XCPhotoCell.m
//  照片浏览器
//
//  Created by 樊小聪 on 2016/12/20.
//  Copyright © 2016年 樊小聪. All rights reserved.
//


/*
 *  备注：图片cell 🐾
 */



#import "XCPhotoCell.h"

#import "XCProgressView.h"
#import "XCPhotoView.h"

#import "XCPhotoModel.h"

#import "UIView+Extension.h"

#import "UIImageView+WebCache.h"


#define K_PLACEHOLDER_IMAGE_NAME  @"empty_picture"


@interface XCPhotoCell ()<UIScrollViewDelegate>
{
    CGFloat _zoomScale;
}

/** 👀 底部滚动视图 👀 */
@property (weak, nonatomic) UIScrollView *contentScrollView;
/** 👀 图片 👀 */
@property (strong, nonatomic) XCPhotoView *photoView;
/** 👀 进度视图 👀 */
@property (weak, nonatomic) XCProgressView *progressView;

@end

@implementation XCPhotoCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        // 设置 UI
        [self setupUI];
        
        // 添加 点击手势
        [self addTapGesture];
    }
    
    return self;
}

#pragma mark - 💤 👀 LazyLoad Method 👀

- (XCPhotoView *)photoView
{
    if (!_photoView)
    {
        XCPhotoView *photoView = [[XCPhotoView alloc] init];
        
        _photoView = photoView;
        _photoView.contentMode   = UIViewContentModeScaleAspectFill;
        _photoView.clipsToBounds = YES;
        _photoView.userInteractionEnabled = YES;
    }
    return _photoView;
}

- (CGFloat)zoomScale
{
    return self.contentScrollView.zoomScale;
}

- (void)setZoomScale:(CGFloat)zoomScale
{
    _zoomScale = zoomScale;
    [self.contentScrollView setZoomScale:zoomScale animated:YES];
}

/**
 设置UI
 */
- (void)setupUI
{
    /*⏰ ----- contentScrollView ----- ⏰*/
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    [scrollView addSubview:self.photoView];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.maximumZoomScale = 5;
    scrollView.delegate    = self;
    self.contentScrollView = scrollView;
    [self.contentView addSubview:scrollView];
    
    /*⏰ ----- progressView ----- ⏰*/
    XCProgressView *progressView = [[XCProgressView alloc] init];
    progressView.size = CGSizeMake(50, 50);
    progressView.centerX = self.width * 0.5;
    progressView.centerY = self.height * 0.5;
    self.progressView = progressView;
    [self.contentView addSubview:progressView];
}

- (void)resetUI
{
    self.progressView.alpha = 1.0;
    [self.contentScrollView setZoomScale:1.0f animated:NO];
    self.contentScrollView.contentSize = self.photoView.bounds.size;
}

/**
 添加点击手势
 */
- (void)addTapGesture
{
    // 添加双击事件
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapDoubleHandle:)];
    doubleTap.numberOfTapsRequired = 2;
    [self addGestureRecognizer:doubleTap];
    
    // 添加单击手势
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapSingleHandle:)];
    [singleTap requireGestureRecognizerToFail:doubleTap];
    [self addGestureRecognizer:singleTap];
    
}

- (void)setPhotoM:(XCPhotoModel *)photoM
{
    _photoM = photoM;
    
    if (!photoM)        return;
    
    // 重置状态
    [self resetUI];
    
    if (photoM.isFromSourceFrame)
    {
        self.progressView.hidden = YES;
        self.photoView.image = self.sourceImage;
        // 如果是 从上一个页面放大显示出来
        self.photoView.frame = photoM.sourcePhotoF;  // 初始frame
        
        // 进行放大动画
        [UIView animateWithDuration:.3f animations:^{
            self.photoView.frame = self.photoView.calF;
        } completion:NULL];
        
        // 更新标记
        photoM.isFromSourceFrame = NO;
        return;
    }
    
    if (photoM.image)
    {
        // 存在图片，优先选择图片
        self.photoView.image = photoM.image;
        self.photoView.frame = self.photoView.calF;
        self.progressView.hidden = YES;
    }
    else
    {
        // 没有图片，此时 加载图片链接地址
        // 注：此处调用 SDWebImage 的加载图片
        self.progressView.hidden = photoM.hasLoadedFinish;
        
        // 显示占位图片 和 图片的frame
        self.photoView.image     = [UIImage imageNamed:K_PLACEHOLDER_IMAGE_NAME];
        self.photoView.frame     = self.photoView.calF;
        
#warning 注：此处图片的URL是利用SDWebImage来实现加载的...
        __block typeof(self)mv = self;
        [self.photoView sd_setImageWithURL:[NSURL URLWithString:photoM.url] placeholderImage:NULL options:SDWebImageRetryFailed | SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
            CGFloat progress = receivedSize / ((CGFloat)expectedSize);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                mv.progressView.progress = progress;
            });
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            if (image)
            {
                photoM.hasLoadedFinish = YES;
                mv.photoView.image           = image;
                mv.photoView.frame = mv.photoView.calF;
                
                if (mv.progressView.progress <= 1.0f)
                {
                    mv.progressView.progress = 1.0f;
                }
            }
        }];
    }
}

#pragma mark - 🎬 👀 Action Method 👀

/**
 双击手势的回调
 */
- (void)didTapDoubleHandle:(UITapGestureRecognizer *)tap
{
    CGFloat zoomScale = self.contentScrollView.zoomScale;
    
    if (zoomScale <= 1.0f)
    {
        // 放大图片
        CGPoint loc = [tap locationInView:tap.view];
        
        CGFloat newZoomScale = self.contentScrollView.maximumZoomScale;
        
        CGFloat xsize = self.width / newZoomScale;
        CGFloat ysize = self.height / newZoomScale;
        
        CGFloat x   = loc.x - xsize * 0.5;
        CGFloat y   = loc.y - ysize * 0.5;
        
        CGRect rect = CGRectMake(x, y, xsize, ysize);
        
        [self.contentScrollView zoomToRect:rect animated:YES];
    }
    else
    {
        // 复原图片
        [self.contentScrollView setZoomScale:1.0f animated:YES];
    }
}


/**
 单击手势的回调
 */
- (void)didTapSingleHandle:(UITapGestureRecognizer *)tap
{
    if (self.didTapSingleHandle)
    {
        self.didTapSingleHandle();
    }
}

#pragma mark - 🔓 👀 Public Method 👀

/**
 消失操作

 @param compeletionBlock 消失时的回调
 */
- (void)dismissHandle:(void(^)())compeletionBlock
{
    // 显示 原视图
    
    if (self.photoM.isDismissScale)
    {
        // 缩放消失
        [UIView animateWithDuration:.3f animations:^{
            
            self.photoView.frame = self.photoM.sourcePhotoF;
            
        } completion:^(BOOL finished) {
            
            // 回调 block
            if (finished  && compeletionBlock)
            {
                // 动画完成时的回调
                compeletionBlock();
            }
        }];
    }
    else
    {
        // 放大消失
        [UIView animateWithDuration:.3f animations:^{
            
            self.photoView.alpha = 0;
            self.photoView.transform = CGAffineTransformMakeScale(2, 2);
            
        } completion:^(BOOL finished) {
            
            self.photoView.hidden = YES;
            
            // 回调 block
            if (finished  && compeletionBlock)
            {
                // 动画完成时的回调
                compeletionBlock();
            }
        }];
    }
}

#pragma mark -- UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.photoView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    
    self.photoView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                      scrollView.contentSize.height * 0.5 + offsetY);
}


@end





























