//
//  ViewController.m
//  XCPhotoBrowserExample
//
//  Created by 樊小聪 on 2017/3/2.
//  Copyright © 2017年 樊小聪. All rights reserved.
//

#import "ViewController.h"

#import "PhotoCell.h"

#import "XCPhotoBrowserManager.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *urls;

@end

@implementation ViewController

static NSString *const identifier = @"identifier";

- (NSArray *)urls
{
    if (_urls == nil)
    {
        _urls = @[@"http://pic.qiantucdn.com/58pic/18/32/09/79u58PIC4Hd_1024.jpg",
                  @"http://img15.3lian.com/2015/f2/50/d/72.jpg",
                  @"http://pic15.huitu.com/res/20140104/1030_20140104233019653200_1.jpg",
                  @"http://pic45.nipic.com/20140805/19318768_143539178000_2.jpg",
                  @"http://img15.3lian.com/2015/f2/160/d/78.jpg",
                  @"http://d.3987.com/fengj_141110/015.jpg",
                  @"http://pic1.win4000.com/wallpaper/5/540556f306f26.jpg",
                  @"http://img15.3lian.com/2015/f2/50/d/71.jpg",
                  @"http://img2.imgtn.bdimg.com/it/u=3128197163,2700290480&fm=21&gp=0.jpg",
                  @"http://img15.3lian.com/2015/f2/50/d/75.jpg",
                  @"http://img15.3lian.com/2015/f2/50/d/70.jpg",
                  @"http://e.hiphotos.baidu.com/zhidao/pic/item/730e0cf3d7ca7bcb96e256f5bc096b63f724a84b.jpg",
                  @"http://file.mumayi.com/forum/201305/06/084948ga3x60oa00fpxuz6.jpg",
                  @"http://image.tianjimedia.com/uploadImages/2012/009/0PGK5PB076Q4.jpg",
                  @"http://download.pchome.net/index.php?c=PicView&picurl=http%3A%2F%2Fimg.download.pchome.net%2F3k%2Fgr%2F134639.jpg",
                  @"http://pic.qiantucdn.com/58pic/18/32/09/79u58PIC4Hd_1024.jpg",
                  @"http://img15.3lian.com/2015/f2/50/d/72.jpg",
                  @"http://pic15.huitu.com/res/20140104/1030_20140104233019653200_1.jpg",
                  @"http://pic45.nipic.com/20140805/19318768_143539178000_2.jpg",
                  @"http://img15.3lian.com/2015/f2/160/d/78.jpg",
                  @"http://d.3987.com/fengj_141110/015.jpg",
                  @"http://pic1.win4000.com/wallpaper/5/540556f306f26.jpg",
                  @"http://img15.3lian.com/2015/f2/50/d/71.jpg",
                  @"http://img2.imgtn.bdimg.com/it/u=3128197163,2700290480&fm=21&gp=0.jpg",
                  @"http://img15.3lian.com/2015/f2/50/d/75.jpg",
                  @"http://img15.3lian.com/2015/f2/50/d/70.jpg",
                  @"http://e.hiphotos.baidu.com/zhidao/pic/item/730e0cf3d7ca7bcb96e256f5bc096b63f724a84b.jpg",
                  @"http://file.mumayi.com/forum/201305/06/084948ga3x60oa00fpxuz6.jpg",
                  @"http://image.tianjimedia.com/uploadImages/2012/009/0PGK5PB076Q4.jpg",
                  @"http://download.pchome.net/index.php?c=PicView&picurl=http%3A%2F%2Fimg.download.pchome.net%2F3k%2Fgr%2F134639.jpg",@"http://pic.qiantucdn.com/58pic/18/32/09/79u58PIC4Hd_1024.jpg",
                  @"http://img15.3lian.com/2015/f2/50/d/72.jpg",
                  @"http://pic15.huitu.com/res/20140104/1030_20140104233019653200_1.jpg",
                  @"http://pic45.nipic.com/20140805/19318768_143539178000_2.jpg",
                  @"http://img15.3lian.com/2015/f2/160/d/78.jpg",
                  @"http://d.3987.com/fengj_141110/015.jpg",
                  @"http://pic1.win4000.com/wallpaper/5/540556f306f26.jpg",
                  @"http://img15.3lian.com/2015/f2/50/d/71.jpg",
                  @"http://img2.imgtn.bdimg.com/it/u=3128197163,2700290480&fm=21&gp=0.jpg",
                  @"http://img15.3lian.com/2015/f2/50/d/75.jpg",
                  @"http://img15.3lian.com/2015/f2/50/d/70.jpg",
                  @"http://e.hiphotos.baidu.com/zhidao/pic/item/730e0cf3d7ca7bcb96e256f5bc096b63f724a84b.jpg",
                  @"http://file.mumayi.com/forum/201305/06/084948ga3x60oa00fpxuz6.jpg",
                  @"http://image.tianjimedia.com/uploadImages/2012/009/0PGK5PB076Q4.jpg",
                  @"http://download.pchome.net/index.php?c=PicView&picurl=http%3A%2F%2Fimg.download.pchome.net%2F3k%2Fgr%2F134639.jpg",
                  @"http://pic.qiantucdn.com/58pic/18/32/09/79u58PIC4Hd_1024.jpg",
                  @"http://img15.3lian.com/2015/f2/50/d/72.jpg",
                  @"http://pic15.huitu.com/res/20140104/1030_20140104233019653200_1.jpg",
                  @"http://pic45.nipic.com/20140805/19318768_143539178000_2.jpg",
                  @"http://img15.3lian.com/2015/f2/160/d/78.jpg",
                  @"http://d.3987.com/fengj_141110/015.jpg",
                  @"http://pic1.win4000.com/wallpaper/5/540556f306f26.jpg",
                  @"http://img15.3lian.com/2015/f2/50/d/71.jpg",
                  @"http://img2.imgtn.bdimg.com/it/u=3128197163,2700290480&fm=21&gp=0.jpg",
                  @"http://img15.3lian.com/2015/f2/50/d/75.jpg",
                  @"http://img15.3lian.com/2015/f2/50/d/70.jpg",
                  @"http://e.hiphotos.baidu.com/zhidao/pic/item/730e0cf3d7ca7bcb96e256f5bc096b63f724a84b.jpg",
                  @"http://file.mumayi.com/forum/201305/06/084948ga3x60oa00fpxuz6.jpg",
                  @"http://image.tianjimedia.com/uploadImages/2012/009/0PGK5PB076Q4.jpg",
                  @"http://download.pchome.net/index.php?c=PicView&picurl=http%3A%2F%2Fimg.download.pchome.net%2F3k%2Fgr%2F134639.jpg",@"http://pic.qiantucdn.com/58pic/18/32/09/79u58PIC4Hd_1024.jpg",
                  @"http://img15.3lian.com/2015/f2/50/d/72.jpg",
                  @"http://pic15.huitu.com/res/20140104/1030_20140104233019653200_1.jpg",
                  @"http://pic45.nipic.com/20140805/19318768_143539178000_2.jpg",
                  @"http://img15.3lian.com/2015/f2/160/d/78.jpg",
                  @"http://d.3987.com/fengj_141110/015.jpg",
                  @"http://pic1.win4000.com/wallpaper/5/540556f306f26.jpg",
                  @"http://img15.3lian.com/2015/f2/50/d/71.jpg",
                  @"http://img2.imgtn.bdimg.com/it/u=3128197163,2700290480&fm=21&gp=0.jpg",
                  @"http://img15.3lian.com/2015/f2/50/d/75.jpg",
                  @"http://img15.3lian.com/2015/f2/50/d/70.jpg",
                  @"http://e.hiphotos.baidu.com/zhidao/pic/item/730e0cf3d7ca7bcb96e256f5bc096b63f724a84b.jpg",
                  @"http://file.mumayi.com/forum/201305/06/084948ga3x60oa00fpxuz6.jpg",
                  @"http://image.tianjimedia.com/uploadImages/2012/009/0PGK5PB076Q4.jpg",
                  @"http://download.pchome.net/index.php?c=PicView&picurl=http%3A%2F%2Fimg.download.pchome.net%2F3k%2Fgr%2F134639.jpg",
                  @"http://pic.qiantucdn.com/58pic/18/32/09/79u58PIC4Hd_1024.jpg",
                  @"http://img15.3lian.com/2015/f2/50/d/72.jpg",
                  @"http://pic15.huitu.com/res/20140104/1030_20140104233019653200_1.jpg",
                  @"http://pic45.nipic.com/20140805/19318768_143539178000_2.jpg",
                  @"http://img15.3lian.com/2015/f2/160/d/78.jpg",
                  @"http://d.3987.com/fengj_141110/015.jpg",
                  @"http://pic1.win4000.com/wallpaper/5/540556f306f26.jpg",
                  @"http://img15.3lian.com/2015/f2/50/d/71.jpg",
                  @"http://img2.imgtn.bdimg.com/it/u=3128197163,2700290480&fm=21&gp=0.jpg",
                  @"http://img15.3lian.com/2015/f2/50/d/75.jpg",
                  @"http://img15.3lian.com/2015/f2/50/d/70.jpg",
                  @"http://e.hiphotos.baidu.com/zhidao/pic/item/730e0cf3d7ca7bcb96e256f5bc096b63f724a84b.jpg",
                  @"http://file.mumayi.com/forum/201305/06/084948ga3x60oa00fpxuz6.jpg",
                  @"http://image.tianjimedia.com/uploadImages/2012/009/0PGK5PB076Q4.jpg",
                  @"http://download.pchome.net/index.php?c=PicView&picurl=http%3A%2F%2Fimg.download.pchome.net%2F3k%2Fgr%2F134639.jpg"
                  ];
    }
    return _urls;
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
    
    cell.urls = self.urls;
    
    cell.didClickImgView = ^(NSInteger index, UIImageView *imgView) {
        
        __weak typeof(self) weakSelf = self;
        
        [XCPhotoBrowserManager showFromViewController:weakSelf selectedIndex:index seletedImageView:imgView urls:self.urls configure:NULL];
    };
    
    return cell;
}


@end
