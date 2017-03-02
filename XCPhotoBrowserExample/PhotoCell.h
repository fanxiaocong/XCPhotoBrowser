//
//  PhotoCell.h
//  TestPhoto
//
//  Created by 樊小聪 on 16/4/25.
//  Copyright © 2016年 樊小聪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoCell : UITableViewCell

@property (strong, nonatomic) NSArray *urls;


@property (copy, nonatomic) void(^didClickImgView)(NSInteger index, UIImageView *imgView);


@end
