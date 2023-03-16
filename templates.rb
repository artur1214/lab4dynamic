class Template
    def initialize(path)
        @path = path
        reload_template
    end
    def render
        @template.result(binding)
    end
    def get_template
        @template
    end
    def reload_template()
        data = File.open(@path).read
        @template= ERB.new(data)
    end
end