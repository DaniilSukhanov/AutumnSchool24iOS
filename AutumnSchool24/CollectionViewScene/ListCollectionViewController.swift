//
//  ListCollectionViewController.swift
//  AutmnSchool24
//
//  Created by Emil Shpeklord on 11.08.2024.
//

import UIKit

final class ListCollectionViewController: UIViewController {
    enum Section: Hashable {
        case main(IconsSectionModel)
    }
    
    enum Item: Hashable {
    case icon(IconModel)
        case description(String)
    }
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias DataSnapshot = NSDiffableDataSourceSnapshot<Section, Item>
    typealias SectionDataSnapshot = NSDiffableDataSourceSectionSnapshot<Item>
    typealias CellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Item>
    typealias HeaderRegistration = UICollectionView.SupplementaryRegistration<UICollectionViewListCell>
    

    private var collectionView: UICollectionView!
    private let dataStorage: [IconsSectionModel] = IconsFabric.getModelSections()
    private var dataSource: DataSource!
                                
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDataSource()
        
    }
}

private extension ListCollectionViewController {
    func setupUI() {
        view.backgroundColor = .systemBackground
        setupCollectionView()
    }
    
    func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .clear
        view.addSubview(collectionView)
        
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
        ])
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        var config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        config.headerMode = .supplementary
        return UICollectionViewCompositionalLayout.list(using: config)
    }
    
    func setupDataSource() {
        let cellRegistration = CellRegistration { cell, indexPath, item in
            var content = cell.defaultContentConfiguration()
            switch item {
            case .icon(let iconModel):
                content.text = iconModel.title
                content.secondaryText = iconModel.subtitle
                content.image = iconModel.image
                if !iconModel.description.isEmpty {
                    var disclouserOptins = UICellAccessory.OutlineDisclosureOptions(style: .header)
                    disclouserOptins.tintColor = .lightGray
                    cell.accessories = [.outlineDisclosure(options: disclouserOptins)]
                }
            case .description(let text):
                content.text = text
                cell.accessories = []
            }
            cell.contentConfiguration = content
        }
        
        let headerRegistration = HeaderRegistration(elementKind: UICollectionView.elementKindSectionHeader) { supplementaryView, elementKind, indexPath in
            let section = self.dataStorage[indexPath.section]
            var content = supplementaryView.defaultContentConfiguration()
            content.text = section.title
            supplementaryView.contentConfiguration = content
        }
        dataSource = getDataSource(headerRegistration: headerRegistration, cellRegistartion: cellRegistration)
        collectionView.dataSource = dataSource
        applyData()
        
        
    }
    
    func getDataSource(headerRegistration: HeaderRegistration, cellRegistartion: CellRegistration) -> DataSource {
        let dataSourche = DataSource(collectionView: collectionView) { collectionView, indexPath, item in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistartion, for: indexPath, item: item)
            
        }
        dataSourche.supplementaryViewProvider = { collectionView, kind, indexPath in
            collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }
        return dataSourche
    }
    
    func applyData() {
        var snapshot = DataSnapshot()
        
        dataStorage.forEach {
            let sectionIdentifier = Section.main($0)
            snapshot.appendSections([sectionIdentifier])
        }
        dataSource.apply(snapshot, animatingDifferences: true)
        dataStorage.forEach {
            let sectionIdentifier = Section.main($0)
            var sectionShapshot = SectionDataSnapshot()
            for icon in $0.icons {
                let iconItem = Item.icon(icon)
                sectionShapshot.append([iconItem])
                if !icon.description.isEmpty {
                    let descriptionItem = icon.description.map { Item.description($0) }
                    sectionShapshot.append(descriptionItem, to: iconItem)
                }
            }
            dataSource.apply(sectionShapshot, to: sectionIdentifier, animatingDifferences: true)
        }
    }
}
