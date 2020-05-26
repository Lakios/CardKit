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
#import "CardKBinding.h"
#import "ConfirmChoosedCard.h"
#import "CardKBankLogoView.h"

const NSString *CardKApplePayllID = @"applePay";
const NSString *CardKSavedCardsCellID = @"savedCards";
const NSString *CardKPayCardButtonCellID = @"button";
const NSString *CardKKindPayRows = @"rows";

@implementation CardKKindPaymentViewController {
  UIButton *_button;
  NSBundle *_bundle;
  NSBundle *_languageBundle;
  NSArray *_sections;
  CardKBankLogoView *_bankLogoView;
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
    
    _bankLogoView = [[CardKBankLogoView alloc] init];
    _bankLogoView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _bankLogoView.title = NSLocalizedStringFromTableInBundle(@"title", nil, _languageBundle, @"Title");
  }
  return self;
}

- (void)_buttonPressed:(UIButton *)button {
  CardKViewController *controller = [[CardKViewController alloc] init];
  controller.cKitDelegate = _cKitDelegate;
  
  [self.navigationController pushViewController:controller animated:YES];
}

- (NSArray *)_defaultSections {
  return @[
    @{CardKKindPayRows: @[@{CardKApplePayllID: @[]}]},
    @{CardKKindPayRows: @[@{CardKPayCardButtonCellID: @[]}]},
    @{CardKKindPayRows: @[@{CardKSavedCardsCellID: CardKConfig.shared.bindings}] },
  ];
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
  
  _bankLogoView.frame = CGRectMake(self.view.bounds.size.width * 2, 0, 0, 0);
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
  NSArray *keys = [_sections[section][CardKKindPayRows][0] allKeys];
  NSString *keyName = keys[0];
  NSArray *test = _sections[section][CardKKindPayRows][0][keyName];
  
  return [test count] == 0 ? 1 : [test count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *cellID = [_sections[indexPath.section][CardKKindPayRows][0] allKeys][0];
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellID forIndexPath:indexPath];

  if ([CardKApplePayllID isEqual:cellID]) {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    [cell addSubview:label];
    label.text = [NSString stringWithFormat:@"index = %ld", (long)indexPath.section];
  } else if([CardKSavedCardsCellID isEqual:cellID]) {
    CardKBinding *cardKBinding = _sections[indexPath.section][CardKKindPayRows][0][CardKSavedCardsCellID][indexPath.row];
    
    [cell addSubview:cardKBinding];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *cellID = [_sections[indexPath.section][CardKKindPayRows][0] allKeys][0];
  
  if ([CardKSavedCardsCellID isEqual:cellID]) {
    ConfirmChoosedCard *confirmChoosedCard = [[ConfirmChoosedCard alloc] init];
    CardKBinding *cardKBinding = [[CardKBinding alloc] init];
    CardKBinding *selectedCardBinding = _sections[indexPath.section][CardKKindPayRows][0][CardKSavedCardsCellID][indexPath.row];
    
    cardKBinding.bindingId = selectedCardBinding.bindingId;
    cardKBinding.paymentSystem = selectedCardBinding.paymentSystem;
    cardKBinding.cardNumber = selectedCardBinding.cardNumber;
       
    confirmChoosedCard.cardKBinding = cardKBinding;
    confirmChoosedCard.bankLogoView = _bankLogoView;
    
    [self.navigationController pushViewController:confirmChoosedCard animated:true];
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  return section == 0 ? 34 : 38;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
  return section == 0 ? 34 : 38;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *cellID = [_sections[indexPath.section][CardKKindPayRows][0] allKeys][0];
  
  return [CardKSavedCardsCellID isEqual:cellID];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
  return NO;
}

@end
