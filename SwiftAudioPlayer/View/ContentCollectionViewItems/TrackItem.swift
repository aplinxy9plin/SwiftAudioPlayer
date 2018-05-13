//
//  TrackItem.swift
//  SwiftAudioPlayer
//
//  Created by Tobias Dunkel on 29.04.18.
//  Copyright © 2018 Tobias Dunkel. All rights reserved.
//

import Cocoa

protocol TrackItemDelegate {
  func trackItemDoubleAction(_ trackItem: TrackItem)
}

class TrackItem: NSCollectionViewItem {
  
  var delegate: TrackItemDelegate?
  
  var track: Track? = nil {
    didSet {
      guard let track = track else { return }
      if let artist = track.artist, let title = track.title {
        trackTitleLabel.stringValue = "\(artist) - \(title)"
      } else {
        trackTitleLabel.stringValue = "\(track.filename)"
      }
      durationLabel.stringValue = track.duration?.durationText ?? ""
    }
  }
  
  let stackView: NSStackView = {
    let stack = NSStackView()
    stack.orientation = .horizontal
    stack.alignment = .centerY
    stack.spacing = 4
    stack.edgeInsets = .init(top: 0, left: 0, bottom: 0, right: 4)
    stack.setClippingResistancePriority(.required, for: .horizontal)
    stack.translatesAutoresizingMaskIntoConstraints = false
    return stack
  }()
  
  let trackArtistLabel: Label = {
    let label = Label()
    label.stringValue = " Artist"
    label.font = NSFont.systemFont(ofSize: 12)
    label.setContentCompressionResistancePriority(.required, for: .horizontal)
    label.alignment = .left
    return label
  }()
  
  let trackTitleLabel: Label = {
    let label = Label()
    label.stringValue = " Super Long and awesome Track Title"
    label.font = NSFont.systemFont(ofSize: 12)
    label.alignment = .left
    return label
  }()
  
  let durationLabel: Label = {
    let label = Label()
    label.stringValue = "03:20"
    label.font = NSFont.monospacedDigitSystemFont(ofSize: 10, weight: NSFont.Weight.regular)
    label.setContentCompressionResistancePriority(.required, for: .horizontal)
    label.alignment = .center
    return label
  }()
  
  let trackNumberLabel: Label = {
    let label = Label()
    label.stringValue = ""
    label.font = NSFont.systemFont(ofSize: 8)
    label.textColor = .gray
    label.setContentCompressionResistancePriority(.required, for: .horizontal)
    label.alignment = .right
    label.translatesAutoresizingMaskIntoConstraints = false
    label.widthAnchor.constraint(equalToConstant: 24).isActive = true
    return label
  }()
  
  override var isSelected: Bool {
    didSet {
      changeView(forSelectedState: isSelected)
    }
  }
  
  override func loadView() {
    self.view = NSView()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
  }
  
  private func setupViews() {
    view.addSubview(stackView)
    stackView.fill(to: self.view)
    
    let leadingViews: [NSView] = [trackNumberLabel, trackTitleLabel]
    let centerViews: [NSView] = []
    let trailingViews: [NSView] = [durationLabel]
    
    leadingViews.forEach { stackView.addView($0, in: .leading) }
    centerViews.forEach { stackView.addView($0, in: .center) }
    trailingViews.forEach { stackView.addView($0, in: .trailing) }
  }
  
  private func changeView(forSelectedState isSelected: Bool) {
    if isSelected {
      view.wantsLayer = true
      view.layer?.backgroundColor = NSColor.selectedTextBackgroundColor.cgColor
      view.layer?.cornerRadius = 4
      trackTitleLabel.textColor = NSColor.selectedTextColor
      durationLabel.textColor = NSColor.selectedTextColor
    } else {
      view.layer = nil
      view.wantsLayer = false
      let defaultLabel = Label()
      trackTitleLabel.textColor = defaultLabel.textColor
      durationLabel.textColor = defaultLabel.textColor
    }
  }
  
  override func mouseDown(with event: NSEvent) {
    if event.clickCount > 1 {
      print("double clicked")
      delegate?.trackItemDoubleAction(self)
    } else {
      super.mouseDown(with: event)
    }
  }
}
