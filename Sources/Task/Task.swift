fileprivate class TaskNode {
	public var task: Task
	public var deps: [TaskNode]
	
	init(task: Task, deps: [TaskNode]) {
		self.task = task
		self.deps = deps
	}
	
	public func postorder() -> Void {
		helper(self)
	}
	
	private func helper(_ node: TaskNode) {
		if !node.deps.isEmpty {
			for dep in node.deps {
				helper(dep)
			}
			node.task.task()
		} else {
			node.task.task()
		}
	}
}

@resultBuilder public struct TaskBuilder {
	public static func buildBlock(_ content: Task...) -> [Task] {
		return content
	}
}

public final class Task {
		
	fileprivate let task: () -> Void
	private var deps: [Task] = []
	private var node: TaskNode?
	
	init(_ task:  @escaping () -> Void = {}) {
		self.task = task
	}

	@discardableResult
	func deps(_ dependencies: Task...) -> Task {
		deps(dependencies)
	}
	
	@discardableResult
	func deps(@TaskBuilder content: () -> [Task]) -> Task {
		deps(content())
	}
	
	
	@discardableResult
	func deps(@TaskBuilder content: () -> Task) -> Task {
		let dc = content()
		deps(dc)
		return self
	}
	
	@discardableResult
	func deps(_ dependencies: [Task]) -> Task {
		self.node = TaskNode(task: self, deps: dependencies.map { $0.node != nil ? $0.node! : TaskNode(task: $0, deps: [])})
		return self
	}
	
	func commit() {
		if let node = self.node {
			node.postorder()
		} else {
			task()
		}
		self.node = nil
	}
}
