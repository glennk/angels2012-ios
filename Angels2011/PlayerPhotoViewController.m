//
//  PlayerViewController.m
//  Angels2011
//
//  Created by Glenn Kronschnabl on 10/24/11.
//  Copyright 2011 Glenn Kronschnabl. All rights reserved.
//

#import "PlayerPhotoViewController.h"
#import <YAJLios/YAJL.h>
#include "ASIHTTPRequest.h"
#import "AwsURLHelper.h"

@implementation PlayerPhotoViewController

@synthesize player;
//@synthesize playerInfo;

@synthesize playerLabel;

//@synthesize scrollView;
//@synthesize playerPhoto;

#define SCALE 0.25f

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"player = %@", player);
    NSString *id = player.uniqueId;
    NSURL *playersURL = [AwsURLHelper getPhotoOfPlayer:id];
    NSLog(@"players.photo..url %@", playersURL);
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:playersURL];
    [request addRequestHeader:@"Accept" value:@"image/jpeg"];
    [request startSynchronous];
    NSError *error = [request error];
    UIImage *image = nil;
    if (!error) {
        NSData *responseData = [request responseData];
        image = [UIImage imageWithData:responseData];
    }      
    
    self.playerLabel.text = player.lastname;
//    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"aaa" ofType:@"jpg"]];
    if (image == nil)
        NSLog(@"Failed to load image for control vieww");
    else {
        playerPhoto.image = image;
        playerPhoto.frame = CGRectMake(0, 0, image.size.width*SCALE, image.size.height*SCALE);
        CGSize size = CGSizeMake(image.size.width*SCALE, image.size.height*SCALE);
        scrollView.contentSize = size; //image.size;
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
