//
//  XCPhotoBrowserViewController.h
//  照片浏览器
//
//  Created by 樊小聪 on 2016/12/20.
//  Copyright © 2016年 樊小聪. All rights reserved.
//


/*
 *  备注：用于显示照片的控制器 🐾
 */


#import <UIKit/UIKit.h>

@class XCPhotoModel, XCPhotoBrowserConfigure;

@interface XCPhotoBrowserViewController : UIViewController

/** 👀 配置参数类 👀 */
@property (strong, nonatomic) XCPhotoBrowserConfigure *configure;

/** 源控制器 */
@property (weak, nonatomic) UIViewController *fromVC;

/** 👀 选中的下标的图片 👀 */
@property (weak, nonatomic) UIImageView *selectedPhotoView;

/** 选中的下标 */
@property (assign, nonatomic) NSInteger selectedIndex;

@property (strong, nonatomic) NSArray<UIImage *> *images;

@property (strong, nonatomic) NSArray<NSString *> *urls;


/**
    显示
 */
- (void)show;

@end
