//
//  UITableViewController+CardKKindPaymentViewController.m
//  CardKit
//
//  Created by Alex Korotkov on 5/13/20.
//  Copyright © 2020 AnjLab. All rights reserved.
//

#import "CardKKindPaymentViewController.h"
#import "CardKViewController.h"
#import "CardKConfig.h"

const NSString *CardKApplePayllID = @"applePay";
const NSString *CardKSavedCardsCellID = @"savedCards";
const NSString *CardKPayCardButtonCellID = @"button";
const NSString *CardKKindPayRows = @"rows";

@implementation CardKKindPaymentViewController {
  UIButton *_button;
  CardKViewController *_controller;
  NSBundle *_bundle;
  NSBundle *_languageBundle;
  NSArray *_sections;
}

- (instancetype)init {
  self = [super initWithStyle:UITableViewStyleGrouped];

  if (self) {
    _button =  [UIButton buttonWithType:UIButtonTypeSystem];
  
    _bundle = [NSBundle bundleForClass:[CardKViewController class]];
     
     NSString *language = CardKConfig.shared.language;
     if (language != nil) {
       _languageBundle = [NSBundle bundleWithPath:[_bundle pathForResource:language ofType:@"lproj"]];
     } else {
       _languageBundle = _bundle;
     }


    [_button
      setTitle: NSLocalizedStringFromTableInBundle(@"payByCard", nil, _languageBundle,  @"Pay by card")
      forState: UIControlStateNormal];

    [_button addTarget:self action:@selector(_buttonPressed:)
    forControlEvents:UIControlEventTouchUpInside];
    
    _sections = [self _defaultSections];
  }
  return self;
}

- (void)_buttonPressed:(UIButton *)button {
  [self presentViewController:_controller animated:YES completion:nil];
}

- (NSArray *)_defaultSections {
  return @[
    @{CardKKindPayRows: @[CardKApplePayllID]},
    @{CardKKindPayRows: @[CardKSavedCardsCellID]},
    @{CardKKindPayRows: @[CardKPayCardButtonCellID]},
  ];
}
- (void)setController:(CardKViewController *)controller {
  _controller = controller;
  
}

- (CardKViewController *)controller {
  return _controller;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  for (NSString *cellID in @[CardKApplePayllID, CardKSavedCardsCellID, CardKPayCardButtonCellID]) {
   [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
  }
  
  CardKTheme *theme = CardKConfig.shared.theme;
  _button.frame = CGRectMake(0, 0, self.view.bounds.size.width, 40);

  self.tableView.separatorColor = theme.colorSeparatar;
  self.tableView.backgroundColor = theme.colorTableBackground;
  self.tableView.sectionFooterHeight = UITableViewAutomaticDimension;
  self.tableView.cellLayoutMarginsFollowReadableWidth = YES;
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  
  CGRect bounds = _button.superview.bounds;
  _button.center = CGPointMake(bounds.size.width * 0.5, bounds.size.height * 0.5);
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return _sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [_sections[section][CardKKindPayRows] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *cellID = _sections[indexPath.section][CardKKindPayRows][indexPath.row] ?: @"unknown";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];

  if ([CardKApplePayllID isEqual:cellID] || [CardKSavedCardsCellID isEqual:cellID]) {
   UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
   [cell addSubview:label];
   label.text = [NSString stringWithFormat:@"index = %ld", (long)indexPath.section];
  } else if ([CardKPayCardButtonCellID isEqual:cellID]) {
   [cell addSubview:_button];
  }
   
  CardKTheme *theme = CardKConfig.shared.theme;
  if (theme.colorCellBackground != nil) {
   cell.backgroundColor = theme.colorCellBackground;
  }

  cell.textLabel.textColor = theme.colorLabel;
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  return section == 0 ? 34 : 38;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
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

@end
