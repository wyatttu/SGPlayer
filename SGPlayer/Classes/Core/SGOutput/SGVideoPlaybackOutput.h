//
//  SGVideoPlaybackOutput.h
//  SGPlayer
//
//  Created by Single on 2018/1/22.
//  Copyright © 2018年 single. All rights reserved.
//

#import "SGOutput.h"
#import "SGPlatform.h"
#import "SGVideoFrame.h"
#import "SGVRViewport.h"
#import "SGPlaybackTimeSync.h"

@interface SGVideoPlaybackOutput : NSObject <SGOutput>

@property (nonatomic, strong) SGPlaybackTimeSync * timeSync;
@property (nonatomic, assign) CMTime rate;

@property (nonatomic, strong) SGPLFView * view;
@property (nonatomic, assign) SGScalingMode scalingMode;
@property (nonatomic, assign) SGDisplayMode displayMode;
#if SGPLATFORM_TARGET_OS_IPHONE_OR_TV
@property (nonatomic, strong) SGVRViewport * viewport;
#endif
@property (nonatomic, assign) CMTime displayInterval;
@property (nonatomic, copy) BOOL (^discardFilter)(CMSampleTimingInfo timingInfo, NSUInteger index);
@property (nonatomic, copy) void (^renderCallback)(SGVideoFrame * frame);

- (SGPLFImage *)originalImage;
- (SGPLFImage *)snapshot;

@end
