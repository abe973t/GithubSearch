//
//  UserCell.swift
//  GithubSearch
//
//  Created by mcs on 4/1/20.
//  Copyright © 2020 MCS. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {
    
    var user: User?
    
    var imgView: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    var userNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "UserName"
        return lbl
    }()
    
    var repoLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Repo: ##"
        return lbl
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .systemRed
        addViews()
    }
    
    func addViews() {
        addSubview(imgView)
        addSubview(userNameLabel)
        addSubview(repoLabel)
        
        addConstraints()
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant: 80),
            
            imgView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            imgView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            imgView.heightAnchor.constraint(equalToConstant: 60),
            imgView.widthAnchor.constraint(equalToConstant: 55),
            
            userNameLabel.leadingAnchor.constraint(equalTo: imgView.trailingAnchor, constant: 10),
            userNameLabel.topAnchor.constraint(equalTo: imgView.topAnchor),
            userNameLabel.heightAnchor.constraint(equalTo: imgView.heightAnchor),
            userNameLabel.trailingAnchor.constraint(equalTo: repoLabel.leadingAnchor, constant: -10),
            
            repoLabel.widthAnchor.constraint(equalToConstant: 100),
            repoLabel.topAnchor.constraint(equalTo: userNameLabel.topAnchor),
            repoLabel.heightAnchor.constraint(equalTo: userNameLabel.heightAnchor),
            repoLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
