//
//  Plugins.swift
//  CasePathable
//
//  Created by Pau Blanes on 09/07/2026.
//

import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct CasePathablePlugin: CompilerPlugin {
    let providingMacros: [any Macro.Type] = [CasePathableMacro.self]
}
