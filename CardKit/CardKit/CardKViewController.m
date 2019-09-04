//
//  CKitViewController.m
//  CardKit
//
//  Created by Yury Korolev on 01.09.2019.
//  Copyright © 2019 AnjLab. All rights reserved.
//

#import "CardKViewController.h"
#import "BankImageProvider.h"

@interface CardKViewController ()

@end

@implementation CardKViewController {
  NSString *_pubKey;
  NSString *_mdOrder;
  BankImageProvider *_bankImageProvider;
  SVGKImageView *_svgImageView;
}

- (instancetype)initWithPublicKey:(NSString *)pubKey mdOrder:(NSString *)mdOrder {
  if (self = [super initWithStyle:UITableViewStyleGrouped]) {
    _pubKey = pubKey;
    _mdOrder = mdOrder;
    _theme = [CardKTheme defaultTheme];
    _bankImageProvider = [[BankImageProvider alloc] init];
    
//    SVGKImage * image = [_bankImageProvider svgImageForNumber:@""];
  }
  
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [_bankImageProvider preloadData];
  
  _svgImageView = [[SVGKImageView alloc] init];
  [self.view addSubview:_svgImageView];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
  return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
  return 0;
}

/*
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
 
 // Configure the cell...
 
 return cell;
 }
 */


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
