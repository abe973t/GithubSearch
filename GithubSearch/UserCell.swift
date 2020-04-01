//
//  UserCell.swift
//  GithubSearch
//
//  Created by mcs on 4/1/20.
//  Copyright © 2020 MCS. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {
    
    var imgView: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    var userNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    var repoLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addViews()
    }
    
    func addViews() {
        addSubview(imgView)
        
        addConstraints()
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            imgView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            imgView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            imgView.heightAnchor.constraint(equalToConstant: 75),
            imgView.widthAnchor.constraint(equalToConstant: 80),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
