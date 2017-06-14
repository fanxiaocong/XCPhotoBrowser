//
//  XCPhotoBrowserController.h
//  XiaoYiService
//
//  Created by 樊小聪 on 2017/6/13.
//  Copyright © 2017年 樊小聪. All rights reserved.
//


/*
 *  备注：用于显示照片的控制器 🐾
 */



#import <UIKit/UIKit.h>

@class XCPhotoBrowserConfigure;

@interface XCPhotoBrowserController : UIViewController

/** 👀 选中的下标的图片 👀 */
@property (weak, nonatomic) UIImageView *selectedPhotoView;
/** 选中的下标 */
@property (assign, nonatomic) NSInteger selectedIndex;
/** 源控制器 */
@property (weak, nonatomic) UIViewController *fromVC;

/** 👀 图片 👀 */
@property (strong, nonatomic) NSArray<UIImage *> *images;
/** 👀 图片URL 👀 */
@property (strong, nonatomic) NSArray<NSString *> *urls;

/** 👀 配置参数类 👀 */
@property (strong, nonatomic) XCPhotoBrowserConfigure *configure;


/**
 *  显示
 */
- (void)show;

@end
