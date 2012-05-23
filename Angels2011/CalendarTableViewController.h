//
//  CalendarTableViewController.h
//  Angels2011
//
//  Created by Glenn Kronschnabl on 11/13/11.
//  Copyright (c) 2011 Glenn Kronschnabl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> 

@property (retain, nonatomic) NSArray *events;

@end
