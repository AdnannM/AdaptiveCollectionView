//
//  ViewController.swift
//  AdaptiveCollectionView
//
//  Created by Adnann Muratovic on 23.08.21.
//

import UIKit

class DoodleViewController: UIViewController {
    
    // MARK: -Properties
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let officeImages = (1...14).map {
        "office-\($0)"
    }
    
    private let kitchenImages = (1...20).map {
        "kitchen-\($0)"
    }
    
    private let macbookImages = (1...30).map {
        "macbook-\($0)"
    }
    
    lazy var dataSource = configureDataSource()
    
    enum Section: Int {
        case office
        case kitchen
        case macbook
        
        var columnCount: Int {
            switch self {
            case .office: return 1
            case .kitchen: return 2
            case .macbook: return 2
            }
        }
        
        var name: String {
            switch self {
            case .office: return "Office"
            case .kitchen: return "Kitchen"
            case .macbook: return "Macbook"
            }
        }
    }
    
    // ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Adaptive"
        
        collectionView.dataSource = dataSource
        collectionView.collectionViewLayout = createMultiGridLayout()
        configureHeader()
        updateSnapshot()
        
    }
    
    // MARK: - Grid Layout
    
    private func customGridLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25), heightDimension: .fractionalHeight(1.0))

        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)

        let grouSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(80.0))

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: grouSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)

        section.interGroupSpacing = 20.0

        let layout = UICollectionViewCompositionalLayout(section: section)

        return layout
    }
    
    // Multiple Grid Layout
    private func createMultiGridLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            var column = 1
            
            if let dataSection = Section(rawValue: sectionIndex) {
                column = dataSection.columnCount
            }
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0/CGFloat(column)),heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            
            var groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),heightDimension: .absolute(200))
            
            
            // Spacing CollectionView section Row
            if sectionIndex == 0 {
                groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(sectionIndex == 0 ? 200:80))
            } else if sectionIndex == 1 {
                groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(sectionIndex == 1 ? 150:80))
            } else if sectionIndex == 2 {
                groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(sectionIndex == 2 ? 110:80))
            }
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
            
            group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
            
            let section = NSCollectionLayoutSection(group: group)
            
            if sectionIndex == 0 {
                section.orthogonalScrollingBehavior = .continuous
            } else if sectionIndex == 1 {
                section.orthogonalScrollingBehavior = .continuous
            }

            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50))
            
            let headerElement = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: "header", alignment: .top)
            
            section.boundarySupplementaryItems = [headerElement]
            
            return section
        }
        
        return layout
        
    }
}

// MARK: - DataSource and Snapshot
extension DoodleViewController {
    func configureDataSource() -> UICollectionViewDiffableDataSource<Section, String> {
        let dataSource = UICollectionViewDiffableDataSource<Section, String>(collectionView: collectionView) {
            (collectionView, IndexPath, imageName) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: IndexPath) as! DoodleCollectionViewCell
            
            cell.imageView.image = UIImage(named: imageName)
            
            return cell
        }
        
        return dataSource
    }
    
    // Header
    func configureHeader() {
        dataSource.supplementaryViewProvider = {(
            collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            
            if kind == UICollectionView.elementKindSectionFooter {
                return nil
            }
            
            let headerView: SectionCollectionHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header", for: indexPath) as! SectionCollectionHeaderView
            
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            
            headerView.titleLabel.text = section.name
            
            return headerView
        }
    }
    
    func updateSnapshot(animattingChange: Bool = false) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        snapshot.appendSections([.office,.kitchen,.macbook])
        snapshot.appendItems(officeImages, toSection: .office)
        snapshot.appendItems(kitchenImages, toSection: .kitchen)
        snapshot.appendItems(macbookImages, toSection: .macbook)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

