//
//  TVShowViewController.m
//  ShowTime
//
//  Created by xinyue-0 on 16/7/22.
//  Copyright © 2016年 xinyue-0. All rights reserved.
//

#import "TVShowViewController.h"
#import <IJKMediaFramework/IJKMediaFramework.h>

@interface TVShowViewController ()

@property (atomic, retain) id <IJKMediaPlayback> player;

@property (weak, nonatomic) UIView *PlayerView;

@end

@implementation TVShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self goPlaying];
    
    
    //rtmp://203.207.99.19:1935/live/CCTV1
    //rtmp://live.hkstv.hk.lxdns.com/live/hks

    _player = [[IJKFFMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:_channelString] withOptions:nil];
    
    UIView *tView = [self.player view];
    UIView *displayView = [[UIView alloc] initWithFrame:self.view.bounds];
    
    _PlayerView = displayView;
    [self.view addSubview:_PlayerView];
    
    tView.frame = _PlayerView.bounds;
    _PlayerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [_PlayerView insertSubview:tView atIndex:1];
    [_player setScalingMode:IJKMPMovieScalingModeAspectFit];
    
    [_player prepareToPlay];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadStateDidChange:) name:IJKMPMoviePlayerLoadStateDidChangeNotification object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayBackFinish:) name:IJKMPMoviePlayerPlaybackDidFinishNotification object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mediaIsPreparedToPlayDidChange:) name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayBackStateDidChange:) name:IJKMPMoviePlayerPlaybackStateDidChangeNotification object:_player];
    
    
    
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IJKMPMoviePlayerLoadStateDidChangeNotification object:_player];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IJKMPMoviePlayerPlaybackDidFinishNotification object:_player];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification object:_player];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IJKMPMoviePlayerPlaybackStateDidChangeNotification object:_player];
    
    [_player pause];
    
    [_player stop];
    
}


- (void)loadStateDidChange:(NSNotification *)noti {
    NSLog(@"loadStateDidChange-------%@",noti);
}

- (void)moviePlayBackFinish:(NSNotification *)noti {
    NSLog(@"moviePlayBackFinish-------%@",noti);
}

- (void)mediaIsPreparedToPlayDidChange:(NSNotification *)noti {
    NSLog(@"mediaIsPreparedToPlayDidChange-------%@",noti);
}

- (void)moviePlayBackStateDidChange:(NSNotification *)noti {
    NSLog(@"moviePlayBackStateDidChange--------%@",noti);
}

- (void)goPlaying {
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
