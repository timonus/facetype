//
//  TJBackButton.h
//  Typeset
//
//  Created by Tim Johnsen on 9/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

typedef enum {
	TJBackButtonTintBlack,
	TJBackButtonTintWhite
} TJBackButtonTint;

@interface TJBackButton : UIButton

- (id)initWithTint:(TJBackButtonTint)tint;

- (void)setTint:(TJBackButtonTint)tint;

@end
