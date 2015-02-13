//
//  XFAWithTableVC.m
//  xflowapp
//
//  Created by Mohammed Tillawy on 2/13/15.
//  Copyright (c) 2015 Mohammed O. Tillawy. All rights reserved.
//

#import "XFAWithTableVC.h"

@interface XFAWithTableVC ()

@end

@implementation XFAWithTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = [NSString stringWithFormat:@"row for indexPath:(%ld,%ld)",(long)indexPath.section,(long)indexPath.row];
    return cell;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.height, 20)];
    label.text = [NSString stringWithFormat:@"section:(%ld)",(long)section];
    label.backgroundColor = [UIColor lightGrayColor];
    label.textColor = [UIColor darkGrayColor];
    return label;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString  * msg = [NSString stringWithFormat:@"selected row at indexPath:(%ld,%ld)",(long)indexPath.section,(long)indexPath.row];
    UIAlertView * av = [[UIAlertView alloc] initWithTitle:@"TITLE" message:msg delegate:self cancelButtonTitle:@"CANCEL" otherButtonTitles:nil, nil];
    [av show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%s alertView clickedButtonAtIndex:%ld",__PRETTY_FUNCTION__, buttonIndex);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
