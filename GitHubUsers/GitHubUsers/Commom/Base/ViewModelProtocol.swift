//
//  ViewModelProtocol.swift
//  GitHubUsers
//
//  Created by Igor Vaz on 13/03/20.
//  Copyright © 2020 Igor Vaz. All rights reserved.
//

import RxSwift

protocol ViewModelProtocol {
    var disposeBag: DisposeBag { get }
}
