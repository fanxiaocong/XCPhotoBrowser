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



