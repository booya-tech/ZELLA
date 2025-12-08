//
//  MyFeedCollectionView.swift
//  ZELLA
//
//  Created by Panachai Sulsaksakul on 12/4/25.
//

import Foundation
import SwiftUI 

@available(*, deprecated, message: "This class is deprecated. Use myFeedGridSection(SwiftUI) in HomeView instead for better performance and features.")
class ProductCollectionViewCell: UICollectionViewCell {
    static let identifier = "ProductCollectionViewCell"

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .systemGray5

        return imageView
    }()

    private let brandLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .black
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private let newBadge: UILabel = {
        let label = UILabel()
        label.text = "NEW"
        label.font = .systemFont(ofSize: 10, weight: .semibold)
        label.textColor = .white
        label.backgroundColor = .black
        label.textAlignment = .center
        label.layer.cornerRadius = 4
        label.clipsToBounds = true
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        [imageView, brandLabel, titleLabel, priceLabel].forEach {
            contentView.addSubview($0)
        }

        imageView.addSubview(newBadge)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),

            newBadge.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 6),
            newBadge.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -6),
            newBadge.widthAnchor.constraint(equalToConstant: 35),
            newBadge.heightAnchor.constraint(equalToConstant: 18),

            brandLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            brandLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            brandLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            titleLabel.topAnchor.constraint(equalTo: brandLabel.bottomAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }

    func configure(with item: Item) {
        brandLabel.text = item.brand.uppercased()
        titleLabel.text = item.title
        priceLabel.text = "฿\(String(format: "%.0f", item.price))"
        newBadge.isHidden = item.condition != .newWithTags
        imageView.image = item.localImageName.flatMap { UIImage(named: $0) }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        newBadge.isHidden = true
    }
}

// MARK: - Collection View Controller
class MyFeedCollectionViewController: UIViewController {
    var items: [Item] = []
    var selectedCategory: ItemCategory = .all {
        didSet { if selectedCategory != oldValue { refreshAndLoad() }}
    }
    
    var onItemTap: ((Item) -> Void)?
    
    private var currentPage = 0
    private var isLoading = false
    private var hasMoreItems = true
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .blue
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: ProductCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchData()
    }
    
    private func setupUI() {
        [collectionView, activityIndicator].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0/3.0), heightDimension: .estimated(200))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(200))
        //FIXME: - convert to non deprecated
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func fetchData() {
        currentPage = 0
        hasMoreItems = true
        loadMoreItems()
    }
    
    private func refreshAndLoad() {
        items = []
        collectionView.reloadData()
        currentPage = 0
        hasMoreItems = true
        loadMoreItems()
    }
    
    private func loadMoreItems() {
        guard !isLoading && hasMoreItems else { return }
        
        isLoading = true
        activityIndicator.startAnimating()
        
        let newItems = MockDataService.shared.getItems(page: self.currentPage, pageSize: 20, category: self.selectedCategory)
        
        if newItems.isEmpty {
            self.hasMoreItems = false
        } else {
            self.items.append(contentsOf: newItems)
            self.currentPage += 1
            self.collectionView.reloadData()
        }
        
        self.isLoading = false
        self.activityIndicator.stopAnimating()
    }
}

//MARK: - DataSource & Delegate
extension MyFeedCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.identifier, for: indexPath) as? ProductCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: items[indexPath.item])
        
        if indexPath.item >= items.count - 5 {
            loadMoreItems()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onItemTap?(items[indexPath.item])
    }
}
