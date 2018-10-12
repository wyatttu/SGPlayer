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
@property (weak, nonatomic) IBOutlet NSView * view1;
@property (weak, nonatomic) IBOutlet NSView * view2;

@property (weak, nonatomic) IBOutlet NSTextField * stateLabel;
@property (weak, nonatomic) IBOutlet NSSlider * progressSilder;
@property (weak, nonatomic) IBOutlet NSTextField * currentTimeLabel;
@property (weak, nonatomic) IBOutlet NSTextField * totalTimeLabel;

@property (nonatomic, assign) BOOL progressSilderTouching;

@end

@implementation PlayerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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

//-(void)viewDidLayout {
//    [super viewDidLayout];
//    self.player.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
//}

- (IBAction)play:(id)sender
{
    [self.player play];
}

- (IBAction)pause:(id)sender
{
    [self.player pause];
}

- (IBAction)progressTouchDown:(id)sender
{
    self.progressSilderTouching = YES;
}

- (IBAction)progressTouchUp:(id)sender
{
    self.progressSilderTouching = NO;
    CMTime time = CMTimeMultiplyByFloat64(self.player.duration, self.progressSilder.doubleValue);
    [self.player seekToTime:time];
}

- (IBAction)progressValueChanged:(id)sender
{
    CMTime time = CMTimeMultiplyByFloat64(self.player.duration, self.progressSilder.doubleValue);
    [self.player seekToTime:time];
}

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
                self.stateLabel.stringValue = @"Idle";
                break;
            case SGPlaybackStatePlaying:
                self.stateLabel.stringValue = @"Playing";
                break;
            case SGPlaybackStatePaused:
                self.stateLabel.stringValue = @"Paused";
                break;
            case SGPlaybackStateFinished:
                self.stateLabel.stringValue = @"Finished";
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
            self.progressSilder.doubleValue = CMTimeGetSeconds(playbackTime) / CMTimeGetSeconds(duration);
        }
        self.currentTimeLabel.stringValue = [self timeStringFromSeconds:CMTimeGetSeconds(playbackTime)];
        self.totalTimeLabel.stringValue = [self timeStringFromSeconds:CMTimeGetSeconds(duration)];
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
