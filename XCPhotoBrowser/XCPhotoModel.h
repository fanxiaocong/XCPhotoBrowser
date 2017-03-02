//
//  XCPhotoModel.h
//  照片浏览器
//
//  Created by 樊小聪 on 2016/12/20.
//  Copyright © 2016年 樊小聪. All rights reserved.
//


/*
 *  备注：图片模型 🐾
 */


#import <UIKit/UIKit.h>

@interface XCPhotoModel : NSObject

///** 源imageView 的尺寸 */
//@property (nonatomic, weak) UIImageView *sourceImageView;
@property (assign, nonatomic) CGRect sourcePhotoF;

/** 👀 图片数据 👀 */
@property (strong, nonatomic) UIImage *image;

/** 👀 图片地址 👀 */
@property (copy, nonatomic) NSString *url;

/** 是否已经加载完毕 */
@property (assign, nonatomic) BOOL hasLoadedFinish;

/** 是否从源frame放大呈现 */
@property (nonatomic,assign) BOOL isFromSourceFrame;

/** 返回源视图时是否缩小返回 */
@property (assign, nonatomic) BOOL isDismissScale;

@end



































