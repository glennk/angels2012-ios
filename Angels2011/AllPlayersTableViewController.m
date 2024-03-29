//
//  AllPlayersTableViewController.m
//  Angels2011
//
//  Created by Glenn Kronschnabl on 11/3/11.
//  Copyright 2011 Glenn Kronschnabl. All rights reserved.
//

#import "AllPlayersTableViewController.h"
#import "PlayerSummaryViewController.h"
#import "Player.h"
#import "Logging.h"

@interface AllPlayersTableViewController()
//@property (copy) NSString *jsonkey;
//@property (retain, nonatomic) NSDictionary * playersAsDictionary;
@property BOOL byNickname;
@property (retain, nonatomic) IBOutlet UITableView *myTableView;
@property (retain, nonatomic) IBOutlet UISegmentedControl *listByNicknameOrLastname;
- (IBAction)sortBy:(id)sender;
@property (retain, nonatomic) NSMutableArray * myplayers;
@end;

@implementation AllPlayersTableViewController
@synthesize myTableView;
@synthesize listByNicknameOrLastname;

//@synthesize sections = _sections;
//@synthesize players = _players;

//@synthesize jsonkey;
//@synthesize playersAsDictionary = _playersAsDictionary;
@synthesize byNickname;

@synthesize myplayers;


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ([[self.myplayers objectAtIndex:section] count] > 0) {
        return [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section];
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation currentCollation];
    self.myplayers = [NSMutableArray arrayWithCapacity:1];
    
    SEL mysel = nil;
    if (self.byNickname)
        mysel = @selector(nickname);
    else
        mysel = @selector(lastname);
        
    for (Player *p in _players) {
        //DLog(@"player = %@", p.lastname);
        NSInteger sect = [theCollation sectionForObject:p collationStringSelector:mysel];
        //DLog(@"in sect index = %i", sect);
        p.sectionNumber = sect;
    }
    
    // (2)
    NSInteger highSection = [[theCollation sectionTitles] count];
    NSMutableArray *sectionArrays = [NSMutableArray arrayWithCapacity:highSection];
    for (int i=0; i<=highSection; i++) {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sectionArrays addObject:sectionArray];
    }
    
    // (3)
    for (Player *p in _players) {
        [(NSMutableArray *)[sectionArrays objectAtIndex:p.sectionNumber] addObject:p];
    }
    
    // (4)
    for (NSMutableArray *sectionArray in sectionArrays) {
        NSArray *sortedSection = [theCollation sortedArrayFromArray:sectionArray
                                            collationStringSelector:mysel];
        [self.myplayers addObject:sortedSection];
    }

    return [self.myplayers count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.myplayers objectAtIndex:section] count];
}

//- (NSDictionary *)XXXplayersAsDictionary
//{
//    if (!_playersAsDictionary) {
//        DLog(@"playersAsDictionary()");
//        _playersAsDictionary = [[NSMutableDictionary alloc] init];
//        for (Player *t in _players) {
//            DLog(@"t.nickname = %@, t.lastname = %@", t.nickname, t.lastname);
//            NSString *key = nil;
//            NSString *x = nil;
//            if (self.byNickname)
//                x = (t.nickname.length > 0) ? t.nickname : @" ";
//            else
//                x = t.lastname;
//            DLog(@"x = '%@'", x);
//            if (x && x.length > 0)
//                key = [x substringToIndex:1];
//            else
//                continue;
//            
//            DLog(@"key = %@", key);
//            if (![_playersAsDictionary objectForKey:key]) {
//                NSMutableArray *x = [[[NSMutableArray alloc] init] autorelease];
//                [x addObject:t];
//                [_playersAsDictionary setValue:x forKey:key];
//            }
//            else {
//                [[_playersAsDictionary objectForKey:key] addObject:t];
//            }
//        }
//    }
//    return _playersAsDictionary;
//}
//
//- (NSArray *)sections
//{
//    if (!_sections) {
//        _sections = [[[self.playersAsDictionary allKeys] sortedArrayUsingSelector:@selector(compare:)] retain];
//        DLog(@"sections = %@", _sections);
//    }
//    return _sections;
//}

- (void)loadRESTWithBlock:(void (^)(NSArray * restData))block
{
	dispatch_queue_t callerQueue = dispatch_get_current_queue();
	dispatch_queue_t downloadQueue = dispatch_queue_create("rest downloader", NULL);
	dispatch_async(downloadQueue, ^{
        NSArray *restData = [[Player allPlayers] retain];
		dispatch_async(callerQueue, ^{
		    block(restData);
		});
	});
	dispatch_release(downloadQueue);
}

- (IBAction)sortBy:(id)sender
{
    DLog(@"Sorty by changed...");
    
	NSUInteger selectedUnit = [listByNicknameOrLastname selectedSegmentIndex];
	if (selectedUnit == 0) {
        DLog(@"By Lastname");
        self.byNickname = FALSE;
	} else {
        DLog(@"By Nickname");
        self.byNickname = TRUE;
	}
    
    [myTableView reloadData];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        UIImage* anImage = [UIImage imageNamed:@"112-group.png"];
        UITabBarItem* item = [[UITabBarItem alloc] initWithTitle:@"Players" image:anImage tag:0];
        self.tabBarItem = item;
        [item release];
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
    DLog(@"viewDidLoad()");
    
    [myTableView setDelegate: self];
    [myTableView setDataSource: self];

    self.title = @"Players";
    
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
    DLog(@"viewWillAppear()");
    
    if (!_players) {
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        spinner.frame = CGRectMake(0., 0., 40., 40.);
        spinner.center = self.view.center;
        [self.view addSubview:spinner];
        
        [spinner startAnimating];
        
        [self loadRESTWithBlock:^(NSArray *restData) {
            _players = [restData copy];
//            [_sections release];
//            _sections = nil;
//            [_playersAsDictionary release];
//            _playersAsDictionary = nil;
            
            [myTableView reloadData];
            [spinner stopAnimating];
            [spinner release];
        }];
        
    }
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

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    // Return the number of sections.
//    return self.sections.count;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    // Return the number of rows in the section.
//    NSArray *playersInSection = [self.playersAsDictionary objectForKey:[self.sections objectAtIndex:section]];
//    return playersInSection.count;
//}
//
//- (Player *)playerAtIndexPath:(NSIndexPath *)indexPath
//{
//    //DLog(@"playerAtIndexPath: section=%d, row=%d", indexPath.section, indexPath.row);
//    //DLog(@"_players.retainCount = %d", [_players retainCount]);
//    NSArray *playersInSection = [self.playersAsDictionary objectForKey:[self.sections objectAtIndex:indexPath.section]];
//    //DLog(@"playerAtIndexPath.playersInSection = %@", playersInSection);
//    Player *t = [playersInSection objectAtIndex:indexPath.row];
//    DLog(@"playerAtIndexPath = %@", t);
//    return t;
//    //    return [teamsInSection objectAtIndex:indexPath.row];
//}
//

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    static NSString *CellIdentifier = @"StateCell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
//                                       reuseIdentifier:CellIdentifier] autorelease];
//    }
//    Player *playerObj = [[self.myplayers objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
//    cell.textLabel.text = playerObj.nickname;
//    return cell;
//}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AngelsAllPlayersCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    Player *p = [[self.myplayers objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
//    Player *p = [self playerAtIndexPath:indexPath];
    if (self.byNickname) {
        cell.textLabel.text = p.nickname;
        NSString *s = [NSString stringWithFormat:@"#%@, %@ %@", p.number, p.firstname, p.lastname]; 
        cell.detailTextLabel.text = s;
    }
    else {
        NSString *s = [NSString stringWithFormat:@"%@ %@", p.firstname, p.lastname]; 
        cell.textLabel.text = s;
        s = [NSString stringWithFormat:@"#%@, %@", p.number, p.nickname]; 
        cell.detailTextLabel.text = s;
    }
    
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return [self.sections objectAtIndex:section];
//}

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

//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    NSArray *keys = [_playersAsDictionary.allKeys sortedArrayUsingSelector:@selector(compare:)];
//    return keys; //[NSArray arrayWithObjects:[self.pla@"a", @"e", @"i", @"m", @"p", nil];
//}
//
//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString*)title atIndex:(NSInteger)index
//{
//    DLog(@"title = %@, index = %d", title, index);
//    return index;
//}

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
    DLog(@"inddexPath: %d", indexPath.row);
    PlayerSummaryViewController *psvc = [[PlayerSummaryViewController alloc] init];
 //   psvc.hidesBottomBarWhenPushed = YES;
    Player *p = [[self.myplayers objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    psvc.player = p;
    [self.navigationController pushViewController:psvc animated:YES];
    [psvc release]; 
    
    
}

@end
