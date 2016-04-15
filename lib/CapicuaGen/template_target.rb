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

  # Define el objetivo de una plantilla
  class TemplateTarget
    include CapicuaGen

    public
    attr_accessor :name, :out_file, :template_name, :append_outdir, :types, :copy_only

    def initialize(attributes= {})
      initialize_properties(attributes)

      @name= @template_name if @template_name and not @name

      # Configuro los parametros de tipo
      @types= []
      if attributes[:types]
        @types= attributes[:types]
        @types= [@types] if @types and not @types.instance_of?(Array)
      end

    end


    # Indica que el destino es de un tipo determinado
    def is_type?(type)
      return type.include?(type)
    end

    # Indica que el destino es de un tipo determinado
    def is_any_type?(types)
      return (@types & types).length>0
    end

  end

end