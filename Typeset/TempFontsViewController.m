//
//  TempFontsViewController.m
//  Typeset
//
//  Created by Tim Johnsen on 9/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TempFontsViewController.h"
#import "TSFontViewController.h"


@implementation TempFontsViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
		
		_datasource = [[NSMutableArray alloc] init];
		
		for (NSString *familyName in [UIFont familyNames]) {
			for (NSString *fontName in [UIFont fontNamesForFamilyName:familyName]) {
				[_datasource addObject:fontName];
			}
		}
		
		[_datasource sortUsingSelector:@selector(caseInsensitiveCompare:)];
    }
    return self;
}

#pragma mark - View lifecycle

- (void)loadView {
	[super loadView];
	[[self tableView] setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait) || (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_datasource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	[[cell textLabel] setFont:[UIFont fontWithName:[_datasource objectAtIndex:indexPath.row] size:44.0f]];
	[[cell textLabel] setText:[_datasource objectAtIndex:indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *str = [_datasource objectAtIndex:indexPath.row];
	
	return [str sizeWithFont:[UIFont fontWithName:str size:44.0f]].height + 20.0f;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[[self navigationController] pushViewController:[[[TSFontViewController alloc] initWithFontName:[_datasource objectAtIndex:indexPath.row]] autorelease] animated:YES];
}

@end
