//
//  GalleryViewController.h
//  MANTRADWAR
//
//  Created by jayraj gohil on 07/04/15.
//  Copyright (c) 2015 August. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IconDownloader.h"
#import "Reachability.h"
@interface GalleryViewController : UIViewController<UITabBarDelegate,UITableViewDataSource,UITableViewDelegate,IconDownloaderDelegate,UIGestureRecognizerDelegate>
@property(nonatomic,retain)IBOutlet UITableView *tblView;
@property(nonatomic,retain)IBOutlet UITabBar *tabBar;
@property(nonatomic,retain)NSMutableArray *arrayData;
@property(nonatomic,strong) NSMutableDictionary *imageDownloadsInProgress;
@property(nonatomic,retain)NSString *albumID;
@property(nonatomic,retain)IBOutlet UIActivityIndicatorView *process;

@end
