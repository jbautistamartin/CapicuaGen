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
CapicuaGen es una herrmamienta de generación de código basado en características
configurables y extensibles.
=end

require_relative 'version'
require_relative 'template_feature'
require_relative 'feature'
require_relative 'target'
require_relative 'generator'
require_relative 'Tools/template_helper'
require_relative 'template'
require_relative 'template_target'
require_relative 'attribute_mixer'
require_relative 'file_information'
require_relative 'Tools/message_helper'
require_relative 'Tools/xml_helper'
