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

module CapicuaGen

  # Clase que permite un escalonamiento de propidades de forma que un AttributeMixer
  # puede estar dentro de otro (recursivamente) y permitir acceder a cualquier atributo
  # definido en cualquiera de ellos, permitiendo que se sobreescriban.
  class AttributeMixer


    public

    #  Mezclador de la base
    attr_accessor :mixer_base

    def initialize
      @internal_mixer= {}
      @mixer_base    = nil
    end

    # Recuperamos un valor
    def [](key)
      return @internal_mixer[key] if @internal_mixer[key]
      return @mixer_base[key] if @mixer_base
      return nil
    end


    # Añade un hash de valores
    def add(hash={})
      hash.each_pair do |k, v|
        self[k]=v
      end
    end


    #agregamos un valor
    def []= (key, value)
      @internal_mixer[key]= value
    end

    # Indica que un attribute esta definido en la base
    def has_in_base?(attribute)
      return false unless @mixer_base
      return true if @mixer_base.has_in_self?(attribute)
      return @mixer_base.has_in_base?(attribute)
    end

    # Indica que un attribute esta definido en el objeto mismo
    def has_in_self?(attribute)
      return false unless @internal_mixer
      return (@internal_mixer.has_key?(attribute) and @internal_mixer[attribute])
    end

  end

end

