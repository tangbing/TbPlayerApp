//
//  ViewController.m
//  TbPlayerApp
//
//  Created by mac on 2017/7/10.
//  Copyright © 2017年 macTb. All rights reserved.
//

#import "ViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "UIView+XMGExtension.h"
#import "CustomTableViewCell.h"
#import <MJExtension.h>
#import "video.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *customTableView;
@property (nonatomic, copy)NSMutableArray *ulrStrings;

@property (nonatomic, strong)NSMutableArray *videoArray;

@property (nonatomic, strong)NSMutableDictionary *dict;

@property (nonatomic, strong)AVPlayerViewController *playerView;

@property (nonatomic, strong) AVPlayer *player;

@end

@implementation ViewController

static NSString* const ID = @"cellIDentifier";


- (NSMutableArray *)videoArray
{
    if (!_videoArray) {
        _videoArray = [NSMutableArray array];
    }
    return _videoArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    [self.customTableView registerNib:[UINib nibWithNibName:NSStringFromClass([CustomTableViewCell class]) bundle:nil] forCellReuseIdentifier:ID];
    self.customTableView.rowHeight = 90;
    
     [self setupVideo];
}

- (void)setupVideo
{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            [group setAssetsFilter:[ALAssetsFilter allVideos]];
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                if (result) {
                    video *v = [[video alloc] init];
                    v.thumbnail = [UIImage imageWithCGImage:result.thumbnail];
                    v.videoURL = result.defaultRepresentation.url;
                    v.duration = [result valueForProperty:ALAssetPropertyDuration];
                    v.name =  [self getFormatedDateStringOfDate:[result valueForProperty:ALAssetPropertyDate]];
                    v.videSize = result.defaultRepresentation.size;
                    v.format = [result.defaultRepresentation.filename pathExtension];
                    [self.videoArray addObject:v];
                }
                
            }];
        } else {
            // 没有更多的group时，既可认为已经加载完成
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showAlbumVideo];
            });
        }
        
    } failureBlock:^(NSError *error) {
        NSLog(@"%@",[error localizedDescription]);
    }];
    
}

- (NSString *)getFormatedDateStringOfDate:(NSDate *)date
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setTimeZone:[NSTimeZone localTimeZone]];
    [fmt setDateFormat:@"yyyyMMddHHmmss"];
    NSString *daetString = [fmt stringFromDate:date];
    return daetString;
}

- (NSString*)caculatorSize:(long long)bytesSize
{
    //Byte --> M
    double mSize = bytesSize / (1024 * 1024);
    return [NSString stringWithFormat:@"%.1fM",mSize];
}

- (void)showAlbumVideo
{
    [self.customTableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return self.videoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];

    video *v = self.videoArray[indexPath.row];
    cell.videoTitleLabel.text = [NSString stringWithFormat:@"%@.%@",v.name,v.format];
    cell.videoImageView.image = v.thumbnail;
    cell.videoOfDiskSize.text = [self caculatorSize:v.videSize];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    video *v = self.videoArray[indexPath.row];
    if (!_playerView) {
        _playerView = [[AVPlayerViewController alloc] init];
        
        //视频播放的url
        NSURL *playerURL = v.videoURL;
        
        
        
        //初始化
        self.playerView = [[AVPlayerViewController alloc]init];
        
        //AVPlayerItem 视频的一些信息  创建AVPlayer使用的
        AVPlayerItem *item = [[AVPlayerItem alloc]initWithURL:playerURL];
        
        //通过AVPlayerItem创建AVPlayer
        self.player = [[AVPlayer alloc]initWithPlayerItem:item];
        
        //给AVPlayer一个播放的layer层
        AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        
        layer.frame = self.view.bounds;
        
        layer.backgroundColor = [UIColor greenColor].CGColor;
        
        //设置AVPlayer的填充模式
        layer.videoGravity = AVLayerVideoGravityResize;
        
        [self.view.layer addSublayer:layer];
        
        //设置AVPlayerViewController内部的AVPlayer为刚创建的AVPlayer
        self.playerView.player = self.player;
        
        //关闭AVPlayerViewController内部的约束
        self.playerView.view.translatesAutoresizingMaskIntoConstraints = YES;
        
        [self presentViewController:self.playerView animated:YES completion:nil];
    }
}

@end
