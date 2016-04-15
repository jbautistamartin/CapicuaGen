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


module CapicuaGen

  require 'fileutils'
  require 'ERB'


  # Clase ayudante para crear arvhiso a partir de Template
  class TemplateHelper

    private

    def initialize

    end

    public

    # Genera un archivo en base a un template
    def self.generate_template (erb_file, current_binding, values= {})


      erb           = ERB.new(File.open(erb_file, 'r').read)


      # Archivo de salida
      out_file      = values[:out_file] if values[:out_file]
      force         = values[:force] if values[:force]

      #caracteristica
      feature       = values[:feature] if values[:feature]
      message_helper= feature.message_helper if feature
      message_helper= MessageHelper.new unless message_helper

      # Genero la plantilla
      result        = erb.result(current_binding)

      # Devuelve el resultado si no hay archivo de salida
      return result unless out_file


      exists= File.exist?(out_file)


      if exists and not force
        message_helper.puts_created_template(File.basename(erb_file), out_file, :ignore)
        return result
      end


      # Creo el directorio
      FileUtils::mkdir_p File.dirname(out_file)

      # Escribo el resultado
      File.open(out_file, 'w') { |file| file.write(result) }

      if exists
        message_helper.puts_created_template(File.basename(erb_file), out_file, :override)
      else
        message_helper.puts_created_template(File.basename(erb_file), out_file, :new)
      end

      return result
    end
  end
end