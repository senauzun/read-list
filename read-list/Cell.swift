//
//  Cell.swift
//  read-list
//
//  Created by Sena Uzun on 27.09.2022.
//

import UIKit
import Firebase

class Cell: UICollectionViewCell {
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var documentID: UILabel!
    @IBOutlet weak var writer: UILabel!
    @IBOutlet weak var bookTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


    
    
    @IBAction func wishListClicked(_ sender: Any) {
        
        let firestoraDatabase = Firestore.firestore()
        
        if let likeCount = Int(likeLabel.text!){
            
            let likeStore = ["wishList" : likeCount + 1] as [String : Any] //cast etmek zorundayız
            firestoraDatabase.collection("Books").document(documentID.text!)
                .setData(likeStore, merge: true)

        }
    }
}
