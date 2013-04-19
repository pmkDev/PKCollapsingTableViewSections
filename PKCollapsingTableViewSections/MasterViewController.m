//
//  MasterViewController.m
//  PKCollapsingTableViewSections
//
//  Created by phil koulen on 07.03.13.
//  Copyright (c) 2013 phil koulen. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"

@interface MasterViewController () {
    NSMutableArray      *sectionTitleArray;
    NSMutableDictionary *sectionContentDict;
    NSMutableArray      *arrayForBool;
}
@end

@implementation MasterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Master", @"Master");
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            self.clearsSelectionOnViewWillAppear = NO;
            self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
        }
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    if (!sectionTitleArray) {
        sectionTitleArray = [NSMutableArray arrayWithObjects:@"Aachen", @"Berlin", @"Düren", @"Essen", @"Münster", nil];
    }
    if (!arrayForBool) {
        arrayForBool    = [NSMutableArray arrayWithObjects:[NSNumber numberWithBool:NO],
                           [NSNumber numberWithBool:NO],
                           [NSNumber numberWithBool:NO],
                           [NSNumber numberWithBool:NO],
                               [NSNumber numberWithBool:NO] , nil];
    }
    if (!sectionContentDict) {
        sectionContentDict  = [[NSMutableDictionary alloc] init];
        NSArray *array1     = [NSArray arrayWithObjects:@"bla 1", @"bla 2", @"bla 3", @"bla 4", nil];
        [sectionContentDict setValue:array1 forKey:[sectionTitleArray objectAtIndex:0]];
        NSArray *array2     = [NSArray arrayWithObjects:@"wurst 1", @"käse 2", @"keks 3", nil];
        [sectionContentDict setValue:array2 forKey:[sectionTitleArray objectAtIndex:1]];
        NSArray *array3     = [NSArray arrayWithObjects:@"banane", @"auto2", @"haus", @"eidechse", nil];
        [sectionContentDict setValue:array3 forKey:[sectionTitleArray objectAtIndex:2]];
        NSArray *array4     = [NSArray arrayWithObjects:@"hoden", @"pute", @"eimer", @"wichtel", @"karl", @"dreirad", nil];
        [sectionContentDict setValue:array4 forKey:[sectionTitleArray objectAtIndex:3]];
        NSArray *array5     = [NSArray arrayWithObjects:@"Ei", @"kanone", nil];
        [sectionContentDict setValue:array5 forKey:[sectionTitleArray objectAtIndex:4]];
    }
}





#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [sectionTitleArray count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([[arrayForBool objectAtIndex:section] boolValue]) {
        return [[sectionContentDict valueForKey:[sectionTitleArray objectAtIndex:section]] count];
    }
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView              = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    headerView.tag                  = section;
    headerView.backgroundColor      = [UIColor whiteColor];
    UILabel *headerString           = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-20-50, 50)];
    BOOL manyCells                  = [[arrayForBool objectAtIndex:section] boolValue];
    if (!manyCells) {
        headerString.text = @"click to enlarge";
    }else{
        headerString.text = @"click again to reduce";
    }
    headerString.textAlignment      = NSTextAlignmentLeft;
    headerString.textColor          = [UIColor blackColor];
    [headerView addSubview:headerString];
    
    UITapGestureRecognizer  *headerTapped   = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionHeaderTapped:)];
    [headerView addGestureRecognizer:headerTapped];
    
    //up or down arrow depending on the bool
    UIImageView *upDownArrow        = [[UIImageView alloc] initWithImage:manyCells ? [UIImage imageNamed:@"upArrowBlack"] : [UIImage imageNamed:@"downArrowBlack"]];
    upDownArrow.autoresizingMask    = UIViewAutoresizingFlexibleLeftMargin;
    upDownArrow.frame               = CGRectMake(self.view.frame.size.width-40, 10, 30, 30);
    [headerView addSubview:upDownArrow];
    
    return headerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footer  = [[UIView alloc] initWithFrame:CGRectZero];
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[arrayForBool objectAtIndex:indexPath.section] boolValue]) {
        return 50;
    }
    return 1;
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    BOOL manyCells  = [[arrayForBool objectAtIndex:indexPath.section] boolValue];
    if (!manyCells) {
        cell.textLabel.text = @"click to enlarge";
    }
    else{
        NSArray *content = [sectionContentDict valueForKey:[sectionTitleArray objectAtIndex:indexPath.section]];
        cell.textLabel.text = [content objectAtIndex:indexPath.row];
    }
    

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    DetailViewController *dvc;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        dvc = [[DetailViewController alloc] initWithNibName:@"DetailViewController_iPhone"  bundle:[NSBundle mainBundle]];
    }else{
        dvc = [[DetailViewController alloc] initWithNibName:@"DetailViewController_iPad"  bundle:[NSBundle mainBundle]];
    }
    dvc.title        = [sectionTitleArray objectAtIndex:indexPath.section];
    dvc.detailItem   = [[sectionContentDict valueForKey:[sectionTitleArray objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:dvc animated:YES];
    
}


#pragma mark - gesture tapped
- (void)sectionHeaderTapped:(UITapGestureRecognizer *)gestureRecognizer{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:gestureRecognizer.view.tag];
    if (indexPath.row == 0) {
        BOOL collapsed  = [[arrayForBool objectAtIndex:indexPath.section] boolValue];
        collapsed       = !collapsed;
        [arrayForBool replaceObjectAtIndex:indexPath.section withObject:[NSNumber numberWithBool:collapsed]];
        
        //reload specific section animated
        NSRange range   = NSMakeRange(indexPath.section, 1);
        NSIndexSet *sectionToReload = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.tableView reloadSections:sectionToReload withRowAnimation:UITableViewRowAnimationFade];
    }
}

@end












