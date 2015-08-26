//
//  HomeViewController.m
//  UberLoginDemo
//
//  Created by 宋志明 on 15-8-26.
//  Copyright (c) 2015年 宋志明. All rights reserved.
//

#import "HomeViewController.h"
#import <AVFoundation/AVFoundation.h>
static const float PLAYER_VOLUME = 0.0;
@interface HomeViewController ()
@property (nonatomic) AVPlayer *player;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createVideoPlayer];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//添加播放
- (void)createVideoPlayer
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"welcome_video" ofType:@"mp4"];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    AVPlayerItem *playItem = [AVPlayerItem playerItemWithURL:url];
    
    [playItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
    self.player = [AVPlayer playerWithPlayerItem:playItem];
    self.player.volume = PLAYER_VOLUME;
    
    
    AVPlayerLayer *playerlayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    
    playerlayer.videoGravity = UIViewContentModeScaleToFill;
    playerlayer.frame = [[UIScreen mainScreen] bounds];
    [self.view.layer addSublayer:playerlayer];
    
    [self.player play];
    
    [self.player.currentItem addObserver:self forKeyPath:AVPlayerItemDidPlayToEndTimeNotification options:NSKeyValueObservingOptionNew context:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
}

// 视频循环播放
- (void)moviePlayDidEnd:(NSNotification*)notification{
    
    AVPlayerItem *item = [notification object];
    [item seekToTime:kCMTimeZero];
    [self.player play];
}
#pragma mark - observer of player
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
}
@end
