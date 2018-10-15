//
//  PlayerViewController.m
//  demo-ios
//
//  Created by Single on 2017/3/15.
//  Copyright © 2017年 single. All rights reserved.
//

#import "PlayerViewController.h"
#import <SGPlayer/SGPlayer.h>
//#import <SGAVPlayer/SGAVPlayer.h>

@interface PlayerViewController () <SGPlayerDelegate>

@property (nonatomic, strong) SGPlayer * player;
@property (nonatomic, strong) SGPlayer * player2;
@property (weak, nonatomic) IBOutlet UIView * view1;
@property (weak, nonatomic) IBOutlet UIView * view2;

@property (weak, nonatomic) IBOutlet UILabel * stateLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progressSilder;
@property (weak, nonatomic) IBOutlet UILabel * currentTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel * totalTimeLabel;

@property (nonatomic, assign) BOOL progressSilderTouching;

@end

@implementation PlayerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    NSURL * contentURL1 = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"i-see-fire" ofType:@"mp4"]];
    NSURL * contentURL2 = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"google-help-vr" ofType:@"mp4"]];
    
    NSMutableArray * assets = [NSMutableArray array];
    for (int i = 0; i < 1; i++)
    {
        SGURLAsset * asset1 = [[SGURLAsset alloc] initWithURL:contentURL1];
        //        asset1.scale = CMTimeMake(1, 3);
        //        SGURLAsset * asset2 = [[SGURLAsset alloc] initWithURL:contentURL2];
        [assets addObject:asset1];
        //        [assets addObject:asset2];
    }
    SGConcatAsset * asset = [[SGConcatAsset alloc] initWithAssets:assets];
    
    self.player = [[SGPlayer alloc] init];
    self.player.delegate = self;
    self.player.view = self.view1;
    
    //    self.player.hardwareDecodeH264 = NO;
    
    SGDiscardFilter * discardFilter = [[SGDiscardFilter alloc] init];
    discardFilter.minimumInterval = CMTimeMake(1, 30);
    
    //    [self.player setCodecDiscardPacketFilter:^BOOL(CMSampleTimingInfo timingInfo, NSUInteger index, BOOL key) {
    //        if (index == 0) {
    //            [discardFilter flush];
    //        }
    //        return [discardFilter discardWithTimeStamp:timingInfo.decodeTimeStamp];
    //    }];
    
    //    [self.player setDisplayDiscardFilter:^BOOL(CMSampleTimingInfo timingInfo, NSUInteger index) {
    //        if (index == 0) {
    //            [discardFilter flush];
    //        }
    //        return [discardFilter discardWithTimeStamp:timingInfo.presentationTimeStamp];
    //    }];
    
    [self.player setDisplayRenderCallback:^(SGVideoFrame * frame) {
        //        NSLog(@"Render : %f", CMTimeGetSeconds(frame.timeStamp));
    }];
    
    [self.player replaceWithAsset:asset];
    [self.player play];
}

//- (void)viewDidLayoutSubviews
//{
//    [super viewDidLayoutSubviews];
//    self.player.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) / 2);
//    self.player2.view.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds) / 2, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) / 2);
//}

- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)play:(id)sender
{
    [self.player play];
    [self.player2 play];
}

- (IBAction)pause:(id)sender
{
    [self.player pause];
    [self.player2 pause];
}

//- (IBAction)progressTouchDown:(id)sender
//{
//    self.progressSilderTouching = YES;
//}

//- (IBAction)progressTouchUp:(id)sender
//{
//    self.progressSilderTouching = NO;
//    CMTime time = CMTimeMultiplyByFloat64(self.player.duration, self.progressSilder.value);
//    CMTime time2 = CMTimeMultiplyByFloat64(self.player2.duration, self.progressSilder.value);
//    [self.player seekToTime:time];
//    [self.player2 seekToTime:time2];
//}
//
//- (IBAction)progressValueChanged:(id)sender
//{
//    CMTime time = CMTimeMultiplyByFloat64(self.player.duration, self.progressSilder.value);
//    CMTime time2 = CMTimeMultiplyByFloat64(self.player2.duration, self.progressSilder.value);
//    [self.player seekToTime:time];
//    [self.player2 seekToTime:time2];
//}

#pragma mark - SGPlayerDelegate

- (void)player:(SGPlayer *)player didChangeState:(SGStateOption)option
{
    if (option & SGStateOptionPrepare)
    {
        NSLog(@"prepareState, %ld", player.prepareState);
    }
    else if (option & SGStateOptionPlayback)
    {
        NSLog(@"playbackState, %ld", player.playbackState);
        switch (player.playbackState)
        {
            case SGPlaybackStateNone:
                self.stateLabel.text = @"Idle";
                break;
            case SGPlaybackStatePlaying:
                self.stateLabel.text = @"Playing";
                break;
            case SGPlaybackStatePaused:
                self.stateLabel.text = @"Paused";
                break;
            case SGPlaybackStateFinished:
                self.stateLabel.text = @"Finished";
                break;
        }
    }
    else if (option & SGStateOptionLoading)
    {
        NSLog(@"loadingState, %ld", player.loadingState);
    }
}

- (void)player:(SGPlayer *)player didChangeTime:(SGTimeOption)option
{
    if (option & SGTimeOptionPlayback)
    {
        CMTime playbackTime = player.playbackTime;
        CMTime duration = player.duration;
        if (!self.progressSilderTouching)
        {
            self.progressSilder.progress = CMTimeGetSeconds(playbackTime) / CMTimeGetSeconds(duration);
        }
        self.currentTimeLabel.text = [self timeStringFromSeconds:CMTimeGetSeconds(playbackTime)];
        self.totalTimeLabel.text = [self timeStringFromSeconds:CMTimeGetSeconds(duration)];
    }
    else if (option & SGTimeOptionLoaded)
    {
        
    }
    else if (option & SGTimeOptionDuration)
    {
        
    }
}

- (void)player:(SGPlayer *)player didFailed:(NSError *)error
{
    NSLog(@"%s, %@", __func__, error);
}

- (NSString *)timeStringFromSeconds:(CGFloat)seconds
{
    return [NSString stringWithFormat:@"%ld:%.2ld", (long)seconds / 60, (long)seconds % 60];
}

@end
