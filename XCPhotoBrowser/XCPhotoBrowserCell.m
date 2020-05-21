//
//  XCPhotoBrowserCell.m
//  XiaoYiService
//
//  Created by 樊小聪 on 2017/6/9.
//  Copyright © 2017年 樊小聪. All rights reserved.
//

#import "XCPhotoBrowserCell.h"

#import "XCPhotoBrowserModel.h"

#import "UIView+Extension.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIView+WebCache.h>
#import <SDWebImage/UIImage+GIF.h>

/// 圆形进度圈的半径
#define kCircleProgressLayerRadius 20
/// 圆形进度圈线的宽度
#define kCircleProgressLayerLineWidth 4

/// 图片的最大缩放比例
#define kMaxZoomScale 5


@interface XCPhotoBrowserCell ()<UIScrollViewDelegate>
{
    CGFloat _zoomScale;
}

/** 👀 底部滚动视图 👀 */
@property (weak, nonatomic) UIScrollView *contentScrollView;
/** 👀 图片视图 👀 */
@property (weak, nonatomic) UIImageView *imgView;
/** 👀 进度圈图层 👀 */
@property (nonatomic, strong) CAShapeLayer *progressLayer;

/** 👀 图片是否已经加载完毕 👀 */
@property (nonatomic, assign) BOOL imgDidLoad;

@end


@implementation XCPhotoBrowserCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        /// 设置 UI
        [self setupUI];
        // 添加 点击手势
        [self addTapGesture];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat circleProgressW = kCircleProgressLayerRadius * 2;
    CGFloat circleProgressH = kCircleProgressLayerRadius * 2;
    CGFloat circleProgressX = self.width * 0.5 - kCircleProgressLayerRadius;
    CGFloat circleProgressY = self.height * 0.5 - kCircleProgressLayerRadius;
    self.progressLayer.frame = CGRectMake(circleProgressX, circleProgressY, circleProgressW, circleProgressH);
}

#pragma mark - 👀 Getter & Setter 👀 💤

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
 *  设置 UI
 */
- (void)setupUI
{
    /// 设置 contentScrollView
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    scrollView.delegate = self;
    scrollView.maximumZoomScale = kMaxZoomScale;
    scrollView.multipleTouchEnabled = YES;
    scrollView.alwaysBounceVertical = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    self.contentScrollView = scrollView;
    [self addSubview:scrollView];
    
    /// 设置 imgView
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.clipsToBounds = YES;
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    self.imgView = imgView;
    [self.contentScrollView addSubview:self.imgView];
    
    /// 设置 progressLayer
    _progressLayer = [CAShapeLayer layer];
    _progressLayer.bounds = CGRectMake(0, 0, kCircleProgressLayerRadius * 2, kCircleProgressLayerRadius * 2);
    _progressLayer.cornerRadius = kCircleProgressLayerRadius;
    _progressLayer.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.500].CGColor;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(_progressLayer.bounds, 7, 7) cornerRadius:(kCircleProgressLayerRadius - 7)];
    _progressLayer.path = path.CGPath;
    _progressLayer.fillColor = [UIColor clearColor].CGColor;
    _progressLayer.strokeColor = [UIColor whiteColor].CGColor;
    _progressLayer.lineWidth = kCircleProgressLayerLineWidth;
    _progressLayer.lineCap = kCALineCapRound;
    _progressLayer.strokeStart = 0;
    _progressLayer.strokeEnd = 0;
    _progressLayer.hidden = YES;
    [self.layer addSublayer:_progressLayer];
}

/**
 *  添加手势
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

#pragma mark - 🎬 👀 Action Method 👀

/**
 *  双击手势的回调
 */
- (void)didTapDoubleHandle:(UITapGestureRecognizer *)tap
{
    CGFloat zoomScale = self.contentScrollView.zoomScale;
    
    if (zoomScale <= 1.0f) {
        // 放大图片
        CGPoint loc = [tap locationInView:tap.view];
        
        CGFloat newZoomScale = self.contentScrollView.maximumZoomScale;
        
        CGFloat xsize = self.width / newZoomScale;
        CGFloat ysize = self.height / newZoomScale;
        
        CGFloat x   = loc.x - xsize * 0.5;
        CGFloat y   = loc.y - ysize * 0.5;
        
        CGRect rect = CGRectMake(x, y, xsize, ysize);
        
        [self.contentScrollView zoomToRect:rect animated:YES];
    } else {
        // 复原图片
        [self.contentScrollView setZoomScale:1.0f animated:YES];
    }
}

/**
 *  单击手势的回调
 */
- (void)didTapSingleHandle:(UITapGestureRecognizer *)tap
{    
    if (self.didTapSingleHandle) {
        self.didTapSingleHandle();
    }
}

#pragma mark - 👀 Setter Method 👀 💤

- (void)setModel:(XCPhotoBrowserModel *)model
{
    if (_model == model)    return;
    
    _model = model;
    
    /// 重置状态
    [self.contentScrollView setZoomScale:1.0 animated:NO];
    self.contentScrollView.maximumZoomScale = 1;
    
    _progressLayer.hidden = NO;
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    _progressLayer.strokeEnd = 0;
    _progressLayer.hidden = YES;
    [CATransaction commit];
    
    if (!_model) {
        _imgView.image = nil;
        return;
    }
    
    if (![_model.image isMemberOfClass:[UIImage class]]) {
        _model.image = nil;
    }
    
    /// 如果是 从上一个页面放大显示出来（图片的过渡动画）
    if (_model.isFromSourceFrame) {
        _imgView.image = _model.image;
        _imgView.frame = _model.sourcePhotoF;
        /// 更新标记
        _model.isFromSourceFrame = NO;
        
        CGRect toF = [self fetchImageFrame];
        
        /// 图片缩放（过渡）动画
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            /// 更新 imgView 的 frame
            _imgView.frame = toF;
        } completion:^(BOOL finished) {
            /// 加载图片数据
            [self loadImageData];
        }];
        return;
    }
    
    /// 加载图片数据
    [self loadImageData];
}

#pragma mark - 🔒 👀 Privite Method 👀

/**
 *  加载图片数据
 */
- (void)loadImageData
{
    if (_model.url) {
        /// 加载图片地址
        [self loadURLImage];
    } else {
        /// 加载本地图片
        [self loadLocalImage];
    }
}

/**
 *  加载 URL 图片
 */
- (void)loadURLImage
{
    _imgDidLoad = NO;
    [_imgView sd_cancelCurrentImageLoad];
        
    __weak typeof(self)weakSelf = self;
    
    [_imgView sd_setImageWithURL:[NSURL URLWithString:self.model.url] placeholderImage:_model.image options:SDWebImageHighPriority progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        if (!weakSelf) return;
        CGFloat progress = receivedSize / (float)expectedSize;
        progress = progress < 0.01 ? 0.01 : progress > 1 ? 1 : progress;
        if (isnan(progress)) progress = 0;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.progressLayer.hidden = NO;
            weakSelf.progressLayer.strokeEnd = progress;
        });
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (!weakSelf) return;
        weakSelf.progressLayer.hidden = YES;
        weakSelf.contentScrollView.maximumZoomScale = kMaxZoomScale;
        if (image) {
            weakSelf.imgDidLoad = YES;
            weakSelf.model.image = image;
            [weakSelf resizeSubviewSize];
        }
    }];
    
    [self resizeSubviewSize];
}

/**
 *  加载本地图片
 */
- (void)loadLocalImage
{
    _imgDidLoad = YES;
    
    _imgView.image = self.model.image;
    self.contentScrollView.maximumZoomScale = kMaxZoomScale;
    
    [self resizeSubviewSize];
}

/**
 *  设置图片尺寸
 */
- (void)resizeSubviewSize
{
    /// 设置图片的尺寸
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    _imgView.frame = [self fetchImageFrame];
    [CATransaction commit];
}

/**
 *  获取图片尺寸
 */
- (CGRect)fetchImageFrame
{
    CGRect contentF;
    
    contentF.origin     = CGPointZero;
    contentF.size.width = self.width;
    
    UIImage *image = _imgView.image;
    
     /// 以当前屏幕宽度为基准，高度自适应
    if (image.size.height / image.size.width > self.height / self.width) {
        /// 当前图片的高度与宽度的比例 > 当前屏幕的高度与宽度的比例
        /// 当前图片容器视图的高度 以 图片的高度为基准
        contentF.size.height = floor(image.size.height / (image.size.width / self.width));
    } else {
        CGFloat height = image.size.height / image.size.width * self.width;
        if (height < 1 || isnan(height)) height = self.height;
        height = floor(height);
        contentF.size.height = height;
        contentF.origin.y    = (self.height - height) * 0.5;
    }
    
    if (contentF.size.height > self.height && contentF.size.height - self.height <= 1) {
        contentF.size.height = self.height;
    }
    
    /// 计算内容视图的尺寸
    self.contentScrollView.contentSize = CGSizeMake(self.width, MAX(contentF.size.height, self.height));
    [self.contentScrollView scrollRectToVisible:self.bounds animated:NO];
    
    if (contentF.size.height <= self.height) {
        self.contentScrollView.alwaysBounceVertical = NO;
    } else {
        self.contentScrollView.alwaysBounceVertical = YES;
    }
    
    return contentF;
}

#pragma mark - 🔓 👀 Public Method 👀

/**
 消失操作
 
 @param compeletionBlock 消失时的回调
 */
- (void)dismissHandle:(void(^)(void))compeletionBlock
{
    // 显示 原视图
    if (self.model.isDismissScale) {
        // 缩放消失
        [UIView animateWithDuration:.3f animations:^{
            self.imgView.frame = self.model.sourcePhotoF;
        } completion:^(BOOL finished) {
            // 回调 block
            if (finished  && compeletionBlock) {
                // 动画完成时的回调
                compeletionBlock();
            }
        }];
    } else {
        // 放大消失
        [UIView animateWithDuration:.3f animations:^{
            self.imgView.alpha = 0;
            self.imgView.transform = CGAffineTransformMakeScale(2, 2);
        } completion:^(BOOL finished) {
            self.imgView.hidden = YES;
            // 回调 block
            if (finished  && compeletionBlock) {
                // 动画完成时的回调
                compeletionBlock();
            }
        }];
    }
}

#pragma mark - 💉 👀 UIScrollViewDelegate 👀

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imgView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    UIView *subView = _imgView;
    
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    
    subView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                 scrollView.contentSize.height * 0.5 + offsetY);
}


@end
