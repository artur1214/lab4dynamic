require 'webrick'
require 'erb'
require_relative 'templates'
require_relative 'argument'

include WEBrick
include Arguements

s = HTTPServer.new(:Port => 1337)
index   = Template.new('index.html')
result  = Template.new('result.html')
error   = Template.new('error.html')

s.mount_proc("/") do |req, res|
    $arguments = Array.new
    $arguments[Arguements::A] = Argument.new(0.01, 1.01, 0.01, 0.01, 'a')
    $arguments[Arguements::B] = Argument.new(1, 314, 3.14, 1, 'b')
    $arguments[Arguements::C] = Argument.new(18, 20.0, 0.4, 18.0, 'c')
    $arguments[Arguements::D] = Argument.new(2**0.5, 3.1, 0.02, 2**0.5, 'd')
    $arguments[Arguements::F] = Argument.new(0, 0.4, 0.001, 0, 'f')
    $arguments[Arguements::X] = Argument.new(3.**(1/3.0), 3.**(1/3.0), 0, 3.**(1/3.0), 'x')
    index.reload_template
    res.body = index.render
end

s.mount_proc("/res") do |req, res|
    $arguments[Arguements::A].value=req.query["a"].to_f
    $arguments[Arguements::B].value=req.query["b"].to_f
    $arguments[Arguements::C].value=req.query["c"].to_f
    $arguments[Arguements::D].value=req.query["d"].to_f
    $arguments[Arguements::F].value=req.query["f"].to_f
    $arguments[Arguements::X].value=req.query["x"].to_f
    found_error = false
    faulted = Array.new
    for argument in $arguments do
        if not argument.validate
            puts argument.name
            faulted << argument.name
            found_error = true
        end
    end
    $arguments[Arguements::X].value=$arguments[Arguements::X].left.round(req.query["x"].to_f.round())
    if not found_error
        a = req.query["a"].to_f
        b = req.query["b"].to_f
        c = req.query["c"].to_f
        d = req.query["d"].to_f
        f = req.query["f"].to_f
        #x = req.query["X"].to_f
        x = $arguments[Arguements::X].value
        puts a,b,c,d,f,x
        calc_result = (a * (x * x) + b * x + c) / (d * x + f)
        puts calc_result
        result.reload_template
            res.body = result.get_template.result(binding)
    else
        calc_result = faulted.to_s
        error.reload_template
        res.body = error.get_template.result(binding)
    end
    
end

trap("INT") {s.shutdown}
s.start
