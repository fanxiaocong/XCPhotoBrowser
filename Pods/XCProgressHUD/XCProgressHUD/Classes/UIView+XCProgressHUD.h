//
//  UIView+XCProgressHUD.h
//  Pods
//
//  Created by 樊小聪 on 2018/4/25.
//

#import <UIKit/UIKit.h>


@interface UIView (XCProgressHUD)

/**
 *  显示加载的HUD（文字：加载中...）
 */
- (void)showHUD;

/**
 *  隐藏HUD
 */
- (void)hideHUD;

/**
 *  只显示文字
 */
- (void)showText:(NSString *)text;

/**
 *  显示加载的HUD，文字字定义
 */
- (void)showHUDWithText:(NSString *)text;

/**
 *  显示成功的HUD
 */
- (void)showSuccess:(NSString *)text;

/**
 *  显示失败的HUD
 */
- (void)showError:(NSString *)error;

/**
 *  显示警告的HUD
 */
- (void)showWarning:(NSString *)warning;

/**
 *  显示带进度的HUD
 */
- (void)showProgressHUD:(NSString *)text;
/// 更新进度
- (void)updateProgress:(CGFloat)progress;
/// 更新进度
- (void)updateProgress:(CGFloat)progress text:(NSString *)text;

@end
