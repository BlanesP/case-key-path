//
//  CasePathableMacros.swift
//  CasePathable
//
//  Created by Pau Blanes on 09/07/2026.
//

import SwiftSyntax
import SwiftSyntaxMacros
import SwiftCompilerPlugin

public struct CasePathableMacro {}

extension CasePathableMacro: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        // Make sure it is an enum
        guard let enumDecl = declaration.as(EnumDeclSyntax.self) else {
            return []
        }
        
        // Get enum type for the CasePath generic
        let enumName = enumDecl.name.text
        
        // Get access level
        let accessLevels: Set<String> = ["public", "package", "internal", "fileprivate", "private", "open"]
        let accessModifier = enumDecl.modifiers.first { accessLevels.contains($0.name.text) }
        let access = accessModifier.map { "\($0.name.text)" } ?? ""
        
        // Get all cases to generate the CasePaths
        let caseElements = enumDecl.memberBlock.members
            .compactMap { $0.decl.as(EnumCaseDeclSyntax.self) }
            .flatMap { $0.elements }
        
        // Iterate cases and generate each CasePath property
        let propertiesText: String = caseElements.map {
            let name = $0.name.text
            let parameters = $0.parameterClause?.parameters ?? []
            let valueTypes: [String] = parameters.map { $0.type.trimmed.description }
            
            let valueType: String = switch valueTypes.count {
            case 0: "Void"
            case 1: valueTypes[0]
            default: "(\(valueTypes.joined(separator: ",")))"
            }
            
            let pattern = switch valueTypes.count {
            case 0: "case .\(name)"
            case 1: "case let .\(name)(v)"
            default: "case let .\(name)(\(valueTypes.indices.map({ "v\($0)" }).joined(separator: ",")))"
            }
            
            let result = switch valueTypes.count {
            case 0: "()"
            case 1: "v"
            default: "(\(valueTypes.indices.map({ "v\($0)" }).joined(separator: ",")))"
            }
            
            let embedArgs = parameters.isEmpty ? "" : "(" + parameters.enumerated().map { index, param in
                if let label = param.firstName?.text, label != "_" {
                    return "\(label): $\(index)"
                } else {
                    return "$\(index)"
                }
            }.joined(separator: ", ") + ")"
            
            return """
                    \(access) var \(name): CasePath<\(enumName), \(valueType)> {
                        CasePath(
                            extract: { if \(pattern) = $0 { return \(result) } else { return nil } },
                            embed: { .\(name)\(embedArgs) }
                        )
                    }
                    """
        }
        .joined(separator: "\n\n")
        
        // Generate the containing struct
        let structDecl: DeclSyntax = """
        \(raw: access) struct AllCasePaths {
            \(raw: propertiesText)
        }
        """
        
        return [
            structDecl,
            "\(raw: access) static let allCasePaths = AllCasePaths()",
        ]
    }
}

extension CasePathableMacro: ExtensionMacro {
    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingExtensionsOf type: some TypeSyntaxProtocol,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {
        
        // protocols is the list of conformances the compiler needs you to add
        guard !protocols.isEmpty else { return [] }
        
        // Add conformance to the protocol
        // We only add the extension, and not everything, because an ExtensionMacro can't attach to a type nested inside a function, while a MemberMacro can
        let ext = try ExtensionDeclSyntax("extension \(type.trimmed): CasePathable {}")
        return [ext]
    }
}
