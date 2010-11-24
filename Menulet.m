//
//  Menulet.m
//  HostfileManager
//
//  Created by ezarko on 11/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Menulet.h"

@implementation Menulet

-(void)dealloc
{
    [statusItem release];
	[super dealloc];
}

-(void)awakeFromNib
{
	NSMenu        *theMenu;
	NSMenuItem    *theMenuItem;
	
	statusItem = [[[NSStatusBar systemStatusBar] 
				   statusItemWithLength:NSVariableStatusItemLength]
				  retain];
    [statusItem setImage:[NSImage imageNamed:@"gh"]];
	[statusItem setHighlightMode:YES];
	[statusItem setTitle:[NSString
						  stringWithString:@""]];
	[statusItem setEnabled:YES];
	[statusItem setToolTip:@"Hostfile Manager"];

	theMenu = [[NSMenu alloc] initWithTitle:@""];

	NSArray *fragments = [self status];
	for (int i = 0; i < [fragments count]; ++i) {
		NSString *text = [fragments objectAtIndex:i];
		theMenuItem = [[NSMenuItem alloc] initWithTitle:[text substringFromIndex:2] action:@selector(toggleFragment:) keyEquivalent:@""];
		[theMenuItem setTarget:self];
		switch ([text characterAtIndex:0]) {
			case '+':
				[theMenuItem setState:NSOnState];
				break;
			case '*':
				[theMenuItem setState:NSMixedState];
				break;
			case ' ':
				[theMenuItem setState:NSOffState];
				break;
			default:
				NSLog(@"Unknown state:%@\n", [text characterAtIndex:0]);
		}
		[theMenu addItem:theMenuItem];
	}

	[theMenu addItem:[NSMenuItem separatorItem]];

	[theMenu addItemWithTitle:@"Quit" action:@selector(terminate:) keyEquivalent:@"Q"];
	[statusItem setMenu:theMenu];
	[theMenu release];

	OSStatus err = AuthorizationCreate(NULL, kAuthorizationEmptyEnvironment, kAuthorizationFlagInteractionAllowed, &auth);
	if (err != errAuthorizationSuccess)
		NSLog(@"AuthorizationCreate returned %@\n", err);
}

-(NSArray *)status
{
	NSTask *task;
	task = [[NSTask alloc] init];
	[task setLaunchPath: @"/usr/local/bin/hostfiles"];
	
	NSArray *arguments = [NSArray arrayWithObjects:@"--status", nil];
	[task setArguments: arguments];
	
	NSPipe *pipe = [NSPipe pipe];
	[task setStandardOutput: pipe];
	
	NSFileHandle *file = [pipe fileHandleForReading];
	
	[task launch];
	
	NSData *data = [file readDataToEndOfFile];
	NSString *string = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
	NSArray *lines = [string componentsSeparatedByString:@"\n"];
	NSRange theRange;
	theRange.location = 0;
	theRange.length = [lines count] - 1;
	return [lines subarrayWithRange:theRange];
}

-(IBAction)toggleFragment:(id)sender
{
	const char *command = "/usr/local/bin/hostfiles";
	char *args[] = {NULL, [[sender title] cStringUsingEncoding:NSUTF8StringEncoding], NULL};
	NSInteger state;
	
	switch ([sender state]) {
		case NSOnState:
		case NSMixedState:
			args[0] = "--disable";
			state = NSOffState;
			break;
		case NSOffState:
			args[0] = "--enable";
			state = NSOnState;
	}
	
	OSStatus err = AuthorizationExecuteWithPrivileges(auth, command, kAuthorizationFlagDefaults, args, NULL);
	if (err != errAuthorizationSuccess) {
		NSLog(@"AuthorizationExecuteWithPrivileges returned %@\n", err);
		return;
	}
	
	[sender setState:state];
}

@end
