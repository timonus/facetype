//
//  TSAppDelegate.m
//  Typeset
//
//  Created by Tim Johnsen on 9/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TSAppDelegate.h"
#import "TempFontsViewController.h"

@implementation TSAppDelegate

@synthesize window = _window;

#pragma mark -
#pragma mark NSObject

- (void)dealloc {
	[_window release];
	[_navigationController release];
    [super dealloc];
}

#pragma mark -
#pragma mark UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
	
	TempFontsViewController *viewController = [[TempFontsViewController alloc] init];
	_navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
	[_navigationController setNavigationBarHidden:YES];
	[viewController release];
	
	[[self window] addSubview:[_navigationController view]];
	
    return YES;
}

@end
