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
require 'optparse'
require 'optparse/time'
require 'ostruct'
require 'pp'

require_relative 'Mixins/reflection_mixin'


module CapicuaGen

  class Generator
    include CapicuaGen

    # Parsea un linea de comamdos
    def parse_command_line(args)

      options = OpenStruct.new

      options.ignore_features=[]

      opt_parser = OptionParser.new do |opts|
        opts.banner = "Uso: <Script generador> [comandos] [opciones]"

        opts.separator ""
        subtext = <<HELP
Comandos:
   generate          :     Genera las caracteriticas configuradas.
   clean             :     Limpia los archivos generados.
   cleanAndGenerate  :     Limpia los archivos generados y luego los vuelve a crear.
   example           :     Genera un ejemplo


Ejecute 'opt.rb COMMAND --help' para obtener mas
HELP
        opts.separator ""
        opts.separator subtext
        opts.separator ""

        # No argument, shows at tail.  This will print an options summary.
        # Try it and see!
        opts.on_tail("-h", "--help", "Muestra este mensaje") do
          puts opts
          options.help=true
          options.exit=true
        end

        # Another typical switch to print the version.
        opts.on_tail("--version", "Muestra la versión") do
          puts ::Version.join('.')
          options.version=true
          options.exit   =true
        end

      end

      subcommands = {

          'generate'         => OptionParser.new do |opts|

            opts.banner = "Uso: generate [options]"
            opts.separator ""

            # List of arguments.
            opts.on("--ignore featurename1, featurename2, featurename2", Array, "Lista de caracteristicas que sera omitidas") do |ignore_features|
              options.ignore_features = ignore_features
            end

            opts.on("-f", "--force", "Fuerza que se sobreescriban las carateristicas generadas") do
              options.force= true
            end

            opts.on_tail("-h", "--help", "Muestra este mensaje") do
              puts opts
              options.help=true
              options.exit=true
            end
          end,


          'clean'            => OptionParser.new do |opts|

            opts.banner = "Uso: clean [options]"
            opts.separator ""

            # List of arguments.
            opts.on("--ignore featurename1, featurename2, featurename2", Array, "Lista de caracteristicas que sera omitidas") do |ignore_features|
              options.ignore_features = ignore_features
            end

            opts.on_tail("-h", "--help", "Muestra este mensaje") do
              puts opts
              options.help=true
              options.exit=true
            end
          end,


          'cleanAndGenerate' => OptionParser.new do |opts|
            opts.banner = "Uso: example [options]"
            opts.separator ""
            opts.separator "Opciones:"
            opts.separator ""

            # List of arguments.
            opts.on("--ignore featurename1, featurename2, featurename2", Array, "Lista de caracteristicas que sera omitidas") do |ignore_features|
              options.ignore_features = ignore_features
            end

            opts.on("-f", "--force", "Fuerza que se sobreescriban las carateristicas generadas") do
              options.force= true
            end

            opts.on_tail("-h", "--help", "Muestra este mensaje") do
              puts opts
              options.help=true
              options.exit=true
            end

            opts.separator ""
          end,


          'example'          => OptionParser.new do |opts|
            opts.banner = "Uso: cleanAndGenerate [options]"
            opts.separator ""
            opts.separator "Opciones:"
            opts.separator ""

            # List of arguments.
            opts.on("-o", "--out directorio", "") do |directorio|
              options.out = directorio
            end

            opts.on_tail("-h", "--help", "Muestra este mensaje") do
              puts opts
              options.help=true
              options.exit=true
            end

            opts.separator ""
          end

      }


      begin
        internal_args=args.clone
        opt_parser.order!(internal_args)
        command = internal_args.shift

        if command

          case command

            when 'generate'
              options.generate=true

            when 'clean'
              options.clean   =true
              options.generate=false

            when 'cleanAndGenerate'
              options.clean   =true
              options.generate=true

            when 'example'
              options.clean   =false
              options.generate=false
              options.example =true
              options.out='.'

          end

          subcommands[command].order! internal_args


        else
          options.generate=true
        end

      rescue => e
        $stderr.puts e
        puts
        puts opt_parser
        puts
        options.exit=true
      end


      return options
    end

  end
end
