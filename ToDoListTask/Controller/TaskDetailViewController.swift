//
//  TaskDetailViewController.swift
//  ToDoListTask
//
//  Created by De la Cruz Hernández on 19/12/22.
//

import UIKit

class TaskDetailViewController: UITableViewController {

    @IBOutlet weak var taskTitle: UITextField!
    @IBOutlet weak var taskDate: UIDatePicker!
    @IBOutlet weak var taskNotes: UITextView!
    @IBOutlet weak var taskCancelButton: UIBarButtonItem!
    @IBOutlet weak var taskSaveButton: UIBarButtonItem!
    
    let context = (UIApplication.shared.delegate! as! AppDelegate).persistentContainer.viewContext
    var toDoDetailTask : Task?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if toDoDetailTask != nil{
            taskTitle.text = toDoDetailTask?.title
            taskDate.date = (toDoDetailTask?.date)!
            taskNotes.text = toDoDetailTask?.note
        } else {
            toDoDetailTask = Task(context: context)
            taskTitle.text = ""
        }
        setupTextFields()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! ToDoListViewController
        toDoDetailTask?.title = taskTitle.text
        toDoDetailTask?.date = taskDate.date
        toDoDetailTask?.note = taskNotes.text
        destination.currentTask = toDoDetailTask
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        var perform = false
        if validateText(text: taskTitle.text!){
            perform = true
        } else{
            mensajeAlert(mensaje: "\(NSLocalizedString("lang.TitleIsEmpty", comment: ""))" )
        }
        return perform
    }
    @IBAction func taskCancelButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
        let isModal = self.presentingViewController is UINavigationController
        if isModal{
            self.dismiss(animated: true)
        } else{
            navigationController?.popViewController(animated: true)
        }
    }

    func mensajeAlert(mensaje: String = "\(NSLocalizedString("lang.Message", comment: ""))",titulo: String = "\(NSLocalizedString("lang.Warning", comment: ""))"){
        let alertMensaje = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        let cancelAcction = UIAlertAction(title: "\(NSLocalizedString("lang.Agree", comment: ""))", style: .cancel)
        alertMensaje.addAction(cancelAcction)
        self.present(alertMensaje, animated: true)
        
    }
    
    @objc func endEditingText(){
        view.endEditing(true)
    }
    func setupTextFields(){
        let toolbar = UIToolbar()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "\(NSLocalizedString("lang.Done", comment: ""))", style: .done, target: self, action: #selector(endEditingText))
        
        toolbar.setItems([flexSpace,doneButton], animated: true)
        toolbar.sizeToFit()
        
        taskTitle.inputAccessoryView = toolbar
        taskNotes.inputAccessoryView = toolbar
    }
}
