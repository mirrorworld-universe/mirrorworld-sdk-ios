//
//  inputParamsView.swift
//  MirrorWorldSDK_Example
//
//  Created by ZMG on 2022/12/2.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit

enum paramsData {
    case email
    case collection_mint
    case name
    case symbol
    case url
    case seller_fee_basis_points
    
    case limit
    case next_before
    case signature
    case to_publickey
    case amount
    case token_mint
    case decimals
    
    case mint_address
    case price
    
    case to_wallet_address
    
    case update_authorities
    case offset
    case creators
    case owners
    
    
    var keyText:String{
        switch self {
        case .email:
            return "email"
        case .collection_mint:
            return "collection_mint"
        case .name:
            return "name"
        case .symbol:
            return "symbol"
        case .url:
            return "url"
        case .seller_fee_basis_points:
            return "seller_fee_basis_points"
        case .limit:
            return "limit"
        case .next_before:
            return "next_before"
        case .signature:
            return "signature"
        case .to_publickey:
            return "to_publickey"
        case .amount:
            return "amount"
        case .token_mint:
            return "token_mint"
        case .decimals:
            return "decimals"
        case .mint_address:
            return "mint_address"
        case .price:
            return "price"
        
        case .to_wallet_address:
            return "to_wallet_address"
        case .update_authorities:
            return "update_authorities"
        case .offset:
            return "offset"
        case .creators:
            return "creators"
        case .owners:
            return "owners"
        default:
            return ""
        }
    }
    var valueText:Any?{
        return UserDefaults.standard.object(forKey: self.keyText)
    }
    
}
class inputParamsView: UIView {
    var paramtersJson:((_ params:[paramsData])->Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 8
        self.backgroundColor = .lightGray
        
    }
    
    deinit {
        print("view deinit")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let hh = (allKeys.count*40) + 100 + (allKeys.count*10)

        cancelBtn.frame = CGRect(x: 10, y: CGFloat(hh)-50, width: (self.frame.size.width-30)*0.5, height: 40)
        sureBtn.frame = CGRect(x: cancelBtn.frame.maxX+10, y: CGFloat(hh)-50, width: (self.frame.size.width-30)*0.5, height: 40)
        titleLbl.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: 30)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var allKeys:[paramsData] = []
    func setParams(keys:[paramsData]?){
        guard let allKey = keys else { return }
        allKeys = allKey
        var Y = 50.0
        var tag = 10
        allKey.forEach { data in
            creatTextFiled(tag: tag, Y: Y,data: data).forEach { textF in
                self.addSubview(textF)
            }
            Y += 45
            tag += 1
        }
        let xx = self.frame.minX
        let yy = self.frame.minY
        let ww = self.frame.width
        let hh = (allKeys.count*40) + 100 + (allKeys.count*10)
        self.frame = CGRect(x: xx, y: yy, width: ww, height: CGFloat(hh))
        addSubview(cancelBtn)
        addSubview(sureBtn)
        addSubview(titleLbl)
    }
    func creatTextFiled(tag:Int,Y:CGFloat,data:paramsData) ->[UITextField]{
        let key = UITextField(frame: CGRect(x: 15, y: Y, width: (UIScreen.main.bounds.size.width-80)*0.5, height: 40))
        key.backgroundColor = .lightText
        key.textColor = UIColor(red: 151/255.0, green: 200/255.0, blue: 29/255.0, alpha: 1)
        key.layer.cornerRadius = 5
        key.layer.borderColor = UIColor(red: 151/255.0, green: 180/255.0, blue: 29/255.0, alpha: 1).cgColor
        key.layer.borderWidth = 2
        key.text = data.keyText
        key.tag = tag
        key.textAlignment = .center
        key.placeholder = "key"
        key.adjustsFontSizeToFitWidth = true
        
        let value = UITextField(frame: CGRect(x: key.frame.maxX+10, y: Y, width: (UIScreen.main.bounds.size.width-50)*0.5, height: 40))
        value.backgroundColor = .lightText
        value.textColor = UIColor(red: 151/255.0, green: 180/255.0, blue: 29/255.0, alpha: 1)
        value.layer.borderColor = UIColor(red: 151/255.0, green: 180/255.0, blue: 29/255.0, alpha: 1).cgColor
        value.layer.borderWidth = 2
        value.layer.cornerRadius = 5
        value.tag = tag+100
        value.textAlignment = .center
        value.placeholder = "value"
        value.adjustsFontSizeToFitWidth = true
        if ((data.valueText as? String)?.count ?? 0) > 0 {
            value.text = (data.valueText as? String) ?? ""
        }
       
        return [key,value]
    }
    
    private lazy var cancelBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("Cancel", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 5

        return btn
    }()
    @objc func cancelAction(){
        self.subviews.forEach { sub in
            sub.removeFromSuperview()
        }
        self.removeFromSuperview()
    }
    private lazy var sureBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("Ok", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 5
        btn.addTarget(self, action: #selector(okAction), for: .touchUpInside)

        return btn
    }()
    @objc func okAction(){
        
        var paramters:[paramsData] = []
        allKeys.forEach { data in
            self.subviews.forEach { subView in
                if subView.isKind(of: UITextField.self){
                    let tf = subView as! UITextField
                    if tf.text == data.keyText{
                        let valueTf = self.viewWithTag(tf.tag+100) as! UITextField
                        let value = valueTf.text
                        UserDefaults.standard.set(value, forKey: data.keyText)
                        UserDefaults.standard.synchronize()
                        paramters.append(data)
                    }
                }
            }
        }
        print(paramters)
        paramtersJson?(paramters)
        
        cancelAction()
    }
    private lazy var titleLbl:UILabel = {
        let lab = UILabel()
        lab.textColor = .black
        lab.textAlignment = .center
        lab.text = "parameters"
        return lab
    }()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.endEditing(true)
    }
    
}
