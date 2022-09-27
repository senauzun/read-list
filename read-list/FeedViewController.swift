//
//  FeedViewController.swift
//  read-list
//
//  Created by Sena Uzun on 24.09.2022.
//

import UIKit
import Firebase
import SDWebImage
import FirebaseStorage

class FeedViewController: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {

    


    @IBOutlet weak var myCell: UICollectionView!
    
    var userEmailArray = [String]()
    var bookArray = [String]()
    var writerArray = [String]()
    var likeArray = [Int]()
    var userImageArray = [String]()
    var documentIdArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        myCell.dataSource = self
        myCell.delegate = self
        
        getDataFromFirestore()
    }
    

    func getDataFromFirestore(){
        
        let firestoreDatabase = Firestore.firestore()
        firestoreDatabase.collection("Books").order(by: "date" , descending: true)
            .addSnapshotListener { snapshot, error in
                if error != nil {
                    print(error?.localizedDescription)
                }
                else{
                    if snapshot?.isEmpty != true && snapshot != nil{
                        self.userEmailArray.removeAll(keepingCapacity: false)
                        self.documentIdArray.removeAll(keepingCapacity: false)
                        self.writerArray.removeAll(keepingCapacity: false)
                        self.bookArray.removeAll(keepingCapacity: false)
                        self.likeArray.removeAll(keepingCapacity: false)
                        self.userImageArray.removeAll(keepingCapacity: false)
                        
                        
                        for document in snapshot!.documents {
                            let documentid = document.documentID
                            self.documentIdArray.append(documentid)
                            
                            if let postedBy = document.get("postedBy") as? String {
                                self.userEmailArray.append(postedBy)
                            }
                            if let bookTitle = document.get("bookTitle") as? String {
                                self.bookArray.append(bookTitle)
                                
                            }
                            if let writer = document.get("writer") as? String{
                                self.writerArray.append(writer)
                            }
                            if let likes = document.get("wishList") as? Int {
                                self.likeArray.append(likes)
                            }
                            if let imageUrl = document.get("imageUrl") as? String {
                                self.userImageArray.append(imageUrl)
                            }
                        }
                        self.myCell.reloadData()

                    }
                }
            }
        
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = myCell.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! Cell
        cell.userEmail.text = userEmailArray[indexPath.row]
        cell.likeLabel.text = String(likeArray[indexPath.row])
        cell.bookTitle.text = bookArray[indexPath.row]
        cell.writer.text = writerArray[indexPath.row]
        cell.documentID.text = documentIdArray[indexPath.row]
        cell.imageView.sd_setImage(with: URL(string: self.userImageArray[indexPath.row]))
        cell.layer.cornerRadius = 5
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.blue.cgColor
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userEmailArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let heightSize: CGFloat = 450
        let size = (collectionView.frame.size.width - 10 )/2
        return CGSize(width: size, height: heightSize)
    }

}
