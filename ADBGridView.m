//
//  ADBGridView.m
//  ADBGridView
//
//  Created by Alberto De Bortoli on 28/02/12.
//  Copyright (c) 2012 Alberto De Bortoli. All rights reserved.
//

#import "ADBGridView.h"
#import "ADBTableViewCell.h"

@interface ADBGridView (Private)
- (void)customInit;
@end

@implementation ADBGridView

@synthesize gridDelegate = _gridDelegate;
@synthesize caching = _caching;

#pragma mark - Table view data source

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self customInit];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:(NSCoder *)aDecoder];
    
    if (self) {
        [self customInit];
    }
    
    return self;
}

- (void)customInit
{
    self.delegate = self;
    self.dataSource = self;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.caching = YES;
    self.backgroundColor = [UIColor blackColor];
}

- (void)reloadData
{
    imagesCount = [_gridDelegate numberOfImagesInGrid:self];
    imagesForRowCount = [_gridDelegate numberOfImagesForRow:self];
    [super reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger retVal = ceilf((float)imagesCount / (float)imagesForRowCount);
    return retVal;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ADBCellIdentifier = @"ADBCell";
    
    NSMutableArray *pathsForCell = [NSMutableArray array];
    
    NSUInteger n = imagesForRowCount;
    for (NSUInteger i = (indexPath.row * n); i < (indexPath.row * n) + n; i++) {
        if (i < imagesCount) {
            NSString *imagePath = [_gridDelegate imagePathForADBGridView:self atIndex:i];
            [pathsForCell addObject:imagePath];
        }
    }
    
    ADBTableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:ADBCellIdentifier];
    if (cell == nil) {
        cell = [[ADBTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:ADBCellIdentifier];
        cell.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    }
    
    cell.caching = _caching;
    cell.delegate = self;
    
    while ([pathsForCell count] < [_gridDelegate numberOfImagesForRow:self]) {
        [pathsForCell addObject:@""];
    }
    
    [cell setImagePaths:pathsForCell targetForGestures:self];
    
    return cell;
}

#pragma mark - ADBTableViewCellDelegate

- (void)ADBTableViewCell:(ADBTableViewCell *)cell didSingleTapView:(ADBImageView *)imageView
{
    if ([_gridDelegate respondsToSelector:@selector(imageInADBGridView:singleTapImageView:)]) {
        [_gridDelegate imageInADBGridView:self singleTapImageView:imageView];
    }
}

- (void)ADBTableViewCell:(ADBTableViewCell *)cell didLongPressView:(ADBImageView *)imageView
{
    if ([_gridDelegate respondsToSelector:@selector(imageInADBGridView:longPressImageView:)]) {
        [_gridDelegate imageInADBGridView:self longPressImageView:imageView];
    }
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.frame.size.width / (float)imagesForRowCount;
}

@end
