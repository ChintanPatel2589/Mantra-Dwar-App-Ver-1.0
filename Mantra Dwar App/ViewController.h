//
//  ViewController.h
//  Mantra Dwar App
//
//  Created by Jitesh Kapadia on 2/18/15.
//  Copyright (c) 2015 August. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownloadMantraViewController.h"
@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITabBarDelegate>
@property(nonatomic,retain)NSMutableArray *arrayData;
@property(nonatomic,retain)IBOutlet UITableView *tblView;
@property(nonatomic,retain)IBOutlet UISwitch *switchMantra;
@property(nonatomic,retain)IBOutlet UITabBar *tabBar;

@end

