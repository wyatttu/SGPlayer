//
//  AppDelegate.m
//  demo-macos
//
//  Created by Single on 2017/3/15.
//  Copyright © 2017年 single. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    NSSetUncaughtExceptionHandler(&exceptionHandler);
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

void exceptionHandler(NSException *anException)
{
    NSLog(@"%@", [anException reason]);
    NSLog(@"%@", [anException userInfo]);
    
    [NSApp terminate:nil];  // you can call exit() instead if desired
}

@end
