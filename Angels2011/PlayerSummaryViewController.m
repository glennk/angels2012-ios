//
//  PlayerSummaryViewController.m
//  Angels2011
//
//  Created by Glenn Kronschnabl on 11/2/11.
//  Copyright 2011 CoreLogic. All rights reserved.
//

#import "PlayerSummaryViewController.h"
#import "PlayerMoreInfoTableViewController.h"
#import "Player.h"


@interface PlayerSummaryViewController()
@end

@implementation PlayerSummaryViewController

@synthesize player = _player;

- (void)setPlayer:(Player *)newplayer
{
    NSLog(@"setPlayer: %@", newplayer);
    [_player release];
    _player = newplayer;
//    [fieldImage.image release];
    fieldImage.image = nil;
}

- (UIImage *)playerCardPhoto
{
    return [Player playerCardPhoto: _player];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear: player = %@", _player);
//    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Ian2" ofType:@"png"]];
//    if (image == nil)
//        NSLog(@"Failed to load image for control vieww");
    if (fieldImage.image == nil)
        fieldImage.image = [self playerCardPhoto];
    
    NSDictionary *bImgs = [NSDictionary dictionaryWithObjectsAndKeys: 
                           @"11UClubTag", @"11UW", @"12UWhiteClubTag", @"12UW", @"12URedClubTag", @"12UR", @"13URedClubTag", @"13UR", nil];

    NSString *bName = [bImgs objectForKey:_player.level];
    NSLog(@"bName = %@", bName);
    UIImage *bimg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:bName ofType:@"png"]];
    if (bimg == nil)
        NSLog(@"Failed to load banner for control vieww");
    banner.image = bimg;
}


- (IBAction)photoButtonPressed:(id)sender
{
    NSLog(@"photoButtonPressed");
    PlayerMoreInfoTableViewController *pmivc = [[PlayerMoreInfoTableViewController alloc] init];
    pmivc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    pmivc.player = _player;
    
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
    NSLog(@"playerSummaryViewController.viewDidLoad = %@", _player);
    NSString *s = [NSString stringWithFormat:@"%@ %@", _player.firstname, _player.lastname];
    [playerLabel setText:s]; //[player objectForKey:@"lastname"];
    playerNumber.text = _player.number;
    playerNickname.text = _player.nickname;
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

- (void)dealloc {
    [super dealloc];
}

@end
