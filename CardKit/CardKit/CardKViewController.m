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
#import "CardKConfig.h"
#import "CardKSwitchView.h"

const NSString *CardKCardCellID = @"card";
const NSString *CardKOwnerCellID = @"owner";
const NSString *CardKSwitchCellID = @"switch";
const NSString *CardKButtonCellID = @"button";
const NSString *CardKRows = @"rows";
const NSString *CardKSectionTitle = @"title";
NSString *CardKFooterID = @"footer";

NSString *CardKProdKey = @"-----BEGIN PUBLIC KEY-----MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAoIITqh9xlGx4tWA+aucb0V0YuFC9aXzJb0epdioSkq3qzNdRSZIxe/dHqcbMN2SyhzvN6MRVl3xyjGAV+lwk8poD4BRW3VwPUkT8xG/P/YLzi5N8lY6ILlfw6WCtRPK5bKGGnERcX5dqL60LhOPRDSYT5NHbbp/J2eFWyLigdU9Sq7jvz9ixOLh6xD7pgNgHtnOJ3Cw0Gqy03r3+m3+CBZwrzcp7ZFs41bit7/t1nIqgx78BCTPugap88Gs+8ZjdfDvuDM+/3EwwK0UVTj0SQOv0E5KcEHENL9QQg3ujmEi+zAavulPqXH5907q21lwQeemzkTJH4o2RCCVeYO+YrQIDAQAB-----END PUBLIC KEY-----";
NSString *CardKTestKey = @"-----BEGIN PUBLIC KEY-----MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAhjH8R0jfvvEJwAHRhJi2Q4fLi1p2z10PaDMIhHbD3fp4OqypWaE7p6n6EHig9qnwC/4U7hCiOCqY6uYtgEoDHfbNA87/X0jV8UI522WjQH7Rgkmgk35r75G5m4cYeF6OvCHmAJ9ltaFsLBdr+pK6vKz/3AzwAc/5a6QcO/vR3PHnhE/qU2FOU3Vd8OYN2qcw4TFvitXY2H6YdTNF4YmlFtj4CqQoPL1u/uI0UpsG3/epWMOk44FBlXoZ7KNmJU29xbuiNEm1SWRJS2URMcUxAdUfhzQ2+Z4F0eSo2/cxwlkNA+gZcXnLbEWIfYYvASKpdXBIzgncMBro424z/KUr3QIDAQAB-----END PUBLIC KEY-----";

@interface ScanViewWrapper: UIView

@property UIButton *backButton;

@end

@implementation ScanViewWrapper {
  UIView *_clippingView;
  UIView *_scanView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    _clippingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    _clippingView.clipsToBounds = YES;
    _clippingView.autoresizesSubviews = NO;
    _backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self addSubview:_clippingView];
    [self addSubview:_backButton];
  }
  return self;
}

-(void)layoutSubviews {
  [super layoutSubviews];
  
  _clippingView.frame = self.bounds;
  _scanView.frame = self.bounds;
  [_scanView layoutSubviews];
  
  if (self.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiomPhone && _clippingView.frame.size.height > _clippingView.frame.size.width) {
    _clippingView.frame = CGRectMake(0, 0, _clippingView.frame.size.width, 300);
  }
  _scanView.center = CGPointMake(_clippingView.bounds.size.width * 0.5, _clippingView.bounds.size.height * 0.5);
  _backButton.frame = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, 44);
  if (@available(iOS 11.0, *)) {
    if (self.safeAreaInsets.bottom > 0) {
      _backButton.center = CGPointMake(_backButton.center.x, _backButton.center.y - 72 - self.safeAreaInsets.bottom);
    } else {
      _backButton.center = CGPointMake(_backButton.center.x, _backButton.center.y - 62);
    }
  } else {
    _backButton.center = CGPointMake(_backButton.center.x, _backButton.center.y - 62);
  }
}

-(void)setScanView:(UIView *)scanView {
  _scanView = scanView;
  [_clippingView addSubview:scanView];
}


@end


@implementation CardKViewController {
  NSString *_pubKey;

  NSString *_mdOrder;
  BOOL _isTestMod;
  BOOL _allowSaveBindings;
  
  ScanViewWrapper *_scanViewWrapper;
  
  CardKBankLogoView *_bankLogoView;
  
  CardKTextField *_ownerTextField;
  CardKCardView *_cardView;
  UIButton *_doneButton;
  NSMutableArray *_sections;
  CardKFooterView *_cardFooterView;
  CardKFooterView *_ownerFooterView;
  NSBundle *_bundle;
  NSBundle *_languageBundle;
  NSString *_lastAnouncment;
  NSMutableArray *_ownerErrors;
  CardKSwitchView *_switchView;
}

- (instancetype)initWithMdOrder:(NSString *)mdOrder {
  if (self = [super initWithStyle:UITableViewStyleGrouped]) {
    _bundle = [NSBundle bundleForClass:[CardKViewController class]];
    
    NSString *language = CardKConfig.shared.language;
    if (language != nil) {
      _languageBundle = [NSBundle bundleWithPath:[_bundle pathForResource:language ofType:@"lproj"]];
    } else {
      _languageBundle = _bundle;
    }
    
    _pubKey = CardKProdKey;

    _mdOrder = mdOrder;
    
    _ownerErrors = [[NSMutableArray alloc] init];

    _bankLogoView = [[CardKBankLogoView alloc] init];
    _bankLogoView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _bankLogoView.title = NSLocalizedStringFromTableInBundle(@"title", nil, _languageBundle, @"Title");
    
    _cardView = [[CardKCardView alloc] init];
    [_cardView addTarget:self action:@selector(_cardChanged) forControlEvents:UIControlEventValueChanged];
    [_cardView addTarget:self action:@selector(_switchToOwner) forControlEvents:UIControlEventEditingDidEndOnExit];
    [_cardView.scanCardTapRecognizer addTarget:self action:@selector(_scanCard:)];

    _ownerTextField = [[CardKTextField alloc] init];
    _ownerTextField.placeholder = NSLocalizedStringFromTableInBundle(@"cardholderPlaceholder", nil, _languageBundle, @"Card holde placeholder");
    [_ownerTextField addTarget:self action:@selector(_clearOwnerError) forControlEvents:UIControlEventEditingDidBegin];
    [_ownerTextField addTarget:self action:@selector(_clearOwnerError) forControlEvents:UIControlEventValueChanged];
    [_ownerTextField addTarget:self action:@selector(_buttonPressed:) forControlEvents:UIControlEventEditingDidEndOnExit];
    _ownerTextField.stripRegexp = @"[^a-zA-Z' .]";
    _ownerTextField.keyboardType = UIKeyboardTypeASCIICapable;
    _ownerTextField.returnKeyType = UIReturnKeyContinue;
    
    _doneButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_doneButton
      setTitle: NSLocalizedStringFromTableInBundle(@"doneButton", nil, _languageBundle, "Submit payment button")
      forState: UIControlStateNormal];
    _doneButton.frame = CGRectMake(0, 0, 200, 44);
    
    [_doneButton addTarget:self action:@selector(_buttonPressed:)
    forControlEvents:UIControlEventTouchUpInside];
  
    _switchView = [[CardKSwitchView alloc] init];

    _sections = [self _defaultSections];
  }
  
  return self;
}

- (NSMutableArray *)_defaultSections {
  NSArray *sections = @[
    @{CardKSectionTitle: NSLocalizedStringFromTableInBundle(@"card", nil, _languageBundle, @"Card section title"), CardKRows: @[CardKCardCellID]},
    @{CardKSectionTitle: NSLocalizedStringFromTableInBundle(@"cardholder", nil, _languageBundle, @"Cardholder section title"), CardKRows: @[CardKOwnerCellID]},
    @{CardKRows: @[CardKButtonCellID]},
  ];
  
  NSMutableArray *defaultSections = [[NSMutableArray alloc] initWithCapacity:3];
  
  [defaultSections setArray:sections];

  return defaultSections;
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

- (void)setAllowSaveBindings:(BOOL)allowSaveBindings {
  if (allowSaveBindings) {
    [_sections insertObject:@{CardKRows: @[CardKSwitchCellID]} atIndex:2];
  }
  _allowSaveBindings = allowSaveBindings;
}

- (BOOL) allowSaveBindings {
  return _allowSaveBindings;
}

- (void)_cardChanged {
  NSString *number = _cardView.number;
  [_bankLogoView showNumber:number];
  [self _refreshErrors];
}

- (BOOL)isTestMod {
  return _isTestMod;
}

- (void)setIsTestMod:(BOOL)isTestMod {
  _isTestMod = isTestMod;
  
  if (isTestMod) {
    _pubKey = CardKTestKey;
  }
}

- (void)fetchKeys {
  NSString *prodURL = @"https://securepayments.sberbank.ru/payment/se/keys.do";
  NSString *testURL = @"https://3dsec.sberbank.ru/payment/se/keys.do";
  NSMutableString *URL = [[NSMutableString alloc] initWithString:prodURL];
  if (_isTestMod) {
    [URL setString:testURL];
  };

  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:URL]];

  NSURLSession *session = [NSURLSession sharedSession];
  
  NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
      NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
      if(httpResponse.statusCode == 200)
      {
        NSError *parseError = nil;
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
        NSArray *keys = [responseDictionary objectForKey:@"keys"];
        NSDictionary *lastKey = [keys lastObject];
        NSString *keyValue = [lastKey objectForKey:@"keyValue"];

        self->_pubKey = keyValue;
      }
  }];
  [dataTask resume];
}

- (void)viewDidLoad {
  [super viewDidLoad];

  [self fetchKeys];

  CardKTheme *theme = CardKConfig.shared.theme;
  _bankLogoView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 80);

  self.tableView.tableHeaderView = _bankLogoView;
  self.tableView.separatorColor = theme.colorSeparatar;
  self.tableView.backgroundColor = theme.colorTableBackground;
  self.tableView.sectionFooterHeight = UITableViewAutomaticDimension;
  self.tableView.cellLayoutMarginsFollowReadableWidth = YES;
  
  _doneButton.tintColor = theme.colorButtonText;
      
  for (NSString *cellID in @[CardKCardCellID, CardKOwnerCellID, CardKButtonCellID, CardKSwitchCellID]) {
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
  }
  
  [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:CardKFooterID];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (self.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiomPad) {
    CGRect r = tableView.readableContentGuide.layoutFrame;
    cell.contentView.subviews.firstObject.frame = CGRectMake(r.origin.x, 0, r.size.width, cell.contentView.bounds.size.height);
  }
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(nonnull UIView *)view forSection:(NSInteger)section {
  if (self.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiomPad) {
    CGRect r = tableView.readableContentGuide.layoutFrame;
    UITableViewHeaderFooterView * v = (UITableViewHeaderFooterView *)view;
    v.contentView.subviews.firstObject.frame = CGRectMake(r.origin.x, 0, r.size.width, v.contentView.bounds.size.height);
  }
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
  [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
  if (self.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiomPad) {
    [self.tableView reloadData];
  }
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
  
  CardKTheme *theme = CardKConfig.shared.theme;
  
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
  } else if ([CardKSwitchCellID isEqual:cellID]) {
    _switchView.frame = cell.contentView.bounds;
    cell.accessoryView = [_switchView getSwitch];
    [cell addSubview:_switchView];
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
      _cardFooterView = [[CardKFooterView alloc] initWithFrame:view.contentView.bounds];
    }
    _cardFooterView.errorMessages = _cardView.errorMessages;

    [view.contentView addSubview:_cardFooterView];
  } else if (section == 1) {
    if (_ownerFooterView == nil) {
      _ownerFooterView = [[CardKFooterView alloc] initWithFrame:view.contentView.bounds];
    }
    
    _ownerFooterView = [[CardKFooterView alloc] initWithFrame:view.contentView.bounds];
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
  NSString *incorrectCardholder = NSLocalizedStringFromTableInBundle(@"incorrectCardholder", nil, _languageBundle, @"incorrectCardholder");
  
  NSString *owner = [_ownerTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  NSInteger len = owner.length;
  if (len == 0 || len > 40) {
    _ownerTextField.showError = YES;
    [_ownerErrors addObject:incorrectCardholder];
  } else {
    NSString *str = [owner stringByReplacingOccurrencesOfString:_ownerTextField.stripRegexp withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, owner.length)];
    if (![str isEqual:owner]) {
      _ownerTextField.showError = YES;
      [_ownerErrors addObject:incorrectCardholder];
    }
  }
  
  [self _refreshErrors];
}

- (void)_refreshErrors {
  _cardFooterView.errorMessages = _cardView.errorMessages;
  _ownerFooterView.errorMessages = _ownerErrors;
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

- (void)_scanCard:(UITapGestureRecognizer *)gestureRecognizer {
  if (_cardView.allowedCardScaner && _cardView.number.length != 0) {
    return;
  }
  
  [_cardView resignFirstResponder];
  [_ownerTextField resignFirstResponder];
  
  [_cKitDelegate cardKitViewControllerScanCardRequest:self];
}

- (void)setCardNumber:(nullable NSString *)number holderName:(nullable NSString *)holderName expirationDate:(nullable NSString *)date cvc:(nullable NSString *)cvc {
  if (number.length > 0) {
    _cardView.number = number;
  }
  if (holderName.length > 0) {
    _ownerTextField.text = holderName;
  }
  
  if (date.length > 0) {
    _cardView.expirationDate = date;
  }
  
  if (cvc.length > 0) {
    _cardView.secureCode = cvc;
  }
  
  [_scanViewWrapper removeFromSuperview];
}

- (void)showScanCardView:(UIView *)view animated:(BOOL)animated {
  CardKTheme *theme = CardKConfig.shared.theme;
  
  _scanViewWrapper = [[ScanViewWrapper alloc] initWithFrame:self.view.bounds];
  _scanViewWrapper.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  _scanViewWrapper.backgroundColor = theme.colorTableBackground;
  _scanViewWrapper.scanView = view;
  [_scanViewWrapper.backButton
    setTitle: NSLocalizedStringFromTableInBundle(@"scanBackButton", nil, _languageBundle, "scanBackButton")
    forState:UIControlStateNormal
  ];
  
  [_scanViewWrapper.backButton addTarget:self action:@selector(_cancelScan) forControlEvents:UIControlEventTouchUpInside];
  
  _scanViewWrapper.alpha = 0;
  [self.view addSubview:_scanViewWrapper];
  
  [UIView animateWithDuration:0.4 animations:^{
    self->_scanViewWrapper.alpha = 1;
  }];
}

- (void)_cancelScan {
  _scanViewWrapper.alpha = 1;
  [UIView animateWithDuration:0.3 animations:^{
    self->_scanViewWrapper.alpha = 0;
  } completion:^(BOOL finished) {
    [self->_scanViewWrapper removeFromSuperview];
    self->_scanViewWrapper = nil;
  }];
}


@end
