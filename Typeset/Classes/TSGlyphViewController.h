//
//  TSGlyphViewController.h
//  Typeset
//
//  Created by Tim Johnsen on 9/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSFontViewController.h"

@interface TSGlyphViewController : UIViewController <UIScrollViewDelegate> {
	UIScrollView *_scrollView;
	UIFont *_font;
	NSMutableDictionary *_characterViews;
	
	int _currentPage;
}

- (id)initWithFontName:(NSString *)fontName initialIndex:(int)initialIndex;
- (id)initWithFont:(UIFont *)font index:(int)initialIndex;

@end
