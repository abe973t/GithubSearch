//
//  RepoCell.swift
//  GithubSearch
//
//  Created by mcs on 4/2/20.
//  Copyright © 2020 MCS. All rights reserved.
//

import UIKit

class RepoCell: UITableViewCell {
    
    var userNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "UserName"
        return lbl
    }()
    
    var forksLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    var starsLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addViews()
    }
    
    func addViews() {
        addSubview(userNameLabel)
        addSubview(forksLabel)
        addSubview(starsLabel)
        
        addConstraints()
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant: 80),
            
            userNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            userNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            userNameLabel.heightAnchor.constraint(equalToConstant: 32),
            userNameLabel.trailingAnchor.constraint(equalTo: forksLabel.leadingAnchor, constant: -10),
            
            forksLabel.topAnchor.constraint(equalTo: userNameLabel.topAnchor),
            forksLabel.heightAnchor.constraint(equalToConstant: 20),
            forksLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            forksLabel.widthAnchor.constraint(equalToConstant: 100),
            
            starsLabel.topAnchor.constraint(equalTo: forksLabel.bottomAnchor, constant: 5),
            starsLabel.heightAnchor.constraint(equalToConstant: 20),
            starsLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            starsLabel.widthAnchor.constraint(equalToConstant: 100),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
