//
//  XCPhotoBrowserController.m
//  XiaoYiService
//
//  Created by 樊小聪 on 2017/6/13.
//  Copyright © 2017年 樊小聪. All rights reserved.
//


/*
 *  备注：用于显示照片的控制器 🐾
 */


#define K_SCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width
#define K_SCREEN_HEIGHT   [UIScreen mainScreen].bounds.size.height

/// 每个 cell 之间的间距
#define kCellPadding    0

#import "XCPhotoBrowserController.h"

#import "XCPhotoBrowserCell.h"

#import "XCPhotoBrowserModel.h"

#import "XCPhotoBrowserConfigure.h"

#import "UIView+Extension.h"


@interface XCPhotoBrowserController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) UICollectionView *collectView;
/** 👀 底部Page 👀 */
@property (weak, nonatomic) UIPageControl *pageCtl;
/** 👀 蒙板 👀 */
@property (weak, nonatomic) UIVisualEffectView *maskBgView;

/** 👀 图片数组模型 👀 */
@property (strong, nonatomic) NSMutableArray<XCPhotoBrowserModel *> *photoModels;

@end


static NSString * const cellIdentifier = @"XCPhotoBrowserCell";

@implementation XCPhotoBrowserController
{
    // 是否正在消失
    BOOL _isDismissing;
    
    // 开始平移的位置
    CGPoint _panGestureBeginPoint;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置 UI
    [self setupUI];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    /// 设置 collectionView 的 frame
    self.collectView.left   = -(kCellPadding * 0.5);
    self.collectView.top    = 0;
    self.collectView.width  = self.view.width + kCellPadding;
    self.collectView.height = self.view.height;
    
    /// 设置 pageCtl 的 frame
    self.pageCtl.width   = self.view.width;
    self.pageCtl.height  = 20;
    self.pageCtl.centerX = self.view.width * 0.5;
    self.pageCtl.top     = self.view.height - 50;
}

#pragma mark - 💤 👀 LazyLoad Method 👀

- (NSMutableArray *)photoModels
{
    if (_photoModels == nil)
    {
        _photoModels = [NSMutableArray array];
    }
    return _photoModels;
}

#pragma mark - 👀 SetupUI 👀 💤

/**
 *  设置 UI
 */
- (void)setupUI
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor clearColor];
    _isDismissing = YES;
    
    /// 设置数据模型
    if (self.urls.count)
    {
        /// 加载 图片URL数组
        [self loadURLData];
    }
    else
    {
        /// 加载本地图片
        [self loadLocalImagesData];
    }
    
    /// 设置 collectionView
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    layout.itemSize           = CGSizeMake(K_SCREEN_WIDTH, K_SCREEN_HEIGHT);
    
    UICollectionView *collectView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    
    self.collectView = collectView;
    self.collectView.delegate        = self;
    self.collectView.dataSource      = self;
    self.collectView.pagingEnabled   = YES;
    self.collectView.scrollsToTop    = NO;
    self.collectView.delaysContentTouches = NO;
    self.collectView.showsHorizontalScrollIndicator = NO;
    self.collectView.showsVerticalScrollIndicator   = NO;
    self.collectView.alwaysBounceHorizontal = (self.photoModels.count > 1);
    self.collectView.backgroundColor = [UIColor clearColor];
    [self.collectView registerClass:[XCPhotoBrowserCell class] forCellWithReuseIdentifier:cellIdentifier];
    // 滚动到当前页
    [self.collectView setContentOffset:CGPointMake(self.selectedIndex * K_SCREEN_WIDTH, 0) animated:NO];
    [self.view addSubview:collectView];
    
    /// 设置 pageCtl
    UIPageControl *pageCtl = [[UIPageControl alloc] init];
    self.pageCtl = pageCtl;
    self.pageCtl.hidesForSinglePage     = YES;
    self.pageCtl.userInteractionEnabled = NO;
    self.pageCtl.numberOfPages = self.photoModels.count;
    self.pageCtl.currentPage   = self.selectedIndex;
    [self.view addSubview:pageCtl];
    
    /// 添加滑动手势
    [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)]];
}

#pragma mark - 🔓 👀 Public Method 👀

/**
 *  显示
 */
- (void)show
{
    /// 获取当前显示的 window
    UIWindow *window = self.fromVC.view.window;
    
    if (!window)    return;
    
    window.backgroundColor = [UIColor clearColor];
    
    /// 添加蒙板视图
    UIView *bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:effect];
    self.maskBgView = blurView;
    self.maskBgView.frame = [UIScreen mainScreen].bounds;
    self.maskBgView.alpha = 0.f;
    [self.maskBgView.contentView addSubview:bgView];
    
    /// 添加视图到当前屏幕上
    [window addSubview:self.maskBgView];
    [window addSubview:self.view];
    
    /// 显示 透明度改变的 动画
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.maskBgView.alpha = 1;
        
    } completion:NULL];
}

#pragma mark - 🔒 👀 Privite Method 👀

/**
 *  加载图片URL数据
 */
- (void)loadURLData
{
    __block typeof(self)weakSelf = self;
    
    [self.urls enumerateObjectsUsingBlock:^(NSString * _Nonnull url, NSUInteger idx, BOOL * _Nonnull stop) {
        
        XCPhotoBrowserModel *photoM = [[XCPhotoBrowserModel alloc] init];
        photoM.url = url;
        
        /// 如果存在缩略图片，则添加占位的缩略图片
        if (weakSelf.images.count > idx)
        {
            photoM.image = weakSelf.images[idx];
        }
        
        // 添加数据
        [weakSelf addPhotoModel:photoM atIndex:idx];
    }];
}

/**
 *  加载本地图片数据
 */
- (void)loadLocalImagesData
{
    __block typeof(self)weakSelf = self;
    
    [self.images enumerateObjectsUsingBlock:^(UIImage * _Nonnull image, NSUInteger idx, BOOL * _Nonnull stop) {
        
        XCPhotoBrowserModel *photoM = [[XCPhotoBrowserModel alloc] init];
        photoM.image = image;
        [weakSelf addPhotoModel:photoM atIndex:idx];
    }];
}

/**
 添加模型数据
 
 @param photoM 要添加的模型
 @param index   对应的下标
 */
- (void)addPhotoModel:(XCPhotoBrowserModel *)photoM atIndex:(NSInteger)index
{
    // 如果 当前选择的图片的下标为 遍历到的下标
    photoM.isFromSourceFrame = (index == self.selectedIndex);
    
    
    ///----- 计算 对应下标的图片在当前屏幕中的 frame
    // 获取对应下标的图片在其父视图中的frame
    CGFloat newW = self.selectedPhotoView.width;
    CGFloat newH = self.selectedPhotoView.height;
    CGFloat newX = (index % self.configure.column) * (newW + self.configure.photoViewColumnMargin) + self.configure.photoViewEdgeInsets.left;
    CGFloat newY = index / self.configure.column * (newH + self.configure.photoViewRowMargin) + self.configure.photoViewEdgeInsets.top;
    
    // 获取对应下标的图片的父视图在屏幕当中的 frame
    CGRect parentViewInScreenFrame = [self.selectedPhotoView.superview.superview convertRect:self.selectedPhotoView.superview.frame toView:self.fromVC.view.window];
    CGFloat parentViewInScreenX = parentViewInScreenFrame.origin.x;
    CGFloat parentViewInScreenY = parentViewInScreenFrame.origin.y;
    
    // 源图片视图在当前屏幕中的frame
    photoM.sourcePhotoF = CGRectMake(newX + parentViewInScreenX, newY + parentViewInScreenY, newW, newH);
    
    
    // 标记当前浏览到的图片与缩略图片的父视图是否相交
    BOOL isIntersect = CGRectIntersectsRect(parentViewInScreenFrame, photoM.sourcePhotoF);
    // 如果当前浏览到的图片与缩略图片的父视图相交，则进行缩放消失；否则直接消失
    photoM.isDismissScale = (self.selectedPhotoView && isIntersect);
    
    [self.photoModels addObject:photoM];
}

#pragma mark - 🎬 👀 Action Method 👀

#define YY_CLAMP(_x_, _low_, _high_)  (((_x_) > (_high_)) ? (_high_) : (((_x_) < (_low_)) ? (_low_) : (_x_)))

/**
 *  平移手势
 */
- (void)pan:(UIPanGestureRecognizer *)pan
{
    switch (pan.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            if (_isDismissing)
            {
                _panGestureBeginPoint = [pan locationInView:self.view];
            }
            else
            {
                _panGestureBeginPoint = CGPointZero;
            }
        } break;
            
        case UIGestureRecognizerStateChanged:
        {
            if (_panGestureBeginPoint.x == 0 && _panGestureBeginPoint.y == 0) return;
            
            CGPoint p = [pan locationInView:self.view];
            
            CGFloat deltaY = p.y - _panGestureBeginPoint.y;
            self.collectView.top = deltaY;
            
            CGFloat alphaDelta = 160;
            CGFloat alpha = (alphaDelta - fabs(deltaY) + 50) / alphaDelta;
            alpha = YY_CLAMP(alpha, 0, 1);
            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveLinear animations:^{
                self.maskBgView.alpha = alpha;
            } completion:nil];
            
        } break;
            
        case UIGestureRecognizerStateEnded:
        {
            if (_panGestureBeginPoint.x == 0 && _panGestureBeginPoint.y == 0) return;
            
            CGPoint v = [pan velocityInView:self.view];
            CGPoint p = [pan locationInView:self.view];
            CGFloat deltaY = p.y - _panGestureBeginPoint.y;
            
            /// 如果 垂直方向的速度大于1000，或者 Y轴方向上的偏移量大于120，则消失，否则复原
            if (fabs(v.y) > 1000 || fabs(deltaY) > 120)
            {
                _isDismissing = NO;
                
                BOOL moveToTop = (v.y < - 50 || (v.y < 50 && deltaY < 0));
                CGFloat vy = fabs(v.y);
                if (vy < 1) vy = 1;
                CGFloat duration = (moveToTop ? self.collectView.bottom : self.view.height - self.collectView.top) / vy;
                duration *= 0.8;
                duration = YY_CLAMP(duration, 0.05, 0.3);
                
                [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionBeginFromCurrentState animations:^{
                    self.maskBgView.alpha = 0;
                    if (moveToTop)
                    {
                        self.collectView.bottom = 0;
                    }
                    else
                    {
                        self.collectView.top = self.view.height;
                    }
                } completion:^(BOOL finished) {
                    
                    // 移除视图
                    [self dismissFinishedHandle];
                }];
            }
            else
            {
                [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:v.y / 1000 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState animations:^{
                    self.collectView.top    = 0;
                    self.maskBgView.alpha   = 1;
                } completion:^(BOOL finished) {
                }];
            }
            
        } break;
            
        case UIGestureRecognizerStateCancelled :
        {
            self.collectView.top    = 0;
            self.maskBgView.alpha   = 1;
        }
        default:break;
    }
}


/**
 消失
 */
- (void)dismiss
{
    self.view.userInteractionEnabled = NO;
    
    XCPhotoBrowserCell *cell = (XCPhotoBrowserCell *)[self.collectView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.selectedIndex inSection:0]];
    
    if (cell.zoomScale > 1)
    {
        // 如果当前 缩放比例大于 1，先缩回原来尺寸，再 消失
        cell.zoomScale = 1;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self zoomOut:cell];
        });
    }
    else
    {
        // 消失
        [self zoomOut:cell];
    }
}

- (void)zoomOut:(XCPhotoBrowserCell *)cell
{
    XCPhotoBrowserModel *photoM = cell.model;
    
    /*⏰ ----- 操作 控制器上面视图的消失动画 ----- ⏰*/
    [UIView animateWithDuration:.3f animations:^{
        
        if (photoM.isDismissScale)
        {
            // 进行 缩放消失
            self.maskBgView.alpha = 0;
        }
        else
        {
            // 直接透明度消失
            self.view.alpha = 0;
        }
    }];
    
    __block typeof(self)weakSelf = self;
    /*⏰ ----- 操作 cell 上面视图的消失动画 ----- ⏰*/
    [cell dismissHandle:^{
        [weakSelf dismissFinishedHandle];
    }];
}

/**
 视图消失完成的操作
 */
- (void)dismissFinishedHandle
{
    [self.maskBgView removeFromSuperview];
    [self.view removeFromSuperview];
    
    self.fromVC = nil;
    self.maskBgView = nil;
    self.view = nil;
    
    [self removeFromParentViewController];
}

#pragma mark - 📕 👀 UICollectionViewDataSource 👀

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photoModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XCPhotoBrowserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.model = self.photoModels[indexPath.item];
    
    __block typeof(self)weakSelf = self;
    
    // 单击手势
    cell.didTapSingleHandle = ^{
        
        // 消失
        [weakSelf dismiss];
    };
    
    return cell;
}

#pragma mark - 💉 👀 UIScrollViewDelegate 👀

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat floatPage = scrollView.contentOffset.x / scrollView.width;
    
    self.selectedIndex = floatPage + 0.5;
    self.pageCtl.currentPage = self.selectedIndex;
}

@end
