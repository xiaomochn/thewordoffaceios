//
//  FaceMainVC.swift
//  thewordofface
//
//  Created by xiaomo on 16/8/9.
//  Copyright © 2016年 xiaomo. All rights reserved.
//

import UIKit
import PagingMenuController
class FaceMainVC: UIViewController{
        var pagvc:PagingMenuController?
    struct MenuItemUsers: MenuItemViewCustomizable {
        let title:String
        var displayMode: MenuItemDisplayMode {
            return .Text(title: MenuItemText(text: title, color: UIColor.blueColor(), selectedColor: UIColor.blueColor(), font: UIFont.systemFontOfSize(UIFont.systemFontSize()), selectedFont: UIFont.systemFontOfSize(UIFont.systemFontSize())))
        }
    }
    struct MenuItemRepository: MenuItemViewCustomizable {}
    struct MenuItemGists: MenuItemViewCustomizable {}
    struct MenuItemOrganization: MenuItemViewCustomizable {}
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initPager()

     
    }
    static let Titls=["海外","固收","浮动","固收+浮动"]
    func initPager(){
        
        struct PagingMenuOptions: PagingMenuControllerCustomizable {
           
            var controolers :[UIViewController]
                init() {
                let story = UIStoryboard(name: "Main", bundle: nil)
                controolers = []
                for item in FaceMainVC.Titls {
                    let vc = story.instantiateViewControllerWithIdentifier("FaceTabVC")
                    vc.title = item
                    controolers.append(vc)
                    }
            }
            var componentType: ComponentType {
                return .All(menuOptions: MenuOptions(), pagingControllers:controolers )
            }
            struct MenuOptions: MenuViewCustomizable {
                var menus : [MenuItemViewCustomizable]
                init() {
                     menus = []
                    for item in FaceMainVC.Titls {
                        menus.append(MenuItemUsers(title: item))
                    }
                    
                }
                var displayMode: MenuDisplayMode {
                    return .SegmentedControl
                }
                var itemsOptions: [MenuItemViewCustomizable] {
                    
                    return menus
                }
            }
        }
        
        let options = PagingMenuOptions()
        let pagingMenuController = self.childViewControllers.first as! PagingMenuController
        pagingMenuController.delegate = self
        pagingMenuController.setup(options)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension FaceMainVC: PagingMenuControllerDelegate {
    // MARK: - PagingMenuControllerDelegate
    
    func willMoveToPageMenuController(menuController: UIViewController, previousMenuController: UIViewController) {
    }
    
    func didMoveToPageMenuController(menuController: UIViewController, previousMenuController: UIViewController) {
    }
    
    func willMoveToMenuItemView(menuItemView: MenuItemView, previousMenuItemView: MenuItemView) {
    }
    
    func didMoveToMenuItemView(menuItemView: MenuItemView, previousMenuItemView: MenuItemView) {
    }
}
