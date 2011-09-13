//
//  TSFontViewController.h
//  Typeset
//
//  Created by Tim Johnsen on 9/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TJPageControl.h"

@interface TSFontViewController : UIViewController <UIScrollViewDelegate> {
	UIScrollView *_scrollView;
	NSMutableDictionary *_charactersViews;
	
	TJPageControl *_pageControl;
	
	UIFont *_font;
}

- (id)initWithFont:(UIFont *)font;

+ (CGFloat)fontSize;
+ (NSArray *)keysForPage:(int)page;
+ (NSArray *)allKeys;

- (void)glyphTapped:(UIGestureRecognizer *)gestureRecognizer;

@end
