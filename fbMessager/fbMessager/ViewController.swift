//
//  ViewController.swift
//  fbMessager
//
//  Created by MAC on 3/15/18.
//  Copyright © 2018 MAC. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    private let cellId = "Cell"
    
    var messages: [Message]?
    
    private func clearData() {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        if let context = delegate?.persistentContainer.viewContext {
            do {
                let entityNames = ["Friend", "Message"]
                
                for entityName in entityNames {
                    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
                    let objects = try context.fetch(fetchRequest)
                    
                    for object in objects {
                        context.delete(object)
                    }
                }
                try context.save()
            } catch let err {
                print(err)
            }
        }
    }
    
    private func setupData() {
        
        clearData()
        
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.persistentContainer.viewContext {
            let mark = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
            mark.name = "Mark Zukerberg"
            mark.profileImageName = "zurkerberg"
            
            let messageMark = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
            messageMark.friend = mark
            messageMark.text = "Hello, my name is Mark. Nice to meet you..."
            messageMark.date = Date() as NSDate
            
            createSteveMessagesWithContext(context: context)
            
            let donal = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
            donal.name = "Donald Trump"
            donal.profileImageName = "donaldTrump"
            
            createMessageWithText(text: "You're fined...", friend: donal, minutesAgo: 5, context: context)
            
            let gandhi = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
            gandhi.name = "Mahatma Gandhi"
            gandhi.profileImageName = "mahatma"
            
            createMessageWithText(text: "Love, Peace, and Joy...", friend: gandhi, minutesAgo: 60 * 24, context: context)
            
            let hillary = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
            hillary.name = "Hillary"
            hillary.profileImageName = "hillaryClinton"
            
            createMessageWithText(text: "Please vote for me. you did for bily", friend: hillary, minutesAgo: 8 * 60 * 24, context: context)
            
        
            do {
                try context.save()
            } catch let err {
                print(err)
            }
        }
        
        loadData()
    }
    
    private func createSteveMessagesWithContext(context: NSManagedObjectContext) {
        let steve = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
        steve.name = "Steve jobs"
        steve.profileImageName = "stevejob"
        
        createMessageWithText(text: "Good morning...", friend: steve, minutesAgo: 2, context: context)
        
        createMessageWithText(text: "Hello how are you?... Are you interested in buying an Apple device Are you interested in buying an Apple device Are you interested in buying", friend: steve, minutesAgo: 1, context: context)
        createMessageWithText(text: "Are you interested in buying an Apple device?..", friend: steve, minutesAgo: 0, context: context)
        
        // response
        createMessageWithText(text: "Yes, totally looking to buy an iphone 7", friend: steve, minutesAgo: 0, context: context, isSender: true)
        
        createMessageWithText(text: "Totally understand that you want Are you interested in buying an Apple device Are you interested in buying an Apple device Are you interested in buying an ", friend: steve, minutesAgo: 0, context: context)
        
        createMessageWithText(text: "Absolutly, I'll just use my iphone 6 plus until them", friend: steve, minutesAgo: 0, context: context, isSender: true)
        
    }
    
    private func createMessageWithText(text: String, friend: Friend, minutesAgo: Double,context: NSManagedObjectContext, isSender: Bool = false) {
        let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
        message.friend = friend
        message.text = text
        // mỗi khi tạo ra thì thời gian trừ đi 1 phút
        message.date = Date().addingTimeInterval( -minutesAgo * 60) as NSDate
        message.isSender = isSender
    }
    
    private func loadData() {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        if let context = delegate?.persistentContainer.viewContext {
            if let friends = fetchFriends() {
                
                messages = [Message]()
                
                for friend in friends {
                    
                    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Message")
                    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
                    fetchRequest.predicate = NSPredicate(format: "friend.name = %@", friend.name!)
                    fetchRequest.fetchLimit = 1
                    
                    do {
                        if let fetchedMessages = try context.fetch(fetchRequest) as? [Message] {
                           messages?.append(contentsOf: fetchedMessages)
                        }
                    } catch let err {
                        print(err)
                    }
                }
                
                // sort message giảm dần theo thời gian
                messages = messages?.sorted(by: {$0.date!.compare($1.date! as Date)  == .orderedDescending })
            }
        }
    }
    
    private func fetchFriends() -> [Friend]? {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        if let context = delegate?.persistentContainer.viewContext {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Friend")
            do {
                return try context.fetch(request) as? [Friend]
            } catch let err {
                print(err)
            }
        }
        return nil
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Recent"

        view.addSubview(collectionView)
        collectionView.register(MessageCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .zero, size: .zero)
        
        setupData()
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = messages?.count {
            return count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MessageCell
        cell.message = messages?[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let layout = UICollectionViewFlowLayout()
        let controller = ChatLogController(collectionViewLayout: layout)
        controller.friend = messages?[indexPath.item].friend
        navigationController?.pushViewController(controller, animated: true)
    }
}

class MessageCell: BaseCell {
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor(red: 0, green: 134/255, blue: 249/255, alpha: 1) : UIColor.white
            nameLabel.textColor = isHighlighted ? UIColor.white : UIColor.black
            timeLabel.textColor = isHighlighted ? UIColor.white : UIColor.black
            messageLabel.textColor = isHighlighted ? UIColor.white : UIColor.black
        }
    }
    
    var message: Message? {
        didSet {
            if let name = message?.friend?.name,
               let profileImage = message?.friend?.profileImageName,
               let messageText = message?.text,
               let date = message?.date {
                
                nameLabel.text = name
                profileImageView.image = UIImage(named: profileImage)
                hasRedImageView.image = UIImage(named: profileImage)
                messageLabel.text = messageText
                
                let dateFormater = DateFormatter()
                dateFormater.dateFormat = "hh:mm a"
                
                let elapsedTimeInSeconds = NSDate().timeIntervalSince(date as Date)
                let secondInDays: TimeInterval = 60 * 60 * 24
                
                if elapsedTimeInSeconds > 7 * secondInDays {
                    dateFormater.dateFormat = "MM/dd/yy"
                } else if elapsedTimeInSeconds > secondInDays {
                    dateFormater.dateFormat = "EEE"
                }
                
                timeLabel.text = dateFormater.string(from: date as Date)
            }
        }
    }
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "zurkerberg")
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 34
        iv.layer.masksToBounds = true
        return iv
    }()
    
    let dividerLineView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        return v
    }()
    
    let containView : UIView = {
        let containView = UIView()
        return containView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Friend Name"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "Your friend's message and something else..."
        label.textColor = .darkGray
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "12: 05 pm"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .right
        return label
    }()
    
    let hasRedImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "zurkerberg")
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 10
        iv.layer.masksToBounds = true
        return iv
    }()
    
    override func setupViews() {
        addSubview(profileImageView)
        addSubview(dividerLineView)
        setupContainerView()
        
        profileImageView.anchor(top: nil, leading: centerXAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 68, height: 68))
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5).isActive = true
        
        dividerLineView.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 82, bottom: 0, right: 0), size: .init(width: 0, height: 1))
    }
    
    private func setupContainerView() {
        addSubview(containView)
        containView.addSubview(nameLabel)
        containView.addSubview(messageLabel)
        containView.addSubview(timeLabel)
        containView.addSubview(hasRedImageView)
        
        containView.anchor(top: profileImageView.topAnchor, leading: profileImageView.trailingAnchor, bottom: profileImageView.bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 5, bottom: 0, right: 0), size: .init(width: 0, height: 0))
        
        nameLabel.anchor(top: containView.topAnchor, leading: containView.leadingAnchor, bottom: nil, trailing: timeLabel.leadingAnchor, padding: .init(top: 4, left: 4, bottom: 0, right: 0), size: .init(width: 0, height: 20))
        
        messageLabel.anchor(top: nameLabel.bottomAnchor, leading: containView.leadingAnchor, bottom: containView.bottomAnchor, trailing: containView.trailingAnchor, padding: .init(top: 0, left: 4, bottom: 0, right: 0), size: .init(width: 0, height: 20))
        
        timeLabel.anchor(top: containView.topAnchor, leading: nil, bottom: nil, trailing: containView.trailingAnchor, padding: .init(top: 4, left: 0, bottom: 0, right: 4), size: .init(width: 100, height: 20))
        
        hasRedImageView.anchor(top: timeLabel.bottomAnchor, leading: nil, bottom: nil, trailing: containView.trailingAnchor, padding: .init(top: 4, left: 0, bottom: 0, right: 4), size: .init(width: 20, height: 20))
    }
}

class BaseCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
    }
}

