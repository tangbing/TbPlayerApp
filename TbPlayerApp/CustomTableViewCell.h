//
//  CustomTableViewCell.h
//  TbPlayerApp
//
//  Created by mac on 2017/7/10.
//  Copyright © 2017年 macTb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *videoImageView;
@property (weak, nonatomic) IBOutlet UILabel *videoTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *videoOfDiskSize;

@end
