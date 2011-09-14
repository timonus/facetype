//
//  TSGlyphViewController.m
//  Typeset
//
//  Created by Tim Johnsen on 9/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TSGlyphViewController.h"
#import "UINavigationController+PopAnimated.h"
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
	[_characterViews release];
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
	[_scrollView setDelegate:self];
	
	[[self view] addSubview:_scrollView];
	[_scrollView release];
	
	[_scrollView setContentOffset:CGPointMake([_scrollView bounds].size.width * _currentPage, 0.0f)];
	
	// Setup Characters
	
	_characterViews = [[NSMutableArray alloc] init];
	
	for (int i = 0 ; i < [characters count] ; i++) {
		NSString *text = [characters objectAtIndex:i];
		
		UILabel *character = [[UILabel alloc] initWithFrame:CGRectMake([_scrollView bounds].size.width * i, 0.0f, [_scrollView bounds].size.width, [_scrollView bounds].size.height)];
		[character setTextAlignment:UITextAlignmentCenter];
		[character setAdjustsFontSizeToFitWidth:YES];
		[character setFont:_font];
		[character setText:text];
		[character setBackgroundColor:[UIColor clearColor]];
		[character setClipsToBounds:NO];
		
		CGPoint center = [character center];
		[character sizeToFit];
		[character setCenter:center];
		
		[_scrollView addSubview:character];
		[_characterViews addObject:character];
		[character release];
		
		if (i == _currentPage) {
			[character setAlpha:1.0f];
		} else {
			[character setAlpha:FADED_ALPHA];
		}
	}
	
	// Setup Back Button
	
	TJBackButton *backButton = [[TJBackButton alloc] initWithFrame:CGRectMake(8.0f, 8.0f, 100.0f, 100.0f)];
	[backButton addTarget:[self navigationController] action:@selector(popViewControllerAnimated) forControlEvents:UIControlEventTouchUpInside];
	
	[[self view] addSubview:backButton];
	[backButton release];
}

- (void)viewDidUnload {
	[super viewDidUnload];
	
	[_characterViews release];
	_characterViews = nil;
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
		
		for (int i = 0 ; i < [_characterViews count] ; i++) {
			if (i == _currentPage) {
				[[_characterViews objectAtIndex:i] setAlpha:1.0f];
			} else {
				[[_characterViews objectAtIndex:i] setAlpha:FADED_ALPHA];
			}
		}
		
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
