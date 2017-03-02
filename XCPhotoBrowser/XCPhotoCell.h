//
//  XCPhotoCell.h
//  照片浏览器
//
//  Created by 樊小聪 on 2016/12/20.
//  Copyright © 2016年 樊小聪. All rights reserved.
//


/*
 *  备注：图片cell 🐾
 */


#import <UIKit/UIKit.h>

@class XCPhotoModel;

@interface XCPhotoCell : UICollectionViewCell

/** 👀 数据模型 👀 */
@property (strong, nonatomic) XCPhotoModel *photoM;

/** 👀 源图片视图 👀 */
@property (strong, nonatomic) UIImage *sourceImage;

/** 👀 当前图片的缩放比例 👀 */
@property (assign, nonatomic) CGFloat zoomScale;

/** 👀 单击的回调 👀 */
@property (copy, nonatomic) void(^didTapSingleHandle)();


/**
 消失操作
 
 @param compeletionBlock 消失时的回调
 */
- (void)dismissHandle:(void(^)())compeletionBlock;


@end
