//
//  PhotoCell.m
//  TestPhoto
//
//  Created by 樊小聪 on 16/4/25.
//  Copyright © 2016年 樊小聪. All rights reserved.
//

#import "PhotoCell.h"
#import "UIImageView+WebCache.h"

@interface PhotoCell ()

@end

@implementation PhotoCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
    for (int i = 10; i<15; i++) {
        
        UIImageView *imgView = [self.contentView viewWithTag:i];

        
        [imgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickImg:)]];
    }
}

- (void)didClickImg:(UITapGestureRecognizer *)tap
{
    UIImageView *imgView = (UIImageView *)tap.view;
    
    if (self.didClickImgView)
    {
        self.didClickImgView(imgView.tag - 10, imgView);
    }
}

- (void)setUrls:(NSArray *)urls
{
    _urls = urls;
    
    for (int i = 0; i<urls.count; i++) {
        
        UIImageView *imgView = [self.contentView viewWithTag:i+10];
        
        [imgView sd_setImageWithURL:[NSURL URLWithString:urls[i]]];
    }
}

@end






















