//
//  TJBackButton.m
//  Typeset
//
//  Created by Tim Johnsen on 9/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TJBackButton.h"

@implementation TJBackButton

- (id)init {
	if (self = [super init]) {
		[self setTint:TJBackButtonTintBlack];
	}
	
	return self;
}

#pragma mark -
#pragma mark UIView

- (id)initWithFrame:(CGRect)frame {
	CGSize size = [[UIImage imageNamed:@"back"] size];
	if (self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, size.width, size.height)]) {
		[self setTint:TJBackButtonTintBlack];
	}
	
	return self;
}

- (void)setFrame:(CGRect)frame {
	CGSize size = [[UIImage imageNamed:@"back"] size];
	[super setFrame:CGRectMake(frame.origin.x, frame.origin.y, size.width, size.height)];
}

- (void)setBounds:(CGRect)bounds {
	CGSize size = [[UIImage imageNamed:@"back"] size];
	[super setBounds:CGRectMake(0.0f, 0.0f, size.width, size.height)];
}

#pragma mark -
#pragma mark Custom Initializer

- (id)initWithTint:(TJBackButtonTint)tint {
	if (self = [super init]) {
		[self setTint:tint];
	}
	
	return self;
}

#pragma mark -
#pragma Tint Setting

- (void)setTint:(TJBackButtonTint)tint {
	[self setTitle:@"  Back" forState:UIControlStateNormal];
	[[self titleLabel] setFont:[UIFont boldSystemFontOfSize:15.0f]];
	[self setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted | UIControlStateSelected];
	
	if (tint == TJBackButtonTintWhite) {
		[self setBackgroundImage:[UIImage imageNamed:@"backWhite"] forState:UIControlStateNormal];
		[self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	} else {
		[self setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
		[self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	}
}

@end
