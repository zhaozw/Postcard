//
//  MessageListViewController.swift
//  Postcard
//
//  Created by Adelita Schule on 5/13/16.
//  Copyright © 2016 operatorfoundation.org. All rights reserved.
//

import Cocoa

class MessageListViewController: NSViewController, NSTableViewDelegate
{
    @IBOutlet var postcardsArrayController: NSArrayController!
    
    var managedContext = (NSApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do view setup here.
        
        
    }
    
    override func viewWillAppear()
    {
        super.viewWillAppear()
        
        //Make sure that the array controller for bindings is only looking at messages for the correct user
        //TODO: This is not available quickly enough, should we store it in UD?
        if let currentUser = Constants.currentUser
        {
            let predicate = NSPredicate(format: "owner == %@", currentUser)
            postcardsArrayController.fetchPredicate = predicate
            print("postcard Array Controller filtered to \(currentUser.emailAddress)\n")
        }
    }
    
    @IBAction func rowSelected(sender: NSTableView)
    {
        if let selectedPostcard = postcardsArrayController.selectedObjects[0] as? Postcard
        {
            //Decrypt the postcard on selection
            //TODO: Should this be a callback function?
            if selectedPostcard.decrypted == false
            {
                MailController.sharedInstance.decryptPostcard(selectedPostcard)
            }
            
            //Tell the message VC what message to display
            let splitVC = parentViewController as! NSSplitViewController
            if let messageVC: MessageViewController = splitVC.childViewControllers[1] as? MessageViewController
            {
                messageVC.postcardObjectController.content = selectedPostcard
            }
        }
        else
        {
            let splitVC = parentViewController as! NSSplitViewController
            if let messageVC: MessageViewController = splitVC.childViewControllers[1] as? MessageViewController
            {
                messageVC.postcardObjectController.content = nil
            }
        }
    }
    
//
}


//MARK: Custom Table Cell Class
class MessagesTableCell: NSTableCellView
{
    @IBOutlet weak var nameLabel: NSTextField!
    @IBOutlet weak var subjectLabel: NSTextField!
    @IBOutlet weak var timeLabel: NSTextField!
    @IBOutlet weak var snippetLabel: NSTextField!
    @IBOutlet weak var penPalImageView: NSImageView!
    
    override func drawRect(dirtyRect: NSRect)
    {
        super.drawRect(dirtyRect)
        
        //When a cell is selected the system sets background style to dark by default
        //Use this to change the cell color
        if backgroundStyle == NSBackgroundStyle.Dark
        {
            NSColor.whiteColor().setFill()
            NSRectFill(dirtyRect)
        }
    }
    
//
}