//
//  ViewController.swift
//  fbMessager
//
//  Created by MAC on 3/15/18.
//  Copyright © 2018 MAC. All rights reserved.
//

import UIKit

class Friend {
    var name: String?
    var profileImageName: String?
}

class Message {
    var text: String?
    var date: Date?
    
    var friend: Friend?
}

class ViewController: UIViewController {

    private let cellId = "Cell"
    
    var messages: [Message]?
    
    private func setupData() {
        let mark = Friend()
        mark.name = "Mark Zukerberg"
        mark.profileImageName = "zurkerberg"
        
        let messageMark = Message()
        messageMark.friend = mark
        messageMark.text = "Hello, my name is Mark. Nice to meet you..."
        messageMark.date = Date()
        
        let steve = Friend()
        mark.name = "Steve job"
        mark.profileImageName = "stevejob"
        
        let messageSteve = Message()
        messageSteve.friend = steve
        messageSteve.text = "Apple creates great IOS for the world..."
        messageSteve.date = Date()
        
        messages = [messageMark, messageSteve]
    }
    // ep2 9:28
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
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
}

class MessageCell: BaseCell {
    
    var message: Message? {
        didSet {
            if let name = message?.friend?.name,
               let profileImage = message?.friend?.profileImageName,
               let messageText = message?.text,
               let date = message?.date {
                
                nameLabel.text = name
                profileImageView.image = UIImage(named: profileImage)
                messageLabel.text = messageText
                
                let dateFormater = DateFormatter()
                dateFormater.dateFormat = "hh:mm a"
                timeLabel.text = dateFormater.string(from: date)
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

