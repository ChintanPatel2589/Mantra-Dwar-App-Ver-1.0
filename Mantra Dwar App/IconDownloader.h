//
//  IconDownloader.h
//  HTDMobile
//
//  Created by Tushar on 4/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


@protocol IconDownloaderDelegate;

@interface IconDownloader : NSObject
{
    //NSMutableDictionary *appRecord;
    // NSIndexPath *indexPathInTableView;
    // id <IconDownloaderDelegate> delegate;
    
    // NSMutableData *activeDownload;
    //NSURLConnection *imageConnection;
}

@property (nonatomic, strong) NSMutableDictionary *appRecord;
@property (nonatomic, strong) NSIndexPath *indexPathInTableView;
@property (nonatomic) int imageViewTag;
@property (nonatomic, strong) id <IconDownloaderDelegate> delegate;

@property (nonatomic, strong) NSMutableData *activeDownload;
@property (nonatomic, strong) NSURLConnection *imageConnection;
@property (nonatomic, retain) NSString *imageUrlKey;

- (void)startDownload;

- (void)cancelDownload;

@end

@protocol IconDownloaderDelegate

- (void)appImageDidLoad:(NSIndexPath *)indexPath withImageViewTag:(int)imageViewTag;

@end