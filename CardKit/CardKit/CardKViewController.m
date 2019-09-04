//
//  CKitViewController.m
//  CardKit
//
//  Created by Yury Korolev on 01.09.2019.
//  Copyright © 2019 AnjLab. All rights reserved.
//

#import "CardKViewController.h"
#import "CardKTextField.h"
#import "CardKCardView.h"

const NSString *CardKCardCellID = @"card";
const NSString *CardKOwnerCellID = @"owner";
const NSString *CardKButtonCellID = @"button";

@interface CardKViewController ()

@end

@implementation CardKViewController {
  NSString *_pubKey;
  NSString *_mdOrder;
  
  UIView *_bankLogoView;
  
  CardKTextField *_ownerTextField;
  CardKCardView *_cardView;
  NSArray *_sections;
}

- (instancetype)initWithPublicKey:(NSString *)pubKey mdOrder:(NSString *)mdOrder {
  if (self = [super initWithStyle:UITableViewStyleGrouped]) {
    _pubKey = pubKey;
    _mdOrder = mdOrder;
    _theme = [CardKTheme defaultTheme];
    
    
    _bankLogoView = [[UIView alloc] init];
    _bankLogoView.backgroundColor = [UIColor redColor];
    _bankLogoView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    
    _cardView = [[CardKCardView alloc] init];
    
    _ownerTextField = [[CardKTextField alloc] init];
    _ownerTextField.backgroundColor = UIColor.greenColor;
    
    _sections = @[
      @{@"title": @"Card", @"rows": @[CardKCardCellID] },
      @{@"title": @"Owner", @"rows": @[CardKOwnerCellID] },
      @{@"rows": @[CardKButtonCellID] },
    ];
  }
  
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  _bankLogoView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 120);
  self.tableView.tableHeaderView = _bankLogoView;
  
  for (NSString *cellID in @[CardKCardCellID, CardKOwnerCellID, CardKButtonCellID]) {
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
  }
  
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return _sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [_sections[section][@"rows"] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  return _sections[section][@"title"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  NSString *cellID = _sections[indexPath.section][@"rows"][indexPath.row] ?: @"unknown";
  
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];

  if ([CardKCardCellID isEqual:cellID]) {
    _cardView.frame = cell.contentView.bounds;
    [cell.contentView addSubview:_cardView];
  } else if ([CardKOwnerCellID isEqual:cellID]) {
    _ownerTextField.frame = cell.contentView.bounds;
    [cell.contentView addSubview:_ownerTextField];
  } else if ([CardKButtonCellID isEqual:cellID]) {
    cell.contentView.backgroundColor = UIColor.brownColor;
  }
  return cell;
}


- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
  return NO;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
  return NO;
}


@end
