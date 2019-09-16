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
#import "CardKFooterView.h"
#import "RSA.h"

const NSString *CardKCardCellID = @"card";
const NSString *CardKOwnerCellID = @"owner";
const NSString *CardKButtonCellID = @"button";
const NSString *CardKRows = @"rows";
const NSString *CardKSectionTitle = @"title";
NSString *CardKFooterID = @"footer";


@implementation CardKViewController {
  NSString *_pubKey;
  NSString *_mdOrder;
  
  CardKBankLogoView *_bankLogoView;
  
  CardKTextField *_ownerTextField;
  CardKCardView *_cardView;
  UIButton *_doneButton;
  NSArray *_sections;
  CardKFooterView *_cardFooterView;
  CardKFooterView *_ownerFooterView;
  NSBundle *_bundle;
  NSString *_lastAnouncment;
  NSMutableArray *_ownerErrors;
}

- (instancetype)initWithPublicKey:(NSString *)pubKey mdOrder:(NSString *)mdOrder {
  if (self = [super initWithStyle:UITableViewStyleGrouped]) {
    _bundle = [NSBundle bundleForClass:[CardKViewController class]];
    
    _pubKey = pubKey;
    _mdOrder = mdOrder;
    
    _ownerErrors = [[NSMutableArray alloc] init];

    _bankLogoView = [[CardKBankLogoView alloc] init];
    _bankLogoView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _bankLogoView.title = NSLocalizedStringFromTableInBundle(@"title", nil, _bundle, @"Title");
    
    _cardView = [[CardKCardView alloc] init];
    [_cardView addTarget:self action:@selector(_cardChanged) forControlEvents:UIControlEventValueChanged];
    [_cardView addTarget:self action:@selector(_switchToOwner) forControlEvents:UIControlEventEditingDidEndOnExit];

    _ownerTextField = [[CardKTextField alloc] init];
    _ownerTextField.placeholder = NSLocalizedStringFromTableInBundle(@"cardholderPlaceholder", nil, _bundle, @"Card holde placeholder");
    [_ownerTextField addTarget:self action:@selector(_clearOwnerError) forControlEvents:UIControlEventEditingDidBegin];
    [_ownerTextField addTarget:self action:@selector(_clearOwnerError) forControlEvents:UIControlEventValueChanged];
    [_ownerTextField addTarget:self action:@selector(_buttonPressed:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    _ownerTextField.returnKeyType = UIReturnKeyContinue;
    
    _doneButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_doneButton
      setTitle: NSLocalizedStringFromTableInBundle(@"doneButton", nil, _bundle, "Submit payment button")
      forState: UIControlStateNormal];
    _doneButton.frame = CGRectMake(0, 0, 200, 44);
    
    [_doneButton addTarget:self action:@selector(_buttonPressed:)
    forControlEvents:UIControlEventTouchUpInside];
  
    _sections = @[
      @{CardKSectionTitle: NSLocalizedStringFromTableInBundle(@"card", nil, _bundle, @"Card section title"), CardKRows: @[CardKCardCellID] },
      @{CardKSectionTitle: NSLocalizedStringFromTableInBundle(@"cardholder", nil, _bundle, @"Cardholder section title"), CardKRows: @[CardKOwnerCellID] },
      @{CardKRows: @[CardKButtonCellID] },
    ];
  }
  
  return self;
}

- (void)_animateError {
  [_doneButton animateError];
}

- (void)setAllowedCardScaner:(BOOL)allowedCardScaner {
  _cardView.allowedCardScaner = allowedCardScaner;
}

- (BOOL)allowedCardScaner {
  return _cardView.allowedCardScaner;
}


- (void)_cardChanged {
  NSString *number = _cardView.number;
  [_bankLogoView showNumber:number];
  [self _refreshErrors];
}

- (void)viewDidLoad {
  [super viewDidLoad];

  CardKTheme *theme = CardKTheme.shared;
  _bankLogoView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 80);

  self.tableView.tableHeaderView = _bankLogoView;
  self.tableView.separatorColor = theme.separatarColor;
  self.tableView.backgroundColor = theme.colorTableBackground;
  self.tableView.sectionFooterHeight = UITableViewAutomaticDimension;

  for (NSString *cellID in @[CardKCardCellID, CardKOwnerCellID, CardKButtonCellID]) {
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
  }
  
  [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:CardKFooterID];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return _sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [_sections[section][CardKRows] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  return _sections[section][CardKSectionTitle];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  CardKTheme *theme = CardKTheme.shared;
  
  NSString *cellID = _sections[indexPath.section][CardKRows][indexPath.row] ?: @"unknown";
  
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

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
  UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:CardKFooterID];
  if (view == nil) {
    view = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:CardKFooterID];
  }

  if(section == 0) {
    if (_cardFooterView == nil) {
      _cardFooterView = [[CardKFooterView alloc] initWithFrame:view.bounds];
    }
    _cardFooterView.errorMessages = _cardView.errorMessages;

    [view.contentView addSubview:_cardFooterView];
  } else if (section == 1) {
    if (_ownerFooterView == nil) {
      _ownerFooterView = [[CardKFooterView alloc] initWithFrame:view.bounds];
    }
    
    _ownerFooterView = [[CardKFooterView alloc] initWithFrame:view.bounds];
    [view.contentView addSubview:_ownerFooterView];
  }

  return view;
}

- (void)_switchToOwner {
  [_ownerTextField becomeFirstResponder];
  [_cardView resetLeftImage];
}

- (void)_clearOwnerError {
  [_cardView resetLeftImage];
  [_ownerErrors removeAllObjects];
  _ownerTextField.showError = NO;
  [self _refreshErrors];
}

- (void)_validateOwner {
  [_ownerErrors removeAllObjects];
  _ownerTextField.showError = NO;
  NSString *incorrectCardholder = NSLocalizedStringFromTableInBundle(@"incorrectCardholder", nil, _bundle, @"incorrectCardholder");
  
  NSString *owner = [_ownerTextField.text  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  NSInteger len = owner.length;
  if (len == 0 || len > 40) {
    _ownerTextField.showError = YES;
    [_ownerErrors addObject:incorrectCardholder];
  }
  
  [self _refreshErrors];
}

- (void)_refreshErrors {
  [self.tableView beginUpdates];
  _cardFooterView.errorMessages = _cardView.errorMessages;
  _ownerFooterView.errorMessages = _ownerErrors;
  [self.tableView endUpdates];
  
  [self _announceError];
}

- (void)_announceError {
  NSString *errorMessage = [_cardView.errorMessages firstObject] ?: [_ownerErrors firstObject];
  if (errorMessage.length > 0 && ![_lastAnouncment isEqualToString:errorMessage]) {
    _lastAnouncment = errorMessage;
    UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, _lastAnouncment);
  }
}

- (BOOL)_isFormValid {
  [_cardView validate];
  [self _validateOwner];
  [self _refreshErrors];
  return _cardFooterView.errorMessages.count == 0 && _ownerErrors.count == 0;
}

- (void)_buttonPressed:(UIButton *)button {
  [_cardView resetLeftImage];
  if (![self _isFormValid]) {
    [self _animateError];
    _lastAnouncment = nil;
    [self _announceError];
    return;
  }
  
  NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
  NSString *uuid = [[NSUUID UUID] UUIDString];
  NSString *cardNumber = _cardView.number;
  NSString *secureCode = _cardView.secureCode;
  NSString *fullYear = _cardView.getFullYearFromExpirationDate;
  NSString *month = _cardView.getMonthFromExpirationDate;
  NSString *expirationDate = [NSString stringWithFormat:@"%@%@", fullYear, month];
  
  NSString *cardData = [NSString stringWithFormat:@"%f/%@/%@/%@/%@/%@", timeStamp, uuid, cardNumber, secureCode, expirationDate, _mdOrder];

  NSString *seToken = [RSA encryptString:cardData publicKey:_pubKey];
  [_cKitDelegate cardKitViewController:self didCreateSeToken:seToken];
}

@end
