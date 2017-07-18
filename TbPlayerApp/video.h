//
//  video.h
//  TbPlayerApp
//
//  Created by mac on 2017/7/10.
//  Copyright © 2017年 macTb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface video : NSObject
/**名称*/
@property(nonatomic, copy) NSString *name;
/**大小*/
@property(nonatomic, assign) long long videSize; //Bytes
/**时长**/
@property(nonatomic, strong) NSNumber *duration;
/**名称*/
@property(nonatomic, copy) NSString *format;
/**缩略图*/
@property(nonatomic, strong) UIImage *thumbnail;
/**播放地址*/
@property (nonatomic, strong) NSURL *videoURL;

@end
