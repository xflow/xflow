//
//  MTTableTVC.m
//  POCHostClient
//
//  Created by Mohammed Tillawy on 1/2/14.
//  Copyright (c) 2014 Mohammed O. Tillawy. All rights reserved.
//

#import "XFATableTVC.h"

@implementation XFATableTVC
/*
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self dummyMethod:1];
}
 */
-(void)dummyMethod:(NSInteger)i{
    NSLog(@"dummyMethod:%d",i);
    
    [self.tableView indexPathForSelectedRow];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@",indexPath);
    if (indexPath.section == 1){
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"MTDummy2VC"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}

-(IBAction)actionBarButton:(id)sender
{
    [self performSegueWithIdentifier:@"SEGUE" sender:self];
}

/*
- (void)performSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    [super performSegueWithIdentifier:identifier sender:sender];
}
 */

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
//    return [super shouldPerformSegueWithIdentifier:identifier sender:sender];
    return TRUE;
};

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UIViewController * vc = segue.destinationViewController;
    vc.title = [NSString stringWithFormat:@"(%ld,%ld)",
                (long)[self.tableView indexPathForSelectedRow].section,
                (long)[self.tableView indexPathForSelectedRow].row];
//    [super prepareForSegue:segue sender:sender];
}



@end
