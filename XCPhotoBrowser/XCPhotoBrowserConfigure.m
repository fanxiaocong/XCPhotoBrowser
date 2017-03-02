//
//  XCPhotoBrowserConfigure.m
//  照片浏览器
//
//  Created by 樊小聪 on 2016/12/21.
//  Copyright © 2016年 樊小聪. All rights reserved.
//




/*
 *  备注：照片浏览器的配置类型 🐾
 */


#import "XCPhotoBrowserConfigure.h"

@implementation XCPhotoBrowserConfigure

+ (instancetype)defaultConfigure
{
    XCPhotoBrowserConfigure *configure = [[XCPhotoBrowserConfigure alloc] init];
    
    configure.photoViewEdgeInsets   = UIEdgeInsetsMake(8, 13, 13, 15);
    configure.photoViewRowMargin    = 8;
    configure.photoViewColumnMargin = 8;
    configure.column = 3;
    configure.visibleCount = 5;
    
    return configure;
}

@end
