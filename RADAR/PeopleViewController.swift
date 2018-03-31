//
//  PeopleViewController.swift
//  RADAR
//
//  Created by Raghav Sreeram on 9/6/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import UIKit

class PeopleViewController: UIViewController {

    var restaurant: Restaurant!
    var restKey: String!
    
    var card: UIView!
    var cardImage: UIImageView!
    var cardNameLabel: UILabel!
    var cardMemo: UILabel!
    var cardInfo: UILabel!
    
    var cardIndex = 0
    var users: [User]!
    var imageUrls: [String]!
    
    var divisor: CGFloat!
    var viewHeight: CGFloat!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        users = []
        imageUrls = []

        viewHeight = self.view.frame.height
        card = UIView()
        card.frame = CGRect(x: 0, y: 0, width: self.view.frame.width - 100, height: self.view.frame.height - 250)
        card.center = CGPoint(x: self.view.frame.width / 2, y: viewHeight/2 - 20)
        //card.backgroundColor = UIColor.black
        card.clipsToBounds = true
        card.layer.masksToBounds = true
        card.layer.cornerRadius = 10
        card.isUserInteractionEnabled = true
        self.view.addSubview(card)
        
        cardImage = UIImageView()
        //cardImage.frame = CGRect(x: 0, y: 0, width: card.frame.width - 40, height: card.frame.height - 120)
        cardImage.frame = CGRect(x: 0, y: 0, width: card.frame.width - 50, height: card.frame.width - 50)
        cardImage.center = CGPoint(x: card.frame.width / 2, y: card.frame.height/2 + 20)
        cardImage.layer.borderWidth = 2
        cardImage.layer.borderColor = UIColor.black.cgColor
        cardImage.layer.cornerRadius = cardImage.frame.width/2
        cardImage.image = UIImage(named: "bar1.png")
        cardImage.clipsToBounds = true
        cardImage.contentMode = .scaleAspectFill
        self.card.addSubview(cardImage)
        
        cardMemo = UILabel()
        cardMemo.text = "Looking for a study buddy!"
        cardMemo.font = UIFont(name: "HelveticaNeue-Thin", size: 17)
        cardMemo.center.x = card.center.x
        cardMemo.textAlignment = .center
        cardMemo.textColor = UIColor.black
        cardMemo.frame = CGRect(x: 0, y: 0, width: card.frame.width, height: 50)
        cardMemo.center.y = 100
        card.addSubview(cardMemo)
        
        cardInfo = UILabel()
        cardInfo.text = "University of California, Davis \n \n \n Computer Science and Engineering \n \n \n Tennis * Soccer * Music \n Travel * Itallian Food * Gym"
        cardInfo.numberOfLines = 10
        cardInfo.font = UIFont(name: "Helvetica", size: 17)
        cardInfo.center.x = card.center.x
        cardInfo.textAlignment = .center
        cardInfo.textColor = UIColor.white
        cardInfo.isHidden = true
        cardInfo.frame = CGRect(x: 0, y: 0, width: card.frame.width, height: 200)
        cardInfo.center.y = cardImage.center.y
        card.addSubview(cardInfo)
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnCard))
        card.addGestureRecognizer(tapGesture)
        
        
        cardNameLabel = UILabel()
        cardNameLabel.frame = CGRect(x: 0, y: 0, width: card.frame.width, height: 50)
        cardNameLabel.center.y = 50
        cardNameLabel.textColor = UIColor.black
        cardNameLabel.textAlignment = .center
        cardNameLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 30)
        cardNameLabel.text = "Sample Bar"
        self.card.addSubview(cardNameLabel)
        
        
        
        var panGeture = UIPanGestureRecognizer(target: self, action: #selector(panCard))
        
        card.addGestureRecognizer(panGeture)
        
        
        let newLatitude = String(restaurant.latitude).replacingOccurrences(of: ".", with: "&")
        let newLongitude = String(restaurant.longitude).replacingOccurrences(of: ".", with: "&")
        let restaurantKey = "\(newLatitude)-\(newLongitude)"
        restKey = restaurantKey
        
        PeopleFunctions.getUsersCheckedIn(at: restaurantKey) { (usersArr) in
            
            print("userArr: \(usersArr)")
            for user in usersArr{
                //INCLUDE THE COMMENTED LINES IN THE END
                //if(user.fbid != User.current.fbid){
                    self.users.append(user)
                    self.imageUrls.append(user.data.url)
                //}
 
            }
   
             self.setUpCard(i: 0)
            return
            
        }
        
        divisor = (view.frame.width / 2) / 0.61

    }
    
    var tappedState = false
    var tappedNumber = 0
    var blurEffectView = UIVisualEffectView()
    func tappedOnCard(){
        
        print("Tapped!")
        //tappedState = !tappedState
        tappedNumber += 1
        if(tappedNumber == 1){
        //if(tappedState){
            //cardView
            cardInfo.isHidden = false
            print("tapped card View!")
            self.cardImage.layer.borderColor = UIColor.black.cgColor
            self.cardImage.layer.borderWidth = 0
            

            
            UIView.animate(withDuration: 0.25, animations: {
               
                self.cardImage.frame = CGRect(x: 0, y: 0, width: self.card.frame.width - 40, height: self.card.frame.height - 120)
                self.cardImage.center = CGPoint(x: self.card.frame.width / 2, y: self.card.frame.height/2 + 20)
            
                self.cardImage.layer.cornerRadius = 10
                //self.card.backgroundColor = UIColor.black
                //self.cardNameLabel.textColor = UIColor.white
                
                self.cardNameLabel.center.y = 20
                self.cardMemo.center.y = 60
                
             

            })
            
            var blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
            blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = cardImage.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.cardImage.addSubview(self.blurEffectView)
            
            
            
        }else if(tappedNumber == 2){
            
            print("Detailed View")
             self.blurEffectView.removeFromSuperview()
//            var blurEffect = UIBlurEffect(style: UIBlurEffectStyle.regular)
//            blurEffectView = UIVisualEffectView(effect: blurEffect)
//            blurEffectView.frame = cardImage.bounds
//            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//            
//            UIView.animate(withDuration: 0.25, animations: {
//            self.cardImage.addSubview(self.blurEffectView)
//            })
//            
            cardInfo.isHidden = true
            
            
            
        }else if(tappedNumber == 3){
            print("tapped circle view!")
            
            cardInfo.isHidden = true
            self.cardImage.layer.borderColor = UIColor.black.cgColor
            self.cardImage.layer.borderWidth = 2
            UIView.animate(withDuration: 0.5, animations: {
                self.blurEffectView.removeFromSuperview()
                self.cardImage.frame = CGRect(x: 0, y: 0, width: self.card.frame.width - 50, height: self.card.frame.width - 50)
                self.cardImage.center = CGPoint(x: self.card.frame.width / 2, y: self.card.frame.height/2 + 20)
                
                self.cardImage.layer.cornerRadius = self.cardImage.frame.width/2
                self.card.backgroundColor = UIColor.white
                self.cardNameLabel.textColor = UIColor.black
                
                self.cardNameLabel.center.y = 50
                self.cardMemo.center.y = 100
            })
            
            tappedNumber = 0

        }
        //}else{
            //circle view
        
        //}
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cardIndex = 0
    }
    
    func showNextCard(_ sender: Any) {
        cardIndex = cardIndex + 1
        
        if(cardIndex == users.count){
            print("No more users!")
            return
        }
        print(cardIndex)
      
        setUpCard(i: cardIndex)
        reset(Any)
        tappedNumber = 2
        tappedOnCard()
    }
    
    func setUpCard(i: Int){
        
       print(i)
        if let url = URL(string: self.imageUrls[i]){
            cardImage.kf.setImage(with: url)
        }
        
        var user = users[i] as! User
        var userName = user.username
        self.cardNameLabel.text = userName
    }
    
    
    
    
    func panCard(_ sender: UIPanGestureRecognizer) {
        
        var card = sender.view!
        
        var point = sender.translation(in: view)
        card.center = CGPoint(x: view.center.x + point.x, y: (viewHeight/2 - 20 + point.y))
        var xFromCenter = card.center.x - view.center.x
        
        if(self.view.center.x / card.center.x > 1.0){
            card.alpha = card.center.x / self.view.center.x
        }else{
        card.alpha = self.view.center.x / card.center.x
        }
        
        card.transform = CGAffineTransform(rotationAngle: xFromCenter/divisor)
        
        if(sender.state == UIGestureRecognizerState.ended){
            if(card.center.x < 60 ){
                
                self.swipedUserLeft()
       
                UIView.animate(withDuration: 0.5, animations: {
                
                    card.center.x = -200.0
                    card.center.y += 75
                    card.alpha = 0
                    
                }, completion: { (bool) in
                    if bool{
                        
                        self.showNextCard(Any)
                        
                    }
                })
                
                return
            }else if(view.frame.width - card.center.x < 60){
                self.swipedUserRight()
               
                UIView.animate(withDuration: 0.5, animations: {
                    
                    card.center.x += 200.0
                    card.center.y += 75
                    card.alpha = 0
                    
                }, completion: { (bool) in
                    if bool{
                        
                        self.showNextCard(Any)
                        
                    }
                })
                
                return
            }
            
            reset(Any)
        }

    }

    func reset(_ sender: Any) {

        self.card.center = CGPoint(x: self.view.frame.width / 2, y: viewHeight/2 - 20)
        self.card.transform = CGAffineTransform(rotationAngle: 0.0)
        self.card.alpha = 1.0
        
    }

    func swipedUserRight(){
        
        print("Swiped User right!")
        PeopleFunctions.rightSwipeOn(fbID: users[cardIndex].fbid, restKey: restKey, completion: {bool in
        
        print("SWIPED RIGHT \(bool)")
        })
        
        
        //cardIndex = cardIndex + 1
        //setUpCard(i: cardIndex)
    }
    
    func swipedUserLeft(){
        print("swiped user Left!")
        //cardIndex = cardIndex + 1
        //setUpCard(i: cardIndex)
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
