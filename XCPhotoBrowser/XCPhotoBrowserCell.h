//
//  XCPhotoBrowserCell.h
//  XiaoYiService
//
//  Created by 樊小聪 on 2017/6/9.
//  Copyright © 2017年 樊小聪. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XCPhotoBrowserModel;

@interface XCPhotoBrowserCell : UICollectionViewCell

@property (strong, nonatomic) XCPhotoBrowserModel *model;

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
