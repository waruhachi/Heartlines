#include "HLSRootListController.h"

@implementation HLSRootListController

- (void)viewDidLoad {

    [super viewDidLoad];

    self.appearanceSettings = [HBAppearanceSettings new];
    self.hb_appearanceSettings = [self appearanceSettings];


    self.preferences = [[HBPreferences alloc] initWithIdentifier:@"love.litten.heartlinespreferences"];


    self.enableSwitch = [UISwitch new];
    [[self enableSwitch] setOnTintColor:[UIColor colorWithRed:0.62 green:0.78 blue:0.86 alpha:1]];
    [[self enableSwitch] addTarget:self action:@selector(setEnabled) forControlEvents:UIControlEventTouchUpInside];


    self.item = [[UIBarButtonItem alloc] initWithCustomView:[self enableSwitch]];
    self.navigationItem.rightBarButtonItem = [self item];
    [[self navigationItem] setRightBarButtonItem:[self item]];


    self.navigationItem.titleView = [UIView new];
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [[self titleLabel] setFont:[UIFont boldSystemFontOfSize:17]];
    [[self titleLabel] setText:@"1.5.4"];
    [[self titleLabel] setTextColor:(self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) ? [UIColor whiteColor] : [UIColor blackColor]];
    [[self titleLabel] setTextAlignment:NSTextAlignmentCenter];
    [[[self navigationItem] titleView] addSubview:[self titleLabel]];

    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.titleLabel.topAnchor constraintEqualToAnchor:self.navigationItem.titleView.topAnchor],
        [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.navigationItem.titleView.leadingAnchor],
        [self.titleLabel.trailingAnchor constraintEqualToAnchor:self.navigationItem.titleView.trailingAnchor],
        [self.titleLabel.bottomAnchor constraintEqualToAnchor:self.navigationItem.titleView.bottomAnchor],
    ]];


    self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [[self iconView] setContentMode:UIViewContentModeScaleAspectFit];
    [[self iconView] setImage:[UIImage imageWithContentsOfFile:jbroot(@"/Library/PreferenceBundles/HeartlinesPreferences.bundle/icon.png")]];
    [[self iconView] setAlpha:0];
    [[[self navigationItem] titleView] addSubview:[self iconView]];

    self.iconView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.iconView.topAnchor constraintEqualToAnchor:self.navigationItem.titleView.topAnchor],
        [self.iconView.leadingAnchor constraintEqualToAnchor:self.navigationItem.titleView.leadingAnchor],
        [self.iconView.trailingAnchor constraintEqualToAnchor:self.navigationItem.titleView.trailingAnchor],
        [self.iconView.bottomAnchor constraintEqualToAnchor:self.navigationItem.titleView.bottomAnchor],
    ]];


    self.blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
    self.blurView = [[UIVisualEffectView alloc] initWithEffect:[self blur]];


    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    self.headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    [[self headerImageView] setContentMode:UIViewContentModeScaleAspectFill];
    [[self headerImageView] setImage:[UIImage imageWithContentsOfFile:jbroot(@"/Library/PreferenceBundles/HeartlinesPreferences.bundle/Banner.png")]];
    [[self headerImageView] setClipsToBounds:YES];
    [[self headerView] addSubview:[self headerImageView]];

    self.headerImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.headerImageView.topAnchor constraintEqualToAnchor:self.headerView.topAnchor],
        [self.headerImageView.leadingAnchor constraintEqualToAnchor:self.headerView.leadingAnchor],
        [self.headerImageView.trailingAnchor constraintEqualToAnchor:self.headerView.trailingAnchor],
        [self.headerImageView.bottomAnchor constraintEqualToAnchor:self.headerView.bottomAnchor],
    ]];

    if ([[NSFileManager defaultManager] fileExistsAtPath:jbroot(@"/Library/MobileSubstrate/DynamicLibraries/Heartlines.disabled")]) {
        [[self enableSwitch] setEnabled:NO];

        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Heartlines" message:@"Heartlines has detected that you have disabled it with iCleaner Pro, here are some quick actions you can perform" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* resetAction = [UIAlertAction actionWithTitle:@"Reset preferences" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
            [self resetPreferences];
        }];

        UIAlertAction* backAction = [UIAlertAction actionWithTitle:@"Back" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
            [[self navigationController] popViewControllerAnimated:YES];
        }];

        UIAlertAction* ignoreAction = [UIAlertAction actionWithTitle:@"Ignore" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
            [[self enableSwitch] setEnabled:YES];
        }];

        [alertController addAction:resetAction];
        [alertController addAction:backAction];
        [alertController addAction:ignoreAction];

        [self presentViewController:alertController animated:YES completion:nil];
    } else if ([[NSFileManager defaultManager] fileExistsAtPath:jbroot(@"/Library/MobileSubstrate/DynamicLibraries/DayNightSwitch.dylib")]) {
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Heartlines" message:@"Heartlines has detected that you have DayNightSwitch installed, which causes issues with Heartlines's preferences\n\n To continue, please disable DayNightSwitch with iCleaner Pro or uninstall it temporarily" preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction* confirmAction = [UIAlertAction actionWithTitle:@"Okey" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
            [[self navigationController] popViewControllerAnimated:YES];
        }];

        [alertController addAction:confirmAction];

        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];

    CGRect frame = self.table.bounds;
    frame.origin.y = -frame.size.height;

    [[[[self navigationController] navigationController] navigationBar] setBarTintColor:[UIColor whiteColor]];
    [[[[self navigationController] navigationController] navigationBar] setTintColor:[UIColor whiteColor]];
    [[[[self navigationController] navigationController] navigationBar] setShadowImage:[UIImage new]];
    [[[[self navigationController] navigationController] navigationBar] setTranslucent:YES];

    [[self blurView] setFrame:[[self view] bounds]];
    [[self blurView] setAlpha:1];
    [[self view] addSubview:[self blurView]];

    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [[self blurView] setAlpha:0];
    } completion:nil];

}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];

    [self setEnabledState];

}

- (NSArray *)specifiers {

	if (_specifiers == nil) _specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];

	return _specifiers;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    tableView.tableHeaderView = [self headerView];

    return [super tableView:tableView cellForRowAtIndexPath:indexPath];

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    CGFloat offsetY = scrollView.contentOffset.y;

    if (offsetY > 200)
        [UIView animateWithDuration:0.2 animations:^{
            [[self iconView] setAlpha:1];
            [[self titleLabel] setAlpha:0];
        }];
    else
        [UIView animateWithDuration:0.2 animations:^{
            [[self iconView] setAlpha:0];
            [[self titleLabel] setAlpha:1];
        }];

}

- (void)setEnabled {
        
    if ([[[self preferences] objectForKey:@"Enabled"] isEqual:@(YES)])
        [[self preferences] setBool:NO forKey:@"Enabled"];
    else
        [[self preferences] setBool:YES forKey:@"Enabled"];

    [self respring];

}

- (void)setEnabledState {

    if ([[[self preferences] objectForKey:@"Enabled"] isEqual:@(YES)])
        [[self enableSwitch] setOn:YES animated:YES];
    else
        [[self enableSwitch] setOn:NO animated:YES];

}

- (void)resetPrompt {

    UIAlertController* resetAlert = [UIAlertController alertControllerWithTitle:@"Heartlines" message:@"Do you really want to reset your preferences?" preferredStyle:UIAlertControllerStyleActionSheet];
	
    UIAlertAction* confirmAction = [UIAlertAction actionWithTitle:@"Yaw" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
        [self resetPreferences];
	}];

	UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Naw" style:UIAlertActionStyleCancel handler:nil];

	[resetAlert addAction:confirmAction];
	[resetAlert addAction:cancelAction];

	[self presentViewController:resetAlert animated:YES completion:nil];

}

- (void)resetPreferences {

    for (NSString* key in [[self preferences] dictionaryRepresentation]) {
        [[self preferences] removeObjectForKey:key];
    }
    
    [[self enableSwitch] setOn:NO animated:YES];
    [self respring];

}

- (void)respring {

    [[self blurView] setFrame:[[self view] bounds]];
    [[self blurView] setAlpha:0];
    [[self view] addSubview:[self blurView]];

    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [[self blurView] setAlpha:1];
    } completion:^(BOOL finished) {
        if (![[NSFileManager defaultManager] fileExistsAtPath:jbroot(@"/Library/MobileSubstrate/DynamicLibraries/shuffle.dylib")])
            [HBRespringController respringAndReturnTo:[NSURL URLWithString:@"prefs:root=Heartlines"]];
        else
            [HBRespringController respringAndReturnTo:[NSURL URLWithString:@"prefs:root=Tweaks&path=Heartlines"]];
    }];

}

@end