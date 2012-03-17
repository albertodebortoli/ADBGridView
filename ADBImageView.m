//
//  ADBImageView.m
//  ADBImageView
//
//  Created by Alberto De Bortoli on 26/02/12.
//  Copyright (c) 2012 Alberto De Bortoli. All rights reserved.
//  Caching functionalities taken from Toto Tvalavadze's TCImageView.
//

#import "ADBImageView.h"
#import <CommonCrypto/CommonDigest.h>

#define kADBImageViewTimoutInterval 30.0
#define kADBImageViewCachedImageJPEGQuality 1.0

static NSTimeInterval cachingTime = 604800.0; // 7 days caching as default

@interface ADBImageView (Private)
+ (NSString*)cacheDirectoryAddress;
- (NSString *)cachedImageSystemName;
- (void)loadImage;
@end

@implementation ADBImageView

@synthesize caching = _caching;
@synthesize url = _url;
@synthesize cacheTime = _cacheTime;
@synthesize delegate = _delegate;

#pragma mark - Initializers

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        self.clipsToBounds = YES;
        self.caching = YES;
        
        UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageSingleTapped:)];
        [self addGestureRecognizer:tgr];
        tgr.numberOfTapsRequired = 1;
        tgr.numberOfTouchesRequired = 1;
        
        UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(imageLongPressed:)];
        [self addGestureRecognizer:lpgr];
        
        [self setUserInteractionEnabled:YES];
        [self setOpaque:YES];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.clipsToBounds = YES;
        self.caching = YES;
        
        UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageSingleTapped:)];
        [self addGestureRecognizer:tgr];
        tgr.numberOfTapsRequired = 1;
        tgr.numberOfTouchesRequired = 1;
        
        UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(imageLongPressed:)];
        [self addGestureRecognizer:lpgr];
        
        [self setUserInteractionEnabled:YES];
        [self setOpaque:YES];
    }
    
    return self;
}

#pragma mark - ADBImageView

- (void)setImageWithURL:(NSURL *)imageURL placeholderImage:(UIImage *)placeholderImage;
{ 
    // Defaults
    _url = imageURL;
    _cacheTime = cachingTime;
    
    _placeholder = [[UIImageView alloc] initWithImage:placeholderImage];
    _placeholder.frame = self.bounds;
    [self addSubview:_placeholder];
    
    [self loadImage];
}

- (void)reloadWithUrl:(NSURL *)url
{
    [self cancelLoad];
    self.image = nil;
    _placeholder.hidden = NO;
    _url = url;
    [self loadImage];
}

- (void)cancelLoad
{
    [_connection cancel];
    _connection = nil;
    _data = nil;
}

#pragma mark - NSURLConnection Delegates

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _data = [[NSMutableData alloc] initWithLength:0];
}

- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)incrementalData 
{
    [_data appendData:incrementalData];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{    
    [_activityIndicator stopAnimating];
    
    if ([_delegate respondsToSelector:@selector(ADBImageView:failedLoadingWithError:)]) {
        [_delegate ADBImageView:self failedLoadingWithError:error];
    }
    
    [_connection cancel];
    _connection = nil;
    _data = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)theConnection 
{
    [_activityIndicator stopAnimating];
    
    UIImage *imageData = [UIImage imageWithData:_data];
    
    if ([_delegate respondsToSelector:@selector(ADBImageView:willUpdateImage:)]) {
        [_delegate ADBImageView:self willUpdateImage:imageData];
    }
    
    self.image = imageData;
    _placeholder.hidden = YES;
    
    if (self.caching) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if (![fileManager fileExistsAtPath:[ADBImageView cacheDirectoryAddress]]) {
            [fileManager createDirectoryAtPath:[ADBImageView cacheDirectoryAddress]
                   withIntermediateDirectories:NO
                                    attributes:nil
                                         error:nil];
        }
        
        // Write image cache file
        NSData *cachedImage = UIImageJPEGRepresentation(self.image, kADBImageViewCachedImageJPEGQuality);
        [cachedImage writeToFile:_cachePath options:NSDataWritingAtomic error:nil];
    }
    
    [_connection cancel];
    _connection = nil;
	_data = nil;
	
    if ([_delegate respondsToSelector:@selector(ADBImageView:didLoadImage:)]) {
        [_delegate ADBImageView:self didLoadImage:imageData];
    }
}

#pragma mark - Gesture actions

- (void)imageSingleTapped:(UIGestureRecognizer *)recognizer
{
    if ([_delegate respondsToSelector:@selector(ADBImageViewDidSingleTap:)]) {
        [_delegate ADBImageViewDidSingleTap:(ADBImageView *)[recognizer view]];
    }
}

- (void)imageLongPressed:(UIGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        if ([_delegate respondsToSelector:@selector(ADBImageViewDidLongPress:)]) {
            [_delegate ADBImageViewDidLongPress:(ADBImageView *)[recognizer view]];
        }
    }
}

#pragma mark - Caching Methods

+ (void)setCachingTime:(NSTimeInterval)cachingTimeInterval
{
    cachingTime = cachingTimeInterval;
}

+ (void)resetGlobalCache
{
    [[NSFileManager defaultManager] removeItemAtPath:[ADBImageView cacheDirectoryAddress] error:nil];
}

- (void)resetCache
{
    [[NSFileManager defaultManager] removeItemAtPath:_cachePath error:nil];
}

#pragma mark - Private methods

+ (NSString*)cacheDirectoryAddress
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    return [documentsDirectoryPath stringByAppendingPathComponent:@"ADBImageView-Cache"];
}

- (NSString *)cachedImageSystemName
{
    const char *concat_str = [[_url absoluteString] UTF8String];
	if (concat_str) {
		unsigned char result[CC_MD5_DIGEST_LENGTH];
        CC_MD5(concat_str, strlen(concat_str), result);
        NSMutableString *hash = [NSMutableString string];
        for (int i = 0; i < 16; i++)
            [hash appendFormat:@"%02X", result[i]];
        
        return [[hash lowercaseString] stringByAppendingPathExtension:@"jpeg"];
    } else {
        return @"";
    }
}

- (void)loadImage
{
    self.image = nil;
    _placeholder.hidden = NO;
    
    if ([[_url absoluteString] isEqualToString:@""]) {
        return;
    }
    
    if (self.caching) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        _cachePath = [[ADBImageView cacheDirectoryAddress] stringByAppendingPathComponent:[self cachedImageSystemName]];
        if ([fileManager fileExistsAtPath:_cachePath]) {
            NSDate *mofificationDate = [[fileManager attributesOfItemAtPath:_cachePath error:nil] objectForKey:NSFileModificationDate];
            NSTimeInterval timeIntervalSinceModification = abs([mofificationDate timeIntervalSinceNow]);
            if (timeIntervalSinceModification <= _cacheTime) {
                NSData *localImageData = [NSData dataWithContentsOfFile:_cachePath];
				UIImage *localImage = [UIImage imageWithData:localImageData];
				
                if ([_delegate respondsToSelector:@selector(ADBImageView:willUpdateImage:)]) {
                    [_delegate ADBImageView:self willUpdateImage:localImage];
                }
				
                self.image = localImage;
                _placeholder.hidden = YES;
                
                if ([_delegate respondsToSelector:@selector(ADBImageView:didLoadImage:)]) {
                    [_delegate ADBImageView:self didLoadImage:localImage];
                }
                return;
            } else {
                [self resetCache];
            }
        }
    }
    
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    CGPoint center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    _activityIndicator.center = center;
    [self addSubview:_activityIndicator];
    [_activityIndicator startAnimating];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:_url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:kADBImageViewTimoutInterval];
    _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

@end
