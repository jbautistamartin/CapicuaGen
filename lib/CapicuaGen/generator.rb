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
require_relative 'Mixins/reflection_mixin'
require_relative 'generator_command_line'

module CapicuaGen


  # Clase generadora, nueclo de CapicuaGen, al que se le configuran todas las caracteristicas
  # y las llama segun corresponda para que generen la parte de codigo asociado a ellas

  class Generator
    include CapicuaGen

    public

    attr_accessor :generation_attributes, :retry_failed, :continue_on_failed, :retries, :local_feature_directory
    attr_accessor :message_helper, :start_time, :end_time, :argv_options

    # Inicializo el objeto
    def initialize(attributes= {})
      initialize_properties(attributes, false)


      # Valores determinados
      @retry_failed             = true unless @retry_failed
      @retries                  = 1 unless @retries
      @continue_on_failed       = true unless @continue_on_failed
      @local_feactures_directory= 'Capicua' unless @local_features_directory

      # Colecciones de caracteristicas que posee el generador
      @features                 = []

      # Caraceristicas a ejecutar
      @targets                  = []

      # Atributos generales de generacion
      @generation_attributes    = AttributeMixer.new

      # Configuro el gestor de mensajes
      @message_helper           = MessageHelper.new

      # Hora de comienzo y final
      @start_time               = Time.now
      @end_time                 = Time.now

      # Opciones
      @argv_options             =OpenStruct.new

      # Aranco configuracion si es necesario
      yield self if block_given?
    end

    # Coleccion de caracteristicas del generador
    def features(values= {})

      # Configuro los parametros por defecto
      enable_generation= nil
      enable           = true

      # Configuro los parametros
      enable_generation= values[:enable_generation] if values[:enable_generation]
      enable           = values[:enable_generation] if values[:enable_generation]

      return @features
    end

    # Agrega una caracteristica en el generador
    def add_feature (feature)
      @features<<feature
    end

    # Quita la caracteristica
    def remove_feature (feature)
      @features.delete(feature)
    end

    # Quita la caracterisitca en base al nombre
    def remove_feature_by_name(feature_name)
      @features.delete_if { |f| f.name==feature_name }
    end

    # Obtiene la caracteristica en base al nombre
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


    # Agrega una caracteristica y al mismo tiempo la convierte en objetivo
    def add_feature_and_target(*features)
      features.each do |feature|
        add_feature(feature)
        target= Target.new(:name => feature.name)
        add_target(target)
      end
    end


    # Obtiene una caracteristica, que a la vez es un objetivo, por su nombre
    def get_feature_by_target_name
      target @targets.detect { |f| f.name==feature_name }

      return unless target

      return get_feature_by_name(target.name)
    end

    # Obtiene una caracteristica, que a la vez es un objetivo, por su tipo
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


    # Obtiene una caracteristica, que a la vez es un objetivo, por su tipo
    def get_features_in_targets
      return get_features_in_targets_by_type
    end

    # Genera todos las caracteristicas
    def generate

      @start_time   = Time.now

      # Reviso argumentos
      argv          =ARGV.clone
      @argv_options =parse_command_line(argv)

      return if @argv_options.exit

      if @argv_options.clean
        clean
      end

      return unless @argv_options.generate

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
            feature.generate
            targets.delete(t)
          rescue => e
            $stderr.puts e
            $stderr.puts e.backtrace
          end
        end

      end

      @end_time=Time.now

      puts
      message_helper.puts_end_generate(@start_time, @end_time)

    end


    # Genera todos las caracteristicas
    def clean

      @start_time   = Time.now

      # Reviso argumentos
      argv          =ARGV.clone
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
            $stderr.puts e
            $stderr.puts e.backtrace
          end
        end

      end

      @end_time=Time.now

      puts
      message_helper.puts_end_generate(@start_time, @end_time)

    end

  end
end