//
//  ViewController.swift
//  GalleryViewController
//
//  Created by Joyce Echessa on 6/3/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

import UIKit

class GalleryViewController: UIViewController {

    //MARK: Parameters
    private lazy var imageNames: [String] = {
        var names = [String]()
        let fileManager = NSFileManager.defaultManager()
        let str = NSBundle.mainBundle().resourcePath
        let resource = str! + "/Images"
        do {
            let contents = try fileManager.contentsOfDirectoryAtPath(resource)
            for image in contents {
                let imagePath = resource + "/\(image)"
                names.append(imagePath)
            }
        } catch {
        }

        return names
    }()

    private let imagesCacheDimension: Int = 3

    var imageViews  = [UIImageView]()

    var pageWidth: CGFloat {
        return self.view.frame.width
    }

    var pageHeight: CGFloat {
        return self.view.frame.height
    }

    var screenIsRotating = false

    var currentPage = Int(0)
    var lastPage: Int = 0
    var indexLastTransition: (Int, Int) = (0, 0)

    var scrollWidth = CGFloat()
    //MARK:-

    //MARK: Lazy parameters

    lazy private var leftArrowBarButton: UIBarButtonItem = {
        let leftButton = UIBarButtonItem(
            image: UIImage(imageLiteral: "leftarrow"),
            style: .Plain,
            target: self,
            action: #selector(arrowBarButtonAction))
        return leftButton
    }()

    lazy private var rightArrowBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(imageLiteral: "rightarrow"),
            style: .Plain,
            target: self,
            action: #selector(arrowBarButtonAction))
        return button
    }()

    lazy private var scrollView: UIScrollView = {

        let scrollView = UIScrollView(frame: self.view.frame)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollEnabled = true
        scrollView.pagingEnabled = true
        scrollView.bounces = false
        scrollView.backgroundColor = UIColor.blackColor()
        scrollView.delegate = self

        self.view.addSubview(scrollView)

        return scrollView
    }()

    lazy var navigationFlow: NavigationFlow = {
        return NavigationFlow(imagesCacheDimension: self.imagesCacheDimension)
    }()
    //MARK:-

    override func viewWillLayoutSubviews() {
        if scrollWidth != scrollView.frame.width {
            //disable scrollViewDidScroll(_:)
            screenIsRotating = true

            self.scrollView.contentSize = CGSize.init(
                width: pageWidth * CGFloat(imageViews.count),
                height: pageHeight)

            self.scrollView.scrollRectToVisible(imageViews[currentPage].frame,
                                                animated: false)
            scrollWidth = self.scrollView.frame.width
        }
        screenIsRotating = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Photo gallery"

        configureView()
        setupNavigationItem()
        setupAutoLayoutConstrains()

        //Load the templates for future photo
        for _ in imageNames {
            loadTemplateForImage()
        }
        loadInitialImageViews()
        disableBarButtonIfNeed()
    }

    //MARK: Help functions
    func loadInitialImageViews() {
        for i in 0...imagesCacheDimension/2 {
            imageViews[i].image = UIImage(contentsOfFile: imageNames[i])
        }
    }

    func loadImagesForCurrentPage() {
        navigationFlow.direction = nil
        if lastPage - currentPage > 0 {
            navigationFlow.direction = .Left
        } else if lastPage - currentPage < 0 {
            navigationFlow.direction = .Rigth
        }

        if  navigationFlow.direction == nil || (lastPage, currentPage) == indexLastTransition {
            return
        }

        let deletionIdx = navigationFlow.indexOfPhotoToDelete(
            forPage: currentPage)

        let loadingIdx = navigationFlow.indexOfPhotoToLoad(forPage: currentPage)

        if deletionIdx >= 0 && deletionIdx < imageViews.count {
            imageViews[deletionIdx].image = nil
        }

        if loadingIdx >= 0 && loadingIdx < imageViews.count {
            imageViews[loadingIdx].image = UIImage(
                contentsOfFile: imageNames[loadingIdx])
        }

        //to avoid same loadings
        indexLastTransition = (lastPage, currentPage)
    }

    func loadTemplateForImage() {
        let frame = CGRect.init(
            x: pageWidth*CGFloat(imageViews.count),
            y: 0,
            width: pageWidth,
            height: pageHeight)

        let newImage = UIImageView(frame: frame)

        var leftView: UIView = self.scrollView

        if let lastImage = imageViews.last {
            leftView = lastImage
        }
        scrollView.addSubview(newImage)

        newImage.snp_makeConstraints { (make) in
            make.top.bottom.width.equalTo(view)
            make.left.equalTo(leftView.snp_right)
        }

        newImage.contentMode = .ScaleAspectFit

        imageViews.append(newImage)

        self.scrollView.contentSize = CGSize.init(
            width: self.scrollView.contentSize.width + pageWidth,
            height: pageHeight)
    }

    private func moveToPageInDirection (direction: NavigationDirection) {
        UIView.animateWithDuration(0.2) {
        self.scrollView.scrollRectToVisible(
            self.imageViews[self.currentPage + direction.rawValue].frame,
            animated: false)
        }
    }

    func disableBarButtonIfNeed() {
        self.navigationItem.rightBarButtonItem?.enabled = true
        self.navigationItem.leftBarButtonItem?.enabled = true

        if currentPage+1 >= imageViews.count {
            self.navigationItem.rightBarButtonItem?.enabled = false
        }

        if currentPage-1 < 0 {
            self.navigationItem.leftBarButtonItem?.enabled = false
        }
    }

    //MARK: Setup functions

    private func configureView() {
        self.view.backgroundColor = UIColor.whiteColor()
        self.edgesForExtendedLayout = UIRectEdge.None
        self.navigationController?.navigationBar.translucent = false
    }

    func setupNavigationItem() {
        self.navigationItem.leftBarButtonItem = leftArrowBarButton
        self.navigationItem.rightBarButtonItem = rightArrowBarButton
    }

    func setupAutoLayoutConstrains() {
        scrollView.snp_makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(view)
        }
    }

    //MARK: addTarget's function
    @objc func arrowBarButtonAction(sender: UIBarButtonItem) {
        switch sender {
        case leftArrowBarButton:
            moveToPageInDirection(NavigationDirection.Left)
        case rightArrowBarButton:
            moveToPageInDirection(NavigationDirection.Rigth)
        default:
            break
        }
    }
}

//MARK: -
//MARK: Extension
//MARK: - UIScrollViewDelegate

extension GalleryViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(scrollView: UIScrollView) {
        // if screen orientation is changed --> return
        if  screenIsRotating || view.frame.width != scrollWidth {
            return
        }
        currentPage = Int((scrollView.contentOffset.x+pageWidth/2)/pageWidth)
        disableBarButtonIfNeed()
        loadImagesForCurrentPage()
        lastPage = currentPage
    }
}
