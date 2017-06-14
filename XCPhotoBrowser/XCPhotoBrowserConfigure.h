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

/**
 *  原视图 上、下、左、右的间距：默认(5, 5, 0, 0)
 *
 *  注：只有前面两个参数（上、左）有效，只需设置前面两个参数
 */
@property (assign, nonatomic) UIEdgeInsets photoViewEdgeInsets;
/** 👀 行间距：默认 5 👀 */
@property (assign, nonatomic) CGFloat photoViewRowMargin;
/** 👀 列间距：默认 5👀 */
@property (assign, nonatomic) CGFloat photoViewColumnMargin;
/** 👀 列数：默认 3 👀 */
@property (assign, nonatomic) NSInteger column;

/**
 默认配置
 */
+ (instancetype)defaultConfigure;

@end
