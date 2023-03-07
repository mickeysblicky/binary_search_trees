module Comparable

end

class Node
    attr_accessor :data, :left, :right

    def initialize(data = nil, left = nil, right = nil)
        @data = data
        @left = left
        @right = right
    end
end

class Tree

    def initialize(array)
        @root = build_tree(array)
    end

    def build_tree(array)
        return if array.empty?

        result = array.sort.uniq
    
        return Node.new(result[0]) if result.length <= 1
        
            mid = result.length / 2
            root = Node.new(result[mid])

            root.left = build_tree(result[0..mid-1])
            root.right = build_tree(result[mid+1..-1])
            return root
    end

    def insert(value, node = @root)
        
        if (node == nil)
            node = Node.new(value)
            return node
        elsif (value < node.data)
            node.left  = insert(value, node.left)
        elsif (value > node.data)
            node.right = insert(value, node.right)
        end

        return node
    end

    def array_of_values(array = [], node = @root)
        if (node == nil)
            return array
        elsif (node != nil)
            array_of_values(array, node.left)
            array << node.data
            array_of_values(array, node.right)
        end
    end

    def delete_recursion(value, node = @root)
        return node if node == nil
        
        if (value < node.data)
            node.left = delete_recursion(value, node.left)
        elsif (value > node.data)
            node.right = delete_recursion(value, node.right)
        else 
            if (node.left == nil)
                return node.right
            elsif (node.right == nil)
                return node.left

            end
            node.data = minValue(node.right)

            node.right = delete_recursion(node.data, node.right)
        end
        return node
    end

    def find(value, node = @root)

        if (value == node.data)
            p node
            return node
        elsif (value < node.data)
            node.left = find(value, node.left)
        elsif (value > node.data)
            node.right = find(value, node.right)
        end
        return node
    end

    def level_order(node = @root, &block)
        if !block_given?
            puts "no block given"
        elsif block_given?

            return nil if node == nil
            queue = []
            queue << node
            current_node = Node.new
            while (!queue.empty?)
                current_node = queue[0]
                puts "current-#{current_node.data}"
                queue.shift
                if (current_node.left != nil)
                    yield(queue ,current_node.left)
                end
                if (current_node.right != nil)
                    yield(queue, current_node.right)
                end
            end
        end
    end

    def minValue(node = @root)

        minv = node.data
        while (node.left != nil)
            minv = node.left.data
            node = node.left
        end
        return minv
    end

    def pretty_print(node = @root, prefix = '', is_left = true)
        
        pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
        puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
        pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
    end
    
    def inorder(node = @root, &block)
        if !block_given?
            puts "no block given"
        elsif block_given?
            if (node != nil)
                inorder(node.left, &block)
                yield(node.data)
                inorder(node.right, &block)
            end
        end
    end

    def preorder(node = @root, &block)
        if !block_given?
            puts "no block given"
        elsif block_given?
            if (node != nil)
                yield(node.data)
                preorder(node.left, &block)
                preorder(node.right, &block) 
            end
        end
    end

    def postorder(node = @root, &block)
        if !block_given?
            puts "no block given"
        elsif block_given?
            if (node != nil)
                postorder(node.left, &block)
                postorder(node.right, &block)
                yield(node.data)
            end
        end
    end

    def height(node = @root, count = -1)
        if node == nil
            return count
        end
        count += 1
        [height(node.left), height(node.right)].max + 1
    end

    def booty(node = @root)
        if (node.left == nil && node.right == nil)
            puts "leaf: #{node.data}"
        elsif (node != nil)
            booty(node.left)
            p node.data
            booty(node.right)
        end

    end

    def depth(value, node = @root, array = [])
        if (!self.array_of_values.any?(value))
            statement = puts "value not found"
            return statement
        elsif (value == node.data)
            puts "#{value} = #{node.data}"
        elsif (value < node.data)
            # puts "#{value} is less than #{node.data}"
            array << node.data
            depth(value, node.left, array)
        elsif (value > node.data)
            # puts "#{value} is greater than #{node.data}"
            array << node.data
            depth(value, node.right, array)
        end
        array.size
    end

    def balanced?(node = @root)
        left_height = height(node.left)
        right_height = height(node.right)
        difference = right_height - left_height
        true_difference = difference.abs
        puts "true difference: #{true_difference}"
        if true_difference <= 1
            # puts "tree is balanced"
            return true
        elsif true_difference > 1
            # puts "tree is not balanced"
            return false
        end
    end

    def rebalance(node = @root)
        array = self.array_of_values
        @root = build_tree(array)
    end

end

tree = Tree.new(Array.new(15) { rand(1..100) })
tree.pretty_print
puts "BALANCED?"
p tree.balanced?
puts "LEVELORDER"
tree.level_order {|q, e| q << e}
puts "PREORDER"
tree.preorder {|e| puts "current-#{e}"}
puts "POSTORDER"
tree.postorder {|e| puts "current-#{e}"}
puts "INORDER"
tree.inorder {|e| puts "current-#{e}"}
puts "INSERT RANDOM NUMS"
tree.insert(76)
tree.insert(53)
tree.insert(15)
tree.insert(1)
tree.insert(21)
tree.insert(13)
tree.pretty_print
puts "^BALANCED?^"
p tree.balanced?
puts "REBALANCE"
tree.rebalance
tree.pretty_print
puts "^BALANCED?^"
p tree.balanced?
puts "LEVELORDER"
tree.level_order {|q, e| q << e}
puts "PREORDER"
tree.preorder {|e| puts "current-#{e}"}
puts "POSTORDER"
tree.postorder {|e| puts "current-#{e}"}
puts "INORDER"
tree.inorder {|e| puts "current-#{e}"}