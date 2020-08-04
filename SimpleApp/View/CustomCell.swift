//
//  CustomCell.swift
//  SampleApp
//
//  Created by prashanthi M on 04/08/20.
//  Copyright © 2020 unilever. All rights reserved.
//

import Foundation
import UIKit

class CustomTableViewCell: UITableViewCell {
    
    lazy var userImage: UIImageView = {
        let userImage = UIImageView(frame: .zero)
        userImage.contentMode = .scaleAspectFill
        return userImage
    }()
    
    lazy var namelbl: UILabel = {
        let lbl = UILabel(frame: .zero)
        lbl.textAlignment = .left
        lbl.font = UIFont.boldSystemFont(ofSize: 18)
        lbl.numberOfLines = 0
        
        return lbl
    }()
    
    lazy var desciptionlbl: UILabel = {
        let desciptionlbl = UILabel(frame: .zero)
        desciptionlbl.textAlignment = .left
        desciptionlbl.adjustsFontSizeToFitWidth = true
        desciptionlbl.numberOfLines = 0
        desciptionlbl.lineBreakMode = NSLineBreakMode.byWordWrapping
        return desciptionlbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        userImage.translatesAutoresizingMaskIntoConstraints = false
        namelbl.translatesAutoresizingMaskIntoConstraints = false
        desciptionlbl.translatesAutoresizingMaskIntoConstraints = false
        contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 120).isActive = true
        
        contentView.addSubview(userImage)
        contentView.addSubview(namelbl)
        contentView.addSubview(desciptionlbl)
        
        NSLayoutConstraint.activate([
            userImage.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor,constant: 8),
            userImage.trailingAnchor.constraint(equalTo: self.namelbl.leadingAnchor,constant: -8),
            userImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            userImage.heightAnchor.constraint(equalToConstant: 100),
            userImage.widthAnchor.constraint(equalToConstant: 100)
            ])
        
        NSLayoutConstraint.activate([
            namelbl.leadingAnchor.constraint(equalTo: self.userImage.trailingAnchor,constant: 8),
            namelbl.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor,constant: -8),
            namelbl.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16),
            namelbl.bottomAnchor.constraint(equalTo: self.desciptionlbl.topAnchor,constant: -8),
            namelbl.heightAnchor.constraint(equalToConstant: 20),
            ])
        NSLayoutConstraint.activate([
            desciptionlbl.leadingAnchor.constraint(equalTo: self.userImage.trailingAnchor,constant: 8),
            desciptionlbl.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor,constant: -8),
            desciptionlbl.topAnchor.constraint(equalTo: self.namelbl.bottomAnchor, constant: 8),
            desciptionlbl.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor,constant: -16)
            ])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        contentView.backgroundColor = UIColor.clear
        userImage.layer.cornerRadius = 50
        userImage.clipsToBounds = true
    }
    
    func configureCell(withViewModel viewModel : Rows){
        namelbl.text = viewModel.title == nil ?  "NA" : viewModel.title ?? ""
        desciptionlbl.text = viewModel.description == nil ? "NA" : viewModel.description ?? ""
        if viewModel.imageHref != nil {
            self.userImage.loadImageUsingCache(withUrl: viewModel.imageHref!)
        }else{
            self.userImage.image = UIImage(named: "default.png")
        }
        
    }
}

extension UIImageView {
    
    func setCustomImage(_ imgURLString: String?) {
        guard let imageURLString = imgURLString else {
            self.image = UIImage(named: "default.png")
            return
        }
        DispatchQueue.global().async { [weak self] in
            let data = try? Data(contentsOf: URL(string: imageURLString)!)
            DispatchQueue.main.async {
                self?.image = data != nil ? UIImage(data: data!) : UIImage(named: "default.png")
            }
        }
    }
}
let imageCache = NSCache<NSString, UIImage>()
extension UIImageView {
    func loadImageUsingCache(withUrl urlString : String) {
        let url = URL(string: urlString)
        if url == nil {return}
        self.image = nil
        
        // check cached image
        if let cachedImage = imageCache.object(forKey: urlString as NSString)  {
            self.image = cachedImage
            return
        }
        // if not, download image from url
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    imageCache.setObject(image, forKey: urlString as NSString)
                    self.image = image
                    
                }
            }
            
        }).resume()
    }
}

