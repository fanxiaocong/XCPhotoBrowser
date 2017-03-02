//
//  XCPhotoBrowserViewController.m
//  照片浏览器
//
//  Created by 樊小聪 on 2016/12/20.
//  Copyright © 2016年 樊小聪. All rights reserved.
//




/*
 *  备注：用于显示照片的控制器 🐾
 */


#define K_SCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width
#define K_SCREEN_HEIGHT   [UIScreen mainScreen].bounds.size.height


#import "XCPhotoBrowserViewController.h"

#import "XCPhotoModel.h"

#import "XCPhotoCell.h"

#import "UIView+Extension.h"

#import "XCPhotoBrowserConfigure.h"

@interface XCPhotoBrowserViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) UICollectionView *collectView;

/** 蒙板 */
@property (weak, nonatomic) UIImageView *maskBgView;

/** 👀 最底部的视图 👀 */
@property (weak, nonatomic) UIImageView *bottomBgView;

/** 图片浏览数组 */
@property (strong, nonatomic) NSMutableArray<XCPhotoModel *> *photoModels;

@end

static NSString *const identifier = @"ID";

@implementation XCPhotoBrowserViewController
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

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
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

//蒙版
- (UIImageView *)maskBgView
{
    if (_maskBgView == nil)
    {
        UIImageView *mask = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _maskBgView = mask;
        [self.view insertSubview:mask atIndex:0];
    }
    return _maskBgView;
}

- (UIImageView *)bottomBgView
{
    if (!_bottomBgView)
    {
        UIImageView *bottomBgView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _bottomBgView = bottomBgView;
        [self.view insertSubview:bottomBgView belowSubview:self.maskBgView];
    }
    return _bottomBgView;
}

#pragma mark - 👀 Setter Method 👀 💤

- (void)setUrls:(NSArray<NSString *> *)urls
{
    _urls = urls;
    
    __block typeof(self)weakSelf = self;
    
    [urls enumerateObjectsUsingBlock:^(NSString * _Nonnull url, NSUInteger idx, BOOL * _Nonnull stop) {
        
        XCPhotoModel *photoM = [[XCPhotoModel alloc] init];
        photoM.url = url;
        
        // 添加数据
        [weakSelf addPhotoModel:photoM atIndex:idx];
    }];
}

- (void)setImages:(NSArray<UIImage *> *)images
{
    _images = images;
    
    __block typeof(self)weakSelf = self;
    
    [images enumerateObjectsUsingBlock:^(UIImage * _Nonnull image, NSUInteger idx, BOOL * _Nonnull stop) {
        
        XCPhotoModel *photoM = [[XCPhotoModel alloc] init];
        photoM.image = image;
        [weakSelf addPhotoModel:photoM atIndex:idx];
    }];
}


/**
 设置 UI
 */
- (void)setupUI
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _isDismissing = YES;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    layout.itemSize           = CGSizeMake(K_SCREEN_WIDTH, K_SCREEN_HEIGHT);
    
    UICollectionView *collectView = [[UICollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:layout];
    
    self.collectView = collectView;
    self.collectView.delegate = self;
    self.collectView.dataSource = self;
    self.collectView.pagingEnabled = YES;
    self.collectView.backgroundColor = [UIColor clearColor];
    self.collectView.showsHorizontalScrollIndicator = NO;
    
    [self.collectView registerClass:[XCPhotoCell class] forCellWithReuseIdentifier:identifier];
    // 滚动到当前页
    [self.collectView setContentOffset:CGPointMake(self.selectedIndex * K_SCREEN_WIDTH, 0) animated:NO];
    
    [self.view addSubview:collectView];
    
    
    [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)]];
}


#pragma mark -- UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photoModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XCPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    cell.sourceImage = self.selectedPhotoView.image;
    cell.photoM = self.photoModels[indexPath.item];
    
    __block typeof(self)weakSelf = self;
    
    // 单击手势
    cell.didTapSingleHandle = ^{
        
        // 消失
        [weakSelf dismiss];
    };
    
    return cell;
}

#pragma mark -- UIScrollView Delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.selectedIndex = (NSInteger)scrollView.contentOffset.x / K_SCREEN_WIDTH;
}


#pragma mark -- Private


/**
 添加模型数据

 @param photoM 要添加的模型
 @param index   对应的下标
 */
- (void)addPhotoModel:(XCPhotoModel *)photoM atIndex:(NSInteger)index
{
    // 如果 当前选择的图片的下标为 遍历到的下标
    photoM.isFromSourceFrame = (index == self.selectedIndex);
    
    // 可见的个数进行缩放消失；不可见直接消失
    photoM.isDismissScale = (index < self.configure.visibleCount);
    photoM.sourcePhotoF   = [self fetchPhotoViewFrameInScreenWithIndex:index];
    
    [self.photoModels addObject:photoM];

}

- (UIImage *)snapshotImageFromView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0);
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *snap = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return snap;
}

- (UIImage *)snapshotImageAfterScreenUpdates:(BOOL)afterUpdates fromView:(UIView *)view
{
    if (![self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
    {
        return [self snapshotImageFromView:view];
    }
    
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0);
    
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:afterUpdates];
    
    UIImage *snap = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return snap;
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
                self.maskBgView.alpha   = alpha;
            } completion:nil];
            
        } break;
            
        case UIGestureRecognizerStateEnded:
        {
            if (_panGestureBeginPoint.x == 0 && _panGestureBeginPoint.y == 0) return;
            
            CGPoint v = [pan velocityInView:self.view];
            CGPoint p = [pan locationInView:self.view];
            CGFloat deltaY = p.y - _panGestureBeginPoint.y;
            
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
                    self.maskBgView.alpha   = 0;
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
    
    XCPhotoCell *cell = (XCPhotoCell *)[self.collectView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.selectedIndex inSection:0]];
    
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

- (void)zoomOut:(XCPhotoCell *)cell
{
    XCPhotoModel *photoM = cell.photoM;
    
    /*⏰ ----- 操作 控制器上面视图的消失动画 ----- ⏰*/
    [UIView animateWithDuration:.3f animations:^{
        
        if (photoM.isDismissScale)
        {
            // 进行 缩放消失
            self.maskBgView.alpha   = 0;
            self.bottomBgView.alpha = 0;
            self.view.backgroundColor = [UIColor clearColor];
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
    self.fromVC         = nil;
    self.photoModels    = nil;
    self.maskBgView     = nil;
    self.bottomBgView   = nil;
    
    [self.view removeFromSuperview];
    self.view = nil;
    [self removeFromParentViewController];
}


/**
 获取对应下标的图片在当前屏幕中的frame

 @param index 要获取frame的图片的下标
 */
- (CGRect)fetchPhotoViewFrameInScreenWithIndex:(NSInteger)index
{
    CGFloat newW = self.selectedPhotoView.width;
    CGFloat newH = self.selectedPhotoView.height;
    CGFloat newX = (index % self.configure.column) * (newW + self.configure.photoViewColumnMargin) + self.configure.photoViewEdgeInsets.left;
    CGFloat newY = index / self.configure.column * (newH + self.configure.photoViewRowMargin) + self.configure.photoViewEdgeInsets.top;
    
    // 源视图的在屏幕当中的frame
    CGRect seletedPhotoInScreenF = [self.selectedPhotoView convertRect:self.selectedPhotoView.bounds toView:self.fromVC.view.window];
    
    // 源视图在父视图中所在的列数
    NSInteger selectedPhotoRow = self.selectedIndex / self.configure.column;
    
    // 父视图在 屏幕当中的 Y 坐标
    // 计算公式： 父 Y  + photoViewEdgeInsets.top  +  (newH + photoViewRowMargin) * selectedPhotoRow   =   seletedPhotoInScreenF.y;
    CGFloat parentViewInScreenY = seletedPhotoInScreenF.origin.y - self.configure.photoViewEdgeInsets.top - (newH + self.configure.photoViewRowMargin) * selectedPhotoRow;
    
    return CGRectMake(newX, newY + parentViewInScreenY, newW, newH);
}

#pragma mark - 🔓 👀 Public Method 👀

- (void)show
{
    // 拿到window
    UIWindow *window = self.fromVC.view.window;
    
    window.backgroundColor = [UIColor clearColor];
    
    if (window == nil)
    {
        return;
    }
    
    self.view.frame = [UIScreen mainScreen].bounds;
    
    // 添加视图
    [window addSubview:self.view];
    
    // 添加子控制器
    [self.fromVC addChildViewController:self];
    
    // 添加蒙板、底部视图
    UIImage *maskImg = [self snapshotImageAfterScreenUpdates:NO fromView:self.fromVC.view];
    
    self.maskBgView.image   = maskImg;
    self.bottomBgView.image = maskImg;
    
    self.view.backgroundColor        = [UIColor clearColor];
    self.collectView.backgroundColor = [UIColor clearColor];
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:effect];
    blurView.frame = self.maskBgView.bounds;
    [self.maskBgView addSubview:blurView];
    
    self.maskBgView.alpha   = 0;
    self.bottomBgView.alpha = 0;
    
    [UIView animateWithDuration:.2f animations:^{
        
        self.maskBgView.alpha     = 1;
        self.bottomBgView.alpha   = 1;
        self.view.backgroundColor = [UIColor blackColor];
        
    } completion:NULL];
}


@end





























