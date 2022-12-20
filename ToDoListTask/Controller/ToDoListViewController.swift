//
//  ToDoListViewController.swift
//  ToDoListTask
//
//  Created by De la Cruz Hernández on 19/12/22.
//

import UIKit

class ToDoListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var toDoListTable: UITableView!
    let context = (UIApplication.shared.delegate! as! AppDelegate).persistentContainer.viewContext
    var currentTask : Task?
    var dataManager : TaskDataManager?
    
    //OK    Tener configurado un Launch Screen para la aplicación
    //OK    Tener configurados los iconos de la aplicación
    //OK    Agregar soporte para un idioma adicional que nos sea ingles o español.
    //OK    Agregar soporte para accesibilidad en texto
    //OK    Agregar el mecanismo para ocultar el teclado
                //-> TapGesture && tool bar
    //OK    Agregar "alert" que indique al usuario que el título de la tarea es requerido
    //OK    Agregar el mecanismo de borrado
                //-> Swipe a celda para borrar y confirmar
    //OK    Agregar método de búsqueda por fecha
                //-> fincion cargardatos() describe metodos
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataManager = TaskDataManager(context: context)
        
        cargardatos()
    }
    func cargardatos(){
        //BUSCA TODO LOS VALORES
        dataManager!.fecth()
        
        ///BUSCA EN VALOR DE  TITULO
        //dataManager!.fecthWithPredicate(searchValue: "task 1")
        
        ///BUSCAR EN VALOR DE TITULO Y NOTAS
        //dataManager!.fecthWithCompountPredicate(title: "task*", notes: "*ola*")
        
        ///BUSCAR EN VALOR FECHA (task.date >= date) - SI SE INGRESA SOLO FECHA 1
        //let date = Date()
        //dataManager!.fecthWithCompountPredicate(date: date)
        
        //BUSCAR EN VALOR FECHA (task.date <= date) - SI SE INGRESA SOLO FECHA 1
        //let date = Date()
        //dataManager!.fecthWithCompountPredicate(date2: date)
        
        ///BUSCAR EN RANGO DE FECHAS - SI SE INGRESA FECHA 1 & FECHA 2
        //let stringdate1 = "17/12/2022 00:00:00"
        //let stringdate2 = "18/12/2022 23:59:59"
        //let dateFormato = DateFormatter()
        //    dateFormato.dateFormat = "dd/MM/yy HH:mm:ss"
        //let date = dateFormato.date(from: stringdate1)
        //let date2 = dateFormato.date(from: stringdate2)
        //dataManager!.fecthWithCompountPredicate(date: date, date2: date2)
    }
    @IBAction func unWindFromDetail(segue: UIStoryboardSegue){
        let source = segue.source as! TaskDetailViewController
        currentTask = source.toDoDetailTask
            do{
                try context.save()
            } catch{
                self.mensajeAlert(mensaje: "\(NSLocalizedString("lang.ErrorToSave", comment: "")): \(error) ")
            }
        cargardatos()
        self.toDoListTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(NSLocalizedString("lang.Tasks", comment: ""))"
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerFrame = tableView.frame
        let title = UILabel()
            title.frame =  CGRectMake(16, 16, headerFrame.size.width-20, 35)
            title.text = self.tableView(tableView, titleForHeaderInSection: section)
            title.font = UIFont.preferredFont(forTextStyle: .body)
            title.adjustsFontForContentSizeCategory = true
            title.textColor = UIColor(named: "ColorUNO")?.resolvedColor(with: self.traitCollection)
        let headerView:UIView = UIView(frame: CGRectMake(0, 0, headerFrame.size.width, headerFrame.size.height))
            headerView.addSubview(title)
            return headerView
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager!.countTask()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoTaskCell", for: indexPath) as! ToDoTaskViewCell
        cell.taskTitulo.text = dataManager?.getTask(at: indexPath.row).title
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "taskSegue", sender: self)
    }
    
    //MOVER CELDAS && agrega accion delete
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "\(NSLocalizedString("lang.Delete", comment: ""))") { _, _, completion in
            let alertMensaje = UIAlertController(title: "\(NSLocalizedString("lang.Warning", comment: ""))", message: "\(NSLocalizedString("lang.DeleteThisTask", comment: ""))", preferredStyle: .alert)
            let agreeAccionHandler = { (accion: UIAlertAction)-> Void in
                do{
                    self.context.delete( (self.dataManager?.getTask(at: indexPath.row))!  )
                    try self.context.save()
                    self.cargardatos()
                    self.toDoListTable.deleteRows(at: [indexPath], with: .automatic)
                } catch{
                    self.mensajeAlert(mensaje: "\(NSLocalizedString("lang.ErrorToDelete", comment: "")): \(error) ")
                }
                completion(true)
            }
            let cancelAccionHandler = { (accion: UIAlertAction)-> Void in
                completion(false)
            }
            let cancelAcction = UIAlertAction(title: "\(NSLocalizedString("lang.Cancel", comment: ""))", style: .cancel,handler: cancelAccionHandler)
            let agreeAcction = UIAlertAction(title: "\(NSLocalizedString("lang.Agree", comment: ""))", style: .destructive ,handler: agreeAccionHandler)
            alertMensaje.addAction(cancelAcction)
            alertMensaje.addAction(agreeAcction)
            self.present(alertMensaje, animated: true, completion: nil)
        }
        let swipeConfig = UISwipeActionsConfiguration(actions: [delete])
        //swipeConfig.performsFirstActionWithFullSwipe = false
        return swipeConfig
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "taskSegue" {
            let destination = segue.destination as! TaskDetailViewController
            destination.toDoDetailTask = dataManager?.getTask(at: toDoListTable.indexPathForSelectedRow!.row )
        }
    }
    
    func mensajeAlert(mensaje: String = "\(NSLocalizedString("lang.Message", comment: ""))",titulo: String = "\(NSLocalizedString("lang.Warning", comment: ""))"){
        let alertMensaje = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        let cancelAcction = UIAlertAction(title: "\(NSLocalizedString("lang.Agree", comment: ""))", style: .cancel)
        alertMensaje.addAction(cancelAcction)
        self.present(alertMensaje, animated: true)
    }
    
}
