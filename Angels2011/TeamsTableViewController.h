//
//  TeamsTableViewController.h
//  Angels2011
//
//  Created by Glenn Kronschnabl on 10/24/11.
//  Copyright 2011 Glenn Kronschnabl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeamsTableViewController : UITableViewController {
    NSArray *sections;
    NSArray *teams;
}

@property (retain, nonatomic) NSArray *sections;
@property (retain, nonatomic) NSArray *teams;

@end
