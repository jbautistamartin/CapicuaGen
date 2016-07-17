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

require 'active_support/core_ext/object/blank'
require_relative 'Mixins/reflection_mixin'
require_relative 'generator_command_line'
require_relative '../CapicuaGen/Examples/Example/Source/example_feature'

module CapicuaGen


  # Clase generadora, nueclo de CapicuaGen, al que se le configuran todas las características
  # y las llama segun corresponda para que generen la parte de código asociado a ellas

  class Generator
    include CapicuaGen

    public

    attr_accessor :generation_attributes, :retry_failed, :continue_on_failed, :retries, :local_templates
    attr_accessor :message_helper, :start_time, :end_time, :argv_options

    # Inicializo el objeto
    def initialize(attributes= {})
      initialize_properties(attributes, false)


      # Valores determinados
      @retry_failed          = true unless @retry_failed
      @retries               = 1 unless @retries
      @continue_on_failed    = true unless @continue_on_failed
      @local_templates       = 'Capicua' unless @local_templates

      # Colecciones de características que posee el generador
      @features              = []

      # Caraceristicas a ejecutar
      @targets               = []

      # Atributos generales de generación
      @generation_attributes = AttributeMixer.new

      # Configuro el gestor de mensajes
      @message_helper        = MessageHelper.new

      # Hora de comienzo y final
      @start_time            = Time.now
      @end_time              = Time.now

      # Opciones
      @argv_options          =OpenStruct.new

      # Aranco configuracion si es necesario
      yield self if block_given?
    end

    # Coleccion de características del generador
    def features(values= {})

      # Configuro los parametros por defecto
      enable_generation= nil
      enable           = true

      # Configuro los parametros
      enable_generation= values[:enable_generation] if values[:enable_generation]
      enable           = values[:enable_generation] if values[:enable_generation]

      return @features
    end

    # Agrega una característica en el generador
    def add_feature (feature)
      @features<<feature
    end

    # Quita la característica
    def remove_feature (feature)
      @features.delete(feature)
    end

    # Quita la caracterisitca en base al nombre
    def remove_feature_by_name(feature_name)
      @features.delete_if { |f| f.name==feature_name }
    end

    # Obtiene la característica en base al nombre
    def get_feature_by_name(feature_name)
      return @features.detect { |f| f.name==feature_name }
    end

    # Obtiene las caracteriscas de un tipo
    def get_features_by_type(feature_type)
      return @features.select { |f| f.type==type }
    end

    # Obtiene el nombre de todos los objetivos
    def targets
      return @targets
    end

    # Agrega un objetivo
    def add_target(target)
      @targets<<target
    end

    # Elimina un objetivo
    def remove_target(target)
      @targets.delete(target)
    end


    # Agrega una característica y al mismo tiempo la convierte en objetivo
    def add_feature_and_target(*features)
      features.each do |feature|
        add_feature(feature)
        target= Target.new(:name => feature.name)
        add_target(target)
      end
    end


    # Obtiene una característica, que a la vez es un objetivo, por su nombre
    def get_feature_by_target_name
      target @targets.detect { |f| f.name==feature_name }

      return unless target

      return get_feature_by_name(target.name)
    end

    # Obtiene una característica, que a la vez es un objetivo, por su tipo
    def get_features_in_targets_by_type(target_types= [])
      features= []

      @targets.each do |t|
        feature= get_feature_by_name(t.feature_name)
        next unless feature
        next unless t.enable
        features<<feature if target_types.blank? or feature.is_any_type?(target_types)
      end

      return features

    end


    # Obtiene una característica, que a la vez es un objetivo, por su tipo
    def get_features_in_targets
      return get_features_in_targets_by_type
    end

    # Genera todos las características
    def generate(values={})

      no_arguments=values[:no_arguments]
      if values[:arguments]
        arguments=Array(values[:arguments])
      else
        arguments=ARGV.clone
      end

      start_time = Time.now

      # Reviso argumentos

      unless no_arguments
        argv          =arguments.clone
        @argv_options =parse_command_line(argv)

        return if @argv_options.exit

        if @argv_options.clean
          clean
        end

        if @argv_options.example
          generate_example
          return
        end

        generate_list if @argv_options.template_list

        generate_export_template @argv_options if @argv_options.template and not @argv_options.template_list

        return unless @argv_options.generate
      end

      @targets.each do |t|

        # configuro todas las asignaciones de generador

        feature          = get_feature_by_name(t.feature_name)
        feature.generator= self

      end

      # Clono los objetivos
      targets= [] + @targets
      retries= @retries + 1

      # Veo si debo hacer algo, si no muestro la ayuda
      if targets.blank?
        parse_command_line(["-h"])
        return
      end


      # Posibles reintentos
      retries.times do

        # Realizo las generaciones
        @targets.each do |t|

          next unless targets.include?(t)

          next unless t.enable_generation and t.enable

          feature= get_feature_by_name(t.feature_name)

          next if @argv_options and @argv_options.ignore_features and @argv_options.ignore_features.include? feature.name

          begin
            feature.generate
            targets.delete(t)
          rescue => e
            message_helper.puts_error_message "Error en característica '#{feature.name}' de tipo '#{feature.class}'"
            message_helper.puts_catched_error e
          end
        end

      end

      end_time=Time.now

      puts
      message_helper.puts_end_generate(start_time, end_time)

    end


    # Genera todos las características
    def clean(values ={})
      @start_time = Time.now

      # Reviso argumentos
      if values[:arguments]
        arguments=Array(values[:arguments])
      else
        arguments=ARGV.clone
      end
      argv          =arguments
      @argv_options =parse_command_line(argv)

      return if @argv_options.exit

      @targets.each do |t|

        # configuro todas las asignaciones de generador

        feature          = get_feature_by_name(t.feature_name)
        feature.generator= self

      end

      # Clono los objetivos
      targets= [] + @targets
      retries= @retries + 1

      # Posibles reintentos
      retries.times do

        # Realizo las generaciones
        @targets.each do |t|

          next unless targets.include?(t)

          next unless t.enable_generation and t.enable

          feature= get_feature_by_name(t.feature_name)

          next if @argv_options.ignore_features.include? feature.name

          begin
            feature.clean
            targets.delete(t)
          rescue => e
            message_helper.puts_catched_error e
          end
        end

      end

      @end_time=Time.now

      puts
      message_helper.puts_end_generate(@start_time, @end_time)

    end


    def generate_example()

      arguments= ['generate']

      argv_options =parse_command_line(ARGV)


      generator_example = CapicuaGen::Generator.new do |g|

        # Creo las características necesarias
        feature_example = CapicuaGen::ExampleFeature.new(:name => 'feature_example')

        # Agrego las característica al generador
        g.add_feature_and_target feature_example

        # Configuro los atributos
        g.generation_attributes.add :out_dir => argv_options.out

      end


      arguments << "--force" if argv_options.force

      generator_example.generate :arguments => arguments

    end

    def generate_list
      templates=[]

      dir = File.join(File.dirname(__FILE__), '../../..')

      Dir["#{dir}/**/*"].select { |e| File.file? e and e=~/Template/ }.each do |f|

        feature_template=get_gem_type_feature(f)
        templates<<feature_template if feature_template

      end

      templates.uniq.each do |feature_template|
        message_helper.puts_list_template(feature_template[:gem], feature_template[:type], feature_template[:feature]) if feature_template
      end


    end

    def generate_export_template(options)
      templates=[]

      dir = File.join(File.dirname(__FILE__), '../../..')

      Dir["#{dir}/**/*"].select { |e| File.file? e and e=~/Template/ }.each do |template_file|


        feature_template=get_gem_type_feature(template_file)

        next unless feature_template

        next unless feature_template[:gem]=~ /#{options.template_gem}/
        next unless feature_template[:type]=~ /#{options.template_type}/
        next unless feature_template[:feature]=~ /#{options.template_feature}/


        out_file=File.join(options.template_out, feature_template[:gem], feature_template[:type], feature_template[:feature], File.basename(template_file))

        exists= File.exist?(out_file)

        if not exists or options.force

          # Creo el directorio
          FileUtils::mkdir_p File.dirname(out_file)
          FileUtils.cp template_file, out_file

          if exists
            message_helper.puts_copy_template(feature_template[:gem], feature_template[:type], feature_template[:feature], out_file, :override)
          else
            message_helper.puts_copy_template(feature_template[:gem], feature_template[:type], feature_template[:feature], out_file, :new)
          end

        else
          message_helper.puts_copy_template(feature_template[:gem], feature_template[:type], feature_template[:feature], out_file, :ignore)
        end


      end
    end

    def get_gem_type_feature(file)
      if file=~/([^\/*]+)\/([^\/*?]+)\/([^\/*?]+)\/Template\//i
        return { :gem => $1, :type => $2, :feature => $3 }
      else
        return nil
      end
    end

  end
end