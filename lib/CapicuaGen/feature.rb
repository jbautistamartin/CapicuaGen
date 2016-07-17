=begin

CapicuaGen

CapicuaGen es un software que ayuda a la creación automática de
sistemas empresariales a través de la definición y ensamblado de
diversos generadores de características.

El proyecto fue iniciado por José Luis Bautista Martín, el 6 de enero
de 2016.

Puede modificar y distribuir este software, según le plazca, y usarlo
para cualquier fin ya sea comercial, personal, educativo, o de cualquier
índole, siempre y cuando incluya este mensaje, y se permita acceso al
código fuente.

Este software es código libre, y se licencia bajo LGPL.

Para más información consultar http://www.gnu.org/licenses/lgpl.html
=end

require_relative 'Mixins/reflection_mixin'

module CapicuaGen

  class Feature
    include CapicuaGen

    protected
    attr_accessor :types

    public
    attr_accessor :name, :generation_attributes
    attr_reader :generator

    def initialize(attributes= {})
      initialize_properties(attributes, false)

      # Configuro los parametros de tipo
      @types= []
      if attributes[:types]
        @types= attributes[:types]
        if @types and not @types.instance_of?(Array)
          @types= [types]
        end
      end


      #Define los atributos de la generación
      @generation_attributes= AttributeMixer.new

      # Generador asociado
      @generator            = nil

      #Ejecuto configuracion en bloque
      yield self if block_given?
    end

    def clean
      message_helper.puts_generating_feature(self)
    end


    def generate
      message_helper.puts_generating_feature(self)
    end


    # Devuelve los archivos generados por esta características
    def get_out_file_information(values= {})
      return []
    end

    # Devuelve los archivos generados por esta características
    def get_relative_out_files(values= {})
      result= []
      # Obtengo la ruta base
      if values[:directory_base]
        directory_base= values[:directory_base]
      else
        directory_base= @generation_attributes[:out_dir]
      end

      get_out_file_information(values).each do |f|
        relative_path= f.get_relative_file_path(directory_base)

        result << relative_path
      end


      return result
    end

    # Indica que el destino es de un tipo determinado
    def is_type?(type)
      return type.include(type)
    end

    # Indica que el destino es de un tipo determinado
    def is_any_type?(types)
      if types and not types.instance_of?(Array)
        types= [types]
      end
      return (@types & types).length > 0
    end


    # Configura el generador y se
    def generator= (value)

      @generator= value

      if @generator
        reset_attributes()
        @generation_attributes.mixer_base= generator.generation_attributes
        configure_attributes()
      end

    end

    # Resetea los atributos personalizados de la característica (antes de establecer el generador)
    def reset_attributes

    end

    # Configura los atributos personalizados de la característica (antes de establecer el generador)
    def configure_attributes()

    end


    def argv_options
      return @generator.argv_options
    end

    def message_helper
      return MessageHelper.New unless @generator
      return @generator.message_helper
    end

    def clone(attributes= {})
      result=super()
      result.initialize_properties(attributes, false)
      return result
    end


  end

end

