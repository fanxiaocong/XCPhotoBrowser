//
//  XCPhotoBrowserModel.h
//  XiaoYiService
//
//  Created by 樊小聪 on 2017/6/9.
//  Copyright © 2017年 樊小聪. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface XCPhotoBrowserModel : NSObject

/** 源imageView 的尺寸 */
@property (assign, nonatomic) CGRect sourcePhotoF;

/** 👀 图片数据 👀 */
@property (strong, nonatomic) UIImage *image;

/** 👀 图片地址 👀 */
@property (copy, nonatomic) NSString *url;

/** 标记 返回源视图时是否缩小返回 */
@property (assign, nonatomic) BOOL isDismissScale;

/** 标记 是否从源frame放大呈现 */
@property (nonatomic,assign) BOOL isFromSourceFrame;

@end
