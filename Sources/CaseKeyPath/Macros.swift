//
//  Macros.swift
//  CasePathable
//
//  Created by Pau Blanes on 10/07/2026.
//

@attached(member, names: named(AllCasePaths), named(allCasePaths))
@attached(extension, conformances: CasePathable)
public macro CasePathable() =
    #externalMacro(module: "CaseKeyPathMacros", type: "CasePathableMacro")
