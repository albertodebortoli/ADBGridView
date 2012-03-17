//
//  ADBTableViewCell.h
//  ADBGridView
//
//  Created by Alberto De Bortoli on 21/01/12.
//  Copyright (c) 2012 Alberto De Bortoli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADBImageView.h"

@class ADBTableViewCell;

@protocol ADBTableViewCellDelegate <NSObject>
@optional
- (void)ADBTableViewCell:(ADBTableViewCell *)cell didSingleTapView:(ADBImageView *)view;
- (void)ADBTableViewCell:(ADBTableViewCell *)cell didLongPressView:(ADBImageView *)view;
@end

@interface ADBTableViewCell : UITableViewCell {
    
    NSMutableArray *_imageSubviews;
    BOOL _caching;
    id <ADBTableViewCellDelegate> __unsafe_unretained _delegate;
}

- (void)setImagePaths:(NSArray *)images targetForGestures:(id)target;

@property (nonatomic, unsafe_unretained) id <ADBTableViewCellDelegate> delegate;
@property (nonatomic, unsafe_unretained) BOOL caching;

@end
