//
//  PhotoAlbumListViewController.h
//  Mantra Dwar App
//
//  Created by Jitesh Kapadia on 2/26/15.
//  Copyright (c) 2015 August. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "DownloadMantraViewController.h"
@interface PhotoAlbumListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITabBarDelegate>
@property(nonatomic,retain)NSMutableArray *arrayData;
@property(nonatomic,retain)IBOutlet UITableView *tblView;
@property(nonatomic,retain)IBOutlet UIActivityIndicatorView *process;
@property(nonatomic,retain)IBOutlet UITabBar *tabBar;
@end
