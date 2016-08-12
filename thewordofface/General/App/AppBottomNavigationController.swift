/*
* Copyright (C) 2015 - 2016, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.io>.
* All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions are met:
*
*	*	Redistributions of source code must retain the above copyright notice, this
*		list of conditions and the following disclaimer.
*
*	*	Redistributions in binary form must reproduce the above copyright notice,
*		this list of conditions and the following disclaimer in the documentation
*		and/or other materials provided with the distribution.
*
*	*	Neither the name of Material nor the names of its
*		contributors may be used to endorse or promote products derived from
*		this software without specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
* AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
* IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
* DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
* FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
* DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
* CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
* OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
* OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

/*
The following is an example of using a MenuController to control the
flow of your application.
*/

import UIKit
import Material

class AppBottomNavigationController: BottomNavigationController {
	/// NavigationBar menu button.
	private var menuButton: IconButton!
	
	/// NavigationBar switch control.
	private var switchControl: MaterialSwitch!
	
	/// NavigationBar search button.
	private var searchButton: IconButton!
	
	override func prepareView() {
		super.prepareView()
       
		prepareMenuButton()
		prepareSwitchControl()
		prepareSearchButton()
		prepareNavigationItem()
		prepareViewControllers()
		prepareTabBar()
         self.title = "首页"
	}
	
	/// Handles the menuButton.
	internal func handleMenuButton() {
		navigationDrawerController?.openLeftView()
	}
	
	/// Handles the searchButton.
	internal func handleSearchButton() {
		let recommended: Array<MaterialDataSourceItem> = Array<MaterialDataSourceItem>()
		let vc: AppSearchBarController = AppSearchBarController(rootViewController: RecommendationViewController(dataSourceItems: recommended))
		vc.modalTransitionStyle = .CrossDissolve
		presentViewController(vc, animated: true, completion: nil)
	}
	
	/// Prepares the menuButton.
	private func prepareMenuButton() {
		let image: UIImage? = MaterialIcon.cm.menu
		menuButton = IconButton()
		menuButton.pulseColor = MaterialColor.white
		menuButton.setImage(image, forState: .Normal)
		menuButton.setImage(image, forState: .Highlighted)
		menuButton.addTarget(self, action: #selector(handleMenuButton), forControlEvents: .TouchUpInside)
	}
	
	/// Prepares the switchControl.
	private func prepareSwitchControl() {
		switchControl = MaterialSwitch(state: .Off, style: .LightContent, size: .Small)
	}
	
	/// Prepares the searchButton.
	private func prepareSearchButton() {
		let image: UIImage? = MaterialIcon.cm.search
		searchButton = IconButton()
		searchButton.pulseColor = MaterialColor.white
		searchButton.setImage(image, forState: .Normal)
		searchButton.setImage(image, forState: .Highlighted)
		searchButton.addTarget(self, action: #selector(handleSearchButton), forControlEvents: .TouchUpInside)
	}
	
	/// Prepares the navigationItem.
	private func prepareNavigationItem() {
		navigationItem.title = "Recipes"
		navigationItem.titleLabel.textAlignment = .Left
		navigationItem.titleLabel.textColor = MaterialColor.white
		navigationItem.titleLabel.font = RobotoFont.mediumWithSize(20)
		
		navigationItem.leftControls = [menuButton]
		navigationItem.rightControls = [switchControl, searchButton]
	}
	
	/// Prepares the view controllers.
	private func prepareViewControllers() {
		viewControllers = [RecipesViewController(), UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("FaceMainVC")]
		selectedIndex = 0
	}
	
	/// Prepares the tabBar.
	private func prepareTabBar() {
		tabBar.tintColor = MaterialColor.white
		tabBar.backgroundColor = MaterialColor.grey.darken4
	}
}

