//
//  XCPhotoBrowserManager.m
//  照片浏览器
//
//  Created by 樊小聪 on 2016/12/20.
//  Copyright © 2016年 樊小聪. All rights reserved.
//

#import "XCPhotoBrowserManager.h"

#import "XCPhotoBrowserController.h"

#import "XCPhotoBrowserModel.h"


@interface XCPhotoBrowserManager ()

@end


@implementation XCPhotoBrowserManager

#pragma mark - 🔓 👀 Public Method 👀

/**
 照片浏览器URL
 
 @param fromVC              源控制器（是从哪一个控制器跳转过来的）
 @param selectedIndex       选中的图片的下标
 @param selectedImageView   选中的图片
 @param urls                图片的url字符串数组
 @param thumbImgs           缩略图片数组
 @param configure           图片配置参数（传空为默认）
 */
+ (void)showFromViewController:(UIViewController *)fromVC
                 selectedIndex:(NSInteger)selectedIndex
              seletedImageView:(UIImageView *)selectedImageView
                          urls:(NSArray<NSString *> *)urls
                     thumbImgs:(NSArray<UIImage *> *)thumbImgs
                     configure:(XCPhotoBrowserConfigure *)configure
{
    if (!urls.count)        return;
    
    XCPhotoBrowserController *vc = [[XCPhotoBrowserController alloc] init];
    
    vc.fromVC     = fromVC;
    vc.configure  = (configure ? configure : [XCPhotoBrowserConfigure defaultConfigure]);
    vc.selectedPhotoView = selectedImageView;
    vc.selectedIndex     = selectedIndex;
    vc.urls = urls;
    vc.images = thumbImgs;
    
    [vc show];
}


/**
 照片浏览器Image
 
 @param fromVC              源控制器（是从哪一个控制器跳转过来的）
 @param selectedIndex       选中的图片的下标
 @param selectedImageView   选中的图片
 @param images              图片数组
 @param configure           图片配置参数（传空为默认）
 */
+ (void)showFromViewController:(UIViewController *)fromVC
                 selectedIndex:(NSInteger)selectedIndex
              seletedImageView:(UIImageView *)selectedImageView
                        images:(NSArray<UIImage *> *)images
                     configure:(XCPhotoBrowserConfigure *)configure
{
    if (!images.count)        return;
    
    XCPhotoBrowserController *vc = [[XCPhotoBrowserController alloc] init];
    
    vc.fromVC     = fromVC;
    vc.configure  = (configure ? configure : [XCPhotoBrowserConfigure defaultConfigure]);
    vc.selectedPhotoView = selectedImageView;
    vc.selectedIndex     = selectedIndex;
    vc.images     = images;
    
    [vc show];
}

@end



