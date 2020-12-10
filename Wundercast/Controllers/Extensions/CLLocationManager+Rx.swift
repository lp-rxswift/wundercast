//
//  CLLocationManager+Rx.swift
//  Wundercast
//
//  Created by Lucas Pedrazoli on 10/12/20.
//  Copyright © 2020 Ray Wenderlich. All rights reserved.
//

import Foundation
import CoreLocation
import RxSwift
import RxCocoa

extension CLLocationManager: HasDelegate {}

class RxCLLocationManagerDelegateProxy:
  DelegateProxy<CLLocationManager, CLLocationManagerDelegate>,
  DelegateProxyType,
  CLLocationManagerDelegate {

  weak public private(set) var locationManager: CLLocationManager?

  public init(locationManager: ParentObject) {
    self.locationManager = locationManager
    super.init(parentObject: locationManager,
               delegateProxy: RxCLLocationManagerDelegateProxy.self)
  }

  static func registerKnownImplementations() {
    register { RxCLLocationManagerDelegateProxy(locationManager: $0) }
  }
}

public extension Reactive where Base: CLLocationManager {
  var delegate: DelegateProxy<CLLocationManager, CLLocationManagerDelegate> {
    RxCLLocationManagerDelegateProxy.proxy(for: base)
  }

  var didUpdateLocations: Observable<[CLLocation]> {
    delegate.methodInvoked(
      #selector(CLLocationManagerDelegate.locationManager(_:didUpdateLocations:)))
      .map { parameters in
        parameters[1] as! [CLLocation]
      }
  }
}
