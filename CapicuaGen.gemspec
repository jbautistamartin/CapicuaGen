# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'CapicuaGen/version'

Gem::Specification.new do |spec|
  spec.name    = "CapicuaGen"
  spec.version = CapicuaGen::VERSION
  spec.authors = ["José Luis Bautista Martín"]
  spec.email   = ["joseluisbautista@gmail.com"]
  spec.date    = Date.today.to_s


  spec.summary     = %q{CapicuaGen es un software que ayuda a la creación automática de
sistemas empresariales a través de la definición y ensamblado de
diversos generadores de características.
}
  spec.description = %q{CapicuaGen es un software que ayuda a la creación automática de
sistemas empresariales a través de la definición y ensamblado de
diversos generadores de características.

El proyecto fue iniciado por José Luis Bautista Martin, el 6 de enero
del 2016.

Puede modificar y distribuir este software, según le plazca, y usarlo
para cualquier fin ya sea comercial, personal, educativo, o de cualquier
índole, siempre y cuando incluya este mensaje, y se permita acceso el
código fuente.

Este software es código libre, y se licencia bajo LGPL.

Para más información consultar http://www.gnu.org/licenses/lgpl.html}

  spec.homepage = "http://desdelashorasextras.blogspot.mx/"
  spec.licenses = ['LGPL']

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features|\.idea)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_runtime_dependency 'activesupport', '>=2.3.18', '~>2.3'
  spec.add_runtime_dependency 'nokogiri', '>=1.6.7', '~>1.6'
  spec.add_runtime_dependency 'uuidtools', '>=2.1.5', '~>2.1'
  spec.add_runtime_dependency 'colorize', '~> 0.7.7'

  spec.required_ruby_version = '>= 2.0.0'

end
