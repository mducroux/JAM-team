
import SpriteKit
import Magnetic

class BubblesViewController: UIViewController {
    
    //MARK: Properties
    @IBOutlet var label: UILabel!
    var n = 5
    
    @IBOutlet weak var magneticView: MagneticView! {
        didSet {
            magnetic.magneticDelegate = self
            #if DEBUG
                magneticView.showsFPS = true
                magneticView.showsDrawCount = true
                magneticView.showsQuadCount = true
            #endif
        }
    }
    
    var magnetic: Magnetic {
        return magneticView.magnetic
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        add(nil)
    }
    
    @IBAction func add(_ sender: UIControl?) {
        for name in UIImage.names {
            let color = UIColor.colors.randomItem()
            let node = Node(text: name.capitalized, image: UIImage(named: name), color: color, radius: 50)
            magnetic.addChild(node)
        }
        
        // Image Node: image displayed by default
        // let node = ImageNode(text: name.capitalized, image: UIImage(named: name), color: color, radius: 40)
        // magnetic.addChild(node)
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
    
    func magnetic(_ magnetic: Magnetic, didSelect node: Node) {
        if n != 1 {
            n = n - 1
            label.text = "Choose \(n) Categories"
        } else {
            let main = UIStoryboard(name: "Main", bundle: nil)
            let vc = main.instantiateViewController(withIdentifier: "RootViewController") as UIViewController
            present(vc, animated: true, completion: nil)
        }
        print("didSelect -> \(node)")
    }
    
    func magnetic(_ magnetic: Magnetic, didDeselect node: Node) {
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
