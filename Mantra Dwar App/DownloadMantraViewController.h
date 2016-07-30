//
//  DownloadMantraViewController.h
//  Mantra Dwar App
//
//  Created by Jitesh Kapadia on 2/25/15.
//  Copyright (c) 2015 August. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DownloadMantraViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,NSURLConnectionDataDelegate>
@property(nonatomic,retain)NSMutableArray *arrayData;
@property(nonatomic,retain)IBOutlet UITableView *tblView;
@property(nonatomic,retain)IBOutlet UIActivityIndicatorView *process;
@property(nonatomic,retain)IBOutlet UIView *viewProgress;
@property(nonatomic,retain)IBOutlet UIProgressView *progressBar;
@property(nonatomic,retain)IBOutlet UILabel *lblProgress,*lblDownloadingSongName;
@property (strong, nonatomic) NSURLConnection *connectionManager;
@property (strong, nonatomic) NSMutableData *downloadedMutableData;
@property (strong, nonatomic) NSURLResponse *urlResponse;
@property(nonatomic,retain) NSMutableDictionary *currentDownloading;
@end
