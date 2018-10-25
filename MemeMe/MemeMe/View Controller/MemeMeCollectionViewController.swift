//
//  MemeMeCollectionViewController.swift
//  MemeMe
//
//  Created by Vitor Costa on 24/10/18.
//  Copyright © 2018 Vitor Costa. All rights reserved.
//

import UIKit

class MemeMeCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    
    // MARK: Private properties
    private var memes:[Meme] {
        get {
            let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            return appDelegate.memes
        }
    }
    
    // MARK: Override functions
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        // Wait frame data update. Without this, view.frame.size returns wrong data
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.configureLayout()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if "showDetail" == segue.identifier {
            let vc:MemeMeDetailViewController = segue.destination as! MemeMeDetailViewController
            vc.meme = (sender as! Meme)
        }
    }
    
    // MARK: Private functions
    private func configureUI(){
        collectionView.delegate = self
        collectionView.dataSource = self
        configureLayout()
    }
    
    private func configureLayout() {
        
        let space:CGFloat = 10
        let constraintsMargins:CGFloat = 10
        
        var division:CGFloat = 0
        
        // If device is in landscape mode, change the number of itens in screen
        if UIDevice.current.orientation.isLandscape {
            division = 6
        } else {
            division = 3
        }
        
        let dimension = (view.frame.size.width - (2 * space) - (2 * constraintsMargins)) / division
        
        collectionViewFlowLayout.minimumInteritemSpacing = space
        collectionViewFlowLayout.minimumLineSpacing = space
        collectionViewFlowLayout.itemSize = CGSize(width: dimension, height: dimension)
        
        collectionView.reloadData()
        
    }
    
    // MARK: Collectionview functions
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:MemeMeCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeMeCollectionViewCell", for: indexPath) as! MemeMeCollectionViewCell
        let meme:Meme = memes[indexPath.row]
        
        cell.imageView.image = meme.memedImage
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: memes[indexPath.row])
    }
    
}

// As the collection view cell is not a complex one, I puted it in the same file.
class MemeMeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
}
