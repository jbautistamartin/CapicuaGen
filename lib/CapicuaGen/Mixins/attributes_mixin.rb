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

=begin
Este mixin se encarga de agegar caractristicas de
=end

require_relative 'parameter_mixin'

module CapicuaGen

  public

  # Devuelve una coleccion atributos de unos terminadas características de cierto tipo
  def get_attributes(values= {})

    # Atributos a generar
    attributes  = initialize_array_parameter(values[:attributes])
    # Tipo de características a buscar
    target_types= initialize_array_parameter(values[:target_types])

    # Agrego los atributes requeridos
    result      = {}
    attributes.each do |a|
      result[a]= []
    end


    # Busco  las características que contiene entidades de SQL para una table
    generator.get_features_in_targets_by_type(target_types).each do |f|

      attributes.each do |a|
        result[a]<<f.generation_attributes[a] if f.generation_attributes[a]
      end

      result.each_pair do |k, v|
        yield k, v
      end

    end
  end


end

