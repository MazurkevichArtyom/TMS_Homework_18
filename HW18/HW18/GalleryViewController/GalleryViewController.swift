//
//  GalleryViewController.swift
//  HW18
//
//  Created by Artem Mazurkevich on 10.04.2022.
//

import UIKit

class GalleryViewController: UIViewController {
    
    private let cellsSpacing: CGFloat = 2.0
    private let cellsInRow: CGFloat = 3
    private let galleryCellKey = "galleryCell"
    
    var delegate: GalleryDelegate?
    
    override func loadView() {
        let customView = UIView(frame: UIScreen.main.bounds)
        customView.backgroundColor = .white
        view = customView
        setupUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    private func setupUI() {
        let customNavigationBar = UINavigationBar()
        customNavigationBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(customNavigationBar)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(onCancelButton))
        let navigationItem = UINavigationItem(title: "Gallery")
        navigationItem.leftBarButtonItem = doneButton
        customNavigationBar.items = [navigationItem]
        
        customNavigationBar.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
        customNavigationBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        customNavigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        customNavigationBar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        let flowLayout = UICollectionViewFlowLayout()
        let cellSize = (view.bounds.width - (cellsInRow - 1) * cellsSpacing) / cellsInRow
        flowLayout.sectionInset = .zero
        flowLayout.minimumLineSpacing = cellsSpacing
        flowLayout.minimumInteritemSpacing = cellsSpacing
        flowLayout.itemSize = CGSize(width: cellSize, height: cellSize)
        flowLayout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(GalleryViewCell.self, forCellWithReuseIdentifier: galleryCellKey)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        collectionView.topAnchor.constraint(equalTo: customNavigationBar.bottomAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    @objc private func onCancelButton() {
        dismiss(animated: true)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension GalleryViewController : UICollectionViewDelegate & UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return delegate?.images.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: galleryCellKey, for: indexPath) as? GalleryViewCell {
            if let image = delegate?.images[indexPath.row] {
                cell.imageView.image = image
            }
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}
