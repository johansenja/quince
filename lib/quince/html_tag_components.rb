require "oj"
require_relative "attributes_by_element"
require_relative "serialiser"

module Quince
  module HtmlTagComponents
    def self.define_html_tag_component(const_name, attrs, self_closing: false)
      klass = Class.new(Quince::Component) do
        Props(
          **GLOBAL_HTML_ATTRS,
          **DOM_EVENTS,
          **attrs,
        )

        def render
          attrs = if props
              props.each_pair.map { |k, v| to_html_attr(k, v) }.compact.join(" ")
            end
          result = "<#{tag_name}"
          result << " #{attrs}>" unless attrs.empty?

          return result if self_closing?

          result << Quince.to_html(children)
          result << "</#{tag_name}>"
          result
        end

        def to_html_attr(key, value)
          # for attribute names which clash with standard ruby method
          # eg :class, the first letter is capitalised
          key[0].downcase!
          attrib = case value
            when String, Integer, Float, Symbol
              value.to_s
            when Callback::Interface
              receiver = value.receiver
              owner = receiver.class.name
              name = value.method_name
              selector = receiver.send :html_element_selector
              internal = Quince::Serialiser.serialise receiver
              payload = { component: CGI.escapeHTML(internal) }.to_json
              payload_var_name = "p"
              stringify_payload = if value.take_form_values
                  "{...#{payload_var_name}, params: getFormValues(this)}"
                else
                  payload_var_name
                end
              cb = %Q{const #{payload_var_name} = #{payload}; callRemoteEndpoint(`/api/#{owner}/#{name}`, JSON.stringify(#{stringify_payload}),`#{selector}`)}
              cb += ";return false" if value.prevent_default
              CGI.escape_html(cb)
            when true
              return key
            when false, nil, Quince::Types::Undefined
              return ""
            else
              raise "prop type not yet implemented #{value}"
            end

          %Q{#{key}="#{attrib}"}
        end

        def tag_name
          @tag_name ||= self.class::TAG_NAME
        end

        def self_closing?
          @self_closing ||= self.class::SELF_CLOSING
        end
      end

      lower_tag = const_name.downcase
      klass.const_set("TAG_NAME", lower_tag == "para" ? "p".freeze : lower_tag.freeze)
      klass.const_set "SELF_CLOSING", self_closing

      HtmlTagComponents.const_set const_name, klass

      Quince.define_constructor HtmlTagComponents.const_get(const_name), lower_tag
    end
    private_class_method :define_html_tag_component

    ATTRIBUTES_BY_ELEMENT.each { |t, attrs| define_html_tag_component(t, attrs) }
    SELF_CLOSING_TAGS.each { |t, attrs| define_html_tag_component(t, attrs, self_closing: true) }

    def internal_scripts
      contents = File.read(File.join(__dir__, "..", "..", "scripts.js"))
      script {
        contents
      }
    end
  end

  Quince::Component.include HtmlTagComponents
end

# tmp hack
class TypedStruct < Struct
  def to_json(*args)
    to_h.to_json(*args)
  end
end
