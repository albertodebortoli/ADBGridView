//
//  ADBBrowseViewController.h
//  ADBGridViewDemo
//
//  Created by Alberto De Bortoli on 21/01/12.
//  Copyright (c) 2012 Alberto De Bortoli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "ADBGridView.h"

@interface BrowseViewController : UIViewController <ADBGridViewDelegate> {
    
    IBOutlet ADBGridView                *gridView1;
    IBOutlet ADBGridView                *gridView2;
    IBOutlet ADBGridView                *gridView3;
    NSMutableArray                      *images;
}

- (IBAction)reloadGrids:(id)sender;

@property (nonatomic, strong) NSMutableArray *images;

@end
