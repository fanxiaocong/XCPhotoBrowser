//
//  TextNetImageViewController.m
//  XCPhotoBrowserExample
//
//  Created by 樊小聪 on 2017/6/14.
//  Copyright © 2017年 樊小聪. All rights reserved.
//



/*
 *  备注：网络图片 🐾
 */

#import "TextNetImageViewController.h"

#import "PhotoCell.h"

#import "XCPhotoBrowserManager.h"

@interface TextNetImageViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

/** 👀 缩略图片URL数组 👀 */
@property (strong, nonatomic) NSArray *thumbURLs;
/** 👀 大图URL数组 👀 */
@property (strong, nonatomic) NSArray *largeURLs;

@end


@implementation TextNetImageViewController

static NSString *const identifier = @"identifier";

- (NSArray *)thumbURLs
{
    if (!_thumbURLs)
    {
        _thumbURLs = @[@"http://ww2.sinaimg.cn/wap360/6204ece1gw1evvzegkumsj20k069f4hm.jpg",
                       @"http://ww1.sinaimg.cn/or360/8faf3cccjw1evvz8z4d9vg208h05okjs.gif",
                       @"http://ww4.sinaimg.cn/or360/8faf3cccjw1evvz92bb87g208h05ox6q.gif",
                       @"http://ww4.sinaimg.cn/wap360/6204ece1gw1evvzh9bp37j20fa08yjt5.jpg",
                       @"http://ww3.sinaimg.cn/wap360/9a099b04gw1evyxrjmnsfj21060o2wm3.jpg",
                       @"http://ww1.sinaimg.cn/wap360/9a099b04gw1evyybmskcnj20m808dt9u.jpg"];
    }
    
    return _thumbURLs;
}

- (NSArray *)largeURLs
{
    if (!_largeURLs)
    {
        _largeURLs = @[@"http://ww2.sinaimg.cn/wap720/6204ece1gw1evvzegkumsj20k069f4hm.jpg",
                       @"http://ww1.sinaimg.cn/large/8faf3cccjw1evvz8z4d9vg208h05okjs.gif",
                       @"http://ww4.sinaimg.cn/large/8faf3cccjw1evvz92bb87g208h05ox6q.gif",
                       @"http://ww4.sinaimg.cn/wap720/6204ece1gw1evvzh9bp37j20fa08yjt5.jpg",
                       @"http://ww3.sinaimg.cn/wap720/9a099b04gw1evyxrjmnsfj21060o2wm3.jpg",
                       @"http://ww1.sinaimg.cn/wap720/9a099b04gw1evyybmskcnj20m808dt9u.jpg"];
    }
    
    return _largeURLs;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.rowHeight = 170;
    [self.tableView registerNib:[UINib nibWithNibName:@"PhotoCell" bundle:nil] forCellReuseIdentifier:identifier];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    cell.urls = self.thumbURLs;
    
    __weak typeof(self) weakSelf = self;
    
    cell.didClickImgView = ^(NSInteger index, UIImageView *imgView) {
        
        NSArray<UIImage *> *thumbImgs = [imgView.superview.subviews valueForKeyPath:@"image"];
        
        XCPhotoBrowserConfigure *configure = [XCPhotoBrowserConfigure defaultConfigure];
        configure.photoViewEdgeInsets   = UIEdgeInsetsMake(8, 13, 8, 0);
        configure.photoViewRowMargin    = 8;
        configure.photoViewColumnMargin = 8;
        configure.column = 2;
        
        /// 图片浏览 --- 网络
        [XCPhotoBrowserManager showFromViewController:weakSelf.navigationController
                                        selectedIndex:index
                                     seletedImageView:imgView
                                                 urls:weakSelf.largeURLs
                                            thumbImgs:thumbImgs
                                            configure:configure];
    };
    
    return cell;
}


@end
