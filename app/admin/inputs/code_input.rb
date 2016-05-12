class CodeInput < Formtastic::Inputs::TextInput
  def to_html
    input_wrapping do
      label_html << Formtastic::Util.html_safe("
      <div codemirror-input class=\"code-input\"
        name=\"#{object_name}[#{method}]\"
        mode=\"#{input_html_options[:mode]}\"
        theme=\"#{input_html_options[:theme]}\">
        #{ERB::Util.json_escape(object.send(method).to_json)}
      </div>
      ")
    end
  end
end
