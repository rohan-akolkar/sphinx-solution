//
//  HomeViewController.swift
//  Sphinx_Solution_MachineTest
//
//  Created by Mac on 04/03/23.
//

import UIKit
//import GoogleMaps
class HomeViewController: UIViewController {
    
    @IBOutlet weak var googleMapView: UIView!
    @IBOutlet weak var userCollectionView: UICollectionView!
    @IBOutlet weak var populationTableView: UITableView!
    
    var newUser : User?
    var user = [User]()
    
    var population = [Population]()
    var jsonDecoder:JSONDecoder?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userCollectionView.delegate = self
        userCollectionView.dataSource = self
       populationTableView.delegate = self
       populationTableView.dataSource = self
        
        let uinibName = UINib(nibName:"UsersCollectionViewCell", bundle: nil)
        self.userCollectionView.register(uinibName, forCellWithReuseIdentifier: "UsersCollectionViewCell")
        
        let uiNibName = UINib(nibName: "PopulationTableViewCell", bundle: nil)
        self.populationTableView.register(uinibName, forCellReuseIdentifier: "PopulationTableViewCell")

        userSeriallization()
        populationDecoder()
    }
    func userSeriallization(){
        
        var urlString : String?
        var url : URL?
        var urlRequest: URLRequest?
        var urlSession : URLSession?
        
        urlString = "https://gorest.co.in/public/v2/users"
        url = URL(string:urlString!)
        urlRequest = URLRequest(url:url!)
        urlRequest?.httpMethod = "GET"
        urlSession = URLSession(configuration: .default)
        let dataTask = urlSession?.dataTask(with: urlRequest!){
            data,response,error in
         
            let jsonObject = try!JSONSerialization.jsonObject(with: data!)as!
            [[String:Any]]
            
            
            for eachUser in jsonObject{
                
                    let UserId = eachUser["id"]as!Int
                    let Username = eachUser["name"]as!String
                    let userGender = eachUser["gender"]as!String
                    self.newUser = User(id: UserId, name: Username, gender: userGender)
                    self.user.append(self.newUser!)
                    
                }
                DispatchQueue.main.async {
                    self.userCollectionView.reloadData()
                }
            }
            dataTask?.resume()
        }
   func populationDecoder(){
        var urlString : String?
        var url : URL?
        var urlRequest: URLRequest?
        var urlSession : URLSession?
        
        
        urlString = "https://gorest.co.in/public/v2/users"
       url = URL(string: urlString!)
       urlRequest = URLRequest(url: url!)
       urlRequest?.httpMethod = "GET"
       urlSession = URLSession(configuration: .default)
       URLSession.shared.dataTask(with: urlRequest!){
           data,response,error in
           
           if(error == nil){
               do{
                  self.jsonDecoder = JSONDecoder()
                   let populationResponse = try
                   self.jsonDecoder?.decode (Population.self, from: data!)
                  // self.JSONDecoder?.decode([Population].self,from:data!)
                  self.population = populationResponse!
                   print(self.population.count)
               }catch{
                   print(error)
                   
               }
           }
           DispatchQueue.main.async {
               self.populationTableView.reloadData()
           }
       }.resume()
        
        
    }

}
    
extension HomeViewController:UICollectionViewDelegateFlowLayout{
func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
   let viewheight = view.frame.size.height
    let viewwidth = view.frame.size.width
    return CGSize(width: viewwidth * 0.70, height: viewheight * 0.50)
}
}
extension HomeViewController:UICollectionViewDataSource{
    
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return user.count
        }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let userCollectionViewCell = self.userCollectionView.dequeueReusableCell(withReuseIdentifier: "UsersCollectionViewCell", for: indexPath)as!UsersCollectionViewCell
        let eachUser = user[indexPath.row]
        userCollectionViewCell.idLabel.text = String(eachUser.id)
        userCollectionViewCell.nameLabel.text = String(eachUser.name)
        userCollectionViewCell.genderLabel.text = String(eachUser.gender)
        return userCollectionViewCell
        
    }

}

extension HomeViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250.00
    }
}

extension HomeViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return population.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let populationtableViewCell = self.populationTableView.dequeueReusableCell(withIdentifier:"PopulationTableViewCell", for: indexPath)as!PopulationTableViewCell
        let eachPopulation = population[indexPath.row]
        populationtableViewCell.populationLabel.text = String(eachPopulation.population)
        populationtableViewCell.yearLabel.text = eachPopulation.Y
        return populationtableViewCell
    }
    
    

