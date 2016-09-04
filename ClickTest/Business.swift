//
//  Business.swift
//  ClickTest
//
//  Created by Jhon Villalobos on 9/2/16.
//  Copyright © 2016 Jhon Villalobos. All rights reserved.
//

import Foundation

class Business {
    var categoria  : String!
    var domicilio  : Double!
    var urlDetalle : String!
    var picture    : String!
    var nombre     : String!
    var rating     : Int!
    var tiempo     : Int!
    var ubicacion  : String!
    var favorite   : Bool!
    var distance   : Double!
    
    init(categoria: String, domicilio: Double, urlDetalle: String, picture: String!, nombre: String, rating: Int, tiempo: Int, ubicacion: String, favorite: Bool, distance: Double) {
        self.categoria  = categoria
        self.domicilio  = domicilio
        self.urlDetalle = urlDetalle
        self.picture    = picture
        self.nombre     = nombre
        self.rating     = rating
        self.tiempo     = tiempo
        self.ubicacion  = ubicacion
        self.favorite   = favorite
        self.distance   = distance
    }
}