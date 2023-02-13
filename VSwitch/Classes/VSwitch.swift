//
//  VSwitch.swift
//  VSwitch
//
//  Created by karl Kevis on 2023/2/10.
//

import UIKit

public class VSwitch: UIView {
    
    public struct Item:Equatable {
        var image:VImage?
        var title:String?
        var backgroundColor:UIColor?
        private var id = UUID().uuidString
        
        public init(image: VImage? = nil, title: String? = nil, backgroundColor: UIColor? = nil) {
            self.image = image
            self.title = title
            self.backgroundColor = backgroundColor
        }
        
        public static func ==(lhs:Item,rhs:Item) -> Bool {
            return lhs.id == rhs.id
        }
    }
    
    class ItemView:UIStackView {
        lazy var imageThumb = UIImageView()
        lazy var lblTitle = UILabel()
        let item:Item
        var selectedClosure:((Item)->Void)?
        
        init(item:Item,spacing:CGFloat,font:UIFont,image:UIImage?,textColor:UIColor?) {
            self.item = item
            super.init(frame: .zero)
            self.axis = .vertical
            self.alignment = .center
            self.distribution = .fillProportionally
            self.spacing = 0
        
            
            let viewStackHori = UIStackView()
            viewStackHori.axis = .horizontal
            viewStackHori.alignment = .center
            viewStackHori.distribution = .fillProportionally
            viewStackHori.spacing = spacing
            addArrangedSubview(viewStackHori)
            viewStackHori.addArrangedSubview(imageThumb)
            viewStackHori.addArrangedSubview(lblTitle)
            
            imageThumb.isHidden = item.image == nil
            imageThumb.image = image
            lblTitle.isHidden = item.title == nil
            lblTitle.textAlignment = .center
            lblTitle.text = item.title
            lblTitle.font = font
            lblTitle.textColor = textColor
            
            isUserInteractionEnabled = true
            addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAction)))
        }
        
        required init(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        @objc func tapAction() {
            selectedClosure?(item)
        }
        
    }
    
    private var containerView = UIView()
    private var offStackView = UIStackView()
    private var containerOnStackView = UIView()
    private var onStackView = UIStackView()
    private var offViews = [ItemView]()
    private var onViews = [ItemView]()
    private(set) open var items = [Item]() {
        didSet {
            reloadViews()
        }
    }
    
    private var viewMask = UIView()
    
    private var beganViewSelectedFrame = CGRect.zero
    private var viewSelected = UIView()
    
    public let standardItemSize = CGSize(width: 120, height: 50)
    
    /// bewteen item image and lable
    let itemInsetSpacing:CGFloat
    
    let padding:CGFloat
    
    /// Font Image color unselected
    public var offColor:UIColor? {
        didSet {
            offViews.forEach {
                $0.lblTitle.textColor = offColor
            }
        }
    }
    /// Font Image color selected
    public var onColor:UIColor? {
        didSet {
            onViews.forEach {
                $0.imageThumb.image = $0.item.image?.tint(with: onColor)
                $0.lblTitle.textColor = onColor
            }
        }
    }
    
    public var font = UIFont.systemFont(ofSize: 16) {
        didSet {
            offViews.forEach {
                $0.lblTitle.font = font
            }
            onViews.forEach {
                $0.lblTitle.font = font
            }
        }
    }
    
    public var animationDuration: TimeInterval = 0.3
    public var animationSpringDamping: CGFloat = 0.75
    public var animationInitialSpringVelocity: CGFloat = 0.0
    
    private(set) open var selectedIndex:Int? {
        didSet {
            selectedChanged?(selectedIndex)
        }
    }
    
    public var selectedChanged:((Int?)->Void)?
    
    private var panGes:UIPanGestureRecognizer!
    
    public override var intrinsicContentSize: CGSize {
        return CGSize(width: standardItemSize.width*CGFloat(items.count), height: standardItemSize.height)
    }
    
    public init(items:[Item],selectedIndex:Int? = nil,itemInsetSpacing:CGFloat = 0,padding:CGFloat = 0) {
        self.itemInsetSpacing = itemInsetSpacing
        self.padding = padding
        super.init(frame: .zero)
        self.selectedIndex = selectedIndex
        self.items = items
        initViews()
        reloadViews()
        translatesAutoresizingMaskIntoConstraints = false
        viewSelected.addObserver(self, forKeyPath: "frame",options: .new, context: nil)

        panGes = UIPanGestureRecognizer(target: self, action: #selector(panAction(gesture:)))
        panGes.delegate = self
        containerOnStackView.addGestureRecognizer(panGes)
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        guard items.count > 0 else { return }
        let width = (self.bounds.width - padding*2)/CGFloat(items.count)
        let height = frame.height - padding*2
        let x = -width - padding
        viewSelected.frame = CGRect(x: x, y: 0, width: width, height: height)
        if let selectedIndex = selectedIndex {
            setSeletedIndex(index: selectedIndex, animation: false)
        }
    }
    
    deinit {
        viewSelected.removeObserver(self, forKeyPath: "frame")
    }
    
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "frame" {
            viewMask.frame = viewSelected.frame
        }
    }
    
    private func initViews() {
        addSubview(containerView)
        containerView.layoutSuper(edage: UIEdgeInsets(inset: padding))
                
        containerView.addSubview(offStackView)
        offStackView.axis = .horizontal
        offStackView.spacing = 0
        offStackView.distribution = .fillEqually
        offStackView.alignment = .fill
        offStackView.layoutSuper(edage:.zero)
        
        containerView.addSubview(containerOnStackView)
        containerOnStackView.layoutSuper(edage: .zero)
        
        viewMask.backgroundColor = .black
        containerOnStackView.layer.mask = viewMask.layer
        containerOnStackView.addSubview(viewSelected)
        
        containerOnStackView.addSubview(onStackView)
        onStackView.axis = .horizontal
        onStackView.spacing = 0
        onStackView.distribution = .fillEqually
        onStackView.alignment = .fill
        onStackView.layoutSuper(edage:.zero)
        
    }
    
    private func reloadViews() {
        onStackView.subviews.forEach {
            onStackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        offStackView.subviews.forEach {
            offStackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        for item in items {
            let offView = ItemView(item: item,spacing: itemInsetSpacing, font: font, image: item.image, textColor: offColor)
            let onView = ItemView(item: item,spacing: itemInsetSpacing ,font: font, image: item.image?.tint(with: onColor), textColor: onColor)
            offViews.append(offView)
            onViews.append(onView)
            onStackView.addArrangedSubview(onView)
            offStackView.addArrangedSubview(offView)
            onView.selectedClosure = { [weak self] selectedItem in
                if let index = self?.items.firstIndex(where: { $0 == selectedItem }) {
                    self?.setSeletedIndex(index: index, animation: true)
                }
            }
        }
        invalidateIntrinsicContentSize()
    }
}

extension VSwitch {
    public func reloadCornerRadius(radius:CGFloat) {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = radius
        self.viewMask.layer.cornerRadius = max(0, (radius - padding))
        self.viewMask.layer.masksToBounds = true
        self.viewSelected.layer.cornerRadius = viewMask.layer.cornerRadius
        self.viewSelected.layer.masksToBounds = true
    }
    
    public func setSeletedIndex(index:Int,animation:Bool) {
        guard index < items.count else { return }
        guard items.count > 0 else { return }
        selectedIndex = index
        let originX = (self.bounds.width - padding*2)/CGFloat(items.count)*CGFloat(index)
        if animation {
            UIView.animate(withDuration: animationDuration, delay: 0, usingSpringWithDamping: animationSpringDamping, initialSpringVelocity: animationInitialSpringVelocity) {
                self.viewSelected.frame.origin.x = originX
                self.viewSelected.layer.backgroundColor = self.items[index].backgroundColor?.cgColor
            }
        }else {
            viewSelected.frame.origin.x = originX
            viewSelected.layer.backgroundColor = items[index].backgroundColor?.cgColor
        }
    }
}

extension VSwitch:UIGestureRecognizerDelegate {
    
    @objc func panAction(gesture:UIPanGestureRecognizer) {
        if gesture.state == .began {
            beganViewSelectedFrame = viewSelected.frame
        } else if gesture.state == .changed {
            var frame = beganViewSelectedFrame
            frame.origin.x += gesture.translation(in: self).x
            frame.origin.x = max(min(frame.origin.x, bounds.width - padding - frame.width), padding)
            viewSelected.frame = frame
        } else {
            let index = max(0, min(items.count - 1, Int(viewSelected.center.x / (bounds.width / CGFloat(items.count)))))
            setSeletedIndex(index: index, animation: true)
        }
    }
    
    override open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == panGes {
            return viewSelected.frame.contains(gestureRecognizer.location(in: self))
        }
        return super.gestureRecognizerShouldBegin(gestureRecognizer)
    }
}
