=begin

CapicuaGen

CapicuaGen es un software que ayuda a la creación automática de
sistemas empresariales a través de la definición y ensamblado de
diversos generadores de características.

El proyecto fue iniciado por José Luis Bautista Martin, el 6 de enero
del 2016.

Puede modificar y distribuir este software, según le plazca, y usarlo
para cualquier fin ya sea comercial, personal, educativo, o de cualquier
índole, siempre y cuando incluya este mensaje, y se permita acceso el
código fuente.

Este software es código libre, y se licencia bajo LGPL.

Para más información consultar http://www.gnu.org/licenses/lgpl.html
=end

require_relative 'Mixins/reflection_mixin'

module CapicuaGen

  # Define un objtivo a contruir
  class Target
    include CapicuaGen


    public

    attr_accessor :name, :feature_name, :enable, :enable_generation, :group


    def initialize(attributes= {})
      @enable= true
      @enable_generation= true

      # Inicializo propiedades
      initialize_properties(attributes, false)

      @feature_name= @name unless @feature_name

    end


  end
end