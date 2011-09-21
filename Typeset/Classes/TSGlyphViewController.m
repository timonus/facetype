//
//  TSGlyphViewController.m
//  Typeset
//
//  Created by Tim Johnsen on 9/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TSGlyphViewController.h"
#import "UINavigationController+PopAnimated.h"
#import "UIFont+TSAdditions.h"
#import "TJScrollViewExtenderView.h"
#import "TJBackButton.h"

#define FADED_ALPHA 0.25f
#define PAGE_INSET ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad ? 80.0f : 46.0f)

@implementation TSGlyphViewController

#pragma mark -
#pragma mark NSObject

- (id)init {
	if ((self = [super init])) {
		_font = [[UIFont systemFontOfSize:[UIFont faceTypeGlyphSize]] retain];
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
	[_scrollView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[_scrollView setContentSize:CGSizeMake([_scrollView bounds].size.width * [[TSFontViewController allKeys] count], [_scrollView bounds].size.height)];
	[_scrollView setClipsToBounds:NO];
	[_scrollView setShowsVerticalScrollIndicator:NO];
	[_scrollView setShowsHorizontalScrollIndicator:NO];	
	[_scrollView setPagingEnabled:YES];
	[_scrollView setDelegate:self];
	
	[[self view] addSubview:_scrollView];
	[_scrollView release];
	
	[_scrollView setContentOffset:CGPointMake([_scrollView bounds].size.width * _currentPage, 0.0f)];
	
	// Setup Scrollview Helper
	
	TJScrollViewExtenderView *extenderView = [[TJScrollViewExtenderView alloc] initWithFrame:CGRectInset([[self view] bounds], 0.0f, PAGE_INSET)];
	[_scrollView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	extenderView.scrollView = _scrollView;
	
	[[self view] insertSubview:extenderView belowSubview:_scrollView];
	[extenderView release];
	
	// Setup Characters
	
	_characterViews = [[NSMutableDictionary alloc] init];
	
	for (int i = 0 ; i < [characters count] ; i++) {
		NSString *text = [characters objectAtIndex:i];
		
		UILabel *character = [[UILabel alloc] initWithFrame:CGRectMake([_scrollView bounds].size.width * i, 0.0f, [_scrollView bounds].size.width, [_scrollView bounds].size.height)];
		[character setTextAlignment:UITextAlignmentCenter];
		[character setAdjustsFontSizeToFitWidth:YES];
		[character setFont:_font];
		[character setText:text];
		[character setBackgroundColor:[UIColor clearColor]];
		[character setClipsToBounds:NO];
		[character setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin];
		
		[_scrollView addSubview:character];
		[_characterViews setObject:character forKey:[NSNumber numberWithInt:i]];
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
	
	// Setup Title Label
	
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [[self view] bounds].size.width - 16.0f, 46.0f)];
	[titleLabel setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
	[titleLabel setTextAlignment:UITextAlignmentRight];
	[titleLabel setFont:[UIFont boldSystemFontOfSize:15.0f]];
	[titleLabel setText:[_font fontName]];
	
	[[self view] insertSubview:titleLabel belowSubview:backButton];
	[titleLabel release];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[_scrollView setContentSize:CGSizeMake([_scrollView bounds].size.width * [[TSFontViewController allKeys] count], [_scrollView bounds].size.height)];
	[_scrollView setContentOffset:CGPointMake(_currentPage * _scrollView.bounds.size.width, 0.0f)];
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

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	_currentPage = ([_scrollView contentOffset].x + [_scrollView bounds].size.width / 2.0f) / [_scrollView bounds].size.width;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[_scrollView setContentSize:CGSizeMake(_scrollView.bounds.size.width * [[TSFontViewController allKeys] count], _scrollView.bounds.size.height)];
	[_scrollView setContentOffset:CGPointMake(_currentPage * _scrollView.bounds.size.width, 0.0f)];
}

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
				[[_characterViews objectForKey:[NSNumber numberWithInt:i]] setAlpha:1.0f];
			} else {
				[[_characterViews objectForKey:[NSNumber numberWithInt:i]] setAlpha:FADED_ALPHA];
			}
		}
		
		[UIView commitAnimations];
	}
}

#pragma mark -
#pragma mark Instance Methods

- (id)initWithFontName:(NSString *)fontName initialIndex:(int)initialIndex {
    if ((self = [self init])) {
        _font = [[UIFont fontWithName:fontName size:[UIFont faceTypeGlyphSize]] retain];
        _currentPage = initialIndex;
    }
    
    return self;
}

- (id)initWithFont:(UIFont *)font index:(int)initialIndex {
	if ((self = [self initWithFontName:[font fontName] initialIndex:initialIndex])) {
	}
	
	return self;
}

@end
