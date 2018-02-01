//
//  ViewController.swift
//  CFB
//
//  Created by Michael Ardizzone on 1/27/18.
//  Copyright © 2018 Michael Ardizzone. All rights reserved.
//

import UIKit
import ZLSwipeableViewSwift
import Cartography
import Nuke

class ZLSwipeableViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var showingBackOfCard = false
    var swipeableView: ZLSwipeableView!
    var colors = ["Turquoise", "Green Sea", "Emerald", "Nephritis", "Peter River", "Belize Hole", "Amethyst", "Wisteria", "Wet Asphalt", "Midnight Blue", "Sun Flower"]
    var people = loadJson(filename: "team")
    var peopleDictionary = [String : [String : String]]()
    var colorIndex = 0
    
    override func viewDidAppear(_ animated: Bool) {
        swipeableView.nextView = {
            return self.nextCardView()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let people = people {
            peopleDictionary = modelToDictionary(input: people)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setToolbarHidden(false, animated: false)
        view.backgroundColor = UIColor.white
        view.clipsToBounds = true
        
        swipeableView = ZLSwipeableView()
        view.addSubview(swipeableView)

        swipeableView.didSwipe = {view, direction, vector in
            self.swipeableView.nextView = {
                return self.nextCardView()
            }
        }

        swipeableView.didDisappear = { view in
            self.view.viewWithTag(2)?.removeFromSuperview()
            self.showingBackOfCard = false
        }
        
        constrain(swipeableView, view) { view1, view2 in
            view1.left == view2.left+50
            view1.right == view2.right-50
            view1.top == view2.top + 120
            view1.bottom == view2.bottom - 100
        }
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer? = nil) {
        UIView.transition(with: swipeableView, duration: 0.6, options: UIViewAnimationOptions.transitionFlipFromRight, animations: nil, completion: nil)
        if showingBackOfCard == false {
            let backOfCardSubview = setUpBackOfCard()
            let backCard = addProfileDataToCard(inputView: backOfCardSubview)
            let theSwipeAbleView = swipeableView.topView() as! CardView
            backOfCardSubview.addSubview(backCard)
            theSwipeAbleView.addSubview(backOfCardSubview)
            showingBackOfCard = true
        } else {
            view.viewWithTag(2)?.removeFromSuperview()
            showingBackOfCard = false
        }
    }
    
    // MARK: Card Setup
    func nextCardView() -> UIView? {
        if colorIndex >= colors.count {
            colorIndex = 0
        }
        colorIndex += 1
        let cardView = setupCardView()
        return cardView
    }
    
    func setUpBackOfCard() -> CardView {
        let backcardView = CardView(frame: swipeableView.bounds)
        backcardView.tag = 2
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        tap.delegate = self
        backcardView.addGestureRecognizer(tap)
        backcardView.backgroundColor = swipeableView.topView()?.backgroundColor
        return backcardView
    }
    
    func addProfileDataToCard(inputView: CardView) -> BackCardView {
        let theSwipeAbleView = swipeableView.topView() as! CardView
        let profileLayer = swipeableView.topView()?.subviews[0] as! ProfileView
        let colorOfTopView = swipeableView.backgroundColor
        let nameOnCard = profileLayer.nameLabel.text
        let interestsText = peopleDictionary[nameOnCard!]!["interests"]
        let datingPrefsText = peopleDictionary[nameOnCard!]!["datingPrefs"]
        let personalityText = peopleDictionary[nameOnCard!]!["personality"]
        let backCardDataView = Bundle.main.loadNibNamed("BackView", owner: self, options: nil)?.first! as! BackCardView
        backCardDataView.frame = CGRect(x: 20, y: 20, width: inputView.frame.size.width - 40, height: inputView.frame.size.height - 20)
        backCardDataView.datingPreferencesLabel.text = datingPrefsText
        backCardDataView.interestsLabel.text = interestsText
        backCardDataView.personalityLabel.text = personalityText
        backCardDataView.backgroundColor = colorOfTopView
        return backCardDataView
    }
    
    func setupCardView() -> UIView {
        let cardView = CardView(frame: swipeableView.bounds)
        cardView.backgroundColor = colorForName(colors[colorIndex])
        let profileView = Bundle.main.loadNibNamed("ProfileView", owner: self, options: nil)?.first! as! ProfileView
        profileView.nameLabel.text = people![colorIndex].name
        let imageURL = URL(string: people![colorIndex].profile_image)
        let request = Request(url: imageURL!)
        Manager.shared.loadImage(with: request, into: profileView.profileImageView)
        profileView.frame = CGRect(x: 20, y: 20, width: cardView.frame.size.width - 40, height: cardView.frame.size.height - 20)
        cardView.addSubview(profileView)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        tap.delegate = self
        cardView.addGestureRecognizer(tap)
        profileView.addGestureRecognizer(tap)
        return cardView
    }
    
    func colorForName(_ name: String) -> UIColor {
        let sanitizedName = name.replacingOccurrences(of: " ", with: "")
        let selector = "flat\(sanitizedName)Color"
        return UIColor.perform(Selector(selector)).takeUnretainedValue() as! UIColor
    }
}



