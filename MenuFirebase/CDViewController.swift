//
//  CDViewController.swift
//  MenuFirebase
//
//  Created by Josue Medina on 06/06/22.
//

import UIKit
import CoreData
class CDViewController: UIViewController {
    
    var listaTareas = [Tarea]()
    let contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    @IBOutlet weak var tablaTareas: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tablaTareas.delegate=self
        tablaTareas.dataSource=self
        leer()

    }
    
    @IBAction func agregarTarea(_ sender: UIBarButtonItem) {
        //campo para el titulo
        var titulo = UITextField()
        var cuerpo = UITextField()
        let alerta = UIAlertController(title: "Agregar", message: "Evento", preferredStyle: .alert)
        let accionAceptar = UIAlertAction(title: "Aceptar", style: .default) { (_) in
            //crear una nueva tarea
            
            let nuevaTarea = Tarea(context: self.contexto)
            nuevaTarea.nombre = titulo.text
            nuevaTarea.descripcion = cuerpo.text
            nuevaTarea.realizada = false
            
            
            //agregar esa tarea al arreglo de listaTareas
            
            self.listaTareas.append(nuevaTarea)
            
            
            self.guardar()
            
        }
        //agregar el textfied
        alerta.addTextField { (textFieldAlerta) in
            textFieldAlerta.placeholder="Escribe el titulo"
            titulo = textFieldAlerta
            
            textFieldAlerta.placeholder="Escrube mensaje"
            cuerpo = textFieldAlerta
        }
        alerta.addAction(accionAceptar)
        present(alerta, animated: true)
    }
    func guardar() {
        
        do{
            try contexto.save()
        }catch{
            print("Error al guardar en core data: \(error.localizedDescription)")
        }
        
        self.tablaTareas.reloadData()
    }
    
    func leer(){
        let solicitud : NSFetchRequest<Tarea> = Tarea.fetchRequest()
        do{
            //asignar al arreglo de tareas la solicitud
            listaTareas = try contexto.fetch(solicitud)
        }catch{
            print("error al leer datos \(error.localizedDescription)")
        }
    }

}

extension CDViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaTareas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tablaTareas.dequeueReusableCell(withIdentifier: "celda", for: indexPath)
        let tarea = listaTareas[indexPath.row]
        
        //operador ternario
        /*let formatter1 = DateFormatter()
        formatter1.dateStyle = .full
                celda.detailTextLabel?.text = formatter1.string(from: listaTareas[indexPath.row].fecha!)*/
        
        celda.textLabel?.text = tarea.nombre
        celda.textLabel?.textColor = tarea.realizada ? .black : .blue
        
        celda.detailTextLabel?.text = tarea.realizada ? "Programado" : "Me Interesa"
        
        celda.accessoryType = tarea.realizada ? .checkmark : .none
        return celda
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tablaTareas.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            tablaTareas.cellForRow(at: indexPath)?.accessoryType = .none
        }else{
            tablaTareas.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        //edicion
        
        listaTareas[indexPath.row].realizada = !listaTareas[indexPath.row].realizada
        guardar()
        
        
        
        tablaTareas.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let accionEliminar = UIContextualAction(style: .normal, title: "borrar") { (_, _, _) in
            self.contexto.delete(self.listaTareas[indexPath.row])
            self.listaTareas.remove(at: indexPath.row)
            self.guardar()
        }
        
        
        accionEliminar.image = UIImage(systemName: "trash")
        accionEliminar.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [accionEliminar])
    }
    
    
}
