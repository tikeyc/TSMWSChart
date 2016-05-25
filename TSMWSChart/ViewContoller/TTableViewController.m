//
//  TTableViewController.m
//  test
//
//  Created by ways on 16/4/14.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import "TTableViewController.h"

#import "WSChinaMapViewController.h"


#import "CoverFlow1ViewController.h"
#import "CoverFlow2ViewController.h"

@interface TTableViewController ()

@end

@implementation TTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 5;
    }else if (section == 1){
        return 1;
    }else{
        return 2;
    }
    
}

/**/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:111];
    
    if (indexPath.section == 0) {
        label.text = [NSString stringWithFormat:@"Chart %ld",(long)indexPath.row + 1];
    }else if (indexPath.section == 1){
        label.text = [NSString stringWithFormat:@"Chart %ld",(long)indexPath.row + 1];
    }else if (indexPath.section == 2){
        label.text = [NSString stringWithFormat:@"CoverFlow %ld",(long)indexPath.row + 1];
    }
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *identifier;
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                //            [self performSegueWithIdentifier:@"TChart1ViewController" sender:nil];
                identifier = @"TChart1ViewController";
            }
                break;
            case 1:
            {
                identifier = @"TChart2ViewController";
            }
                break;
            case 2:
            {
                identifier = @"TChart3ViewController";
            }
                break;
            case 3:
            {
                identifier = @"TChart4ViewController";
            }
                break;
            case 4:
            {
                identifier = @"TChart5ViewController";
            }
                break;
                
            default:
                break;
        }
        
        
        
    
    }else if (indexPath.section == 1){
        switch (indexPath.row) {
            case 0:
            {
                WSChinaMapViewController *chinaMap = [[WSChinaMapViewController alloc] init];
                [self.navigationController pushViewController:chinaMap animated:YES];
            }
                break;
            
                
            default:
                break;
        }

    }else if (indexPath.section == 2){
        
        switch (indexPath.row) {
            
                case 0:
            {
                identifier = @"CoverFlow1ViewController";
            }
                break;
            case 1:
            {
                identifier = @"CoverFlow2ViewController";
            }
                break;
                
            default:
                break;
        }
        
        
    }
    
    
    
    // ////////////////////
    if (identifier) {
        UIStoryboard *stroyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        UIViewController *vc = [stroyBoard instantiateViewControllerWithIdentifier:identifier];
        [self.navigationController pushViewController:vc animated:YES];
    }
    

    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"TChart1ViewController"]) {
        
    }
}

@end
