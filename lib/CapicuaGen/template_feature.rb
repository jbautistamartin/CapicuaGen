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

require_relative 'feature'

module CapicuaGen

  # Es un tipo de caracteristica especial que se basa en generación de codigo a travez de plantillas
  class TemplateFeature < Feature


    private

    # Plantillas (archivos *.erb)
    attr_accessor :templates

    # Relacion de las Template con los objetivos
    attr_accessor :template_targets

    protected

    attr_accessor :template_directories


    public

    # Inicializo el objeto
    def initialize(atributes= {})
      super(atributes)


      # Define las interfaces del proyectowh
      @templates           = []

      # Define los objetivos concretos de los templates
      @template_targets    = []

      # Directorios donde conseguir los templates
      @template_directories= []

    end


    # Coleccion de caracteristicas del generador
    def templates
      return @templates
    end

    # Agrega una caracteristica en el generador
    def add_template(template)
      @templates<<template
    end

    # Agrega una caracteristica en el generador
    def set_template(name, template)
      remove_template_by_name(name)
      template.name= name
      @templates<<template
    end

    # Quita la caracteristica
    def remove_template(template)
      @templates.delete(template)
    end

    # Quita la caracterisitca en base al nombre
    def remove_template_by_name(template_name)
      @templates.delete_if { |f| f.name==template_name }
    end

    # Obtiene la caracteristica en base al nombre
    def get_template_by_name(template_name)
      return @templates.detect { |f| f.name==template_name }
    end

    # Coleccion de template_targets del generador
    def template_targets
      return @template_targets
    end

    # Agrega una template_target en el generador
    def add_template_target(template_target)
      @template_targets<<template_target
    end

    # Agrega una template_target en el generador
    def set_template_target(name, template_target)
      remove_template_target_by_name(name)
      template_target.name= name
      if name=~ /^([^\/]+)\//
        template_target.template_name= $1
      else
        template_target.template_name= name unless template_target.template_name
      end

      @template_targets<<template_target

      # Devuelve el template recien configurado
      return template_target

    end

    # Quita la template_target
    def remove_template_target(template_target)
      @template_targets.delete(template_target)
    end

    # Quita la caracterisitca en base al nombre
    def remove_template_target_by_name(template_target_name)
      @template_targets.delete_if { |f| f.name==template_target_name }
    end

    # Obtiene la template_target en base al nombre
    def get_template_target_by_name(template_target_name)
      return @template_targets.detect { |f| f.name==template_target_name }
    end

    # Configura el generador y se
    def generator= (value)
      super(value)

      if @generator
        configure_template_directories()
        configure_template_targets()
      end

    end


    def configure_template_directories
      # Configuro las rutas de los templates
      template_local_dir = get_template_local_dir(get_class_file)
      self.template_directories << template_local_dir if template_local_dir
      self.template_directories << File.join(File.dirname(get_class_file), '../template')

    end

    # Configura los objetivos de las platillas (despues de establecer el generador)
    def configure_template_targets

    end

    # Genero el codigo, usando todas las plantillas configuradas
    def generate
      super()

      message_helper.add_indent

      # Genera una a una todas los objetivos de los templates
      self.template_targets.each do |t|
        generate_template_target(t)
      end

      message_helper.remove_indent
      puts
    end

    def clean
      super()

      message_helper.add_indent

      # Genera una a una todas los objetivos de los templates
      self.template_targets.each do |t|
        clean_template_target(t)
      end

      message_helper.remove_indent
      puts
    end


    protected

    # Genero una plantilla en particular
    def generate_template_target(template_target, current_binding= nil)

      # Localizo la plantilla
      template     = self.get_template_by_name(template_target.template_name)

      # Obtengo el archivo del template
      template_file= ''
      @template_directories.each do |template_directory|
        template_file= File.join(template_directory, template.file)
        break if File.exist?(template_file)
      end


      # Obtengo la salida
      if template_target.out_file.blank?
        out_file= nil
      else
        out_file= File.join(self.generation_attributes[:out_dir], template_target.out_file)
      end

      current_binding= binding unless current_binding

      if template_target.copy_only

        exists= File.exist?(out_file)

        # Creo el directorio
        FileUtils::mkdir_p File.dirname(out_file)

        if exists
          if @generator.argv_options.force
            FileUtils.cp template_file, out_file
            message_helper.puts_created_template(File.basename(out_file), out_file, :override)
          else
            message_helper.puts_created_template(File.basename(out_file), out_file, :ignore)
          end
        else
          FileUtils.cp template_file, out_file
          message_helper.puts_created_template(File.basename(out_file), out_file, :new)
        end

      else
        # Creo la salida
        return TemplateHelper.generate_template(template_file, current_binding, :out_file => out_file, :feature => self, :force => @generator.argv_options.force)
      end


    end


    # Limpio el resultado de una plantilla (borro archivos)
    def clean_template_target(template_target, current_binding= nil)

      # Localizo la plantilla
      template= self.get_template_by_name(template_target.template_name)

      # Obtengo la salida
      if template_target.out_file.blank?
        return
      else
        out_file= File.join(self.generation_attributes[:out_dir], template_target.out_file)
      end

      return if !File.exist?(out_file)

      # Elimino el archivo
      File.delete(out_file)

      message_helper.puts_created_template(File.basename(template.file), out_file, :delete)


    end


    # Devuelve los archivos generados por esta caracteristicas
    def get_out_file_information(values= {})

      # Recupero los parametros
      types = values[:types]
      types = [types] if types and not types.instance_of?(Array)

      #recupero los archivos pertinentes
      result= []

      self.template_targets.each do |t|
        # si no hay tipos definidos o los tipos tienen algo en común, lo agrego a los resultados
        next unless types.blank? or t.is_any_type?(types)
        next unless t.respond_to?('out_file')
        next if t.out_file.blank?


        file_information= FileInformation.new(:file_name => File.join(self.generation_attributes[:out_dir], t.out_file))

        result << file_information

      end

      return result

    end


    protected
    # Directorio local para obtener los templates
    def get_template_local_dir(file)
      begin
        feacture_directory= File.dirname(file).split('/')
        feacture_name     = feacture_directory[feacture_directory.count-2]
        package_name      = feacture_directory[feacture_directory.count-3]
        gem_name          = feacture_directory[feacture_directory.count-4]
        template_local    = File.join(@generator.local_templates, gem_name, package_name, feacture_name)

        return template_local

      rescue
        #Seguramente no sigue la estructura indicada para templates
        return nil
      end
    end


    # For instances of class A only, we use the __FILE__ keyword.
    # This method is overwritten by the #get_file method defined above.
    def get_class_file
      __FILE__
    end

    private
    # Called from b.rb at `class A < B`. `subclass` is the Class object B.
    # This method makes sure every subclass (class B, class C...)
    # has #get_file defined correctly for instances of the subclass.
    def self.inherited (subclass)
      subclass.instance_eval do
        # This array contains strings like "/path/to/a.rb:3:in `instance_eval'".
        strings_ary   = caller

        # We look for the last string containing "<top (required)>".
        require_index = strings_ary.index { |x| x.include?("<top (required)>") }
        require_string= strings_ary[require_index]

        # We use a regex to extract the filepath from require_string.
        filepath      = require_string[/^(.*):\d+:in `<top \(required\)>'/, 1]

        # This defines the method #get_file for instances of `subclass`.
        define_method(:get_class_file) { filepath }
      end
    end


  end


end

