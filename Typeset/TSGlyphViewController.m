//
//  TSGlyphViewController.m
//  Typeset
//
//  Created by Tim Johnsen on 9/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TSGlyphViewController.h"
#import "TJBackButton.h"

#define FADED_ALPHA 0.25f
#define PAGE_INSET ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad ? 80.0f : 46.0f)

@implementation TSGlyphViewController

#pragma mark -
#pragma mark NSObject

- (id)init {
	if (self = [super init]) {
		_font = [[UIFont systemFontOfSize:[TSGlyphViewController fontSize]] retain];
	}
	
	return self;
}

- (void)dealloc {
	[_font release];
	
	[super dealloc];
}

#pragma mark -
#pragma mark UIViewController

- (void)loadView {
	[super loadView];
	[[self view] setClipsToBounds:YES];
	
	NSArray *characters = [TSFontViewController allKeys];
	
	// Setup Scrollview
	
	_scrollView = [[UIScrollView alloc] initWithFrame:CGRectInset([[self view] bounds], PAGE_INSET, PAGE_INSET)];
	[_scrollView setContentSize:CGSizeMake([_scrollView bounds].size.width * [[TSFontViewController allKeys] count], [_scrollView bounds].size.height)];
	[_scrollView setClipsToBounds:NO];
	[_scrollView setShowsVerticalScrollIndicator:NO];
	[_scrollView setShowsHorizontalScrollIndicator:NO];	
	[_scrollView setPagingEnabled:YES];
	
	[[self view] addSubview:_scrollView];
	[_scrollView release];
	
	[_scrollView setContentOffset:CGPointMake([_scrollView bounds].size.width * _currentPage, 0.0f)];
	
	// Setup Characters
	
	for (int i = 0 ; i < [characters count] ; i++) {
		NSString *text = [characters objectAtIndex:i];
		
		UILabel *character = [[UILabel alloc] initWithFrame:CGRectMake([_scrollView bounds].size.width * i, 0.0f, [_scrollView bounds].size.width, [_scrollView bounds].size.height)];
		[character setTextAlignment:UITextAlignmentCenter];
		[character setAdjustsFontSizeToFitWidth:YES];
		[character setFont:_font];
		[character setText:text];
		[character setBackgroundColor:[UIColor clearColor]];
		[character setClipsToBounds:NO];
		
		[_scrollView addSubview:character];
		[character release];
	}
	
	// Setup Back Button
	
	TJBackButton *backButton = [[TJBackButton alloc] initWithFrame:CGRectMake(8.0f, 8.0f, 100.0f, 100.0f)];
	[backButton addTarget:[self navigationController] action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
	
	[[self view] addSubview:backButton];
	[backButton release];
}

- (void)viewDidUnload {
	[super viewDidUnload];
	
	_scrollView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown;
}

#pragma mark -
#pragma mark UIScrollViewDelegate

#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	int page = (scrollView.contentOffset.x + [scrollView bounds].size.width / 2.0f) / [scrollView bounds].size.width;
	
	if (page != _currentPage) {
		_currentPage = page;
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationBeginsFromCurrentState:YES];
		
//		for (NSString *key in _charactersViews) {
//			[[_charactersViews objectForKey:key] setAlpha:FADED_ALPHA];
//		}
//		
//		for (NSString *key in [TSFontViewController keysForPage:page]) {
//			[[_charactersViews objectForKey:key] setAlpha:1.0f];
//		}
		
		[UIView commitAnimations];
	}
}

#pragma mark -
#pragma mark Class Methods

+ (CGFloat)fontSize {
	return 650.0f;
}

#pragma mark -
#pragma mark Instance Methods

- (id)initWithFont:(UIFont *)font {
	if (self = [self init]) {
		_font = [[UIFont fontWithName:[font fontName] size:[TSGlyphViewController fontSize]] retain];
		_currentPage = 0;
	}
	
	return self;
}

- (id)initWithFont:(UIFont *)font index:(int)initialIndex {
	if (self = [self initWithFont:font]) {
		_currentPage = initialIndex;
	}
	
	return self;
}

@end
