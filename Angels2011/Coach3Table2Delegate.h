//
//  Coach3Table1Delegate.h
//  Angels2011aws
//
//  Created by Glenn Kronschnabl on 2/26/12.
//  Copyright (c) 2012 CoreLogic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Coach.h"

@interface Coach3Table2Delegate : NSObject <UITableViewDelegate, UITableViewDataSource> {

    Coach *coach;
}

@property (retain, nonatomic) Coach *coach;

@end
