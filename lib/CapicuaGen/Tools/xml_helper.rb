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

require 'nokogiri'
require "rexml/document"

module CapicuaGen

  # Clase ayudante para tratar con archivos XML
  class XMLHelper

    private

    def initialize

    end

    public

    # obtiene un nodo de un xml
    def self.get_node_from_xml_document(xml, xpath)

      # Busco el nodo
      xml_node_xpath= xml.root.xpath(xpath)

      # Si no xml_node_xpath un primer nodo
      return xml_node_xpath.first if xml_node_xpath.first

      return create_node(xml.root, xpath)

    end

    private

    # Localiza un nodo y si no existe lo crea
    def self.create_node(xml_node, path)

      paths= path.split(/\//).select { |x| !x.blank? }


      current_node_name= paths.shift

      # Alcance el ultimo nodo lo creo
      if paths.count==0
        current_node= Nokogiri::XML::Node.new(clear_node_name(current_node_name), xml_node)
        xml_node.add_child(current_node)
        return current_node
      end

      # Si no existe lo creo
      current_node= xml_node.xpath(current_node_name).first
      unless current_node
        current_node= Nokogiri::XML::Node.new(clear_node_name(current_node_name), xml_node)
        xml_node.add_child(current_node)
      end

      return create_node current_node, paths.join('/')

    end

    # Limpia un atributo del nombre de un nodo
    def self.clear_node_name(node_string)
      if node_string=~/([^\[]+)\[/
        return $1
      else
        return node_string
      end
    end


    # Formate el xml
    def self.format(xml_string)
      doc= REXML::Document.new(xml_string)
      doc.context[:attribute_quote]= :quote
      formatted= ""
      doc.write(formatted, 2)
      return formatted
    end


  end
end
