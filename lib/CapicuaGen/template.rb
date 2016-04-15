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

  # Define una plantilla para generar codigo
  class Template



    public
    attr_accessor :name, :file

    def initialize(atributes= {})
      @name= atributes[:name] if atributes[:name]
      @file= atributes[:file] if atributes[:file]
    end


  end
end
