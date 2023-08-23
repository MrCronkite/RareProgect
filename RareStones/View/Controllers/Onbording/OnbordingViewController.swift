//
//  OnbordingViewController.swift
//  RareStones
//
//  Created by admin1 on 17.08.23.
//

import UIKit

final class OnbordingViewController: UIViewController {
    
    var currentIndex: Int = 0
    
    let titles = ["Recognize stones and find out their estimated value", "Useful information for finding the most expensive stones", "Open up limitless possibilities"]
    let animation = ["anim01", "anim02"]
    
    let nextButton: UIButton = {
        let view = UIButton()
        view.setTitle("Continue", for: .normal)
        view.backgroundColor = R.Colors.roseBtn
        view.setTitleColor(.white, for: .normal)
        view.layer.cornerRadius = 25
        return view
    }()
    
    var pageViewController: UIPageViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupPageViewController()
        setupView()
        let vc = StartViewController()
        vc.modalPresentationStyle = .fullScreen
        DispatchQueue.main.async {
            self.present(vc, animated: false)
        }
    }
}

extension OnbordingViewController {
    private func setupView() {
        [nextButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -37),
            nextButton.heightAnchor.constraint(equalToConstant: 54),
            nextButton.widthAnchor.constraint(equalToConstant: 311),
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    private func setupPageViewController() {
        pageViewController = UIPageViewController(transitionStyle: .scroll,
                                                  navigationOrientation: .horizontal,
                                                  options: nil)
        
        if let firstViewController = viewControllerAtIndex(0) {
            pageViewController.setViewControllers([firstViewController],
                                                  direction: .forward,
                                                  animated: true,
                                                  completion: nil)
        }
        
        pageViewController.dataSource = self
        pageViewController.delegate = self
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
    }
    
    @objc func nextButtonTapped() {
        currentIndex += 1
        if let nextViewController = viewControllerAtIndex(currentIndex) {
            pageViewController.setViewControllers([nextViewController],
                                                  direction: .forward,
                                                  animated: true,
                                                  completion: nil)
        }
    }
}

extension OnbordingViewController: StartFreeViewControllerDelegate {
    func showButton() {
        UIView.animate(withDuration: 0.5) {
            self.nextButton.backgroundColor = .white
            self.nextButton.isHidden = true
        }
        
    }
}

extension OnbordingViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func viewControllerAtIndex(_ index: Int) -> UIViewController? {
        if index >= 0 && index < 2 {
            let contentViewController = BaseViewOnbording(subtitle: titles[index],
                                                          nameAnimation: animation[index])
            return contentViewController
        } else {
            let vc = StartFreeViewController()
            vc.delegate = self
            return vc
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let index = titles.firstIndex(of: (viewController.view.subviews.first as? UILabel)?.text ?? "") {
            let previousIndex = (index - 1 + titles.count) % titles.count
            if previousIndex < 2 {
                return viewControllerAtIndex(previousIndex)
            }
        } else if currentIndex == 2 {
            return viewControllerAtIndex(1)
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let index = titles.firstIndex(of: (viewController.view.subviews.first as? UILabel)?.text ?? "") {
            let nextIndex = (index + 1) % titles.count
            return viewControllerAtIndex(nextIndex)
        } else if currentIndex == 3 {
            return nil
        }
        return nil
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return currentIndex
    }
    
        func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
            if let viewController = pendingViewControllers.first, let index = titles.firstIndex(of: (viewController.view.subviews.first as? UILabel)?.text ?? "") {
    
                currentIndex = index
                if index == 1 {
                    UIView.animate(withDuration: 0.5) {
                        self.nextButton.backgroundColor = R.Colors.roseBtn
                        self.nextButton.isHidden = false
                    }
                }
            }
        }
}
