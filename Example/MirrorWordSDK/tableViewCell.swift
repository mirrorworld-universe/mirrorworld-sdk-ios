//
//  tableViewCell.swift
//  MirrorWordSDK_Example
//
//  Created by ZMG on 2022/10/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit

class tableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .black
        self.selectionStyle = .none
        self.contentView.backgroundColor = .darkGray
        contentView.layer.cornerRadius = 5
        setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        contentView.addSubview(titleLbl)
//        contentView.addSubview(textView)
        
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = CGRect(x: 15, y: 10, width: UIScreen.main.bounds.size.width-30, height: self.frame.height-20)
        
    }
    
    
    public lazy var titleLbl:UILabel = {
        let lab = UILabel(frame: CGRect(x: 15, y: 0, width:UIScreen.main.bounds.size.width, height: 30))
        lab.textColor = UIColor(red: 151/255.0, green: 180/255.0, blue: 29/255.0, alpha: 1)
        lab.text = "-"
        return lab
    }()
    
    public lazy var textView:UITextView = {
        let textView = UITextView(frame: CGRect(x:UIScreen.main.bounds.size.width-200, y: 0, width: 200, height: 100))
        return textView
    }()
    
}
