//
//  ADBGridView.h
//  ADBGridView
//
//  Created by Alberto De Bortoli on 28/02/12.
//  Copyright (c) 2012 Alberto De Bortoli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADBTableViewCell.h"

@class ADBGridView;

@protocol ADBGridViewDelegate <NSObject>
@required
- (NSString *)imagePathForADBGridView:(ADBGridView *)view atIndex:(NSUInteger)index;
- (NSUInteger)numberOfImagesInGrid:(ADBGridView *)view;
- (NSUInteger)numberOfImagesForRow:(ADBGridView *)view;
@optional
- (void)imageInADBGridView:(ADBGridView *)gridView singleTapImageView:(ADBImageView *)imageView;
- (void)imageInADBGridView:(ADBGridView *)gridView longPressImageView:(ADBImageView *)imageView;
@end

@interface ADBGridView : UITableView <UITableViewDelegate, UITableViewDataSource, ADBTableViewCellDelegate> {
    NSUInteger  imagesCount;
    NSUInteger  imagesForRowCount;
    BOOL _caching;
    id <ADBGridViewDelegate> __unsafe_unretained _gridDelegate;
}

@property (nonatomic, unsafe_unretained) IBOutlet id <ADBGridViewDelegate> gridDelegate;
@property (nonatomic, unsafe_unretained) BOOL caching;

@end
