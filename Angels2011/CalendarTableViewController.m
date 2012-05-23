//
//  CalendarTableViewController.m
//  Angels2011
//
//  Created by Glenn Kronschnabl on 11/13/11.
//  Copyright (c) 2011 Glenn Kronschnabl. All rights reserved.
//

#import "CalendarTableViewController.h"
#import "GCalEvent.h"
#import "Logging.h"
#import "WebViewController.h"

@interface CalendarTableViewController()
@property (retain, nonatomic) NSMutableDictionary *eventsAsDictionary;
@property (retain, nonatomic) NSArray *sections;
@property (retain, nonatomic) NSDateFormatter *inDateFormatter, *outDateFormatter;
@property (retain, nonatomic) UIView * origView;
@property (retain, nonatomic) UIActivityIndicatorView *spinner;
@property (retain, nonatomic) IBOutlet UITableView *mainTable;
@property BOOL includePast;
- (IBAction)gotoAngelsCalendar:(id)sender;

@end


@implementation CalendarTableViewController

@synthesize events = _events;
@synthesize eventsAsDictionary = _eventsAsDictionary;
@synthesize sections = _sections;
@synthesize inDateFormatter, outDateFormatter;
@synthesize origView, spinner;
@synthesize mainTable;
@synthesize includePast;


- (NSDictionary *)eventsAsDictionary
{
    if (!_eventsAsDictionary) {
        _eventsAsDictionary = [[NSMutableDictionary alloc] init];
        for (GCalEvent *e in _events) {
            if (![_eventsAsDictionary objectForKey:e.start]) {
                NSMutableArray *x = [[[NSMutableArray alloc] init] autorelease];
                [x addObject:e];
                [_eventsAsDictionary setValue:x forKey:e.start];
                
            } else {
                [[_eventsAsDictionary objectForKey:e.start] addObject:e];
            }
        }
    }
    return _eventsAsDictionary;
}

- (NSArray *)sections
{
    if (!_sections) {
        _sections = [[[self.eventsAsDictionary allKeys] sortedArrayUsingSelector:@selector(compare:)] retain];
        DLog(@"_sections = %@", _sections);
    }
    return _sections;
}

- (void)loadGcal
{
    DLog(@"loadGcal()");
    _events = [[GCalEvent allGcalEvents] retain];
    [_sections release];
    _sections = nil;
    [_eventsAsDictionary release];
    _eventsAsDictionary = nil;
    [spinner stopAnimating];
    [spinner release];
    [self setView: origView];
    [mainTable reloadData];
    
    // scroll to a section that is close to today's date
//    NSIndexPath *ip = [self getIndexPathNearToday];
//    if (ip != nil)
        [mainTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:8] atScrollPosition:UITableViewScrollPositionBottom animated:TRUE];
    
    DLog(@"loadGcal()...done");
}

// can return nil if we're at the end
- (NSIndexPath *)getIndexPathNearToday
{
    NSIndexPath *result = nil;
    NSDate *date = [[NSDate alloc] init];
//    date = [date dateByAddingTimeInterval:3000000];
    DLog(@"today = %@", date);
    // convert each section to a date
    int i = 0;
    for (; i < self.sections.count; i++) {
        NSString *s = [self.sections objectAtIndex:i];
        NSDate *dstart = [inDateFormatter dateFromString:s];
        if ([date timeIntervalSinceDate:dstart] < 0) {
            DLog(@"dstart = %@, today = %@, i = %d", dstart, date, i);
            result = [NSIndexPath indexPathForRow:0 inSection: (++i < self.sections.count) ? i : self.sections.count-1];
            break;
        }
    }
    [date release];
    return result;
}

//- (void)toggleIncludePast
//{
//    DLog(@"toggleIncludePast()");
//    if (self.includePast) {
//        self.includePast = FALSE;
//        self.navigationItem.rightBarButtonItem.title = @"Include Past";
//    }
//    else {
//        self.includePast = TRUE;
//        self.navigationItem.rightBarButtonItem.title = @"Upcoming";
//    }
//    _events = [[GCalEvent allGcalEvents :self.includePast] retain];
//    [_sections release];
//    _sections = nil;
//    [_eventsAsDictionary release];
//    _eventsAsDictionary = nil;
//    [mainTable reloadData];
//    
//}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        UIImage* anImage = [UIImage imageNamed:@"83-calendar.png"];
        UITabBarItem* item = [[UITabBarItem alloc] initWithTitle:@"Tournaments" image:anImage tag:0];
        self.tabBarItem = item;
        [item release];
        
        UIBarButtonItem *lbarItem = [[UIBarButtonItem alloc] initWithTitle:@"Full Calendar" style:UIBarButtonItemStyleBordered target:self action:@selector(gotoAngelsCalendar:)];
        self.navigationItem.rightBarButtonItem = lbarItem;
        [lbarItem release];
        
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
    [mainTable setDelegate: self];
    [mainTable setDataSource: self];

    self.navigationItem.title = @"Tournaments";

    self.inDateFormatter = [[NSDateFormatter alloc] init];
    [self.inDateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.outDateFormatter = [[NSDateFormatter alloc] init];
   // [self.outDateFormatter setDateStyle:NSDateFormatterMediumStyle];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    NSString *usFormatString = [NSDateFormatter dateFormatFromTemplate:@"EdMMM" options:0 locale:usLocale];
    DLog(@"usFormatterString: %@", usFormatString);
    [self.outDateFormatter setDateFormat:usFormatString];
    [usLocale release];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.inDateFormatter = nil;
    self.outDateFormatter = nil;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!_events) {
        DLog(@"_events is nil, fetch via REST");
        spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [spinner startAnimating];
        
        origView = [self.view retain];
        
        [self setView:spinner];
        [self performSelectorInBackground:@selector(loadGcal) withObject:nil];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSArray *entriesInSection = [self.eventsAsDictionary objectForKey:[self.sections objectAtIndex:section]];
    return entriesInSection.count;
}

- (GCalEvent *)entryAtIndexPath:(NSIndexPath *)indexPath
{
//    DLog(@"entryAtIndexPath: section=%d, row=%d", indexPath.section, indexPath.row);
    NSString *key = [self.sections objectAtIndex:indexPath.section];
//    DLog(@"key = %@", key);
    NSArray *eventsInSection = [self.eventsAsDictionary objectForKey:key];
    GCalEvent *t = [eventsInSection objectAtIndex:indexPath.row];
//    DLog(@"gcalEventAtIndexPath = %@", t);
    return t;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CalendarCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    GCalEvent *t = [self entryAtIndexPath:indexPath];
    //DLog(@"cell = %@", t);
    cell.textLabel.text = t.description;
    
    NSString *detailText = [[[NSString alloc] initWithFormat:@"%@", t.location] autorelease];

    cell.detailTextLabel.text = detailText; //[t objectForKey:@"location"];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *s = [self.sections objectAtIndex:section];
    NSDate *dstart = [inDateFormatter dateFromString:s];
    NSString *x = [outDateFormatter stringFromDate:dstart];
    return x; //[self.sections objectAtIndex:section];
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
}

- (IBAction)gotoAngelsCalendar:(id)sender
{    
    DLog(@"gotoAngelsCalendar");
    WebViewController *web = [[WebViewController alloc] init];
    
//    UINavigationController *cntrol = [[UINavigationController alloc] initWithRootViewController:web];
//    [self presentViewController:cntrol animated:YES completion:nil];
    [self.navigationController pushViewController:web animated:YES];
//    [cntrol release];
    [web release];
    
}
@end
