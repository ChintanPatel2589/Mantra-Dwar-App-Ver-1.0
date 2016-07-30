//
//  IconDownloader.m
//  HTDMobile
//
//  Created by Tushar on 4/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "IconDownloader.h"
@implementation IconDownloader

@synthesize appRecord;
@synthesize indexPathInTableView, imageViewTag;
@synthesize delegate;
@synthesize activeDownload;
@synthesize imageConnection;
@synthesize imageUrlKey;
#pragma mark
- (void)dealloc
{
    [appRecord release];
    [indexPathInTableView release];
    [activeDownload release];
    [imageConnection cancel];
    [imageConnection release];
    [super dealloc];
}

- (void)startDownload
{
    self.activeDownload = [NSMutableData data];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:
                                                                                  @"%@", [appRecord valueForKey:imageUrlKey]]]
                                                cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                            timeoutInterval:60.0];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    self.imageConnection = conn;
    [conn release];
}


- (void)cancelDownload
{
    [self.imageConnection cancel];
    self.imageConnection = nil;
    self.activeDownload = nil;
}


#pragma mark -
#pragma mark Download support (NSURLConnectionDelegate)

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.activeDownload appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // Clear the activeDownload property to allow later attempts
    NSLog(@"Error:%@",error);
    self.activeDownload = nil;
    // Release the connection now that it's finished
    self.imageConnection = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
   // NSLog(@"Got download");
    UIImage *image = [[UIImage alloc] initWithData:self.activeDownload];
    if (image==NULL)
    {
        return;
    }
    else
    {
        @try {
            //TN Cache an image once it get download
            NSUserDefaults *usrDefs = [NSUserDefaults standardUserDefaults];
            NSData *imgData = UIImagePNGRepresentation(image);
            [usrDefs setObject:imgData forKey:[appRecord objectForKey:imageUrlKey]];
            [self.appRecord setObject:image forKey:[NSString stringWithFormat:@"Icon%d", imageViewTag]];
            self.activeDownload = nil;
            [image release];
            self.imageConnection = nil;
            [self.delegate appImageDidLoad:self.indexPathInTableView withImageViewTag:self.imageViewTag];
        }
        @catch (NSException *exception) {
        }
        @finally {
        }
    }
}

@end

