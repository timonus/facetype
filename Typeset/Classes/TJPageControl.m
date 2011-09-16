//
//  TJPageControl.m
//  NGadget
//
//  Created by Tim Johnsen on 10/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TJPageControl.h"

@implementation TJPageControl

@synthesize currentPage;
@synthesize numberOfPages;
@synthesize delegate;

@synthesize indicatorSize;
@synthesize indicatorSpacing;
@synthesize baseColor;
@synthesize selectedColor;
@synthesize style;
@synthesize type;
@synthesize alignment;

-(id)init{
	if(self = [super init]){
		[self setBackgroundColor:[UIColor clearColor]];
		currentPage = 0;
		numberOfPages = 0;
		
		indicatorSize = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone ? 4 : 6;
		indicatorSpacing = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone ? 10 : 14;
		
		baseColor = [UIColor grayColor];
		selectedColor = [UIColor grayColor];
		
		style = TJPageControlStyleEmptyIndicators;
		type = TJPageControlTypeCircle;
		alignment = TJPageControlAlignmentCenter;
		
		[self addGestureRecognizer:[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)] autorelease]];
	}
	return self;
}

-(void)setFrame:(CGRect)rect{
	[super setFrame:rect];
	[self setNeedsDisplay];
}

-(void)setNumberOfPages:(int)n{
	numberOfPages = n;
	[self setNeedsDisplay];
}

-(int)numberOfPages{
	return numberOfPages;
}

-(void)setCurrentPage:(int)n{
	currentPage = n;
	while(currentPage >= numberOfPages)
		currentPage--;
	while(currentPage < 0)
		currentPage++;
	[self setNeedsDisplay];
}

-(int)currentPage{
	return currentPage;
}

- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
	
	CGContextRef context = UIGraphicsGetCurrentContext();

	if(numberOfPages > 1){
		
		float length = numberOfPages * indicatorSize + indicatorSpacing * (numberOfPages - 1);
			
		float x = rect.size.width / 2, y = rect.size.height / 2;
		
		if(self.bounds.size.width > self.bounds.size.height){
			if(alignment == TJPageControlAlignmentCenter)
				x -= length / 2;
			else
				if(alignment == TJPageControlAlignmentLeftTop)
					x = indicatorSpacing;
				else
					if(alignment == TJPageControlAlignmentRightBottom)
						x = self.bounds.size.width - length - indicatorSpacing;
			y -= indicatorSize / 2;
		}
		else{
			x -= indicatorSize / 2;
			
			if(alignment == TJPageControlAlignmentCenter)
				y -= length / 2;
			else
				if(alignment == TJPageControlAlignmentLeftTop)
					y = indicatorSpacing;
				else
					if(alignment == TJPageControlAlignmentRightBottom)
						y = self.bounds.size.height - length - indicatorSpacing;
		}
			
		// draw each of the indicators	
		for(int i = 0 ; i < numberOfPages ; i++){
			if(style == TJPageControlStyleEmptyIndicators){
				// draw empty indicators
				if(i == currentPage){
					[selectedColor setFill];
					if(type == TJPageControlTypeCircle)
						CGContextFillEllipseInRect(context, CGRectMake(x, y, indicatorSize, indicatorSize));
					else
						CGContextFillRect(context, CGRectMake(x, y, indicatorSize, indicatorSize));
				}
				[baseColor setStroke];
				if(type == TJPageControlTypeCircle)
					CGContextStrokeEllipseInRect(context, CGRectMake(x, y, indicatorSize, indicatorSize));
				else
					CGContextStrokeRect(context, CGRectMake(x, y, indicatorSize, indicatorSize));
			}
			else{
				// draw shaded indicators
				if(i == currentPage)
					[selectedColor setFill];
				else
					[baseColor setFill];
				
				if(type == TJPageControlTypeCircle)
					CGContextFillEllipseInRect(context, CGRectMake(x, y, indicatorSize, indicatorSize));
				else
					CGContextFillRect(context, CGRectMake(x, y, indicatorSize, indicatorSize));
			}
			
			if(self.bounds.size.width > self.bounds.size.height)
				x += indicatorSize + indicatorSpacing;
			else
				y += indicatorSize + indicatorSpacing;
		}
	}
}

-(void)tapped:(UIGestureRecognizer *)recognizer{
/*
	CGPoint point = [recognizer locationInView:self];
	float length = numberOfPages * indicatorSize + indicatorSpacing * (numberOfPages - 1);
	if(self.bounds.size.width > self.bounds.size.height){
		// left/right
		if(point.x < self.center.x - length / 2){
//			NSLog(@"left");// go left
			if([delegate respondsToSelector:@selector(lastPage)])
				[delegate lastPage];
		}
		else
			if(point.x > self.center.x + length / 2){
//				NSLog(@"right");// go right
				if([delegate respondsToSelector:@selector(nextPage)])
					[delegate nextPage];
			}
	}
	else{
		// up/down
		if(point.y < self.center.y - length / 2){
//			NSLog(@"up");// go up
			if([delegate respondsToSelector:@selector(lastPage)])
				[delegate lastPage];
		}
		else
			if(point.y > self.center.y + length / 2){
//				NSLog(@"down");// go down
				if([delegate respondsToSelector:@selector(nextPage)])
					[delegate nextPage];
			}
	}
 */
}

- (void)dealloc {
    [super dealloc];
}


@end
