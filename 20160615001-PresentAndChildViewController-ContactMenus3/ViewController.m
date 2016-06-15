//
//  ViewController.m
//  20160615001-PresentAndChildViewController-ContactMenus3
//
//  Created by Rainer on 16/6/15.
//  Copyright © 2016年 Sand. All rights reserved.
//

#import "ViewController.h"
#import "CategoriesModel.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *menuArray;

@property (weak, nonatomic) IBOutlet UITableView *categoryTableView;
@property (weak, nonatomic) IBOutlet UITableView *detailCategoryTableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%@", NSStringFromUIEdgeInsets(self.categoryTableView.contentInset));
    
    self.detailCategoryTableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    
    [self.categoryTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.categoryTableView)
        return self.menuArray.count;
    
    CategoriesModel *detailCategory = self.menuArray[self.categoryTableView.indexPathForSelectedRow.row];
    
    return detailCategory.subcategories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.categoryTableView) {
        static NSString *tableViewCellIdentifier = @"categoriesTableViewCellIdentifier";
        
        UITableViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:tableViewCellIdentifier];
        
        tableViewCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        CategoriesModel *categoriesModel = self.menuArray[indexPath.row];
        
        tableViewCell.imageView.image = [UIImage imageNamed:categoriesModel.icon];
        tableViewCell.imageView.highlightedImage = [UIImage imageNamed:categoriesModel.highlighted_icon];
        tableViewCell.textLabel.text = categoriesModel.name;
        tableViewCell.textLabel.highlightedTextColor = [UIColor colorWithRed:69 / 255.0 green:201 / 255.0 blue:191 / 255.0 alpha:1];
        
        return tableViewCell;
    } else {
        static NSString *tableViewCellIdentifier = @"detailCategoriesTableViewCellIdentifier";
        
        UITableViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:tableViewCellIdentifier];
        
        tableViewCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        CategoriesModel *detailCategory = self.menuArray[self.categoryTableView.indexPathForSelectedRow.row];
        
        NSString *detailName = detailCategory.subcategories[indexPath.row];
        
        tableViewCell.textLabel.text = detailName;
        tableViewCell.textLabel.highlightedTextColor = [UIColor colorWithRed:69 / 255.0 green:201 / 255.0 blue:191 / 255.0 alpha:1];
        
        return tableViewCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.categoryTableView) {
        [self.detailCategoryTableView reloadData];
    }
}

- (NSArray *)menuArray {
    if (nil == _menuArray) {
        NSArray *menuArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"categories" ofType:@"plist"]];
        
        NSMutableArray *menuMutableArray = [NSMutableArray array];
        
        [menuArray enumerateObjectsUsingBlock:^(NSDictionary *dictionary, NSUInteger idx, BOOL *stop) {
            CategoriesModel *categoriesModel = [CategoriesModel categoriesWithDictionary:dictionary];
            
            [menuMutableArray addObject:categoriesModel];
        }];
        
        _menuArray = menuMutableArray;
    }
    
    return _menuArray;
}

@end
