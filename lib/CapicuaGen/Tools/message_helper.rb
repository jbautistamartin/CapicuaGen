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

require 'colorize'

# Agrega opciones de refleccion a las clases que lo implementan
module CapicuaGen

  # Ayuda a mostar mensajes en pantalla con un forma y de una forma determinada
  class MessageHelper

    public
    # Inicializa el objeto
    def initialize
      @indent= 0
    end

    # Agrega una tabulacion a la derecha
    def add_indent
      @indent+= 1
    end

    # Elimina una tabulación
    def remove_indent
      @indent-= 1
      @indent= 0 if @indent<0
    end

    # Numero de las indentaciones
    def indent
      return indent
    end

    # Devuelve los espacios
    def puts_spaces(spaces= @indent)
      @indent.times do |i|
        print "\t"
      end
    end

    # Imprime un mensaje
    def puts_message(text)
      puts_spaces
      puts(text)
    end

    # Mensaje "Procesando caracteristica"
    def puts_generating_feature(feature)
      puts_message "Procesando caracteristica: '#{feature.name} -> #{feature.class.name}'"
    end


    # Mesaje para plantilla creada
    def puts_created_template(template, out_file, mode)

      result= ''

      case mode
        when :override
          result= "* #{template}".colorize(:yellow) + " -> '#{out_file}': Sobreescrito"
        when :new
          result= "+ #{template}".colorize(:blue) + " -> '#{out_file}': Creado"
        when :ignore
          result= "! #{template}".colorize(:red) + " -> '#{out_file}': NO creado"
        when :delete
          result= "- #{template}".colorize(:magenta) + " -> '#{out_file}': Eliminado"
        else
          result= "? #{template}".colorize(:red) + " -> '#{out_file}': #{mode.to_s}"
      end

      puts_message result

    end

    # Mesaje para template copiado
    def puts_copy_template(gem, type, feature, out_file, mode)

      result  = ''
      template= "#{gem}, #{type}, #{feature}"
      puts_created_template(template, out_file, mode)

    end

    # Mensaje gneracion acabada
    def puts_end_generate(start_time, end_time)

      total_time=end_time-start_time
      puts_message "Finalizado, tiempo total: #{total_time} segundos."
      puts
    end

    # Mesaje para plantilla creada
    def puts_list_template(gem, file, feature)
      puts_message "- gem:".colorize(:red) + " '#{gem}', " + "file:".colorize(:yellow) + "'#{file}', " + "feature:".colorize(:blue) + "'#{feature}'"
    end


    def puts_catched_error(e)
      $stderr.puts e.to_s.colorize(:red)
      $stderr.puts
      $stderr.puts e.backtrace.join($/).to_s.colorize(:red)
    end

    # Indica que un archivo fue modificado
    def puts_file_modified(out_file, mode)
      case mode
        when :override
          result= "*".colorize(:yellow) + " -> '#{out_file}': Modificado"
        when :new
          result= "+".colorize(:blue) + " -> '#{out_file}': Creado"
        when :ignore
          result= "!".colorize(:red) + " -> '#{out_file}': NO modificado"
        when :delete
          result= "-".colorize(:magenta) + " -> '#{out_file}': Eliminado"
        else
          result= "?".colorize(:red) + " -> '#{out_file}': #{mode.to_s}"
      end
      puts_message result

    end


  end


end