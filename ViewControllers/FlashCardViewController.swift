//
//  FlashCardViewController.swift
//  Flashcard
//
//  Created by Naoto Ohno on 7/30/15.
//  Copyright (c) 2015 Naoto. All rights reserved.
//

import Foundation
import Parse
import ConvenienceKit
import Foundation

class FlashCardViewController: UIViewController, UIScrollViewDelegate{
    
    //IBOutlet for scrollView and container view(view which contains 3 views)
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    
    
    //IBOutlet for 3 flashCrad views
    @IBOutlet weak var flashCardView0: FlashCardView!
    @IBOutlet weak var flashCardView1: FlashCardView!
    @IBOutlet weak var flashCardView2: FlashCardView!
    
    
    //Instantiate card class in Models as an array to access to Card class on Parse
    var cardsObjects = [Card]()
    
    //Index for 3 cards?
    var cardIndex = 0
    
    //Reciever of studySet object passed from StudySetViewController
    var studySet : StudySets!
    
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        
        //Query to fetch Card class from Parse
        var cardsQuery = PFQuery(className: Card.parseClassName())//Card.parseClassName is same as "Card"
        
        //Sort query by studySet pointer
        cardsQuery.whereKey("studySets", equalTo: studySet)
        
        //The values are optional so unwrap it by optional binding
        if let cards = cardsQuery.findObjects() as? [Card] {
            cardsObjects = cards
        }
        
        
        //this tells self class instance is set to delegate of scrollView
        scrollView.delegate = self //should I change the name? cuz scrollView already exists in CreateSetViewController
        
        
        let termString = cardsObjects[cardIndex].term
        flashCardView1.termInFlashCard.text = termString
        
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //methods controlling placements of views in scroll view
    func moveToCenter() {
        //Why should I set frameSizeHeight to contentOffset's y?
        scrollView.contentOffset = CGPoint(x: 0, y: scrollView.frame.size.height)
    }
    
    
}



extension FlashCardViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        
        println(offset.y)
        println(scrollView.frame.size.height)
        
        if offset.y != scrollView.frame.size.height {
            
            if offset.y == 0 {
                cardIndex -= 1
            } else {
                cardIndex += 1
            }
            
            //
            moveToCenter()
            
            
            // Also needs to update text field content
            if cardIndex > 0 {
                flashCardView0.termInFlashCard.text = cardsObjects[cardIndex - 1].term
            }
            
            flashCardView1.termInFlashCard.text = cardsObjects[cardIndex].term
            
            if cardIndex + 1 < cardsObjects.count {
                flashCardView2.termInFlashCard.text = cardsObjects[cardIndex + 1].term
            } else {
                flashCardView2.termInFlashCard.text = nil
            }
            
        }
    }
}

