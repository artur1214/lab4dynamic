
class Argument
    def initialize(left, right, discrete, value, name)
        @left = left
        @right = right
        @discrete = discrete
        @value = value
        @name = name
    end

    def name
        @name
    end

    def value
        @value
    end

    def value=(value)
        @value=value
    end

    def left
        @left
    end

    def right
        @right
    end

    def left=(left)
        @left=left
    end

    def right=(right)
        @right=right
    end

    def discrete
        @discrete
    end

    def validate
        if discrete == 0 # Для констант проверяем количество знаков после запятой
            puts((@value >= 0) && (@value % 1 == 0))
            return ((@value >= 0)&&(@value % 1 == 0))
        end
        vals = (@left...@right).step(discrete).to_a
        val = @left
        step = 1
        while val <= @value + @discrete
            if @name == 'd'
                # Проверка правильности ввода. Считаем, что ввод правильный
                # Если значения отличаются не более чем на 0.00006
                # сделанно так, из-за возможных проблем с округлением в IEEE 754 и
                # потому что это корень из двух.
                eq = (val- @value).abs <= 0.00006
            else
                eq = (val - @value).abs <= 0.00006  #(Float::EPSILON*step)
            end
            if eq
                return true
            end
            val += @discrete
            step+=1
        end
        puts @name, @value, val, Float::EPSILON*step
        return false
        # for value in vals do
        #     if @value.eql?(value)
        #         return true
        #     end
        # end
        # return false
        # return (@left...@right).include?(@value)
    end
end

module Arguements
    A = 0
    B = 1
    C = 2
    D = 3
    F = 4
    X = 5
end