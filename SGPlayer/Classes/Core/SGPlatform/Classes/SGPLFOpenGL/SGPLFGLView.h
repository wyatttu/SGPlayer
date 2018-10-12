//
//  SGPLFGLView.h
//  SGPlatform
//
//  Created by Single on 2017/2/23.
//  Copyright © 2017年 single. All rights reserved.
//

#import "SGPLFOpenGL.h"

#import "SGPLFGLContext.h"

#if SGPLATFORM_TARGET_OS_MAC

@interface SGPLFGLView : NSOpenGLView

@property (nonatomic, strong) CAOpenGLLayer * glLayer;

#elif SGPLATFORM_TARGET_OS_IPHONE_OR_TV

@interface SGPLFGLView : UIView
@property (nonatomic, strong) CAEAGLLayer * glLayer;

#endif

@property (nonatomic, strong) SGPLFGLContext * context;
@property (nonatomic, assign) double glScale;

- (void)renderbufferStorage;
- (void)present;

@end
