//
//  UIView+XCProgressHUD.m
//  Pods
//
//  Created by 樊小聪 on 2018/4/25.
//

#import "UIView+XCProgressHUD.h"

#import "JGProgressHUD.h"
#import "XCProgressHUDLoadingIndicatorView.h"
#import "XCProgressHUDSuccessIndicatorView.h"
#import "XCProgressHUDErrorIndicatorView.h"
#import "XCProgressHUDWarningIndicatorView.h"

#import <objc/runtime.h>


@implementation UIView (XCProgressHUD)

- (JGProgressHUD *)HUD
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setHUD:(JGProgressHUD *)HUD
{
    objc_setAssociatedObject(self, @selector(HUD), HUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (JGProgressHUD *)prototypeHUD
{
    if ([self HUD]) {
        [[self HUD] dismissAnimated:YES];
    }
    
    JGProgressHUD *HUD = [[JGProgressHUD alloc] initWithStyle:JGProgressHUDStyleDark];
    HUD.interactionType = JGProgressHUDInteractionTypeBlockAllTouches;
    HUD.animation = [[JGProgressHUDFadeAnimation alloc] init];
//    HUD.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.4f];
    HUD.HUDView.backgroundColor = [UIColor blackColor];
    HUD.HUDView.alpha = 0.8f;
    HUD.textLabel.font = [UIFont systemFontOfSize:15];
    HUD.shadow = [JGProgressHUDShadow shadowWithColor:[UIColor blackColor] offset:CGSizeZero radius:8.0 opacity:0.4f];
    HUD.square = NO;
    
    return HUD;
}

#pragma mark - 🔓 👀 Public Method 👀

/**
 *  显示加载的HUD（文字：加载中...）
 */
- (void)showHUD
{
    [self showHUDWithText:@"加载中..."];
}

/**
 *  隐藏HUD
 */
- (void)hideHUD
{
    [[self HUD] dismiss];
}

/**
 *  只显示文字
 */
- (void)showText:(NSString *)text
{
    JGProgressHUD *HUD = [self prototypeHUD];
    HUD.indicatorView = nil;
    HUD.textLabel.text = text;
    HUD.position = JGProgressHUDPositionCenter;
    [HUD showInView:self];
    [HUD dismissAfterDelay:1.f];
}

/**
 *  显示加载的HUD，文字字定义
 */
- (void)showHUDWithText:(NSString *)text
{
    JGProgressHUD *HUD = [self prototypeHUD];
    HUD.textLabel.text = text;
    HUD.indicatorView  = [[XCProgressHUDLoadingIndicatorView alloc] init];
    [HUD showInView:self];
    [self setHUD:HUD];
    
    //    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];
    //
    //    NSMutableArray *imgsArr = [NSMutableArray array];
    //    for (NSInteger index = 0; index < 20; index ++)
    //    {
    //        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"%02zi", index+1]];
    //        [imgsArr addObject:img];
    //    }
    //    UIImageView *imgView         = [[UIImageView alloc] initWithFrame:contentView.bounds];
    //    [contentView addSubview:imgView];
    //    JGProgressHUD *HUD           = self.prototypeHUD;
    //    [self setHUD:HUD];
    //    HUD.HUDView.backgroundColor = [UIColor clearColor];
    //    HUD.HUDView.alpha           = 1;
    //    HUD.indicatorView = [[JGProgressHUDIndicatorView alloc] initWithContentView:contentView];
    //
    //    imgView.animationImages      = imgsArr;
    //    imgView.animationDuration    = imgsArr.count * 0.02;
    //    imgView.animationRepeatCount = 0;
    //    [imgView startAnimating];
    //    HUD.square = YES;
    //    [HUD showInView:self];
}

/**
 *  显示成功的HUD
 */
- (void)showSuccess:(NSString *)text
{
    JGProgressHUD *HUD = [self prototypeHUD];
    HUD.textLabel.text = text;
    HUD.indicatorView  = [[XCProgressHUDSuccessIndicatorView alloc] init];
    [HUD showInView:self];
    [HUD dismissAfterDelay:1.0];
}

/**
 *  显示失败的HUD
 */
- (void)showError:(NSString *)text
{
    JGProgressHUD *HUD = [self prototypeHUD];
    HUD.textLabel.text = text;
    HUD.indicatorView  = [[XCProgressHUDErrorIndicatorView alloc] init];
    [HUD showInView:self];
    [HUD dismissAfterDelay:1.0];
}

/**
 *  显示警告的HUD
 */
- (void)showWarning:(NSString *)text
{
    JGProgressHUD *HUD = [self prototypeHUD];
    HUD.textLabel.text = text;
    HUD.indicatorView  = [[XCProgressHUDWarningIndicatorView alloc] init];
    [HUD showInView:self];
    [HUD dismissAfterDelay:1.0];
}

/**
 *  显示带进度的HUD
 */
- (void)showProgressHUD:(NSString *)text
{
    JGProgressHUD *HUD = [self prototypeHUD];
    HUD.detailTextLabel.text = text;
    [self setHUD:HUD];
    HUD.indicatorView  = [[JGProgressHUDPieIndicatorView alloc] init];
    [HUD showInView:self];
}
/// 更新进度
- (void)updateProgress:(CGFloat)progress
{
    [self updateProgress:progress text:NULL];
}
/// 更新进度
- (void)updateProgress:(CGFloat)progress text:(NSString *)text
{
    if (progress < 0) {
        progress = 0;
    }
    
    if (progress >= 0.999) {
        progress = 1;
    }
    
    JGProgressHUD *HUD = self.HUD;

    if (text) {
        HUD.detailTextLabel.text = text;
    }
    [HUD setProgress:progress animated:NO];
}

@end
