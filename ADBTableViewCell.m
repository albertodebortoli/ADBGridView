//
//  ADBTableViewCell.m
//  ADBGridView
//
//  Created by Alberto De Bortoli on 21/01/12.
//  Copyright (c) 2012 Alberto De Bortoli. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ADBTableViewCell.h"
#import "ADBImageView.h"

@implementation ADBTableViewCell

@synthesize delegate = _delegate;
@synthesize caching = _caching;

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier;
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setImagePaths:(NSArray *)images targetForGestures:(id)target
{
    for (ADBImageView *imageView in _imageSubviews) {
        [imageView removeFromSuperview];
    }
    
    _imageSubviews = [NSMutableArray array];
    
    CGFloat size = self.frame.size.width / (float)[images count];
    
    for (int i = 0; i < [images count]; i++) {
        ADBImageView *image = [[ADBImageView alloc] initWithFrame:CGRectMake(size * i, 0, size, size)];
        image.caching = _caching;
        
        NSURL *path = [NSURL URLWithString:[images objectAtIndex:i]];
        [image setImageWithURL:path placeholderImage:[UIImage imageNamed:@""]];
        [_imageSubviews addObject:image];
    }
    
    for (ADBImageView *imageView in _imageSubviews)
    {
        // single tap gesture recognizer
        UITapGestureRecognizer  *tgrCopyURL = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        tgrCopyURL.numberOfTapsRequired = 1;
        tgrCopyURL.numberOfTouchesRequired = 1;
        
        // long press gesture recognizer
        UILongPressGestureRecognizer *lpgrShowMenu = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        [imageView addGestureRecognizer:tgrCopyURL];
        [imageView addGestureRecognizer:lpgrShowMenu];
        
        [self addSubview:imageView];
    }
}

#pragma mark - Gesture recognizer related actions

- (void)singleTap:(UIGestureRecognizer *)recognizer
{
    ADBImageView *view = (ADBImageView *)recognizer.view;
    if ([_delegate respondsToSelector:@selector(ADBTableViewCell:didSingleTapView:)]) {
        [_delegate ADBTableViewCell:self didSingleTapView:view];
    }
}

- (void)longPress:(UILongPressGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        ADBImageView *view = (ADBImageView *)recognizer.view;
        if ([_delegate respondsToSelector:@selector(ADBTableViewCell:didLongPressView:)]) {
            [_delegate ADBTableViewCell:self didLongPressView:view];
        }
    }
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    for (ADBImageView *imageView in _imageSubviews) {
        [imageView removeFromSuperview];
    }
    
    [self.textLabel setText:@""];
}

@end
