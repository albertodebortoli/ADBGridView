//
//  ADBBrowseViewController.m
//  ADBGridViewDemo
//
//  Created by Alberto De Bortoli on 21/01/12.
//  Copyright (c) 2012 Alberto De Bortoli. All rights reserved.
//

#import "BrowseViewController.h"
#import "AppDelegate.h"

@implementation BrowseViewController

@synthesize images;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.images = [NSMutableArray array];
    
    NSArray *imageFileNames = [NSArray arrayWithObjects:
                               @"034aa53e76d1f8c5ca14eea7307cb79f.jpeg",
                               @"03a0da73a155a295021bf8809eafe34c.jpeg",
                               @"041f940818f608f57b8f67c58fb02ae1.jpeg",
                               @"0cc1fa78326554a6c4fd327bd9ed3e06.jpeg",
                               @"15074cee0ee1635b63a2083748f54602.jpeg",
                               @"2192f1dcccf82192c4b301c949335a1b.jpeg",
                               @"26e854c446d570f19468c6f78241e252.jpeg",
                               @"2e9eace485a1b1d83deb9d3343f8cd0e.jpeg",
                               @"36e6ed8bc92cf43ea51e4b31cd6a500d.jpeg",
                               @"41a789e98971ce3328b10382f973dd80.jpeg",
                               @"41b471d4bdd50bb4a4b82bacabfba50c.jpeg",
                               @"43b69795bdc3398306c1e45d12a5aae1.jpeg",
                               @"485a29dbb97aca0e0702e49f265c17e4.jpeg",
                               @"53157e1d28baa06dac6e058c3d39fb3c.jpeg",
                               @"57093cc4f2d501c2f1aa21acac4f7450.jpeg",
                               @"5811887578c2c4287ef15110da90ddc8.jpeg",
                               @"60ab09d4c3e232b216a3938ac9ab91ba.jpeg",
                               @"7e04ab8a44257c82a1588c2469a86eca.jpeg",
                               @"8155bfe2cd9d42f979d51cf932801d5b.jpeg",
                               @"957b1522a243845e3fb3e789cb565da8.jpeg",
                               @"98bb704f9c644752e92f2a8656ac943b.jpeg",
                               @"9d2894d42c6accf86ed68e3774ccad16.jpeg",
                               @"9ffd9eca1b717283b2067518e58bd4a0.jpeg",
                               @"a4d216340b6c5e5eb64e723a4a358d28.jpeg",
                               @"a7088a3c01745e4ac5c03aab0da3cfb1.jpeg",
                               @"ab5f3d76db6bee49639c82c7acafcaea.jpeg",
                               @"b7d51b33b3dff708943cfe8bd6496388.jpeg",
                               @"c18cdd159b659e8fe8d9cc16d5c8109a.jpeg",
                               @"c7e95a6f9b69207318bc28bc02746247.jpeg",
                               @"e0e6bcc27e0116693c19249a9afa1ae0.jpeg",
                               @"e5f9a21646773d088fb3798bf1d60d2f.jpeg",
                               @"ec4c9ed7add67a53517b07c1e5170ecd.jpeg",
                               @"eff3d4c1d7a354a913797e7d52449ce5.jpeg",
                               @"f8dd830cb1244698a79f386f1053f2c4.jpeg",
                               @"fca43d21dc368c9d7fb962f2143c1cab.jpeg", nil];
    
    NSString *basePath = @"http://albertodebortoli.it/GitHub/ADBGridView/";

    for (NSString *imageFileName in imageFileNames) {
        [self.images addObject:[basePath stringByAppendingString:imageFileName]];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - ADBGridViewDelegate

- (NSString *)imagePathForADBGridView:(ADBGridView *)view atIndex:(NSUInteger)index
{
    return [self.images objectAtIndex:index];
}

- (NSUInteger)numberOfImagesInGrid:(ADBGridView *)view
{
    return [images count];
}

- (NSUInteger)numberOfImagesForRow:(ADBGridView *)view
{
    if (view == gridView1) {
        return 3;
    } else if (view == gridView2) {
        return 8;
    } else if (view == gridView3) {
        return 7;
    }
    
    return 0;
}

- (void)imageInADBGridView:(ADBGridView *)gridView singleTapImageView:(ADBImageView *)imageView
{
    NSLog(@"Single tap on image with URL %@", [imageView.url absoluteString]);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Single tap on image w/ URL"
                                                    message:[imageView.url absoluteString]
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"Ok", nil];
    [alert show];
}

- (void)imageInADBGridView:(ADBGridView *)gridView longPressImageView:(ADBImageView *)imageView
{
    NSLog(@"Long press on image with URL %@", [imageView.url absoluteString]);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Long press on image w/ URL"
                                                    message:[imageView.url absoluteString]
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"Ok", nil];
    [alert show];
}

#pragma mark - Actions

- (IBAction)reloadGrids:(id)sender
{
    [gridView1 reloadData];
    [gridView2 reloadData];
    [gridView3 reloadData];
}

@end
