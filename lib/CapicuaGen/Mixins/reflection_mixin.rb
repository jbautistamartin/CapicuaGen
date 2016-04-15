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
Este mixin se encarga de agegar funcionalidad que permite que una clase
cree propieades dinamicas y permite inicializarlas a traves de un hash
pasado al contructor.
=end


# Agrega opciones de refleccion a las clases que lo implementan
module CapicuaGen


  private


  # Crea un metodo
  def create_method(name, &block)
    self.singleton_class.send(:define_method, name, &block)
  end

  # Crea una propiedad
  def create_attr(name)
    create_method("#{name}=".to_sym) { |val| instance_variable_set("@" + name, val) }
    create_method(name.to_sym) { instance_variable_get("@" + name) }
  end

  # Establece una propiedad
  def set_property(prop_name, prop_value)
    self.send("#{prop_name}=", prop_value)
  end

  protected



  public
  # Inicializa las propiedades de un objeto, si no dichas propiedades las crea
  def initialize_properties(properties, create_new_properties= true)

    # Recorro las propiedades
    properties.each do |key, value|

      # convierto el simbolo en un string
      key_s= key.to_s

      # Compruebo si existe y si no lo creo
      if not self.respond_to?(key.to_s)
        if create_new_properties
          create_attr(key.to_s)
        else
          raise ("No se permite la propiedad '#{key}' para el tipo '#{self.class.name}'")
        end
      end

      # Establezco el valor
      set_property(key_s, value)

    end


  end

end