//
//  AllCoachesTableViewController.h
//  Angels2011
//
//  Created by Glenn Kronschnabl on 11/17/11.
//  Copyright (c) 2011 CoreLogic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllCoachesTableViewController : UITableViewController {
    NSArray *sections;
    NSArray *coaches;
}

@property (retain, nonatomic) NSArray *sections;
@property (retain, nonatomic) NSArray *coaches;

@end
