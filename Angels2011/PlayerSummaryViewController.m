//
//  PlayerSummaryViewController.m
//  Angels2011
//
//  Created by Glenn Kronschnabl on 11/2/11.
//  Copyright 2011 CoreLogic. All rights reserved.
//

#import "PlayerSummaryViewController.h"
//#import "PlayerPhotoViewController.h"
#import "PlayerMoreInfoTableViewController.h"
#import <YAJLios/YAJL.h>
#import "AwsURLHelper.h"
#include "ASIHTTPRequest.h"
#include "Player.h"


@interface PlayerSummaryViewController()
//@property (retain) IBOutlet UILabel *playerLabel;
//@property (retain) IBOutlet UIImageView *fieldImage;
//@property (retain) IBOutlet UIView *fieldOverlay;
//@property (retain) NSMutableDictionary *positions;
@end

@implementation PlayerSummaryViewController

//@synthesize playerLabel;
@synthesize player; //, playerInfo;
//@synthesize fieldImage; //, fieldOverlay
//@synthesize banner;


- (void)drawCircelAtPoint:(CGPoint)p withRaduis:(CGFloat)radius inContext:(CGContextRef)context
{
    UIGraphicsPushContext(context);
    CGContextBeginPath(context);
    CGContextAddArc(context, p.x, p.y, radius, 0, 2*M_PI, YES);
    CGContextStrokePath(context);
    UIGraphicsPopContext();
    
}

- (UIImage*)getImage
{
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
    
    if (image == nil)
        NSLog(@"Failed to load image for URL: %@", playersURL);
    else {
//        fieldImage.image = image;
//        playerPhoto.frame = CGRectMake(0, 0, image.size.width*SCALE, image.size.height*SCALE);
//        CGSize size = CGSizeMake(image.size.width*SCALE, image.size.height*SCALE);
//        scrollView.contentSize = size; //image.size;
    }
    return image;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Ian2" ofType:@"png"]];
//    if (image == nil)
//        NSLog(@"Failed to load image for control vieww");
    fieldImage.image = [self getImage]; //image;
    
    NSDictionary *bImgs = [NSDictionary dictionaryWithObjectsAndKeys: 
                           @"11UClubTag", @"11UW", @"12UWhiteClubTag", @"12UW", @"12URedClubTag", @"12UR", @"13URedClubTag", @"13UR", nil];

    NSLog(@"player.level = %@", player.level);
    NSString *bName = [bImgs objectForKey:player.level];
    NSLog(@"bName = %@", bName);
//    UIImage *bimg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"11UClubTag" ofType:@"png"]];
    UIImage *bimg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:bName ofType:@"png"]];
    if (bimg == nil)
        NSLog(@"Failed to load banner for control vieww");
    banner.image = bimg;

//    [image release];
    
//     UIImage *dot = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"85-trophy" ofType:@"png"]];
//    UIImageView *overlayImageView = [[UIImageView alloc] initWithImage:dot];
//    //[overlayImageView setFrame:CGRectMake(30, 100, 260, 200)];
//    [overlayImageView setCenter:CGPointMake(150, 200)];
//    [[self view] addSubview:overlayImageView];
//    [overlayImageView release];

  
//         // Drawing code
//        CGPoint midPoint;
//        midPoint.x = self.fieldOverlay.bounds.origin.x + self.fieldOverlay.bounds.size.width/2;
//        midPoint.y = self.fieldOverlay.bounds.origin.y + self.fieldOverlay.bounds.size.height/2;
//        
//        CGFloat size = self.fieldOverlay.bounds.size.width / 2;
//        if (self.fieldOverlay.bounds.size.height < self.fieldOverlay.bounds.size.width) size = self.fieldOverlay.bounds.size.height / 2;
//        size *= 0.90;
//        
//        CGContextRef context = UIGraphicsGetCurrentContext();
//        
//        [self.fieldOverlay drawCircelAtPoint:midPoint withRaduis:size inContext:context];
//
  }


- (IBAction)photoButtonPressed:(id)sender
{
    NSLog(@"photoButtonPressed");
    PlayerMoreInfoTableViewController *pmivc = [[PlayerMoreInfoTableViewController alloc] init];
    pmivc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    pmivc.player = player;
    
    UINavigationController *cntrol = [[UINavigationController alloc] initWithRootViewController:pmivc];
    [self presentViewController:cntrol animated:YES completion:nil];
    //[self.navigationController pushViewController:pmivc animated:YES];
    [cntrol release];
    [pmivc release];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //self.navigationItem.rightBarButtonItem.title = @"Photos";
        UIBarButtonItem *rBarItem = [[UIBarButtonItem alloc] initWithTitle:@"More Info" style:UIBarButtonItemStyleBordered target:self action:@selector(photoButtonPressed:)];
        self.navigationItem.rightBarButtonItem = rBarItem;
        [rBarItem release];
        self.hidesBottomBarWhenPushed = YES;
        
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
    NSLog(@"playerSummaryViewController.viewDidLoad = %@", player);
    NSString *s = [NSString stringWithFormat:@"%@ %@", player.firstname, player.lastname];
    [playerLabel setText:s]; //[player objectForKey:@"lastname"];
    playerNumber.text = player.number;
    playerNickname.text = player.nickname;
    playerPositions.text = player.positions;
    // Do any additional setup after loading the view from its nib.
}


- (void)viewDidUnload
{
    [playerNumber release];
    playerNumber = nil;
    [playerNickname release];
    playerNickname = nil;
    [fieldImage release];
    fieldImage = nil;
//    [fieldOverlay release];
//    fieldOverlay = nil;
    [playerPositions release];
    playerPositions = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [playerNumber release];
    [playerNickname release];
    [fieldImage release];
//    [fieldOverlay release];
    [playerPositions release];
    [super dealloc];
}

@end
