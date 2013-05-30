//
//  InstaShareGramMainViewController.m
//  instasharegram
//
//  Created by 권 회경 on 13. 5. 29..
//  Copyright (c) 2013년 Swanky Street. All rights reserved.
//

#import "InstaShareGramMainViewController.h"

@interface InstaShareGramMainViewController ()
@end

@implementation InstaShareGramMainViewController
@synthesize thumbnailWebView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Instasharegram";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSURL *url = [NSURL URLWithString:@"https://instagram.com/oauth/authorize/?display=touch&client_id=0e57f32cd05241919e1210acafb2d8f0&redirect_uri=http://instasharegram.com&response_type=token"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [thumbnailWebView loadRequest:request];
    [thumbnailWebView setDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setThumbnailWebView:nil];
    [super viewDidUnload];
}

#pragma jeanclad UIWebviewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
  navigationType:(UIWebViewNavigationType)navigationType  {
    NSString *kRedirectURI = @"abc";
    NSPredicate *successPredicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", kRedirectURI];
    NSLog(@"request = %@", request);
    NSLog(@"scheme = %@", [[request URL] scheme]);

    if ([successPredicate evaluateWithObject:[[request URL] scheme]]) {
        NSString *responseTokenString = [[request URL] absoluteString];
        NSString *removedRedirectURI =
        [responseTokenString stringByReplacingOccurrencesOfString:kRedirectURI withString:@""];
        
        // uri와 토큰은 “#”문자열로 구분이 됩니다.
        NSArray *tokenArray = [removedRedirectURI componentsSeparatedByString:@"="];
        NSString *token = [tokenArray objectAtIndex:1];
        
        NSString *kAccessToken = nil;
        // 부여받은 토큰을 저는 NSUserDefaults를 이용하여 저장하였습니다.
        [[NSUserDefaults standardUserDefaults] setObject:token forKey:kAccessToken];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        //[self.navigationController popViewControllerAnimated:YES];
        
        return NO;
    }
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"error = %@", error);
    NSString *errorReason = nil;
    
    if (error.code==NSURLErrorTimedOut) {
        errorReason=@"URL Time Out Error ";
    }
    else if (error.code==NSURLErrorCannotFindHost) {
        errorReason=@"Cannot Find Host ";
    }
    else if (error.code==NSURLErrorCannotConnectToHost) {
        errorReason=@"Cannot Connect To Host";
    }
    else if (error.code==NSURLErrorNetworkConnectionLost) {
        errorReason=@"Network Connection Lost";
    }
    else if (error.code==NSURLErrorUnknown) {
        errorReason=@"Unknown Error";
    }
    else {
        errorReason=@"Loading Failed";
    }
    UIAlertView *errorAlert=[[UIAlertView alloc]initWithTitle:errorReason message:@"Redirecting to the server failed. do you want to EXIT the app"  delegate:self cancelButtonTitle:@"EXIT" otherButtonTitles:@"RELOAD", nil];
    
    
    [errorAlert show];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"finish load");
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"start load");
}

@end
