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
#import "CardKTextField.h"
#import "CardKFooterView.h"
#import "CardKValidation.h"

const NSString *CardKSavedCardCellID = @"savedCard";
const NSString *CardKSecureCodeCellID = @"secureCode";
const NSString *CardKBindingButtonCellID = @"button";
const NSString *CardKConfirmChoosedCardRows = @"rows";
NSString *CardKConfirmChoosedCardFooterID = @"footer";

@implementation ConfirmChoosedCard {
  UIButton *_button;
  NSBundle *_bundle;
  NSBundle *_languageBundle;
  NSMutableArray *_sections;
  CardKFooterView *_secureCodeFooterView;
  CardKTextField *_secureCodeTextField;
  NSMutableArray *_secureCodeErrors;
  NSString *_lastAnouncment;
}
- (instancetype)init {
  self = [super initWithStyle:UITableViewStyleGrouped];

  if (self) {
    _button =  [UIButton buttonWithType:UIButtonTypeSystem];

    _bundle = [NSBundle bundleForClass:[ConfirmChoosedCard class]];
     
     NSString *language = CardKConfig.shared.language;

     _secureCodeErrors = [[NSMutableArray alloc] init];
    
     if (language != nil) {
       _languageBundle = [NSBundle bundleWithPath:[_bundle pathForResource:language ofType:@"lproj"]];
     } else {
       _languageBundle = _bundle;
     }
    
    _secureCodeTextField = [[CardKTextField alloc] init];
    _secureCodeTextField.pattern = CardKTextFieldPatternSecureCode;
    _secureCodeTextField.placeholder = NSLocalizedStringFromTableInBundle(@"CVC", nil, _languageBundle, @"CVC placeholder");
    _secureCodeTextField.secureTextEntry = YES;
    _secureCodeTextField.accessibilityLabel = NSLocalizedStringFromTableInBundle(@"cvc", nil, _languageBundle, @"CVC accessibility");
    
    [_secureCodeTextField addTarget:self action:@selector(_clearSecureCodeErrors) forControlEvents:UIControlEventEditingDidBegin];
    [_secureCodeTextField addTarget:self action:@selector(_clearSecureCodeErrors) forControlEvents:UIControlEventValueChanged];
    [_secureCodeTextField addTarget:self action:@selector(_buttonPressed:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    [_button
      setTitle: NSLocalizedStringFromTableInBundle(@"Pay", nil, _languageBundle,  @"Pay")
      forState: UIControlStateNormal];
    [_button addTarget:self action:@selector(_buttonPressed:)
    forControlEvents:UIControlEventTouchUpInside];

    _sections = [self _defaultSections];
  }
  return self;
}

- (void)_refreshErrors {
  _secureCodeFooterView.errorMessages = _secureCodeErrors;
  [self _announceError];
}
- (void)_announceError {
  NSString *errorMessage = [_secureCodeErrors firstObject];
  if (errorMessage.length > 0 && ![_lastAnouncment isEqualToString:errorMessage]) {
    _lastAnouncment = errorMessage;
    UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, _lastAnouncment);
  }
}

- (void)_clearSecureCodeErrors {
  [_secureCodeErrors removeAllObjects];
  _secureCodeTextField.showError = NO;
  [self _refreshErrors];
}

- (void)_validateSecureCode {
  BOOL isValid = YES;
  NSString *secureCode = _secureCodeTextField.text;
  NSString *incorrectCvc = NSLocalizedStringFromTableInBundle(@"incorrectCvc", nil, _languageBundle, @"incorrectCvc");
  [self _clearSecureCodeErrors];
  
  if (![CardKValidation isValidSecureCode:secureCode]) {
    [_secureCodeErrors addObject:incorrectCvc];
    isValid = NO;
  }
  
  _secureCodeTextField.showError = !isValid;
}

- (BOOL)_isFormValid {
  [self _validateSecureCode];
  [self _refreshErrors];
  return _secureCodeErrors.count == 0;
}

- (void)_buttonPressed:(UIButton *)button {
  if ([self _isFormValid]) {
    return;
  }
  
  [self _animateError];
  _lastAnouncment = nil;
  [self _announceError];
  return;
}

- (void)_animateError {
  [_button animateError];
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

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
  UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier: CardKConfirmChoosedCardFooterID];
  if (view == nil) {
    view = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier: CardKConfirmChoosedCardFooterID];
  }

  if (section == 1) {
    if (_secureCodeFooterView == nil) {
      _secureCodeFooterView = [[CardKFooterView alloc] initWithFrame:view.contentView.bounds];
    }
    
    _secureCodeFooterView = [[CardKFooterView alloc] initWithFrame:view.contentView.bounds];
    [view.contentView addSubview:_secureCodeFooterView];
  }
  
  return view;
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
    _secureCodeTextField.frame = cell.contentView.bounds;
    [cell.contentView addSubview:_secureCodeTextField];
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
