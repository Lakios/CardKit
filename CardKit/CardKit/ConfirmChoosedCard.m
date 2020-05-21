//
//  UITableViewController+ConfirmChoosedCard.m
//  CardKit
//
//  Created by Alex Korotkov on 5/21/20.
//  Copyright © 2020 AnjLab. All rights reserved.
//

#import "ConfirmChoosedCard.h"
#import "CardKConfig.h"
#import "CardKBinding.h"


const NSString *CardKSavedCardCellID = @"savedCard";
const NSString *CardKSecureCodeCellID = @"secureCode";
const NSString *CardKBindingButtonCellID = @"button";
const NSString *CardKConfirmChoosedCardRows = @"rows";

@implementation ConfirmChoosedCard {
  UIButton *_button;
  NSBundle *_bundle;
  NSBundle *_languageBundle;
  NSMutableArray *_sections;
}
- (instancetype)init {
  self = [super initWithStyle:UITableViewStyleGrouped];

  if (self) {
    _button =  [UIButton buttonWithType:UIButtonTypeSystem];

    _bundle = [NSBundle bundleForClass:[ConfirmChoosedCard class]];
     
     NSString *language = CardKConfig.shared.language;

     if (language != nil) {
       _languageBundle = [NSBundle bundleWithPath:[_bundle pathForResource:language ofType:@"lproj"]];
     } else {
       _languageBundle = _bundle;
     }

    [_button
      setTitle: NSLocalizedStringFromTableInBundle(@"Pay", nil, _languageBundle,  @"Pay")
      forState: UIControlStateNormal];

    [_button addTarget:self action:@selector(_buttonPressed:)
    forControlEvents:UIControlEventTouchUpInside];

    _sections = [self _defaultSections];
  }
  return self;
}

- (void)_buttonPressed:(UIButton *)button {
}

- (NSMutableArray *)_defaultSections {
  NSMutableArray *defaultSections = [[NSMutableArray alloc] initWithArray: @[
    @{CardKConfirmChoosedCardRows: @[CardKSavedCardCellID]},
    @{CardKConfirmChoosedCardRows: @[CardKBindingButtonCellID] },
  ] copyItems:YES];
  
  if (CardKConfig.shared.bindingCVCRequired) {
    [defaultSections insertObject:@{CardKConfirmChoosedCardRows: @[CardKSecureCodeCellID]} atIndex:1];
  }
  
  return defaultSections;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  for (NSString *cellID in @[CardKSavedCardCellID, CardKSecureCodeCellID, CardKBindingButtonCellID]) {
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
  return  [_sections[section][CardKConfirmChoosedCardRows] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *cellID = _sections[indexPath.section][CardKConfirmChoosedCardRows][indexPath.row];
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellID forIndexPath:indexPath];

  if ([CardKSavedCardCellID isEqual:cellID]) {
    CardKBinding *cardKBinding = [[CardKBinding alloc] init];
    
    [cell addSubview:cardKBinding];

    cardKBinding.bindingId = @"bindingId";
    cardKBinding.systemProvider = @"MIR";
    cardKBinding.cardNumber = @"5555";
  } else if([CardKSecureCodeCellID isEqual:cellID]) {
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"CVC";
    
    [cell addSubview:label];
  } else if ([CardKBindingButtonCellID isEqual:cellID]) {
    [cell addSubview:_button];
  }
   
  CardKTheme *theme = CardKConfig.shared.theme;
  if (theme.colorCellBackground != nil) {
   cell.backgroundColor = theme.colorCellBackground;
  }

  cell.textLabel.textColor = theme.colorLabel;
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
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
