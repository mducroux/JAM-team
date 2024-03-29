
import SpriteKit
import Magnetic
import UIKit
import CoreData

class BubblesViewController: UIViewController {
    
    //var set = Set<String>()
    
    //MARK: Properties
    @IBOutlet var label: UILabel!
    var n = 5
    
    @IBOutlet weak var magneticView: MagneticView! {
        didSet {
            magnetic.magneticDelegate = self
        }
    }
    
    var magnetic: Magnetic {
        return magneticView.magnetic
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)

        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore  {
            print("Not first launch.")
        } else {
            print("First launch, setting UserDefault.")
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            UserDefaults.standard.set(0 , forKey:"keyDate")
        }
        
        let date = Date()
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)

        let previousDay = UserDefaults.standard.object(forKey: "keyDate") as! Int
        
        if (previousDay == day) {
            self.present(PageViewController(), animated: true, completion:nil)
            return
        }
        
        UserDefaults.standard.set(day, forKey:"keyDate")
        add(nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func add(_ sender: UIControl?) {
        for name in UIImage.names {
            let color = UIColor.colors.randomItem()
            let node = Node(text: name.capitalized, image: UIImage(named: name), color: color, radius: 50)
            magnetic.addChild(node)
        }
    }
    
    @IBAction func reset(_ sender: UIControl?) {
        let speed = magnetic.physicsWorld.speed
        magnetic.physicsWorld.speed = 0
        let sortedNodes = magnetic.children.flatMap { $0 as? Node }.sorted { node, nextNode in
            let distance = node.position.distance(from: magnetic.magneticField.position)
            let nextDistance = nextNode.position.distance(from: magnetic.magneticField.position)
            return distance < nextDistance && node.isSelected
        }
        var actions = [SKAction]()
        for (index, node) in sortedNodes.enumerated() {
            node.physicsBody = nil
            let action = SKAction.run { [unowned magnetic, unowned node] in
                if node.isSelected {
                    let point = CGPoint(x: magnetic.size.width / 2, y: magnetic.size.height + 40)
                    let movingXAction = SKAction.moveTo(x: point.x, duration: 0.2)
                    let movingYAction = SKAction.moveTo(y: point.y, duration: 0.4)
                    let resize = SKAction.scale(to: 0.3, duration: 0.4)
                    let throwAction = SKAction.group([movingXAction, movingYAction, resize])
                    node.run(throwAction) { [unowned node] in
                        node.removeFromParent()
                    }
                } else {
                    node.removeFromParent()
                }
            }
            actions.append(action)
            let delay = SKAction.wait(forDuration: TimeInterval(index) * 0.004)
            actions.append(delay)
        }
        magnetic.run(.sequence(actions)) { [unowned magnetic] in
            magnetic.physicsWorld.speed = speed
        }
    }
    
}

// MARK: - MagneticDelegate
extension BubblesViewController: MagneticDelegate {
    
//    @IBAction func add(_ sender: Any) {
//        let listObject = UserDefaults.standard.object(forKey: "list")
//        var list: [String] = []
//        if let tempList = listObject as? [String] {
//            list = tempList
//            list.append(textField.text!)
//        } else {
//            list = [textField.text!]
//        }
//        UserDefaults.standard.set(list, forKey: "list")
//        textField.text = ""
//    }
    
    
    func magnetic(_ magnetic: Magnetic, didSelect node: Node) {
        
//        let decoded  = UserDefaults.standard.object(forKey: "set") as! Data
//        let decodedSet = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! Set<String>
//        set = decodedSet
//        set.insert(node.text!)
//        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: set)
//        UserDefaults.standard.set(encodedData, forKey: "set")
//        UserDefaults.standard.synchronize()
//        
        if n != 1 {
            n = n - 1
            label.text = "Choose \(n) Categories"
        } else {
            self.present(PageViewController(), animated: true, completion:nil)
        }
        
        print("didSelect -> \(node)")
    }
    
    func magnetic(_ magnetic: Magnetic, didDeselect node: Node) {
        
//        let setObject = UserDefaults.standard.object(forKey: "set")
//
//        if let tempSet = setObject as? Set<String> {
//            set = tempSet
//            set.remove(node.text!)
//            UserDefaults.standard.set(set, forKey: "set")
//        }
        
        n = n + 1
        label.text = "Choose \(n) Categories"
        print("didDeselect -> \(node)")
    }
    
}

// MARK: - ImageNode
class ImageNode: Node {
    
    override var image: UIImage? {
        didSet {
            sprite.texture = image.map { SKTexture(image: $0) }
        }
    }
    
    override func selectedAnimation() {}
    override func deselectedAnimation() {}
}
