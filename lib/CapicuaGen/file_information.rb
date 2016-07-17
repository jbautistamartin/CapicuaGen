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

require 'pathname'

module CapicuaGen

  # Representa informacion acerca de un archivo
  class FileInformation


    public
    attr_accessor :file_name

		# Inicializa la característica
    def initialize(values= {})
      @file_name= values[:file_name]
    end

    def get_relative_file_path(directory_base)

      return file_name unless directory_base


      first= Pathname.new directory_base
      second= Pathname.new file_name

      return second.relative_path_from(first).to_s

    end

  end
end

