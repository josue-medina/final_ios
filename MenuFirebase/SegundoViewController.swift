//
//  SegundoViewController.swift
//  MenuFirebase
//
//  Created by Josue Medina on 05/06/22.
//

import UIKit

struct NoticiasModelo: Codable{
    let team: [Noticia]
}

struct Noticia: Codable{
    var fullName: String?
    var short_name: String?
    var shield: String?
}


class TerceroViewController: UIViewController {
   
    var articuloNoticias : [Noticia] = []
    
    @IBOutlet weak var tablaNoticias: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //registramos la celda
        tablaNoticias.register(UINib(nibName: "CeldaNoticiaTableViewCell", bundle: nil), forCellReuseIdentifier: "celdaNoticia")
        
        tablaNoticias.delegate = self
        tablaNoticias.dataSource = self
        buscarNoticias()
    }
    
    func buscarNoticias(){
        let urlString = "https://apiclient.besoccerapps.com/scripts/api/api.php?key=01a8ae66c5dcb08b5053beea6993cf0d&tz=Europe/Madrid&format=json&req=teams&league=1&year=2022"
        if let url = URL(string: urlString){
            if let data = try? Data(contentsOf: url){
                let decodificador = JSONDecoder()
                
                if let datosDecodificados = try?
                    decodificador.decode(NoticiasModelo.self, from: data){
                    //print("datosDecodificados: \(datosDecodificados.team)")
                    
                    articuloNoticias = datosDecodificados.team
                    tablaNoticias.reloadData()
                }
            }
        }
    }
}

extension TerceroViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articuloNoticias.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tablaNoticias.dequeueReusableCell(withIdentifier: "celdaNoticia", for: indexPath) as! CeldaNoticiaTableViewCell
        celda.tituloNoticiaLabel.text = articuloNoticias[indexPath.row].fullName
        celda.descripcionNoticiaLabel.text = articuloNoticias[indexPath.row].short_name
        
        //cargamos la imagen
        if let url = URL(string: articuloNoticias[indexPath.row].shield ?? ""){
            if let imagenData = try? Data(contentsOf: url ){
            celda.imagenNoticiaIV.image = UIImage(data: imagenData)
        }
        }
        return celda
    }
    
}
