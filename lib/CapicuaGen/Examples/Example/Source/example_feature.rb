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


require 'active_support/core_ext/object/blank'

require_relative '../../../capicua_gen'


module CapicuaGen

  # Caracteristica generadora de una pantalla de Bienvenida
  class ExampleFeature < CapicuaGen::TemplateFeature
    include CapicuaGen

    public

    # Inicializa la caracteristica
    def initialize(values= {})
      super(values)

      # Configuro los tipos si estos no han sido configurados previamente
      self.types= [:example] if self.types.blank?

      # Configuro los templates
      set_template('generator', Template.new(:file => 'generator.erb'))
      set_template('GemFile', Template.new(:file => 'GemFile.erb'))
      set_template('instnwnd', Template.new(:file => 'instnwnd.erb'))


    end

    # Configura los objetivos de las platillas (despues de establecer el generador)
    def configure_template_targets

      # Configuro los templates
      set_template_target('generator', TemplateTarget.new(:out_file => "generator.rb", :types => :example, :copy_only => true))
      set_template_target('GemFile', TemplateTarget.new(:out_file => "GemFile", :types => :proyect_file, :copy_only => true))
      set_template_target('instnwnd', TemplateTarget.new(:out_file => "scripts/instnwnd.sql", :types => :proyect_file, :copy_only => true))

    end


  end
end