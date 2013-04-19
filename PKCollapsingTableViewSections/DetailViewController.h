//
//  DetailViewController.h
//  PKCollapsingTableViewSections
//
//  Created by phil koulen on 07.03.13.
//  Copyright (c) 2013 phil koulen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>{
}

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
