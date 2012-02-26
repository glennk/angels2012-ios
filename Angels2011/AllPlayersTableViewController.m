//
//  AllPlayersTableViewController.m
//  Angels2011
//
//  Created by Glenn Kronschnabl on 11/3/11.
//  Copyright 2011 CoreLogic. All rights reserved.
//

#import "AllPlayersTableViewController.h"
#import "PlayerSummaryViewController.h"
#import <YAJLios/YAJL.h>
#include "ASIHTTPRequest.h"
#include "AwsURLHelper.h"
#include "Player.h"

@interface AllPlayersTableViewController()
@property (copy) NSString *jsonkey;
@property (retain, nonatomic) NSDictionary * playersAsDictionary;
@property BOOL byNickname;
@end;

@implementation AllPlayersTableViewController

@synthesize sections = _sections;
@synthesize players = _players;

@synthesize jsonkey;
@synthesize playersAsDictionary = _playersAsDictionary;
@synthesize byNickname;

/*
 * players[NSArray]
 *
 * [0] = NSDictionary(name=Aaron Little, etc)
 * [1] = NSDictionary(name=Michael Kronschnabl, etc)
 
 key=A, value=NSArray
 [0] = Aaron Little
 [1] = <any other names that start with A>
 
 key=M, value=NSArray
 [0] = Michael Kronschnabl
 [1] = <any other names that start with M>
 */

//- (NSArray *)sectionsOLD
//{
//    if (!_sections) {
//        _sections = [[[self.players allKeys] sortedArrayUsingSelector:@selector(compare:)] retain];
//        NSLog(@"sections = %@", _sections);
//    }
//    return _sections;
//}

- (NSDictionary *)playersAsDictionary
{
    if (!_playersAsDictionary) {
        NSLog(@"playersAsDictionary()");
        NSMutableDictionary *p = [[NSMutableDictionary alloc] init];
        for (Player *t in self.players) {
            NSLog(@"t.nickname = %@, t.lastname = %@", t.nickname, t.lastname);
            NSString *key = nil;
            NSString *x = nil;
            if (self.byNickname)
                x = t.nickname;
            else
                x = t.lastname;
            NSLog(@"x = %@", x);
            if (x && x.length > 0)
                key = [x substringToIndex:1];
            else
                continue;
            
            NSLog(@"key = %@", key);
            if (![p objectForKey:key]) {
                NSMutableArray *x = [[NSMutableArray alloc] init];
                [x addObject:t];
                [p setValue:x forKey:key];
                [x release];
            }
            else {
                [[p objectForKey:key] addObject:t];
            }
        }
        _playersAsDictionary = [[NSDictionary alloc] initWithDictionary:p];
        [p release];
    }
    return _playersAsDictionary;
}


- (NSArray *)sections
{
    if (!_sections) {
        _sections = [[[self.playersAsDictionary allKeys] sortedArrayUsingSelector:@selector(compare:)] retain];
        NSLog(@"sections = %@", _sections);
    }
    return _sections;
}

- (NSArray *)players
{
    if (!_players) {
        NSLog(@"getPlayers()");
        NSMutableArray *jplayers = [[NSMutableArray alloc] init];
        NSURL *playersURL = [AwsURLHelper getPlayers];
        NSLog(@"players.url %@", playersURL);
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:playersURL];
        [request addRequestHeader:@"Accept" value:@"application/json"];
        [request startSynchronous];
        NSError *error = [request error];
        if (!error) {
            NSString *response = [request responseString];
            NSLog(@"players.response = %@", response);
            NSDictionary *temp = [response yajl_JSON];
            NSLog(@"players[after json parse] = %@", temp);
            NSArray *x = [temp objectForKey:@"players"];
            NSLog(@"x = %@", x);
            for (NSDictionary *t in x) {
                NSLog(@"t = %@", t);
                Player* p = [Player playerFromJson:t];
                [jplayers addObject:p];
            }
        }
        NSLog(@"jplayers array = %@", jplayers);
        _players = [[NSArray alloc] initWithArray:jplayers];
        [jplayers release];
    }
    return _players;
}
 

- (void)toggleNicknames
{
    NSLog(@"toggleNicknames(), setting _sections and _players to nil");
    [_sections release];
    _sections = nil;
    [_playersAsDictionary release];
    _playersAsDictionary = nil;
    if (jsonkey == @"lastname") {
        jsonkey = @"nickname";
        self.byNickname = TRUE;
        self.navigationItem.leftBarButtonItem.title = @"By Lastnames";
    }
    else {
        jsonkey = @"lastname";
        self.byNickname = FALSE;
        self.navigationItem.leftBarButtonItem.title = @"By Nicknames";
    }
    [self.tableView reloadData];
    
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        UIImage* anImage = [UIImage imageNamed:@"112-group.png"];
        UITabBarItem* item = [[UITabBarItem alloc] initWithTitle:@"Players" image:anImage tag:0];
        self.tabBarItem = item;
        [item release];
        UIBarButtonItem *lbarItem = [[UIBarButtonItem alloc] initWithTitle:@"By Nicknames" style:UIBarButtonItemStyleBordered target:self action:@selector(toggleNicknames)];
        self.navigationItem.leftBarButtonItem = lbarItem;
        [lbarItem release];
        NSLog(@"set jsonkey = @lastname");
        jsonkey = @"lastname";
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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
//    _players = self.players;
//    playersAsDictionary = [self putPlayersInDictionary:FALSE];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSArray *playersInSection = [self.playersAsDictionary objectForKey:[self.sections objectAtIndex:section]];
    return playersInSection.count;
}

//- (NSDictionary *)playerAtIndexPath:(NSIndexPath *)indexPathOLD
//{
//    //NSLog(@"playerAtIndexPath: section=%d, row=%d", indexPath.section, indexPath.row);
//    //NSLog(@"_players.retainCount = %d", [_players retainCount]);
//    NSArray *playersInSection = [self.players objectForKey:[self.sections objectAtIndex:indexPath.section]];
//    //NSLog(@"playerAtIndexPath.playersInSection = %@", playersInSection);
//    NSDictionary *t = [playersInSection objectAtIndex:indexPath.row];
//    NSLog(@"playerAtIndexPath = %@", t);
//    return t;
//    //    return [teamsInSection objectAtIndex:indexPath.row];
//}

- (Player *)playerAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"playerAtIndexPath: section=%d, row=%d", indexPath.section, indexPath.row);
    //NSLog(@"_players.retainCount = %d", [_players retainCount]);
    NSArray *playersInSection = [self.playersAsDictionary objectForKey:[self.sections objectAtIndex:indexPath.section]];
    //NSLog(@"playerAtIndexPath.playersInSection = %@", playersInSection);
    Player *t = [playersInSection objectAtIndex:indexPath.row];
    NSLog(@"playerAtIndexPath = %@", t);
    return t;
    //    return [teamsInSection objectAtIndex:indexPath.row];
}

//- (NSDictionary *)playerAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSArray *playersInSection = [self.players objectForKey:[self.sections objectAtIndex:indexPath.section]];
//    return [playersInSection objectAtIndex:indexPath.row];
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AngelsAllPlayersCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    //NSDictionary *t = [self playerAtIndexPath:indexPath];
    Player *p = [self playerAtIndexPath:indexPath];
    NSLog(@"cell = %@", p);
    if (jsonkey == @"nickname") {
        //cell.textLabel.text = [t objectForKey:jsonkey];
        cell.textLabel.text = p.nickname;
    }
    else {
        //NSString *s = [NSString stringWithFormat:@"%@ %@", [t objectForKey:@"firstname"], [t objectForKey:@"lastname"]]; 
        NSString *s = [NSString stringWithFormat:@"%@ %@", p.firstname, p.lastname]; 
        cell.textLabel.text = s;
    }
    

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.sections objectAtIndex:section];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
    NSLog(@"inddexPath: %d", indexPath.row);
    PlayerSummaryViewController *psvc = [[PlayerSummaryViewController alloc] init];
 //   psvc.hidesBottomBarWhenPushed = YES;
    psvc.player = [self playerAtIndexPath:indexPath];
    [self.navigationController pushViewController:psvc animated:YES];
    [psvc release]; 
    
    
}

@end
