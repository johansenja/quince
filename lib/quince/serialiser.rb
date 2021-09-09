module Quince
  class Serialiser
    class << self
      def serialise(obj)
        val = case obj
          when Quince::Component
            {
              id: serialise(obj.send(:__id)),
              props: serialise(obj.props),
              state: serialise(obj.state),
              children: serialise(obj.children),
              html_element_selector: serialise(obj.send(:html_element_selector)),
            }
          when Array
            obj.map { |e| serialise e }
          when TypedStruct, Struct, OpenStruct, Hash
            result = obj.each_pair.each_with_object({}) do |(k, v), ob|
              case v
              when Undefined
                next
              else
                ob[k] = serialise(v)
              end
            end
            if result.empty? && !obj.is_a?(Hash)
              obj = nil
              nil
            else
              result
            end
          when Proc
            obj = obj.call # is there a more efficient way of doing this?
            serialise(obj)
          when String
            res = obj.gsub "\n", '\n'
            res.gsub! ?", '\"'
            res
          else
            obj
          end

        { t: obj.class&.name, v: val }
      end

      def deserialise(json)
        case json[:t]
        when "String", "Integer", "Float", "NilClass", "TrueClass", "FalseClass"
          json[:v]
        when "Symbol"
          json[:v].to_sym
        when "Array"
          json[:v].map { |e| deserialise e }
        when "Hash"
          transform_hash json[:v]
        when "OpenStruct"
          OpenStruct.new(**transform_hash(props))
        when nil
          nil
        else
          klass = Object.const_get(json[:t])
          if klass < TypedStruct
            transform_hash_for_struct(json[:v]) || {}
          elsif klass < Quince::Component
            instance = klass.allocate
            val = json[:v]
            id = deserialise val[:id]

            instance.instance_variable_set :@__id, id
            instance.instance_variable_set(
              :@props,
              klass.send(
                :initialize_props,
                klass,
                id,
                **(deserialise(val[:props]) || {}),
              ),
            )
            st = deserialise(val[:state])
            instance.instance_variable_set :@state, klass::State.new(**st) if st
            instance.instance_variable_set :@children, deserialise(val[:children])
            instance
          else
            klass = Object.const_get(json[:t])
            klass.new(deserialise(json[:v]))
          end
        end
      end

      private

      def transform_hash(hsh)
        hsh.transform_values! { |v| deserialise v }
      end

      def transform_hash_for_struct(hsh)
        hsh.to_h { |k, v| [k.to_sym, deserialise(v)] }
      end
    end
  end
end
