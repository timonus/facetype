//
//  UIFont+TSAdditions.m
//  Typeset
//
//  Created by Tim Johnsen on 9/16/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "UIFont+TSAdditions.h"

@implementation UIFont (TSAdditions)

+ (CGFloat)faceTypeFontSize {
	return [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad ? 100.0f : 36.0f;
}

+ (CGFloat)faceTypeGlyphSize {
	return [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad ? 650.0f : 200.0f;
}

@end
