//
//  TextLocalImageViewController.m
//  XCPhotoBrowserExample
//
//  Created by 樊小聪 on 2017/6/14.
//  Copyright © 2017年 樊小聪. All rights reserved.
//


/*
 *  备注：本地图片 🐾
 */


#import "TextLocalImageViewController.h"

#import "XCPhotoBrowserManager.h"

@interface TextLocalImageViewController ()

@property (weak, nonatomic) IBOutlet UIView *imageContainerView;

@property (strong, nonatomic) NSArray<UIImage *> *imgsArr;


@end

@implementation TextLocalImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /// 设置 UI
    [self setupUI];
}

#pragma mark - 💤 👀 LazyLoad Method 👀

- (NSArray<UIImage *> *)imgsArr
{
    if (!_imgsArr)
    {
        NSMutableArray *mArr = [NSMutableArray array];
        
        for (NSInteger i = 0; i < 9; i ++)
        {
            NSString *imgName = [NSString stringWithFormat:@"%zi.jpg", i + 1];
            [mArr addObject:[UIImage imageNamed:imgName]];
        }
        
        _imgsArr = mArr;
    }
    
    return _imgsArr;
}

/**
 *  设置 UI
 */
- (void)setupUI
{
    NSInteger imageCount = self.imageContainerView.subviews.count;
    
    for (NSInteger i = 0; i < imageCount; i ++)
    {
        UIImageView *imgView = self.imageContainerView.subviews[i];
        imgView.userInteractionEnabled = YES;
        [imgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickImageAction:)]];
    }
}

#pragma mark - 🎬 👀 Action Method 👀

- (void)didClickImageAction:(UITapGestureRecognizer *)tap
{
    UIImageView *imgView = (UIImageView *)tap.view;
    
    NSInteger index = (imgView.tag - 10);
    
    /// 图片浏览 --- 本地
    [XCPhotoBrowserManager showFromViewController:self.navigationController
                                    selectedIndex:index
                                 seletedImageView:imgView
                                           images:self.imgsArr
                                        configure:NULL];
}

@end
