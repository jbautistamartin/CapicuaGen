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

=begin
Este mixin se presentar herramientas para trabajar con parametros
=end


module CapicuaGen

# Inicializa un parametro que debe ser un array
  def initialize_array_parameter(value)

    # Configuro los parametros de tipo
    result= []
    if value
      result= value
      if result and not result.instance_of?(Array)
        result= [result]
      end
    else
      result= []
    end
    return result
  end


end