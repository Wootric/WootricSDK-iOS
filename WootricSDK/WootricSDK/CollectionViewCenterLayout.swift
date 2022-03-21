import UIKit

class CollectionViewRow {
    var attributes = [UICollectionViewLayoutAttributes]()
    var spacing: CGFloat = 0

    init(spacing: CGFloat) {
        self.spacing = spacing
    }

    func add(attribute: UICollectionViewLayoutAttributes) {
        attributes.append(attribute)
    }

    var rowWidth: CGFloat {
        return attributes.reduce(0, { result, attribute -> CGFloat in
            return result + attribute.frame.width
        }) + CGFloat(attributes.count - 1) * spacing
    }

    func centerLayout(collectionViewWidth: CGFloat) {
        let padding = (collectionViewWidth - rowWidth) / 2
        var offset = padding
        for attribute in attributes {
            attribute.frame.origin.x = offset
            offset += attribute.frame.width + spacing
        }
    }
}

@objc public class CollectionViewCenterLayout: UICollectionViewFlowLayout {
  public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    guard let attributes = super.layoutAttributesForElements(in: rect) else {
        return nil
    }

    var rows = [CollectionViewRow]()
    var currentRowY: CGFloat = -1
    
    for attribute in attributes {
      if currentRowY != attribute.frame.midY {
          currentRowY = attribute.frame.midY
          rows.append(CollectionViewRow(spacing: 10))
      }
      rows.last?.add(attribute: attribute.copy() as! UICollectionViewLayoutAttributes)
    }
    rows.forEach { $0.centerLayout(collectionViewWidth: collectionView?.frame.width ?? 0) }
    return rows.flatMap { $0.attributes }
  }
  
  public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
      guard let layoutAttributes = super.layoutAttributesForItem(at: indexPath) else { return nil }
      guard let collectionView = collectionView else { return nil }
      let collectionWidth = collectionView.safeAreaLayoutGuide.layoutFrame.width
      layoutAttributes.bounds.size.width = collectionWidth - sectionInset.left - sectionInset.right
      return layoutAttributes
  }

  public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
      guard let collectionView = collectionView else { return false }
      return !newBounds.size.equalTo(collectionView.bounds.size)
  }
}
