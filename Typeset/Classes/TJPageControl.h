//
//  TJPageControl.h
//  NGadget
//
//  Created by Tim Johnsen on 10/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
	TJPageControlStyleEmptyIndicators,
	TJPageControlStyleShadedIndicators
} TJPageControlStyle;

typedef enum{
	TJPageControlTypeCircle,
	TJPageControlTypeSquare
} TJPageControlType;

typedef enum{
	TJPageControlAlignmentCenter,
	TJPageControlAlignmentLeftTop,
	TJPageControlAlignmentRightBottom
} TJPageControlAlignment;


@interface TJPageControl : UIView {
	int numberOfPages;
	int currentPage;
	id delegate;
	
	int indicatorSize;
	int indicatorSpacing;
	UIColor *baseColor;
	UIColor *selectedColor;
	TJPageControlStyle style;
	TJPageControlType type;
	TJPageControlAlignment alignment;
}

@property (assign) int numberOfPages;
@property (assign) int currentPage;
@property (assign) id delegate;

@property (assign) int indicatorSize;
@property (assign) int indicatorSpacing;
@property (assign) UIColor *baseColor;
@property (assign) UIColor *selectedColor;
@property (assign) TJPageControlStyle style;
@property (assign) TJPageControlType type;
@property (assign) TJPageControlAlignment alignment;

-(void)tapped:(UIGestureRecognizer *)recognizer;

@end
