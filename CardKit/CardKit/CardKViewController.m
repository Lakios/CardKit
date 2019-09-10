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
#import "CardKBankLogoView.h"

const NSString *CardKCardCellID = @"card";
const NSString *CardKOwnerCellID = @"owner";
const NSString *CardKButtonCellID = @"button";

@interface CardKViewController ()

@end

@implementation CardKViewController {
  NSString *_pubKey;
  NSString *_mdOrder;
  
  CardKBankLogoView *_bankLogoView;
  
  CardKTheme *_theme;
  CardKTextField *_ownerTextField;
  CardKCardView *_cardView;
  UIButton *_doneButton;
  NSArray *_sections;
}

- (instancetype)initWithPublicKey:(NSString *)pubKey mdOrder:(NSString *)mdOrder {
  if (self = [super initWithStyle:UITableViewStyleGrouped]) {
    _pubKey = pubKey;
    _mdOrder = mdOrder;
    _theme = [CardKTheme shared];

    self.tableView.separatorColor = _theme.separatarColor;
    self.tableView.backgroundColor = _theme.colorTableBackground;
    
    _bankLogoView = [[CardKBankLogoView alloc] init];
    _bankLogoView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    
    _cardView = [[CardKCardView alloc] init];
    
    [_cardView addTarget:self action:@selector(_cardChanged) forControlEvents:UIControlEventValueChanged];
    
    _ownerTextField = [[CardKTextField alloc] init];
    _ownerTextField.placeholder = @"CARD OWNER";
    
    _doneButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_doneButton setTitle:@"Purchase" forState:UIControlStateNormal];
    _doneButton.frame = CGRectMake(0, 0, 200, 44);
    
    _sections = @[
      @{@"title": @"Card", @"rows": @[CardKCardCellID] },
      @{@"title": @"Owner", @"rows": @[CardKOwnerCellID] },
      @{@"rows": @[CardKButtonCellID] },
    ];
  }
  
  return self;
}

- (CardKTheme *)theme {
  return _theme;
}

- (void)setTheme:(CardKTheme *)theme {
  _theme = theme;
}

- (void)_cardChanged {
  NSString * number = _cardView.number;
  [_bankLogoView showNumber:number];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  _bankLogoView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 80);
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
    [cell addSubview:_doneButton];
  }
  
  cell.backgroundColor = _theme.colorCellBackground;
  cell.textLabel.textColor = _theme.colorLabel;
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  return section == 0 ? 34 : 38;
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

- (NSString *)purchaseButtonTitle {
  return _doneButton.currentTitle;
}

- (void)setPurchaseButtonTitle:(NSString *)purchaseButtonTitle {
  [_doneButton setTitle:purchaseButtonTitle forState:UIControlStateNormal];
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  
  CGRect bounds = _doneButton.superview.bounds;
  _doneButton.center = CGPointMake(bounds.size.width * 0.5, bounds.size.height * 0.5);
}


@end
