//
//  ImagesLocalViewController.h
//  TKScroller
//
//  Created by Toseefhusen on 27/02/14.
//  Copyright (c) 2014 Toseef Khilji. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "TKScroller.h"

@interface ImagesLocalViewController : UIViewController
{
    
}
@property(nonatomic) int page;
@property(nonatomic,retain)TKScroller *scroller;
@property(nonatomic,retain)NSMutableArray *imageArray;
@end
