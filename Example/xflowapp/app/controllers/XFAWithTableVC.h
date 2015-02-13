//
//  XFAWithTableVC.h
//  xflowapp
//
//  Created by Mohammed Tillawy on 2/13/15.
//  Copyright (c) 2015 Mohammed O. Tillawy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XFAWithTableVC : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>


@property (nonatomic,weak) IBOutlet UITableView * theTableView;

@end
