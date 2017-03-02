//
//  XCPhotoBrowserConfigure.h
//  照片浏览器
//
//  Created by 樊小聪 on 2016/12/21.
//  Copyright © 2016年 樊小聪. All rights reserved.
//


/*
 *  备注：照片浏览器的配置类型 🐾
 */



#import <UIKit/UIKit.h>

@interface XCPhotoBrowserConfigure : NSObject

/** 👀 原视图 上、下、左、右的间距 👀 */
@property (assign, nonatomic) UIEdgeInsets photoViewEdgeInsets;
/** 👀 行间距 👀 */
@property (assign, nonatomic) CGFloat photoViewRowMargin;
/** 👀 列间距 👀 */
@property (assign, nonatomic) CGFloat photoViewColumnMargin;
/** 👀 列数 👀 */
@property (assign, nonatomic) NSInteger column;
/** 👀 可见图片的数量 （当前可见的图片的数量，默认是全部图片都可见。注：可见的图片是带有缩放效果的图片，不可见的图片是不带有缩放效果的图片） 👀 */
@property (assign, nonatomic) NSInteger visibleCount;


/**
 默认配置
 */
+ (instancetype)defaultConfigure;

@end
