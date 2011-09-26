//
//  TSFontViewController.m
//  Typeset
//
//  Created by Tim Johnsen on 9/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TSFontViewController.h"
#import "TSGlyphViewController.h"
#import "UINavigationController+PopAnimated.h"
#import "TJBackButton.h"
#import "TJScrollViewExtenderView.h"
#import "UIFont+TSAdditions.h"

#define FADED_ALPHA 0.25f
#define PAGE_INSET ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad ? 80.0f : 46.0f)
#define CELLS_PER_ROW 4

@implementation TSFontViewController

#pragma mark -
#pragma mark NSObject

- (id)init {
	if ((self = [super init])) {
		_font = [[UIFont systemFontOfSize:[UIFont faceTypeFontSize]] retain];
	}
	
	return self;
}

- (void)dealloc {
	[_charactersViews release];
	[_font release];
	
	[super dealloc];
}

#pragma mark -
#pragma mark UIViewController

- (void)loadView {
	[super loadView];
	[[self view] setClipsToBounds:YES];
	
	// Setup Scrollview
	
	_scrollView = [[UIScrollView alloc] initWithFrame:CGRectInset([[self view] bounds], PAGE_INSET, PAGE_INSET)];
	[_scrollView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[_scrollView setContentSize:CGSizeMake([_scrollView bounds].size.width * 3.0f, [_scrollView bounds].size.height)];
	[_scrollView setClipsToBounds:NO];
	[_scrollView setShowsVerticalScrollIndicator:NO];
	[_scrollView setShowsHorizontalScrollIndicator:NO];	
	[_scrollView setPagingEnabled:YES];
	[_scrollView setDelegate:self];
	
	[[self view] addSubview:_scrollView];
	[_scrollView release];
	
	// Setup Scrollview Helper
	
	TJScrollViewExtenderView *extenderView = [[TJScrollViewExtenderView alloc] initWithFrame:CGRectInset([[self view] bounds], 0.0f, PAGE_INSET)];
	[_scrollView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	extenderView.scrollView = _scrollView;
	
	[[self view] insertSubview:extenderView belowSubview:_scrollView];
	[extenderView release];
	
	// Setup Characters
	
	if (!_charactersViews) {
		_charactersViews = [[NSMutableDictionary alloc] init];
	}
	
	CGSize size = CGSizeMake(([_scrollView bounds].size.width / CELLS_PER_ROW), ([_scrollView bounds].size.height / ceil(26.0f / CELLS_PER_ROW)));
	
	for (int page = 0 ; page < 3 ; page++) {
		NSArray *characters = [TSFontViewController keysForPage:page];
		for (int i = 0 ; i < [characters count] ; i++) {
			NSString *text = [characters objectAtIndex:i];
			
			UIButton *character = [[UIButton alloc] initWithFrame:CGRectMake([_scrollView bounds].size.width * page + size.width * (i % CELLS_PER_ROW), size.height * (i / CELLS_PER_ROW), size.width, size.height)];
			[[character titleLabel] setAdjustsFontSizeToFitWidth:YES];
			[[character titleLabel] setFont:_font];
			[character setTitle:text forState:UIControlStateNormal];
			[character setBackgroundColor:[UIColor clearColor]];
			[character setClipsToBounds:NO];
			[character setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
			[character setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
			[character setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
			[character setUserInteractionEnabled:YES];
			[character addTarget:self action:@selector(glyphTapped:) forControlEvents:UIControlEventTouchUpInside];
			[character setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin];
			
			if (page != 0) {
				[character setAlpha:FADED_ALPHA];
			}
			
			[_charactersViews setObject:character forKey:text];
			[_scrollView addSubview:character];
			[character release];
		}
	}
	
	// Setup Back Button
	
	TJBackButton *backButton = [[TJBackButton alloc] initWithFrame:CGRectMake(8.0f, 8.0f, 100.0f, 100.0f)];
	[backButton addTarget:[self navigationController] action:@selector(popViewControllerAnimated) forControlEvents:UIControlEventTouchUpInside];
	
	[[self view] addSubview:backButton];
	[backButton release];
	
	// Setup Page Control
	
	_pageControl = [[TJPageControl alloc] init];
	[_pageControl setFrame:CGRectMake(0.0f, [[self view] bounds].size.height - PAGE_INSET, [[self view] bounds].size.width, PAGE_INSET)];
	[_pageControl setNumberOfPages:3];
	[_pageControl setCurrentPage:0];
	[_pageControl setBackgroundColor:[UIColor clearColor]];
	[_pageControl setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
	
	[_pageControl setBaseColor:[UIColor blackColor]];
	[_pageControl setSelectedColor:[UIColor blackColor]];
	
	[[self view] addSubview:_pageControl];
	[_pageControl release];
	
	// Setup Title Label
	
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80.0f, 0.0f, [[self view] bounds].size.width - 88.0f, 46.0f)];
	[titleLabel setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
	[titleLabel setTextAlignment:UITextAlignmentRight];
	[titleLabel setFont:[UIFont boldSystemFontOfSize:15.0f]];
	[titleLabel setText:[_font fontName]];t
	
	[[self view] insertSubview:titleLabel belowSubview:backButton];
	[titleLabel release];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[_scrollView setContentSize:CGSizeMake([_scrollView bounds].size.width * 3.0f, [_scrollView bounds].size.height)];
}

- (void)viewDidUnload {
	[super viewDidUnload];
	
	[_charactersViews release];
	_charactersViews = nil;
	_scrollView = nil;
	_pageControl = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	_currentPage = ([_scrollView contentOffset].x + [_scrollView bounds].size.width / 2.0f) / [_scrollView bounds].size.width;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[_scrollView setContentSize:CGSizeMake(_scrollView.bounds.size.width * 3.0f, _scrollView.bounds.size.height)];
	[_scrollView setContentOffset:CGPointMake(_currentPage * _scrollView.bounds.size.width, 0.0f)];
}

#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	int page = (scrollView.contentOffset.x + [scrollView bounds].size.width / 2.0f) / [scrollView bounds].size.width;
	
	if (page != [_pageControl currentPage]) {
		[_pageControl setCurrentPage:page];
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationBeginsFromCurrentState:YES];
		
		for (NSString *key in _charactersViews) {
			[[_charactersViews objectForKey:key] setAlpha:FADED_ALPHA];
		}
		
		for (NSString *key in [TSFontViewController keysForPage:page]) {
			[[_charactersViews objectForKey:key] setAlpha:1.0f];
		}
		
		[UIView commitAnimations];
	}
}

#pragma mark -
#pragma mark Class Methods

+ (NSArray *)keysForPage:(int)page {
	
	NSMutableArray *keys = [[NSMutableArray alloc] init];
	
	switch (page) {
		case 0:
			for (int i = 0 ; i < 26 ; i++){
				[keys addObject:[NSString stringWithFormat:@"%c", 'A' + i]];
			}
			break;
		case 1:
			for (int i = 0 ; i < 26 ; i++){
				[keys addObject:[NSString stringWithFormat:@"%c", 'a' + i]];
			}
			break;
		case 2:
			for (int i = 0 ; i < 10 ; i++){
				[keys addObject:[NSString stringWithFormat:@"%c", '0' + i]];
			}
			[keys addObject:@"."];
			[keys addObject:@","];
			[keys addObject:@"?"];
			[keys addObject:@"!"];
			[keys addObject:@"'"];
			[keys addObject:@"\""];
			[keys addObject:@":"];
			[keys addObject:@";"];
			[keys addObject:@"&"];
			[keys addObject:@"@"];
			[keys addObject:@"#"];
			[keys addObject:@"$"];
			[keys addObject:@"%"];
			[keys addObject:@"*"];
			
			[keys addObject:@"()"];
			[keys addObject:@"{}"];
			[keys addObject:@"[]"];
			[keys addObject:@"<>"];
			
			break;
	}
	
	return [keys autorelease];
}

+ (NSArray *)allKeys {
	NSMutableArray *allKeys = [[NSMutableArray alloc] init];
	
	[allKeys addObjectsFromArray:[self keysForPage:0]];
	[allKeys addObjectsFromArray:[self keysForPage:1]];
	[allKeys addObjectsFromArray:[self keysForPage:2]];
	
	return [allKeys autorelease];
}

#pragma mark -
#pragma mark Instance Methods

- (id)initWithFont:(UIFont *)font {
	if ((self = [self initWithFontName:[font fontName]])) {
	}
	
	return self;
}

- (id)initWithFontName:(NSString *)fontName {
	if ((self = [self init])) {
		_font = [[UIFont fontWithName:fontName size:[UIFont faceTypeFontSize]] retain];
	}
	
	return self;
}

- (void)glyphTapped:(id)sender {
	int index = [[TSFontViewController allKeys] indexOfObject:[[(UIButton *)sender titleLabel] text]];
	[[self navigationController] pushViewController:[[[TSGlyphViewController alloc] initWithFont:_font index:index] autorelease] animated:YES];
}

@end
