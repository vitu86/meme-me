//
//  MemeMeTableViewController.swift
//  MemeMe
//
//  Created by Vitor Costa on 24/10/18.
//  Copyright © 2018 Vitor Costa. All rights reserved.
//

import UIKit

class MemeMeTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Private properties
    private var memes:[Meme] {
        get {
            let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            return appDelegate.memes
        }
        
        set {
            let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.memes = newValue
        }
    }
    
    // MARK: Override functions
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if "showDetail" == segue.identifier {
            let vc:MemeMeDetailViewController = segue.destination as! MemeMeDetailViewController
            vc.meme = (sender as! Meme)
        }
    }
    
    // MARK: Private functions
    private func configureUI() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: Table view functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "MemeMeTableViewCell")!
        let meme:Meme = memes[indexPath.row]
        
        cell.textLabel?.text = meme.topText + " " + meme.bottomText
        cell.textLabel?.lineBreakMode = .byTruncatingMiddle
        cell.imageView?.image = meme.memedImage
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: memes[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            memes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}
