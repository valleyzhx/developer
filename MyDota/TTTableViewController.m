//
//  TTTableViewController.m
//  MyDota
//
//  Created by Simplan on 14/11/22.
//  Copyright (c) 2014年 Simplan. All rights reserved.
//

#import "TTTableViewController.h"
#import "ChartView.h"
#import "TotalInfoCell.h"
#import "HeroInfoCell.h"

@interface TTTableViewController ()

@end

@implementation TTTableViewController{
    NSMutableArray *heroArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}
-(void)setScoreInfoDic:(NSDictionary *)scoreInfoDic{
    _scoreInfoDic = scoreInfoDic;
    if (heroArr==nil) {
        heroArr = [[NSMutableArray alloc]initWithArray:_scoreInfoDic[@"ratingHeros"]];
    }else{
        heroArr = scoreInfoDic[@"ratingHeros"];
    }
     [self makeSortOfArray:heroArr];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}
-(void)makeSortOfArray:(NSMutableArray*)array{
    NSComparator comparator =^(id obj1, id obj2){
        int a = [obj1[@"score"]intValue];
        int b = [obj2[@"score"]intValue];
        if (a < b) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        if (a > b) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    };
    [array sortUsingComparator:comparator];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section==0) {
        return 2;
    }
    return heroArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return indexPath.row?106:200;
    }
    
    return 56;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        if (indexPath.row == 0) {
         UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"chartView"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            ChartView *view = [[ChartView alloc]initWithArray:_scoreInfoDic[@"heroRoadInfos"]];
            [cell.contentView addSubview:view];
            return cell;
        }else if (indexPath.row == 1){
            TotalInfoCell *infoCell = [[TotalInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"infoCell"];
            [infoCell setCellDataWithData:_totalDic];
            return infoCell;
            
        }
    }
    else{
       HeroInfoCell* cell = [tableView dequeueReusableCellWithIdentifier:@"HeroInfoCell"];
        if (cell==nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"HeroInfoCell" owner:nil options:nil]objectAtIndex:0];
        }
       
        NSDictionary *dic = heroArr[indexPath.row];
        [cell setSocreWithData:dic];
        return cell;
    }
    
    return nil;
    
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

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/


#pragma mark - scrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (_scoreDelegate) {
        [_scoreDelegate detailScrollEnabled:NO];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (_scoreDelegate) {
        [_scoreDelegate detailScrollEnabled:YES];
    }
}

@end
