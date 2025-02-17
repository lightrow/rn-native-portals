import Foundation
import UIKit

class PortalOrigin: UIView, PortalView {
  
  var registry: PortalRegistry
  var lastDestination: PortalDestination?
  
  @objc var destination: NSString {
    willSet(newDestination) {
      restituteIfNeeded(destinationName: newDestination as NSString?)
      registry.remove(origin: self)
    }
    didSet {
      destination = destination as NSString? ?? ""
      registry.put(origin: self)
      move()
    }
  }

  override func didMoveToWindow() {
    super.didMoveToWindow()
    if (self.window == nil) {
      registry.remove(origin: self)
    }
  }

  func restituteIfNeeded(destinationName: NSString?) {
    if ((destinationName == nil || destinationName == "") && lastDestination?.lastOrigin == self) {
      lastDestination?.restitute()
    }
  }
  
  func move() {
    guard let realDestination = registry.get(name: destination) else { return }
    
    realDestination.restitute()
    moveTo(destination: realDestination)
    
    realDestination.prepareNextRestitute(origin: self)
  }
  
  init(registry: PortalRegistry) {
    self.registry = registry
    destination = ""
    super.init(frame: CGRect.zero)
    isUserInteractionEnabled = true
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
