//
//  Coach3MoreInfoViewController.h
//  Angels2011aws
//
//  Created by Glenn Kronschnabl on 2/26/12.
//  Copyright (c) 2012 CoreLogic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Coach.h"

@interface Coach3MoreInfoViewController :  UIViewController  {
    
//}<UITableViewDelegate, UITableViewDataSource> {
    
    Coach *coach;
    
    IBOutlet UILabel *name;
    IBOutlet UITableView *table2;
    IBOutlet UIActivityIndicatorView *spinner;
}

@property (retain, nonatomic) Coach *coach;

@end
