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
  NSBundle *_bundle;
  NSString *_lastAnouncment;
  BOOL _allowedCardScaner;
}

- (instancetype)initWithPublicKey:(NSString *)pubKey mdOrder:(NSString *)mdOrder {
  if (self = [super initWithStyle:UITableViewStyleGrouped]) {
    _bundle = [NSBundle bundleForClass:[CardKViewController class]];
    
    _pubKey = pubKey;
    _mdOrder = mdOrder;

    _bankLogoView = [[CardKBankLogoView alloc] init];
    _bankLogoView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    _cardView = [[CardKCardView alloc] init];
    [_cardView addTarget:self action:@selector(_cardChanged) forControlEvents:UIControlEventValueChanged];
    [_cardView addTarget:self action:@selector(_reloadSectionByIndexPathOfYourCell) forControlEvents:UIControlEventEditingDidEnd];
    
    _ownerTextField = [[CardKTextField alloc] init];
    _ownerTextField.placeholder = NSLocalizedStringFromTableInBundle(@"CARD OWNER", nil, _bundle, @"Card owner placeholder");
    
    _doneButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_doneButton
      setTitle: NSLocalizedStringFromTableInBundle(@"Submit Payment", nil, _bundle, "Submit payment button")
      forState: UIControlStateNormal];
    _doneButton.frame = CGRectMake(0, 0, 200, 44);
    
    [_doneButton addTarget:self action:@selector(buttonPressed:)
    forControlEvents:UIControlEventTouchUpInside];
  
    _sections = @[
      @{CardKSectionTitle: NSLocalizedStringFromTableInBundle(@"Card", nil, _bundle, @"Card section title"), CardKRows: @[CardKCardCellID] },
      @{CardKSectionTitle: NSLocalizedStringFromTableInBundle(@"Cardholder", nil, _bundle, @"Cardholder section title"), CardKRows: @[CardKOwnerCellID] },
      @{CardKRows: @[CardKButtonCellID] },
    ];
  }
  
  return self;
}

- (void)buttonPressed:(UIButton *)button {
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

- (void)setAllowedCardScaner:(BOOL)allowedCardScaner {
  _cardView.allowedCardScaner = allowedCardScaner;
  _allowedCardScaner = allowedCardScaner;
}

- (BOOL)allowedCardScaner {
  return _allowedCardScaner;
}

- (void)_cardChanged {
  NSString *number = _cardView.number;
  [_bankLogoView showNumber:number];
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
    _cardFooterView = [[CardKFooterView alloc] initWithFrame:view.bounds];
    _cardFooterView.errorMessages = _cardView.errorMessages;

    [view.contentView addSubview:_cardFooterView];
  }

  return view;
}

- (void)_reloadSectionByIndexPathOfYourCell {
  [self.tableView beginUpdates];
  _cardFooterView.errorMessages = _cardView.errorMessages;
  [self.tableView endUpdates];
  
  NSString *errorMessage = [_cardView.errorMessages firstObject];
  if (errorMessage.length > 0 && ![_lastAnouncment isEqualToString:errorMessage]) {
    _lastAnouncment = errorMessage;
    UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, _lastAnouncment);
  }
}

@end
